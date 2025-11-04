import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_road_app/VehicleOwner/real_voice_assis.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:smart_road_app/services/tts_service.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Repair AI Assistant',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const AdvancedAIAssistantScreen(),
    );
  }
}

class AdvancedAIAssistantScreen extends StatefulWidget {
  const AdvancedAIAssistantScreen({super.key});

  @override
  State<AdvancedAIAssistantScreen> createState() => _AdvancedAIAssistantScreenState();
}

class _AdvancedAIAssistantScreenState extends State<AdvancedAIAssistantScreen>
    with SingleTickerProviderStateMixin {
  File? _selectedImage;
  bool _isAnalyzing = false;
  bool _isListening = false;
  bool _isSpeaking = false;
  DamageAnalysisResult? _analysisResult;
  late AnimationController _animationController;
  late Animation<double> _animation;

  final ImagePicker _imagePicker = ImagePicker();
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  final TtsService _tts = TtsService();
  String _lastWords = '';
  String _currentMode = 'car_damage'; // 'car_damage' or 'symbol_error'

  @override
  void initState() {
    super.initState();
  _initializeSpeech();
  _tts.init();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _animationController.forward();
        }
      });
  }

  void _initializeSpeech() async {
    await _speechToText.initialize();
    setState(() {});
  }

  // TTS is handled by TtsService

  void _startListening() async {
    if (!_speechToText.isAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Speech recognition not available')),
      );
      return;
    }

    await _speechToText.listen(
      onResult: (result) {
        setState(() {
          _lastWords = result.recognizedWords;
        });
        _processVoiceCommand(_lastWords);
      },
    );

    setState(() {
      _isListening = true;
      _animationController.forward();
    });
  }

  void _stopListening() {
    _speechToText.stop();
    setState(() {
      _isListening = false;
      _animationController.reset();
    });
  }

  void _processVoiceCommand(String command) {
    final lowerCommand = command.toLowerCase();
    
    // Mode selection commands
    if (lowerCommand.contains('car damage') || lowerCommand.contains('damage mode')) {
      setState(() {
        _currentMode = 'car_damage';
      });
  _tts.speak('Switched to car damage detection mode');
    } else if (lowerCommand.contains('symbol') || lowerCommand.contains('warning light')) {
      setState(() {
        _currentMode = 'symbol_error';
      });
  _tts.speak('Switched to car symbol error detection mode');
    }
    
    // Action commands
    if (lowerCommand.contains('take photo') || lowerCommand.contains('camera')) {
      _captureImage();
    } else if (lowerCommand.contains('gallery') || lowerCommand.contains('upload')) {
      _pickImage();
    } else if (lowerCommand.contains('analyze') || lowerCommand.contains('scan')) {
      if (_selectedImage != null) {
        _analyzeImage();
      } else {
  _tts.speak('Please select an image first');
      }
    } else if (lowerCommand.contains('solution') || lowerCommand.contains('fix')) {
      _openSolutions();
    } else if (lowerCommand.contains('damage') || lowerCommand.contains('issues')) {
      _openDamageAnalysis();
    } else if (lowerCommand.contains('youtube') || lowerCommand.contains('video')) {
      _openYouTubeLinks();
    } else if (lowerCommand.contains('details') || lowerCommand.contains('analysis')) {
      _openDetailedAnalysis();
    } else if (lowerCommand.contains('what is') || lowerCommand.contains('explain')) {
      _handleInformationQuery(lowerCommand);
    } else if (lowerCommand.contains('help') || lowerCommand.contains('what can you do')) {
      _showHelpGuide();
    }
  }

  void _handleInformationQuery(String query) {
    String response = '';
    
    if (_currentMode == 'symbol_error') {
      if (query.contains('engine') || query.contains('check engine')) {
        response = 'The check engine light indicates issues with engine components. Common causes include oxygen sensor failure, loose gas cap, or catalytic converter problems.';
      } else if (query.contains('oil') || query.contains('oil pressure')) {
        response = 'The oil pressure warning means low oil pressure. Stop driving immediately to prevent engine damage. Check oil level and look for leaks.';
      } else if (query.contains('battery') || query.contains('charging')) {
        response = 'The battery warning light indicates charging system problems. Could be alternator failure, battery issues, or electrical system faults.';
      } else if (query.contains('brake') || query.contains('abs')) {
        response = 'Brake system warnings can mean low brake fluid, worn brake pads, or ABS system malfunctions. Have brakes inspected immediately.';
      } else if (query.contains('temperature') || query.contains('overheat')) {
        response = 'Engine temperature warning means the engine is overheating. Stop driving immediately to prevent serious engine damage.';
      } else {
        response = 'I need more specific information about the symbol. Please describe the warning light you are seeing.';
      }
    } else {
      if (query.contains('dent') || query.contains('body damage')) {
        response = 'Car dents can be repaired using paintless dent repair for small dents, or body filler and repainting for larger damage.';
      } else if (query.contains('scratch') || query.contains('paint')) {
        response = 'Paint scratches vary by depth. Clear coat scratches can be polished out, while deeper scratches need touch-up paint or professional repainting.';
      } else if (query.contains('crack') || query.contains('windshield')) {
        response = 'Windshield cracks smaller than 6 inches can often be repaired. Larger cracks usually require windshield replacement for safety.';
      } else if (query.contains('bumper') || query.contains('fender')) {
        response = 'Bumper and fender damage assessment depends on material. Plastic bumpers can often be repaired, while metal parts may need replacement.';
      } else {
        response = 'I need more specific information about the car damage. Please describe what you are seeing.';
      }
    }
    
    if (response.isNotEmpty) {
  _tts.speak(response);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  void _showHelpGuide() {
    final helpText = _currentMode == 'car_damage' 
        ? '''
    CAR DAMAGE DETECTION MODE:
    - Take photos of car dents, scratches, or body damage
    - Analyze collision damage
    - Provide repair solutions and cost estimates
    
    Voice Commands:
    - "Take photo" or "Camera" - Capture image
    - "Analyze this" - Analyze current image
    - "What is this dent?" - Get information
    - "Show solutions" - Repair instructions
    - "Symbol mode" - Switch to warning light detection
    '''
        : '''
    CAR SYMBOL ERROR MODE:
    - Identify dashboard warning lights
    - Explain what each symbol means
    - Provide troubleshooting steps
    
    Voice Commands:
    - "Take photo" or "Camera" - Capture image
    - "Analyze this" - Analyze current image
    - "What is check engine light?" - Get information
    - "Show solutions" - Fix instructions
    - "Car damage mode" - Switch to damage detection
    ''';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${_currentMode == 'car_damage' ? 'Car Damage' : 'Symbol Error'} Help Guide'),
        content: SingleChildScrollView(child: Text(helpText)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _speakSolution() {
    if (_analysisResult != null) {
      final solutionText = '''
        I found ${_analysisResult!.damageType.toLowerCase()}. 
        The severity is ${_analysisResult!.severity.toLowerCase()}.
        ${_analysisResult!.description}.
        Here are the solutions: ${_analysisResult!.solutions.join('. ')}
      ''';
      
  _tts.speak(solutionText);
      setState(() {
        _isSpeaking = true;
      });
      
      Future.delayed(const Duration(seconds: 10), () {
        setState(() {
          _isSpeaking = false;
        });
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _analysisResult = null;
        });
        _analyzeImage();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> _captureImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _analysisResult = null;
        });
        _analyzeImage();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error capturing image: $e')),
      );
    }
  }

  Future<void> _analyzeImage() async {
    if (_selectedImage == null) return;

    setState(() {
      _isAnalyzing = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 3));

    final result = _currentMode == 'car_damage' 
        ? await _mockCarDamageAnalysis()
        : await _mockSymbolErrorAnalysis();

    setState(() {
      _analysisResult = result;
      _isAnalyzing = false;
    });

    _speakSolution();
  }

  Future<DamageAnalysisResult> _mockCarDamageAnalysis() async {
    return DamageAnalysisResult(
      damageType: 'Front Bumper Damage',
      severity: 'Medium',
      confidence: 92.5,
      description: 'Detected 15cm crack on front bumper with paint scratches. Plastic deformation visible. No structural frame damage detected.',
      issues: [
        '15cm crack on front bumper',
        'Paint scratches and chips',
        'Plastic deformation around impact area',
        'Minor bracket misalignment',
        'Fog light mounting damaged'
      ],
      solutions: [
        'Clean the area with automotive cleaner',
        'Apply plastic welding for the crack',
        'Use body filler for smooth surface',
        'Sand with 400-600 grit sandpaper',
        'Apply primer and paint matching',
        'Clear coat application',
        'Reinstall and align bumper brackets'
      ],
      youtubeLinks: [
        YouTubeLink(
          title: 'Bumper Crack Repair - Complete Guide',
          url: 'https://youtube.com/watch?v=bumper_repair',
          duration: '15:30',
          channel: 'Auto Repair Pro',
        ),
      ],
      googleSearchLinks: [
        SearchLink(
          title: 'Plastic Bumper Repair Methods',
          url: 'https://www.google.com/search?q=plastic+bumper+repair',
          description: 'Professional bumper repair techniques'
        ),
      ],
      alternativeSolutions: [
        AlternativeSolution(
          title: 'Professional Repair',
          description: 'Certified auto body shop repair',
          cost: '\$300-\$600',
          time: '2-3 days',
          rating: 4.8
        ),
        AlternativeSolution(
          title: 'Bumper Replacement',
          description: 'Complete bumper replacement',
          cost: '\$400-\$800',
          time: '3-5 days',
          rating: 4.6
        ),
      ],
      estimatedRepairCost: '\$150 - \$300',
      repairTime: '4-6 hours',
      toolsRequired: ['Plastic welder', 'Sandpaper (400-600 grit)', 'Body filler', 'Primer', 'Paint kit', 'Clear coat', 'Safety mask'],
      materialsRequired: ['Plastic welding rods', 'Body filler', 'Automotive primer', 'Color-matched paint', 'Clear coat', 'Cleaning solvent'],
      safetyPrecautions: [
        'Work in well-ventilated area',
        'Wear safety glasses and mask',
        'Use gloves when handling chemicals',
        'Disconnect battery if working near electrical'
      ],
      expertTips: [
        'Test paint color match on hidden area first',
        'Apply thin layers of filler for better results',
        'Allow proper drying time between coats',
        'Use UV-resistant clear coat for longevity'
      ],
      immediateActions: [
        'Cover crack with tape to prevent moisture entry',
        'Clean area to prevent rust on metal parts',
        'Take photos for insurance documentation'
      ],
      preventionTips: [
        'Maintain safe following distance',
        'Park carefully in tight spaces',
        'Consider bumper protection film'
      ]
    );
  }

  Future<DamageAnalysisResult> _mockSymbolErrorAnalysis() async {
    return DamageAnalysisResult(
      damageType: 'Check Engine Light',
      severity: 'Medium',
      confidence: 88.0,
      description: 'Check Engine Light detected. This indicates issues with engine management system. Common causes include sensor failures, emission problems, or fuel system issues.',
      issues: [
        'Engine control system error',
        'Potential oxygen sensor malfunction',
        'Possible catalytic converter issues',
        'Fuel system inefficiency detected',
        'Emission control system warning'
      ],
      solutions: [
        'Check gas cap is properly tightened',
        'Use OBD2 scanner to read error codes',
        'Inspect oxygen sensors for damage',
        'Check catalytic converter condition',
        'Test fuel injector performance',
        'Verify spark plug and ignition coil function',
        'Reset codes after repair completion'
      ],
      youtubeLinks: [
        YouTubeLink(
          title: 'Check Engine Light Diagnosis Guide',
          url: 'https://youtube.com/watch?v=check_engine',
          duration: '12:45',
          channel: 'Auto Diagnostics',
        ),
      ],
      googleSearchLinks: [
        SearchLink(
          title: 'Check Engine Light Causes & Solutions',
          url: 'https://www.google.com/search?q=check+engine+light+causes',
          description: 'Complete guide to check engine light troubleshooting'
        ),
      ],
      alternativeSolutions: [
        AlternativeSolution(
          title: 'Professional Diagnosis',
          description: 'Full diagnostic scan at repair shop',
          cost: '\$80-\$150',
          time: '1-2 hours',
          rating: 4.7
        ),
        AlternativeSolution(
          title: 'Mobile Mechanic',
          description: 'On-site diagnostic service',
          cost: '\$60-\$120',
          time: 'Same day',
          rating: 4.4
        ),
      ],
      estimatedRepairCost: '\$50 - \$400',
      repairTime: '1-3 hours',
      toolsRequired: ['OBD2 Scanner', 'Multimeter', 'Basic hand tools', 'Safety gloves'],
      materialsRequired: ['Replacement sensors if needed', 'Electrical contact cleaner', 'Diagnostic code reader'],
      safetyPrecautions: [
        'Work on cool engine only',
        'Disconnect battery before electrical work',
        'Use jack stands if working underneath',
        'Follow proper diagnostic procedures'
      ],
      expertTips: [
        'Note if light is steady or flashing',
        'Record all error codes before clearing',
        'Address underlying cause, not just reset light',
        'Regular maintenance prevents many check engine issues'
      ],
      immediateActions: [
        'Check if light is steady or flashing',
        'Note any changes in vehicle performance',
        'Schedule diagnostic scan as soon as possible'
      ],
      preventionTips: [
        'Regular oil changes and maintenance',
        'Use quality fuel and additives',
        'Address minor issues before they become major',
        'Follow manufacturer service schedule'
      ]
    );
  }

  void _openYouTubeLinks() {
    if (_analysisResult != null) {
      showModalBottomSheet(
        context: context,
        builder: (context) => YouTubeLinksBottomSheet(links: _analysisResult!.youtubeLinks),
      );
    }
  }

  void _openGoogleLinks() {
    if (_analysisResult != null) {
      showModalBottomSheet(
        context: context,
        builder: (context) => GoogleLinksBottomSheet(links: _analysisResult!.googleSearchLinks),
      );
    }
  }

  void _openAlternativeSolutions() {
    if (_analysisResult != null) {
      showModalBottomSheet(
        context: context,
        builder: (context) => AlternativeSolutionsBottomSheet(solutions: _analysisResult!.alternativeSolutions),
      );
    }
  }

  void _openDetailedAnalysis() {
    if (_analysisResult != null) {
      showModalBottomSheet(
        context: context,
        builder: (context) => DetailedAnalysisBottomSheet(result: _analysisResult!),
        isScrollControlled: true,
      );
    }
  }

  void _openDamageAnalysis() {
    if (_analysisResult != null) {
      showModalBottomSheet(
        context: context,
        builder: (context) => DamageAnalysisBottomSheet(result: _analysisResult!),
        isScrollControlled: true,
      );
    }
  }

  void _openSolutions() {
    if (_analysisResult != null) {
      showModalBottomSheet(
        context: context,
        builder: (context) => SolutionsBottomSheet(result: _analysisResult!),
        isScrollControlled: true,
      );
    }
  }

  void _openCarSymbolsGuide() {
    showModalBottomSheet(
      context: context,
      builder: (context) => CarSymbolsGuideBottomSheet(),
      isScrollControlled: true,
    );
  }

  void _openCarDamageGuide() {
    showModalBottomSheet(
      context: context,
      builder: (context) => CarDamageGuideBottomSheet(),
      isScrollControlled: true,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _speechToText.stop();
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Repair AI Assistant'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Mode indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: _currentMode == 'car_damage' ? Colors.orange : Colors.green,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _currentMode == 'car_damage' ? 'Damage Mode' : 'Symbol Mode',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (_isListening)
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) => Icon(
                Icons.mic,
                color: Colors.red,
                size: 24 * _animation.value,
              ),
            ),
          IconButton(
  icon: Icon(_isListening ? Icons.stop : Icons.mic),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SmartRoadVoiceAssistant(), // Your target screen
      ),
    );
  },
),
          //_isListening ? _stopListening : _startListening,
          IconButton(
            icon: const Icon(Icons.help),
            onPressed: _showHelpGuide,
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Voice Command Display
                if (_lastWords.isNotEmpty) _buildVoiceCommandDisplay(),
                
                // Mode Selection Buttons
                _buildModeSelectionSection(),
                const SizedBox(height: 16),
                
                // Header Section
                _buildHeaderSection(),
                const SizedBox(height: 24),
                
                // Image Upload Section
                _buildImageUploadSection(),
                const SizedBox(height: 24),
                
                // Quick Guide Buttons
                _buildQuickGuideSection(),
                const SizedBox(height: 24),
                
                // Analysis Results
                if (_analysisResult != null) _buildAnalysisResults(),
                
                // Loading Indicator
                if (_isAnalyzing) _buildLoadingIndicator(),
              ],
            ),
          ),
          
          // Floating Action Buttons
          if (_analysisResult != null) _buildFloatingActionButtons(),
        ],
      ),
    );
  }

  Widget _buildModeSelectionSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: () {
                  setState(() {
                    _currentMode = 'car_damage';
                  });
    
    
                  _tts.speak('Car damage mode activated');
                },
                icon: const Icon(Icons.car_crash),
                label: const Text('Car Damage'),
                style: FilledButton.styleFrom(
                  backgroundColor: _currentMode == 'car_damage' ? Colors.orange : Colors.grey,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: () {
                  setState(() {
                    _currentMode = 'symbol_error';
                  });
                  _tts.speak('Symbol error mode activated');
                },
                icon: const Icon(Icons.warning),
                label: const Text('Symbol Error'),
                style: FilledButton.styleFrom(
                  backgroundColor: _currentMode == 'symbol_error' ? Colors.green : Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickGuideSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Guides',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Card(
                child: InkWell(
                  onTap: _openCarDamageGuide,
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(Icons.car_repair, size: 40, color: Colors.orange),
                        SizedBox(height: 8),
                        Text(
                          'Car Damage Guide',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Card(
                child: InkWell(
                  onTap: _openCarSymbolsGuide,
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(Icons.warning_amber, size: 40, color: Colors.red),
                        SizedBox(height: 8),
                        Text(
                          'Symbol Error Guide',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVoiceCommandDisplay() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.mic, color: Colors.blue[700], size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _lastWords,
              style: TextStyle(
                color: Colors.blue[800],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _currentMode == 'car_damage' ? 'Car Damage Assistant' : 'Car Symbol Assistant',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _currentMode == 'car_damage' 
              ? 'Take photo of car damage for analysis and repair solutions'
              : 'Take photo of dashboard symbols for explanation and fixes',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Voice commands: "Take photo", "Analyze", "What is check engine light?", "Car damage mode", "Symbol mode"',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildImageUploadSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (_selectedImage == null) ...[
              Icon(
                _currentMode == 'car_damage' ? Icons.car_repair : Icons.dashboard,
                size: 80,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                _currentMode == 'car_damage' ? 'No Car Damage Photo' : 'No Symbol Photo',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                _currentMode == 'car_damage'
                    ? 'Say "Take photo" or upload image of car damage'
                    : 'Say "Take photo" or upload image of dashboard symbol',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
            ] else ...[
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: FileImage(_selectedImage!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            if (_selectedImage == null) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _captureImage,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Take Photo'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Gallery'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'AI is Analyzing...',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              _currentMode == 'car_damage'
                  ? 'Processing car damage image'
                  : 'Identifying dashboard symbol',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisResults() {
    final result = _analysisResult!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getSeverityColor(result.severity),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        result.severity,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${result.confidence.toStringAsFixed(1)}% Confidence',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  result.damageType,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  result.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildFloatingActionButtons() {
    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                icon: Icons.play_circle_fill,
                label: 'Videos',
                color: Colors.red,
                onTap: _openYouTubeLinks,
              ),
              _buildActionButton(
                icon: Icons.warning_amber,
                label: 'Issues',
                color: Colors.orange,
                onTap: _openDamageAnalysis,
              ),
              _buildActionButton(
                icon: Icons.construction,
                label: 'Fix It',
                color: Colors.green,
                onTap: _openSolutions,
              ),
              _buildActionButton(
                icon: Icons.analytics,
                label: 'Details',
                color: Colors.purple,
                onTap: _openDetailedAnalysis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon),
          color: color,
          onPressed: onTap,
          style: IconButton.styleFrom(
            backgroundColor: color.withOpacity(0.1),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'low':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'high':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

// Data Models
class DamageAnalysisResult {

  const DamageAnalysisResult({
    required this.damageType,
    required this.severity,
    required this.confidence,
    required this.description,
    required this.issues,
    required this.solutions,
    required this.youtubeLinks,
    required this.googleSearchLinks,
    required this.alternativeSolutions,
    required this.estimatedRepairCost,
    required this.repairTime,
    required this.toolsRequired,
    required this.materialsRequired,
    required this.safetyPrecautions,
    required this.expertTips,
    required this.immediateActions,
    required this.preventionTips,
  });
  final String damageType;
  final String severity;
  final double confidence;
  final String description;
  final List<String> issues;
  final List<String> solutions;
  final List<YouTubeLink> youtubeLinks;
  final List<SearchLink> googleSearchLinks;
  final List<AlternativeSolution> alternativeSolutions;
  final String estimatedRepairCost;
  final String repairTime;
  final List<String> toolsRequired;
  final List<String> materialsRequired;
  final List<String> safetyPrecautions;
  final List<String> expertTips;
  final List<String> immediateActions;
  final List<String> preventionTips;
}

class YouTubeLink {

  const YouTubeLink({
    required this.title,
    required this.url,
    required this.duration,
    required this.channel,
  });
  final String title;
  final String url;
  final String duration;
  final String channel;
}

class SearchLink {

  const SearchLink({
    required this.title,
    required this.url,
    required this.description,
  });
  final String title;
  final String url;
  final String description;
}

class AlternativeSolution {

  const AlternativeSolution({
    required this.title,
    required this.description,
    required this.cost,
    required this.time,
    required this.rating,
  });
  final String title;
  final String description;
  final String cost;
  final String time;
  final double rating;
}

// Bottom Sheet Widgets
class DamageAnalysisBottomSheet extends StatelessWidget {

  const DamageAnalysisBottomSheet({super.key, required this.result});
  final DamageAnalysisResult result;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.8,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning_amber, color: Colors.orange[700], size: 28),
                const SizedBox(width: 12),
                Text(
                  'Damage Analysis Report',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800],
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Damage Overview
            _buildSection(
              title: 'Damage Overview',
              icon: Icons.assessment,
              color: Colors.blue,
              children: [
                _buildInfoRow('Damage Type:', result.damageType),
                _buildInfoRow('Severity Level:', result.severity),
                _buildInfoRow('Confidence:', '${result.confidence.toStringAsFixed(1)}%'),
                _buildInfoRow('Estimated Repair Cost:', result.estimatedRepairCost),
                _buildInfoRow('Repair Time:', result.repairTime),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Detected Issues
            _buildSection(
              title: 'Detected Issues',
              icon: Icons.error_outline,
              color: Colors.red,
              children: [
                Column(
                  children: result.issues.map((issue) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.circle, size: 8, color: Colors.red[400]),
                        const SizedBox(width: 12),
                        Expanded(child: Text(issue)),
                      ],
                    ),
                  )).toList(),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Technical Details
            _buildSection(
              title: 'Technical Assessment',
              icon: Icons.engineering,
              color: Colors.purple,
              children: [
                _buildInfoRow('Damage Category:', 'Structural Surface Crack'),
                _buildInfoRow('Risk Level:', 'Moderate-High'),
                _buildInfoRow('Urgency:', 'Immediate Attention Required'),
                _buildInfoRow('Affected Area:', 'Surface Layer + Substrate'),
                _buildInfoRow('Progression:', 'Slow but steady without intervention'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SolutionsBottomSheet extends StatelessWidget {

  const SolutionsBottomSheet({super.key, required this.result});
  final DamageAnalysisResult result;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.8,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.construction, color: Colors.green[700], size: 28),
                const SizedBox(width: 12),
                Text(
                  'Repair Solutions & Guide',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Step-by-Step Solutions
            _buildSection(
              title: 'Step-by-Step Repair Guide',
              icon: Icons.format_list_numbered,
              color: Colors.blue,
              children: [
                Column(
                  children: result.solutions.asMap().entries.map((entry) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: Colors.blue[500],
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${entry.key + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.value,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )).toList(),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Tools & Materials
            _buildSection(
              title: 'Required Tools & Materials',
              icon: Icons.build,
              color: Colors.orange,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ...result.toolsRequired.map((tool) => Chip(
                      label: Text(tool),
                      backgroundColor: Colors.orange[50],
                    )),
                    ...result.materialsRequired.map((material) => Chip(
                      label: Text(material),
                      backgroundColor: Colors.green[50],
                    )),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Safety Precautions
            _buildSection(
              title: 'Safety Precautions',
              icon: Icons.security,
              color: Colors.red,
              children: [
                Column(
                  children: result.safetyPrecautions.map((precaution) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.check_circle, size: 16, color: Colors.green),
                        const SizedBox(width: 12),
                        Expanded(child: Text(precaution)),
                      ],
                    ),
                  )).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class YouTubeLinksBottomSheet extends StatelessWidget {

  const YouTubeLinksBottomSheet({super.key, required this.links});
  final List<YouTubeLink> links;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'YouTube Tutorials',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...links.map((link) => _buildYouTubeCard(link, context)),
        ],
      ),
    );
  }

  Widget _buildYouTubeCard(YouTubeLink link, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.red[400],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.play_arrow, color: Colors.white),
        ),
        title: Text(
          link.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
          maxLines: 2,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(link.channel),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.schedule, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(link.duration, style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ],
        ),
        onTap: () async {
          final url = Uri.parse(link.url);
          if (await canLaunchUrl(url)) {
            await launchUrl(url);
          }
        },
      ),
    );
  }
}

class GoogleLinksBottomSheet extends StatelessWidget {

  const GoogleLinksBottomSheet({super.key, required this.links});
  final List<SearchLink> links;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Google Search Results',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...links.map((link) => _buildGoogleCard(link, context)),
        ],
      ),
    );
  }

  Widget _buildGoogleCard(SearchLink link, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.blue[500],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.search, color: Colors.white),
        ),
        title: Text(
          link.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(link.description),
        onTap: () async {
          final url = Uri.parse(link.url);
          if (await canLaunchUrl(url)) {
            await launchUrl(url);
          }
        },
      ),
    );
  }
}

class AlternativeSolutionsBottomSheet extends StatelessWidget {

  const AlternativeSolutionsBottomSheet({super.key, required this.solutions});
  final List<AlternativeSolution> solutions;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Alternative Solutions',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...solutions.map((solution) => _buildSolutionCard(solution, context)),
        ],
      ),
    );
  }

  Widget _buildSolutionCard(AlternativeSolution solution, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  solution.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                Chip(
                  label: Text('⭐ ${solution.rating}'),
                  backgroundColor: Colors.amber[50],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(solution.description),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildInfoChip('Cost', solution.cost, context),
                const SizedBox(width: 8),
                _buildInfoChip('Time', solution.time, context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, String value, BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailedAnalysisBottomSheet extends StatelessWidget {

  const DetailedAnalysisBottomSheet({super.key, required this.result});
  final DamageAnalysisResult result;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.8,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Comprehensive Analysis',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Complete Overview
            _buildSection(
              title: 'Complete Damage Assessment',
              icon: Icons.assessment,
              children: [
                _buildDetailRow('Damage Classification:', result.damageType),
                _buildDetailRow('Severity Assessment:', result.severity),
                _buildDetailRow('Confidence Level:', '${result.confidence}%'),
                _buildDetailRow('Risk Category:', 'Moderate Structural Risk'),
                _buildDetailRow('Recommended Action:', 'Immediate Repair'),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Technical Analysis
            _buildSection(
              title: 'Technical Analysis',
              icon: Icons.engineering,
              children: [
                _buildDetailRow('Affected Components:', 'Surface Layer, Substrate Material'),
                _buildDetailRow('Damage Progression:', 'Progressive without intervention'),
                _buildDetailRow('Environmental Factors:', 'Moisture sensitive, Temperature dependent'),
                _buildDetailRow('Structural Impact:', 'Localized integrity compromise'),
                _buildDetailRow('Repair Complexity:', 'Moderate - DIY with care'),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Cost & Time Analysis
            _buildSection(
              title: 'Cost & Time Analysis',
              icon: Icons.schedule,
              children: [
                _buildDetailRow('DIY Repair Cost:', result.estimatedRepairCost),
                _buildDetailRow('Professional Cost:', '\$120-\$200'),
                _buildDetailRow('DIY Time Required:', result.repairTime),
                _buildDetailRow('Professional Time:', '1-2 days'),
                _buildDetailRow('Cost Effectiveness:', 'Highly cost-effective DIY'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue[700]),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 180,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CarSymbolsGuideBottomSheet extends StatelessWidget {

  CarSymbolsGuideBottomSheet({super.key});
  final Map<String, Map<String, String>> commonSymbols = {
    'Check Engine': {
      'icon': '🚨',
      'description': 'Engine management system issue',
      'urgency': 'Moderate - Schedule inspection',
      'common_causes': 'Loose gas cap, sensor failure, emission problems',
      'immediate_action': 'Check gas cap, monitor performance'
    },
    'Oil Pressure': {
      'icon': '🛢️',
      'description': 'Low oil pressure warning',
      'urgency': 'High - Stop immediately',
      'common_causes': 'Low oil level, oil pump failure, sensor issue',
      'immediate_action': 'Stop engine, check oil level'
    },
    'Battery/Charging': {
      'icon': '🔋',
      'description': 'Charging system problem',
      'urgency': 'Moderate - Limited driving',
      'common_causes': 'Alternator failure, battery issues, belt problems',
      'immediate_action': 'Check battery connections, limit electrical use'
    },
    'Brake System': {
      'icon': '🛑',
      'description': 'Brake system warning',
      'urgency': 'High - Immediate inspection',
      'common_causes': 'Low brake fluid, worn pads, ABS malfunction',
      'immediate_action': 'Test brakes carefully, check fluid level'
    },
    'Temperature': {
      'icon': '🌡️',
      'description': 'Engine overheating',
      'urgency': 'High - Stop immediately',
      'common_causes': 'Coolant leak, thermostat failure, water pump issue',
      'immediate_action': 'Stop engine, let cool, check coolant'
    },
    'Tire Pressure': {
      'icon': '🌀',
      'description': 'Low tire pressure',
      'urgency': 'Low - Check when safe',
      'common_causes': 'Puncture, temperature changes, slow leak',
      'immediate_action': 'Check tire pressure when safe'
    },
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber, size: 28, color: Colors.red),
              const SizedBox(width: 12),
              const Text(
                'Car Symbol Error Guide',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: commonSymbols.entries.map((entry) {
                final symbol = entry.key;
                final info = entry.value;
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              info['icon']!,
                              style: const TextStyle(fontSize: 24),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              symbol,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getUrgencyColor(info['urgency']!),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                info['urgency']!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          info['description']!,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        _buildInfoRow('Common Causes:', info['common_causes']!),
                        const SizedBox(height: 8),
                        _buildInfoRow('Immediate Action:', info['immediate_action']!),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(value)),
      ],
    );
  }

  Color _getUrgencyColor(String urgency) {
    if (urgency.contains('High')) return Colors.red;
    if (urgency.contains('Moderate')) return Colors.orange;
    return Colors.green;
  }
}

class CarDamageGuideBottomSheet extends StatelessWidget {

  CarDamageGuideBottomSheet({super.key});
  final Map<String, Map<String, String>> damageTypes = {
    'Dents & Dings': {
      'icon': '🔨',
      'description': 'Surface deformations from impacts',
      'repair_method': 'Paintless Dent Repair (PDR) or traditional bodywork',
      'cost_range': '\$50-\$500',
      'diy_possible': 'Yes, for small dents',
      'time_required': '1-4 hours'
    },
    'Paint Scratches': {
      'icon': '🎨',
      'description': 'Surface scratches through paint layers',
      'repair_method': 'Polishing, touch-up paint, or repainting',
      'cost_range': '\$20-\$800',
      'diy_possible': 'Yes, for clear coat scratches',
      'time_required': '30min - 2 days'
    },
    'Cracks & Breaks': {
      'icon': '⚡',
      'description': 'Structural damage to plastic or metal parts',
      'repair_method': 'Plastic welding, fiberglass repair, or replacement',
      'cost_range': '\$100-\$1500',
      'diy_possible': 'Limited - professional recommended',
      'time_required': '2-8 hours'
    },
    'Collision Damage': {
      'icon': '💥',
      'description': 'Major impact damage affecting multiple components',
      'repair_method': 'Frame straightening, part replacement, repainting',
      'cost_range': '\$500-\$5000+',
      'diy_possible': 'No - professional required',
      'time_required': '3-14 days'
    },
    'Glass Damage': {
      'icon': '🔍',
      'description': 'Cracked or chipped windows/windshield',
      'repair_method': 'Resin injection or full replacement',
      'cost_range': '\$60-\$1000',
      'diy_possible': 'No - professional required',
      'time_required': '1-3 hours'
    },
  };

  @override


  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.car_repair, size: 28, color: Colors.orange),
              const SizedBox(width: 12),
              const Text(
                'Car Damage Repair Guide',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: damageTypes.entries.map((entry) {
                final damage = entry.key;
                final info = entry.value;
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              info['icon']!,
                              style: const TextStyle(fontSize: 24),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              damage,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          info['description']!,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        _buildInfoRow('Repair Method:', info['repair_method']!),
                        _buildInfoRow('Cost Range:', info['cost_range']!),
                        _buildInfoRow('DIY Possible:', info['diy_possible']!),
                        _buildInfoRow('Time Required:', info['time_required']!),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}