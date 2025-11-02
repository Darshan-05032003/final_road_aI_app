import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;

class RealVoiceAssistant extends StatefulWidget {
  const RealVoiceAssistant({super.key});

  @override
  State<RealVoiceAssistant> createState() => _RealVoiceAssistantState();
}

class _RealVoiceAssistantState extends State<RealVoiceAssistant> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _text = 'Tap the microphone and speak your command';
  String _response = '';
  bool _processing = false;
  bool _speechAvailable = false;
  bool _autoMode = true; // Auto mode enabled by default

  final String _apiKey = "AIzaSyDQpesj3QbnhjVoM1hkA8Rlfuql96j3FRU";
  final String _url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent";

  @override
  void initState() {
    super.initState();
    _initSpeech();
    // Auto-start listening after initialization (optional)
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
      _text = '🎤 Listening automatically... Speak your command!';
      _response = '';
    });

    _speech.listen(
      onResult: (result) {
        setState(() {
          _text = result.recognizedWords;
        });
        
        // Automatically process when user stops speaking (final result)
        if (result.finalResult && result.recognizedWords.isNotEmpty) {
          _processVoiceCommand(result.recognizedWords);
        }
      },
      listenFor: Duration(seconds: 10), // Shorter duration for auto mode
      pauseFor: Duration(seconds: 2),   // Shorter pause for quicker response
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
      _text = 'Listening... Speak your command now!';
      _response = '';
    });

    try {
      await _speech.listen(
        onResult: (result) {
          setState(() {
            _text = result.recognizedWords;
          });
          
          if (result.finalResult) {
            _processVoiceCommand(result.recognizedWords);
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
      _showActionFeedback('🔄 Auto Mode: ON - Listening continuously', Colors.green);
    } else {
      _stopListening();
      _showActionFeedback('⏹ Auto Mode: OFF - Tap microphone to speak', Colors.blue);
    }
  }

  void _processVoiceCommand(String command) async {
    if (command.isEmpty) return;
    
    setState(() {
      _processing = true;
      _response = 'Processing: "$command"';
    });

    try {
      final String prompt = """
You are CampusMarket Voice Assistant. Users give voice commands and you need to understand their intent and provide actionable responses.

User voice command: "$command"

Based on the command, provide a helpful response and suggest the appropriate action. Focus on campus marketplace activities like buying, selling, renting items.

Respond in this exact JSON format:
{
  "action": "buy|sell|rent|search|navigate|help",
  "response": "Your spoken response to the user",
  "suggestion": "What action to take in the app"
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
        String aiResponse = data["candidates"][0]["content"]["parts"][0]["text"] ?? "I didn't understand that command. Please try again.";
        
        try {
          final Map<String, dynamic> parsedResponse = jsonDecode(aiResponse);
          setState(() {
            _response = parsedResponse['response'] ?? aiResponse;
          });
          _executeRealAction(parsedResponse['action'] ?? 'help', command);
        } catch (e) {
          setState(() {
            _response = aiResponse;
          });
          _executeRealAction('help', command);
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

  void _executeRealAction(String action, String command) {
    switch (action) {
      case 'buy':
        _showActionFeedback('🛍 Opening Buy Section...', Colors.green);
        // Navigate to buy section
        break;
      case 'sell':
        _showActionFeedback('💰 Opening Sell Items...', Colors.orange);
        // Navigate to sell section
        break;
      case 'rent':
        _showActionFeedback('🏠 Showing Rental Items...', Colors.blue);
        // Navigate to rent section
        break;
      case 'search':
        _showActionFeedback('🔍 Searching Products...', Colors.purple);
        _performSearch(command);
        break;
      case 'navigate':
        _showActionFeedback('🧭 Navigating...', Colors.teal);
        break;
      default:
        _showActionFeedback('✅ Command processed', Colors.grey);
    }
  }

  void _performSearch(String command) {
    String searchQuery = command;
    if (command.contains('search for')) {
      searchQuery = command.split('search for').last.trim();
    } else if (command.contains('find')) {
      searchQuery = command.split('find').last.trim();
    }
    
    if (searchQuery.isNotEmpty) {
      _showActionFeedback('🔍 Searching for: $searchQuery', Colors.purple);
    }
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
      _text = 'Tap the microphone and speak your command';
      _response = '';
      _isListening = false;
    });
    _speech.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voice Assistant'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_autoMode ? Icons.autorenew : Icons.mic),
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
            onPressed: _showVoiceCommandsHelp,
            tooltip: 'Voice Commands',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
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
                      'AUTO MODE: Listening Continuously',
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
                                color: _isListening ? Colors.red : (_autoMode ? Colors.green : Colors.blue[600]),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: (_isListening ? Colors.red : (_autoMode ? Colors.green : Colors.blue[600]!)).withOpacity(0.4),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Icon(
                                _autoMode ? Icons.autorenew : 
                                _isListening ? Icons.mic : Icons.mic_none,
                                color: Colors.white,
                                size: 50,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            _autoMode ? '🔄 AUTO LISTENING' : 
                            _isListening ? '🎤 LISTENING... SPEAK NOW' : '🎤 TAP TO SPEAK',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _autoMode ? Colors.green : 
                                    _isListening ? Colors.red : Colors.blue[600],
                            ),
                          ),
                          SizedBox(height: 10),
                          if (_autoMode)
                            Text(
                              'Speak any time - I\'m always listening!',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.green[600],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          if (_isListening && !_autoMode)
                            Text(
                              'I\'m listening... speak your command clearly',
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
                                _isListening ? 'LIVE VOICE INPUT' : 'YOUR COMMAND',
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
                              color: _isListening ? Colors.green : Colors.blue[800],
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
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.blue[200]!),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.smart_toy, color: Colors.blue[700], size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'VOICE ASSISTANT:',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.blue[700],
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
                color: Colors.blue[50],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(width: 15),
                    Text(
                      'Processing voice command...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

            // Quick Actions
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(top: BorderSide(color: Colors.grey[300]!)),
              ),
              child: Column(
                children: [
                  Text(
                    '💡 Try these voice commands:',
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
                      'I want to buy textbooks',
                      'Show me items for rent', 
                      'How to sell my laptop',
                      'Search for calculators',
                      'Open buy section',
                    ].map((command) {
                      return ActionChip(
                        label: Text(command),
                        onPressed: () {
                          setState(() => _text = command);
                          _processVoiceCommand(command);
                        },
                        backgroundColor: Colors.blue[100],
                        labelStyle: TextStyle(color: Colors.blue[800], fontSize: 12),
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

  void _showVoiceCommandsHelp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Voice Commands Guide'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Try saying:'),
              SizedBox(height: 10),
              Text('• "I want to buy engineering textbooks"'),
              Text('• "Show me items for rent"'),
              Text('• "How do I sell my laptop?"'),
              Text('• "Search for calculators"'),
              Text('• "Navigate to buy section"'),
              Text('• "Help me rent a camera"'),
              SizedBox(height: 15),
              Text('Auto Mode Features:'),
              Text('• Continuous listening'),
              Text('• Automatic command processing'),
              Text('• Auto-restart after each command'),
              Text('• Green indicator when active'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
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