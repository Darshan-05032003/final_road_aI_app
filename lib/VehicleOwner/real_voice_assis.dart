import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_road_app/core/ai_config.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SmartRoadVoiceAssistant extends StatefulWidget {
  const SmartRoadVoiceAssistant({super.key});

  @override
  State<SmartRoadVoiceAssistant> createState() => _SmartRoadVoiceAssistantState();
}

class _SmartRoadVoiceAssistantState extends State<SmartRoadVoiceAssistant> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _text = 'Tap the microphone for road assistance and traffic help';
  String _response = '';
  bool _processing = false;
  bool _speechAvailable = false;
  bool _autoMode = true; // Auto mode enabled by default

  // Read API endpoint/key from central AI config
  final String _apiKey = AiConfig.apiKey;
  final String _url = AiConfig.endpoint;

  @override
  void initState() {
    super.initState();
    _initSpeech();
    // Auto-start listening after initialization
    Future.delayed(Duration(seconds: 2), () {
      if (_speechAvailable && _autoMode) {
        _startAutoListening();
      }
    });
  }

  void _initSpeech() async {
    try {
      bool available = await _speech.initialize(
        onStatus: (status) {
          print('Speech Status: $status');
          if (status == 'done' || status == 'notListening') {
            setState(() => _isListening = false);
            
            // Auto-restart listening in auto mode
            if (_autoMode && !_processing) {
              Future.delayed(Duration(milliseconds: 500), _startAutoListening);
            }
          }
        },
        onError: (error) {
          print('Speech Error: $error');
          setState(() {
            _isListening = false;
            _text = 'Speech error: $error';
          });
          
          // Auto-restart after error in auto mode
          if (_autoMode) {
            Future.delayed(Duration(seconds: 2), _startAutoListening);
          }
        },
      );
      
      setState(() {
        _speechAvailable = available;
        if (!available) {
          _text = 'Speech recognition not available on this device';
        }
      });
    } catch (e) {
      setState(() {
        _text = 'Error initializing speech: $e';
      });
    }
  }

  void _startAutoListening() {
    if (!_speechAvailable || _processing || _isListening) return;

    setState(() {
      _isListening = true;
      _text = '🎤 Smart Road Assistant listening... How can I help with your journey?';
      _response = '';
    });

    _speech.listen(
      onResult: (result) {
        setState(() {
          _text = result.recognizedWords;
        });
        
        // Automatically process when user stops speaking (final result)
        if (result.finalResult && result.recognizedWords.isNotEmpty) {
          _processRoadCommand(result.recognizedWords);
        }
      },
      listenFor: Duration(seconds: 10),
      pauseFor: Duration(seconds: 2),
      partialResults: true,
      listenMode: stt.ListenMode.confirmation,
      cancelOnError: true,
    );
  }

  void _startManualListening() async {
    if (!_speechAvailable) {
      setState(() {
        _text = 'Speech recognition not available. Please check microphone permissions.';
      });
      return;
    }

    setState(() {
      _isListening = true;
      _text = 'Listening... Tell me about your road situation!';
      _response = '';
    });

    try {
      await _speech.listen(
        onResult: (result) {
          setState(() {
            _text = result.recognizedWords;
          });
          
          if (result.finalResult) {
            _processRoadCommand(result.recognizedWords);
          }
        },
        listenFor: Duration(seconds: 30),
        pauseFor: Duration(seconds: 3),
        partialResults: true,
        listenMode: stt.ListenMode.confirmation,
      );
    } catch (e) {
      setState(() {
        _isListening = false;
        _text = 'Error starting voice recognition: $e';
      });
    }
  }

  void _stopListening() async {
    try {
      await _speech.stop();
      setState(() => _isListening = false);
    } catch (e) {
      setState(() {
        _isListening = false;
      });
    }
  }

  void _toggleAutoMode() {
    setState(() {
      _autoMode = !_autoMode;
    });
    
    if (_autoMode) {
      _startAutoListening();
      _showActionFeedback('🔄 Road Assistant: AUTO MODE ON - Always ready to help', Colors.green);
    } else {
      _stopListening();
      _showActionFeedback('⏹ Road Assistant: MANUAL MODE - Tap to speak', Colors.blue);
    }
  }

  void _processRoadCommand(String command) async {
    if (command.isEmpty) return;
    
    setState(() {
      _processing = true;
      _response = 'Analyzing road situation: "$command"';
    });

    try {
      final String prompt = """
You are Smart Road Voice Assistant. Users give voice commands related to traffic, weather, car problems, road assistance, and navigation. You need to understand their road-related needs and provide helpful responses.

User voice command: "$command"

Based on the command, provide a helpful response and suggest the appropriate action. Focus on:
- Traffic conditions and alerts
- Weather impacts on driving
- Car problems and repairs
- Road assistance services
- Navigation and route optimization
- Emergency situations
- Service provider connections

Respond in this exact JSON format:
{
  "action": "traffic_check|weather_alert|car_repair|road_assistance|navigation|emergency|service_finder|safety_tips",
  "response": "Your spoken response to the user about their road situation",
  "suggestion": "What specific action to take in the smart road app",
  "urgency": "low|medium|high"
}

Response:""";

      final http.Response response = await http.post(
        Uri.parse("$_url?key=$_apiKey"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [{"parts": [{"text": prompt}]}],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String aiResponse = data["candidates"][0]["content"]["parts"][0]["text"] ?? "I didn't understand that road command. Please try again.";
        
        try {
          final Map<String, dynamic> parsedResponse = jsonDecode(aiResponse);
          setState(() {
            _response = parsedResponse['response'] ?? aiResponse;
          });
          _executeRoadAction(
            parsedResponse['action'] ?? 'safety_tips', 
            command,
            parsedResponse['urgency'] ?? 'low'
          );
        } catch (e) {
          setState(() {
            _response = aiResponse;
          });
          _executeRoadAction('safety_tips', command, 'low');
        }
      } else {
        setState(() {
          _response = "Network error. Please check your connection and try again.";
        });
      }
    } catch (e) {
      setState(() {
        _response = "Connection failed: $e";
      });
    } finally {
      setState(() => _processing = false);
      
      // Auto-restart listening after processing in auto mode
      if (_autoMode && !_isListening) {
        Future.delayed(Duration(seconds: 1), _startAutoListening);
      }
    }
  }

  void _executeRoadAction(String action, String command, String urgency) {
    Color urgencyColor = urgency == 'high' ? Colors.red : 
                        urgency == 'medium' ? Colors.orange : Colors.green;
    
    switch (action) {
      case 'traffic_check':
        _showActionFeedback('🚦 Checking Traffic Conditions...', urgencyColor);
        _analyzeTraffic(command);
        break;
      case 'weather_alert':
        _showActionFeedback('🌧️ Analyzing Weather Impact...', urgencyColor);
        _checkWeather(command);
        break;
      case 'car_repair':
        _showActionFeedback('🔧 Finding Repair Services...', urgencyColor);
        _findCarRepair(command);
        break;
      case 'road_assistance':
        _showActionFeedback('🛟 Connecting Road Assistance...', Colors.red);
        _callRoadAssistance(command);
        break;
      case 'navigation':
        _showActionFeedback('🧭 Optimizing Your Route...', urgencyColor);
        _optimizeRoute(command);
        break;
      case 'emergency':
        _showActionFeedback('🚨 Emergency Protocol Activated!', Colors.red);
        _handleEmergency(command);
        break;
      case 'service_finder':
        _showActionFeedback('🔍 Locating Service Providers...', urgencyColor);
        _findServices(command);
        break;
      case 'safety_tips':
        _showActionFeedback('🛡️ Providing Safety Guidance...', Colors.blue);
        _provideSafetyTips(command);
        break;
      default:
        _showActionFeedback('✅ Road Command Processed', Colors.grey);
    }
  }

  void _analyzeTraffic(String command) {
    String location = _extractLocation(command);
    if (location.isNotEmpty) {
      _showActionFeedback('🚦 Analyzing traffic around $location', Colors.orange);
    } else {
      _showActionFeedback('🚦 Checking current traffic conditions', Colors.orange);
    }
  }

  void _checkWeather(String command) {
    String location = _extractLocation(command);
    if (location.isNotEmpty) {
      _showActionFeedback('🌤️ Getting weather forecast for $location', Colors.blue);
    } else {
      _showActionFeedback('🌤️ Checking road weather conditions', Colors.blue);
    }
  }

  void _findCarRepair(String command) {
    String issue = command;
    if (command.contains('engine')) {
      issue = 'engine repair';
    } else if (command.contains('tire') || command.contains('flat')) {
      issue = 'tire service';
    } else if (command.contains('brake')) {
      issue = 'brake repair';
    }
    
    _showActionFeedback('🔧 Finding $issue specialists nearby', Colors.purple);
  }

  void _callRoadAssistance(String command) {
    _showActionFeedback('🛟 Dispatching road assistance to your location', Colors.red);
    // In real app, this would trigger emergency services
  }

  void _optimizeRoute(String command) {
    String destination = _extractLocation(command);
    if (destination.isNotEmpty) {
      _showActionFeedback('🧭 Calculating best route to $destination', Colors.teal);
    } else {
      _showActionFeedback('🧭 Optimizing your current route', Colors.teal);
    }
  }

  void _handleEmergency(String command) {
    _showActionFeedback('🚨 ALERT: Emergency services notified! Stay calm.', Colors.red);
    // In real app, this would contact emergency services
  }

  void _findServices(String command) {
    String serviceType = 'service';
    if (command.contains('fuel') || command.contains('gas')) {
      serviceType = 'fuel station';
    } else if (command.contains('mechanic')) {
      serviceType = 'mechanic';
    } else if (command.contains('tow')) {
      serviceType = 'towing service';
    }
    
    _showActionFeedback('📍 Finding nearest $serviceType', Colors.green);
  }

  void _provideSafetyTips(String command) {
    _showActionFeedback('🛡️ Generating safety recommendations', Colors.blue);
  }

  String _extractLocation(String command) {
    // Simple location extraction - in real app, use geocoding
    if (command.contains('near me') || command.contains('around here')) {
      return 'your location';
    }
    
    List<String> commonLocations = ['downtown', 'highway', 'freeway', 'bridge', 'tunnel'];
    for (String location in commonLocations) {
      if (command.contains(location)) {
        return location;
      }
    }
    
    return '';
  }

  void _showActionFeedback(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _clearConversation() {
    setState(() {
      _text = 'Tap the microphone for road assistance and traffic help';
      _response = '';
      _isListening = false;
    });
    _speech.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Road Assistant'),
        backgroundColor: Colors.deepOrange[600],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_autoMode ? Icons.autorenew : Icons.car_repair),
            onPressed: _toggleAutoMode,
            tooltip: _autoMode ? 'Auto Mode ON' : 'Auto Mode OFF',
          ),
          IconButton(
            icon: Icon(Icons.clear_all),
            onPressed: _clearConversation,
            tooltip: 'Clear',
          ),
          IconButton(
            icon: Icon(Icons.help),
            onPressed: _showRoadCommandsHelp,
            tooltip: 'Road Commands',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepOrange.shade50,
              Colors.white,
            ],
          ),
        ),
        child: Column(
          children: [
            // Auto Mode Indicator
            if (_autoMode)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                color: Colors.green[50],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.autorenew, color: Colors.green, size: 16),
                    SizedBox(width: 8),
                    Text(
                      'ROAD ASSISTANT: Always Monitoring',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

            // Voice Input Section
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Microphone Section
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: _autoMode ? _toggleAutoMode : (_isListening ? _stopListening : _startManualListening),
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: _isListening ? Colors.red : (_autoMode ? Colors.green : Colors.deepOrange[600]),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: (_isListening ? Colors.red : (_autoMode ? Colors.green : Colors.deepOrange[600]!)).withOpacity(0.4),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Icon(
                                _autoMode ? Icons.assistant : 
                                _isListening ? Icons.mic : Icons.car_repair,
                                color: Colors.white,
                                size: 50,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            _autoMode ? '🔄 ROAD ASSISTANT ACTIVE' : 
                            _isListening ? '🎤 LISTENING... DESCRIBE YOUR SITUATION' : '🚗 TAP FOR ROAD HELP',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _autoMode ? Colors.green : 
                                    _isListening ? Colors.red : Colors.deepOrange[600],
                            ),
                          ),
                          SizedBox(height: 10),
                          if (_autoMode)
                            Text(
                              'I\'m always here for road emergencies and assistance',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.green[600],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          if (_isListening && !_autoMode)
                            Text(
                              'Describe your traffic, weather, or car problem clearly',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 20),
                    
                    // Voice Input Text
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: _isListening ? Colors.green : Colors.grey[300]!,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (_isListening)
                                Icon(Icons.record_voice_over, color: Colors.green, size: 16),
                              if (_isListening) SizedBox(width: 8),
                              Text(
                                _isListening ? 'LIVE ROAD REPORT' : 'YOUR SITUATION',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: _isListening ? Colors.green : Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            _text,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: _isListening ? Colors.green : Colors.deepOrange[800],
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 30),
                    
                    // Assistant Response
                    if (_response.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.deepOrange[50],
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.deepOrange[200]!),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.assistant, color: Colors.deepOrange[700], size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'SMART ROAD ASSISTANT:',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.deepOrange[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              _response,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[800],
                                height: 1.4,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Processing Indicator
            if (_processing)
              Container(
                padding: EdgeInsets.all(16),
                color: Colors.deepOrange[50],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(width: 15),
                    Text(
                      'Analyzing road situation...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.deepOrange[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

            // Quick Road Actions
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(top: BorderSide(color: Colors.grey[300]!)),
              ),
              child: Column(
                children: [
                  Text(
                    '🚗 Common Road Commands:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      'Check traffic ahead',
                      'Weather conditions', 
                      'My car has engine trouble',
                      'Find nearest mechanic',
                      'I need road assistance',
                      'Optimize my route',
                      'Emergency help',
                      'Fuel station nearby',
                    ].map((command) {
                      return ActionChip(
                        label: Text(command),
                        onPressed: () {
                          setState(() => _text = command);
                          _processRoadCommand(command);
                        },
                        backgroundColor: Colors.deepOrange[100],
                        labelStyle: TextStyle(color: Colors.deepOrange[800], fontSize: 12),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRoadCommandsHelp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.assistant, color: Colors.deepOrange),
            SizedBox(width: 8),
            Text('Smart Road Commands'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Try these road-related commands:'),
              SizedBox(height: 15),
              Text('🚦 **Traffic & Navigation:**'),
              Text('• "Check traffic conditions ahead"'),
              Text('• "Is there heavy traffic downtown?"'),
              Text('• "Find the fastest route home"'),
              Text('• "Any accidents on highway 101?"'),
              
              SizedBox(height: 15),
              Text('🌧️ **Weather & Roads:**'),
              Text('• "What\'s the weather like for driving?"'),
              Text('• "Are roads icy ahead?"'),
              Text('• "Weather alert for my route"'),
              
              SizedBox(height: 15),
              Text('🔧 **Car Problems:**'),
              Text('• "My car won\'t start"'),
              Text('• "I have a flat tire"'),
              Text('• "Engine warning light is on"'),
              Text('• "Find a mechanic nearby"'),
              
              SizedBox(height: 15),
              Text('🛟 **Emergency & Assistance:**'),
              Text('• "I need road assistance"'),
              Text('• "Emergency - car breakdown"'),
              Text('• "Find nearest fuel station"'),
              Text('• "Call tow truck"'),
              
              SizedBox(height: 15),
              Text('Auto Mode Features:'),
              Text('• Continuous road monitoring'),
              Text('• Instant emergency response'),
              Text('• Automatic service provider matching'),
              Text('• Real-time traffic updates'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Drive Safe!'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }
}