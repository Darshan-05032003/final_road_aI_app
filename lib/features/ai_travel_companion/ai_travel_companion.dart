// lib/features/ai_travel_companion/ai_travel_companion.dart
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:avatar_glow/avatar_glow.dart';
import 'dart:math';

class AITravelCompanion extends StatefulWidget {
  @override
  _AITravelCompanionState createState() => _AITravelCompanionState();
}

class _AITravelCompanionState extends State<AITravelCompanion> 
    with SingleTickerProviderStateMixin {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _recognizedText = '';
  List<ChatMessage> _messages = [];
  late AnimationController _animationController;
  late Animation<double> _bubbleAnimation;

  final List<String> _aiResponses = [
    "I've found the safest route to your destination! It avoids construction and has minimal traffic.",
    "Based on current conditions, I recommend taking Highway 101. It's 15 minutes faster than the alternative.",
    "I notice you're driving during rush hour. Let me find a route with less congestion for you.",
    "Weather alert: Light rain expected in 20 minutes. I've adjusted the route to avoid slippery roads.",
    "There's an accident reported 5 miles ahead. I'm rerouting you to save 10 minutes.",
    "I found a beautiful scenic route that's only 5 minutes longer. Would you like to take it?",
    "Your current speed is perfect for fuel efficiency. Maintaining this will save you 15% on gas.",
    "I detected a rest stop coming up in 2 miles. Perfect timing for a quick break!",
  ];

  final List<String> _routeSuggestions = [
    "🚗 Fastest Route: 25 mins via I-280",
    "🛣️ Scenic Route: 32 mins via Coastal Highway", 
    "⛽ Eco Route: 28 mins, saves 20% fuel",
    "🛑 Safest Route: 30 mins, avoids highways",
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    )..repeat(reverse: true);
    
    _bubbleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut)
    );

    // Add welcome message
    _addAIMessage("Hello! I'm your AI travel companion. Ask me for directions, route suggestions, or travel advice!");
  }

  void _startListening() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) {
            setState(() {
              _recognizedText = result.recognizedWords;
            });
            if (result.finalResult) {
              _processUserInput(_recognizedText);
            }
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _processUserInput(String input) {
    if (input.isEmpty) return;
    
    _addUserMessage(input);
    
    // Simulate AI processing
    Future.delayed(Duration(seconds: 1), () {
      final response = _generateAIResponse(input);
      _addAIMessage(response);
      
      // If it's a route request, show route options
      if (input.toLowerCase().contains('route') || 
          input.toLowerCase().contains('direction') ||
          input.toLowerCase().contains('how to get')) {
        _showRouteSuggestions();
      }
    });
  }

  String _generateAIResponse(String input) {
    input = input.toLowerCase();
    
    if (input.contains('hello') || input.contains('hi')) {
      return "Hello! Ready to help with your journey. Where would you like to go?";
    } else if (input.contains('weather')) {
      return "Current weather: 72°F, partly cloudy. Perfect driving conditions!";
    } else if (input.contains('traffic')) {
      return "Traffic is light on your route. Estimated travel time: 25 minutes.";
    } else if (input.contains('gas') || input.contains('fuel')) {
      return "There's a gas station in 2 miles with prices 10% below average.";
    } else if (input.contains('rest') || input.contains('tired')) {
      return "I found a rest area in 5 miles. Would you like me to navigate there?";
    } else if (input.contains('food') || input.contains('hungry')) {
      return "There are 3 highly-rated restaurants at your next exit. Mexican, Italian, or American?";
    } else {
      // Return random AI response
      return _aiResponses[Random().nextInt(_aiResponses.length)];
    }
  }

  void _showRouteSuggestions() {
    Future.delayed(Duration(seconds: 2), () {
      _addAIMessage("Here are your route options:");
      for (String route in _routeSuggestions) {
        _addRouteSuggestion(route);
      }
    });
  }

  void _addUserMessage(String text) {
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
    });
  }

  void _addAIMessage(String text) {
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });
  }

  void _addRouteSuggestion(String route) {
    setState(() {
      _messages.add(ChatMessage(
        text: route,
        isUser: false,
        isRoute: true,
        timestamp: DateTime.now(),
      ));
    });
  }

  void _selectRoute(String route) {
    _addUserMessage("I'll take: $route");
    _addAIMessage("Excellent choice! Navigating you now. Estimated arrival: 25 minutes.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AI Travel Companion"),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Chat Messages
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                return ChatBubble(
                  message: message,
                  onRouteSelect: _selectRoute,
                );
              },
            ),
          ),
          
          // Voice Input Section
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ],
            ),
            child: Column(
              children: [
                if (_recognizedText.isNotEmpty)
                  Container(
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.mic, color: Colors.blue, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _recognizedText,
                            style: TextStyle(color: Colors.blue[800]),
                          ),
                        ),
                      ],
                    ),
                  ),
                
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Type your message...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        ),
                        onSubmitted: (text) {
                          if (text.isNotEmpty) {
                            _processUserInput(text);
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 12),
                    ScaleTransition(
                      scale: _bubbleAnimation,
                      child: AvatarGlow(
                        glowColor: Colors.blue,
                        
                        duration: Duration(milliseconds: 2000),
                        repeat: true,
                        
                        
                        child: FloatingActionButton(
                          onPressed: _startListening,
                          backgroundColor: _isListening ? Colors.red : Colors.blue,
                          child: Icon(
                            _isListening ? Icons.mic : Icons.mic_none, 
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _speech.stop();
    super.dispose();
  }
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final Function(String)? onRouteSelect;

  const ChatBubble({required this.message, this.onRouteSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser)
            Container(
              margin: EdgeInsets.only(right: 8, top: 4),
              child: CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 16,
                child: Icon(Icons.smart_toy, color: Colors.white, size: 16),
              ),
            ),
          
          Flexible(
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: message.isUser ? Colors.blue[100] : Colors.grey[100],
                borderRadius: BorderRadius.circular(15),
              ),
              child: message.isRoute 
                  ? RouteSuggestionCard(
                      route: message.text,
                      onSelect: onRouteSelect,
                    )
                  : Text(
                      message.text,
                      style: TextStyle(
                        fontSize: 14,
                        color: message.isUser ? Colors.blue[900] : Colors.grey[800],
                      ),
                    ),
            ),
          ),
          
          if (message.isUser)
            Container(
              margin: EdgeInsets.only(left: 8, top: 4),
              child: CircleAvatar(
                backgroundColor: Colors.green,
                radius: 16,
                child: Icon(Icons.person, color: Colors.white, size: 16),
              ),
            ),
        ],
      ),
    );
  }
}

class RouteSuggestionCard extends StatelessWidget {
  final String route;
  final Function(String)? onSelect;

  const RouteSuggestionCard({required this.route, this.onSelect});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onSelect?.call(route),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.blue),
        ),
        child: Row(
          children: [
            Icon(Icons.directions_car, color: Colors.blue),
            SizedBox(width: 8),
            Expanded(child: Text(route)),
            Icon(Icons.arrow_forward, color: Colors.blue, size: 16),
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isRoute;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isRoute = false,
  });
}