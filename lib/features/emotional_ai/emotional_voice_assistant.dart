// lib/features/emotional_ai/emotional_voice_assistant.dart
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'dart:math';

class EmotionalVoiceAssistant extends StatefulWidget {
  @override
  _EmotionalVoiceAssistantState createState() => _EmotionalVoiceAssistantState();
}

class _EmotionalVoiceAssistantState extends State<EmotionalVoiceAssistant> 
    with SingleTickerProviderStateMixin {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  bool _isListening = false;
  String _recognizedText = '';
  List<EmotionalMessage> _messages = [];
  late AnimationController _emotionController;
  late Animation<double> _emotionAnimation;
  
  String _currentEmotion = "calm";
  double _stressLevel = 0.3;
  bool _isSpeaking = false;

  // Emotional responses based on detected mood
  final Map<String, List<String>> _emotionalResponses = {
    "stressed": [
      "I notice you seem stressed. Let me find the calmest route and play some relaxing music for you.",
      "Take a deep breath. I'm adjusting the route to avoid traffic and reduce your stress.",
      "I understand this is frustrating. I'll find a smoother route with less congestion.",
      "Stress detected. How about some calming music and a scenic detour?",
    ],
    "angry": [
      "I sense some frustration. Let me handle the navigation while you focus on driving safely.",
      "I understand this is annoying. I'm rerouting to get you there faster and smoother.",
      "Road rage detected. Taking over navigation to ensure your safety.",
      "Let me help you relax. Changing to a less congested route immediately.",
    ],
    "tired": [
      "You seem tired. There's a rest stop in 5 miles. Would you like me to navigate there?",
      "Fatigue detected. How about some energizing music and a coffee shop suggestion?",
      "I notice you're getting tired. Let me find the quickest route so you can rest sooner.",
      "Tiredness detected. Playing some upbeat music to keep you alert and focused.",
    ],
    "calm": [
      "You're doing great! Maintaining a calm driving style. Current route is optimized for comfort.",
      "Perfect driving conditions detected. Your calm mood is helping fuel efficiency.",
      "I appreciate your relaxed driving. This is the safest way to travel!",
      "Calm and collected - perfect for driving. Route is clear and traffic-free.",
    ],
    "happy": [
      "Great to hear you're in a good mood! How about some upbeat music for your journey?",
      "Positive energy detected! Let's make this drive even more enjoyable with a scenic route.",
      "Your happy mood is contagious! Route is optimized for maximum enjoyment.",
      "Wonderful! I'll keep the good vibes going with smooth navigation and great music.",
    ],
  };

  final Map<String, Color> _emotionColors = {
    "stressed": Colors.orange,
    "angry": Colors.red,
    "tired": Colors.blue,
    "calm": Colors.green,
    "happy": Colors.purple,
  };

  final Map<String, IconData> _emotionIcons = {
    "stressed": Icons.psychology_outlined,
    "angry": Icons.mood_bad,
    "tired": Icons.nightlight_round,
    "calm": Icons.self_improvement,
    "happy": Icons.emoji_emotions,
  };

  @override
  void initState() {
    super.initState();
    _emotionController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    
    _emotionAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _emotionController, curve: Curves.easeInOut)
    );

    _initializeTTS();
    _addWelcomeMessage();
  }

  void _initializeTTS() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setPitch(1.0);
  }

  void _addWelcomeMessage() {
    _addAIMessage(
      "Hello! I'm your emotional AI assistant. I can sense your mood and adjust my responses accordingly. How are you feeling today?",
      emotion: "calm"
    );
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
    
    // Analyze emotion from text
    final detectedEmotion = _analyzeEmotion(input);
    _updateEmotionState(detectedEmotion);
    
    // Generate emotional response
    Future.delayed(Duration(seconds: 1), () {
      final response = _generateEmotionalResponse(input, detectedEmotion);
      _addAIMessage(response, emotion: detectedEmotion);
      _speakResponse(response);
    });
  }

  String _analyzeEmotion(String text) {
    text = text.toLowerCase();
    
    // Simple emotion analysis
    if (text.contains('stress') || text.contains('pressure') || text.contains('anxious')) {
      return "stressed";
    } else if (text.contains('angry') || text.contains('mad') || text.contains('frustrat')) {
      return "angry";
    } else if (text.contains('tired') || text.contains('sleep') || text.contains('exhaust')) {
      return "tired";
    } else if (text.contains('happy') || text.contains('good') || text.contains('great') || text.contains('excite')) {
      return "happy";
    } else {
      // Random emotion for variety in demo
      List<String> emotions = ["calm", "happy", "calm"];
      return emotions[Random().nextInt(emotions.length)];
    }
  }

  void _updateEmotionState(String emotion) {
    setState(() {
      _currentEmotion = emotion;
      // Update stress level based on emotion
      switch (emotion) {
        case "stressed":
          _stressLevel = 0.8;
          break;
        case "angry":
          _stressLevel = 0.9;
          break;
        case "tired":
          _stressLevel = 0.6;
          break;
        case "happy":
          _stressLevel = 0.2;
          break;
        case "calm":
          _stressLevel = 0.3;
          break;
      }
    });
  }

  String _generateEmotionalResponse(String input, String emotion) {
    final responses = _emotionalResponses[emotion] ?? _emotionalResponses["calm"]!;
    String baseResponse = responses[Random().nextInt(responses.length)];
    
    // Add context-specific actions
    if (input.toLowerCase().contains('route') || input.toLowerCase().contains('direction')) {
      baseResponse += " I'm optimizing your route for a ${emotion == "stressed" || emotion == "angry" ? "calmer" : "more enjoyable"} journey.";
    }
    
    if (input.toLowerCase().contains('music')) {
      baseResponse += " Playing ${_getMusicSuggestion(emotion)} music to match your mood.";
    }
    
    if (input.toLowerCase().contains('weather')) {
      baseResponse += " Weather is perfect for driving - 72°F and clear skies.";
    }
    
    return baseResponse;
  }

  String _getMusicSuggestion(String emotion) {
    switch (emotion) {
      case "stressed":
        return "calming classical";
      case "angry":
        return "soothing instrumental";
      case "tired":
        return "upbeat and energetic";
      case "happy":
        return "your favorite upbeat";
      case "calm":
        return "light jazz";
      default:
        return "relaxing";
    }
  }

  void _speakResponse(String text) async {
    setState(() => _isSpeaking = true);
    await _flutterTts.speak(text);
    // Note: There's no reliable way to detect when TTS finishes in Flutter
    Future.delayed(Duration(seconds: text.length ~/ 10), () {
      setState(() => _isSpeaking = false);
    });
  }

  void _addUserMessage(String text) {
    setState(() {
      _messages.add(EmotionalMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
    });
  }

  void _addAIMessage(String text, {required String emotion}) {
    setState(() {
      _messages.add(EmotionalMessage(
        text: text,
        isUser: false,
        timestamp: DateTime.now(),
        emotion: emotion,
      ));
    });
  }

  void _changeEmotionManually(String emotion) {
    _updateEmotionState(emotion);
    final response = "I see you're feeling ${emotion}. ${_emotionalResponses[emotion]?[0] ?? "How can I help you?"}";
    _addAIMessage(response, emotion: emotion);
    _speakResponse(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Emotional AI Assistant"),
        backgroundColor: _emotionColors[_currentEmotion],
        elevation: 0,
      ),
      body: Column(
        children: [
          // Emotion Status Bar
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _emotionColors[_currentEmotion]!,
                  _emotionColors[_currentEmotion]!.withOpacity(0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                ScaleTransition(
                  scale: _emotionAnimation,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _emotionIcons[_currentEmotion],
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentEmotion.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: _stressLevel,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Stress Level: ${(_stressLevel * 100).toInt()}%",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_isSpeaking)
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.volume_up, color: Colors.white, size: 20),
                  ),
              ],
            ),
          ),

          // Quick Emotion Selector
          Container(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                _buildEmotionButton("calm", "Calm"),
                _buildEmotionButton("happy", "Happy"),
                _buildEmotionButton("tired", "Tired"),
                _buildEmotionButton("stressed", "Stressed"),
                _buildEmotionButton("angry", "Angry"),
              ],
            ),
          ),

          // Chat Messages
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                return EmotionalChatBubble(message: message);
              },
            ),
          ),

          // Input Section
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
                      color: _emotionColors[_currentEmotion]!.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.mic, color: _emotionColors[_currentEmotion], size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _recognizedText,
                            style: TextStyle(color: _emotionColors[_currentEmotion]!.withOpacity(0.8)),
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
                          hintText: "How are you feeling?",
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
                    AvatarGlow(
  glowColor: _emotionColors[_currentEmotion]!,
  animate: _isListening,
  duration: Duration(milliseconds: 2000),
  repeat: true,
  
  child: FloatingActionButton(
    onPressed: _startListening,
    backgroundColor: _isListening ? Colors.red : _emotionColors[_currentEmotion],
    child: Icon(
      _isListening ? Icons.mic : Icons.mic_none, 
      size: 30,
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

  Widget _buildEmotionButton(String emotion, String label) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      child: ElevatedButton(
        onPressed: () => _changeEmotionManually(emotion),
        style: ElevatedButton.styleFrom(
          backgroundColor: _emotionColors[emotion]!.withOpacity(0.1),
          foregroundColor: _emotionColors[emotion],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_emotionIcons[emotion], size: 16),
            SizedBox(width: 4),
            Text(label),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emotionController.dispose();
    _speech.stop();
    _flutterTts.stop();
    super.dispose();
  }
}

class EmotionalChatBubble extends StatelessWidget {
  final EmotionalMessage message;

  const EmotionalChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final emotionColor = _getEmotionColor(message.emotion);
    
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
                backgroundColor: emotionColor,
                radius: 16,
                child: Icon(Icons.psychology, color: Colors.white, size: 16),
              ),
            ),
          
          Flexible(
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: message.isUser 
                    ? Colors.blue[100] 
                    : emotionColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                border: message.isUser ? null : Border.all(
                  color: emotionColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!message.isUser && message.emotion != "calm")
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: emotionColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        message.emotion.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: emotionColor,
                        ),
                      ),
                    ),
                  if (!message.isUser && message.emotion != "calm") SizedBox(height: 4),
                  Text(
                    message.text,
                    style: TextStyle(
                      fontSize: 14,
                      color: message.isUser ? Colors.blue[900] : Colors.grey[800],
                    ),
                  ),
                ],
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

  Color _getEmotionColor(String emotion) {
    final colors = {
      "stressed": Colors.orange,
      "angry": Colors.red,
      "tired": Colors.blue,
      "calm": Colors.green,
      "happy": Colors.purple,
    };
    return colors[emotion] ?? Colors.grey;
  }
}

class EmotionalMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String emotion;

  EmotionalMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.emotion = "calm",
  });
}