import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_filex/open_filex.dart';

class FileDownloadUtil {
  // Singleton instance
  static final FileDownloadUtil _instance = FileDownloadUtil._internal();
  factory FileDownloadUtil() => _instance;
  FileDownloadUtil._internal();

  // Download file with error handling
  static Future<void> downloadFile({
    required String fileUrl,
    required String fileName,
    required String docName,
    required BuildContext context,
    bool openAfterDownload = true,
  }) async {
    try {
      // Validate URL
      if (fileUrl.isEmpty) {
        _showErrorSnackBar(context, 'Document URL is not available');
        return;
      }

      if (!fileUrl.startsWith('http')) {
        _showErrorSnackBar(context, 'Invalid document URL');
        return;
      }

      // Request permissions
      final hasPermission = await _requestStoragePermission(context);
      if (!hasPermission) {
        _showErrorSnackBar(context, 'Storage permission required for download');
        return;
      }

      // Show loading
      _showLoadingSnackBar(context, 'Downloading $docName...');

      // Download the file
      await _performDownload(
        context: context,
        fileUrl: fileUrl,
        fileName: fileName,
        docName: docName,
        openAfterDownload: openAfterDownload,
      );
    } catch (e) {
      _showErrorSnackBar(context, 'Download failed: $e');
      print('Download error: $e');
    }
  }

  // Request storage permission
  static Future<bool> _requestStoragePermission(BuildContext context) async {
    try {
      if (!Platform.isAndroid) {
        return true; // For iOS, return true
      }

      PermissionStatus status;

      // Try photos permission (Android 13+)
      status = await Permission.photos.status;
      if (status.isGranted) return true;
      
      if (!status.isGranted) {
        status = await Permission.photos.request();
        if (status.isGranted) return true;
      }

      // Try storage permission (older Android)
      status = await Permission.storage.status;
      if (status.isGranted) return true;
      
      if (!status.isGranted) {
        status = await Permission.storage.request();
        if (status.isGranted) return true;
      }

      // Show permission guide if denied
      if (status.isPermanentlyDenied) {
        _showPermissionGuideDialog(context);
      }

      return false;
    } catch (e) {
      print('Permission error: $e');
      final status = await Permission.storage.request();
      return status.isGranted;
    }
  }

  // Perform the actual download
  static Future<void> _performDownload({
    required BuildContext context,
    required String fileUrl,
    required String fileName,
    required String docName,
    required bool openAfterDownload,
  }) async {
    try {
      // Get download directory
      final directory = await _getDownloadDirectory();
      final cleanFileName = _cleanFileName(fileName);
      final filePath = '${directory.path}/$cleanFileName';

      // Get unique file name
      final File file = await _getUniqueFile(filePath);

      // Download file
      final response = await http.get(Uri.parse(fileUrl));
      
      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        
        // Hide loading
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        
        // Show success
        _showSuccessSnackBar(context, '$docName downloaded successfully!');
        
        // Open file if requested
        if (openAfterDownload) {
          final result = await OpenFilex.open(file.path);
          if (result.type != ResultType.done) {
            print('File opened with result: ${result.message}');
          }
        }
      } else {
        throw Exception('HTTP ${response.statusCode}: Failed to download file');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      throw e;
    }
  }

  // Get download directory
  static Future<Directory> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      try {
        final externalDir = await getExternalStorageDirectory();
        if (externalDir != null) {
          final downloadDir = Directory('${externalDir.path}/Download');
          if (!await downloadDir.exists()) {
            await downloadDir.create(recursive: true);
          }
          return downloadDir;
        }
      } catch (e) {
        print('External storage error: $e');
      }
    }
    
    // Fallback
    final documentsDir = await getApplicationDocumentsDirectory();
    final downloadDir = Directory('${documentsDir.path}/Download');
    if (!await downloadDir.exists()) {
      await downloadDir.create(recursive: true);
    }
    return downloadDir;
  }

  // Get unique file name
  static Future<File> _getUniqueFile(String filePath) async {
    File file = File(filePath);
    int counter = 1;
    
    while (await file.exists()) {
      final path = file.path;
      final extension = path.substring(path.lastIndexOf('.'));
      final nameWithoutExtension = path.substring(0, path.lastIndexOf('.'));
      final newPath = '${nameWithoutExtension}_$counter$extension';
      file = File(newPath);
      counter++;
    }
    
    return file;
  }

  // Get file extension from URL
  static String getFileExtension(String url) {
    try {
      Uri uri = Uri.parse(url);
      String path = uri.path;
      int lastDotIndex = path.lastIndexOf('.');
      if (lastDotIndex != -1) {
        return path.substring(lastDotIndex);
      }
    } catch (e) {
      print('Error getting file extension: $e');
    }
    return '.pdf'; // Default extension
  }

  // Clean file name
  static String _cleanFileName(String fileName) {
    return fileName.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');
  }

  // Snackbar helpers
  static void _showLoadingSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.blue,
        duration: const Duration(minutes: 5),
      ),
    );
  }

  static void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  static void _showPermissionGuideDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Storage Permission Required'),
        content: const Text(
          'To download files, please grant storage permission in app settings.\n\n'
          '1. Go to App Settings\n'
          '2. Tap on "Permissions"\n'
          '3. Enable "Storage" or "Photos and Videos"\n\n'
          'After granting permission, try downloading again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }
}