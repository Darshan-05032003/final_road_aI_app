import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
// only used on mobile

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: VehicleDamageAnalyzer(),
  ));
}

class VehicleDamageAnalyzer extends StatefulWidget {
  const VehicleDamageAnalyzer({super.key});

  @override
  State<VehicleDamageAnalyzer> createState() => _VehicleDamageAnalyzerState();
}

class _VehicleDamageAnalyzerState extends State<VehicleDamageAnalyzer> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;
  String _result = "";
  bool _isLoading = false;

  final String apiKey = "AIzaSyDQpesj3QbnhjVoM1hkA8Rlfuql96j3FRU";
  final String url =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent";

  Future<void> _captureOrSelectImage() async {
    try {
      final XFile? file = await _picker.pickImage(source: ImageSource.camera);

      if (file != null) {
        final bytes = await file.readAsBytes();
        setState(() {
          _imageBytes = bytes;
          _result = "";
        });
        await _analyzeImage(bytes);
      }
    } catch (e) {
      setState(() {
        _result = "Error capturing image: $e";
      });
    }
  }

  Future<void> _analyzeImage(Uint8List bytes) async {
    setState(() => _isLoading = true);
    try {
      final base64Image = base64Encode(bytes);
      final requestBody = {
        "contents": [
          {
            "parts": [
              {
                "text":
                    "Analyze this image of a vehicle and describe any damage found, its severity, and suggest possible repair actions."
              },
              {
                "inline_data": {
                  "mime_type": "image/jpeg",
                  "data": base64Image,
                }
              }
            ]
          }
        ]
      };

      final response = await http.post(
        Uri.parse("$url?key=$apiKey"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data["candidates"]?[0]?["content"]?["parts"]?[0]?["text"] ??
            "No description found.";
        setState(() => _result = text);
      } else {
        setState(() => _result = "Error: ${response.statusCode}\n${response.body}");
      }
    } catch (e) {
      setState(() => _result = "Error analyzing image: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vehicle Damage Analyzer (AI)"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: const Text("Capture or Select Vehicle Image"),
                onPressed: _captureOrSelectImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                ),
              ),
              const SizedBox(height: 20),
              if (_imageBytes != null)
                Image.memory(_imageBytes!, height: 250, fit: BoxFit.cover),
              const SizedBox(height: 20),
              if (_isLoading)
                const CircularProgressIndicator()
              else if (_result.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _result,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}