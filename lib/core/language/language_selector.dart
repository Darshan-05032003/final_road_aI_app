import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_road_app/core/language/language_service.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);
    
    return PopupMenuButton<String>(
      icon: const Icon(Icons.language, color: Colors.white),
      tooltip: 'Change Language',
      onSelected: (String languageCode) {
        languageService.changeLanguageByCode(languageCode);
      },
      itemBuilder: (BuildContext context) {
        final currentLanguageCode = languageService.currentLanguageCode;
        
        return [
          _buildMenuItem('en', 'English', '🇺🇸', currentLanguageCode),
          _buildMenuItem('es', 'Español', '🇪🇸', currentLanguageCode),
          _buildMenuItem('hi', 'हिन्दी', '🇮🇳', currentLanguageCode),
          _buildMenuItem('fr', 'Français', '🇫🇷', currentLanguageCode),
        ];
      },
    );
  }

  PopupMenuItem<String> _buildMenuItem(
    String code, 
    String name, 
    String flag, 
    String currentCode
  ) {
    return PopupMenuItem<String>(
      value: code,
      child: Row(
        children: [
          Text(flag),
          const SizedBox(width: 12),
          Text(name),
          if (code == currentCode) ...[
            const Spacer(),
            const Icon(Icons.check, size: 16, color: Colors.blue),
          ],
        ],
      ),
    );
  }
}