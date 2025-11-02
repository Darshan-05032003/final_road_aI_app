import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'language_service.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);
    
    return PopupMenuButton<String>(
      icon: const Icon(Icons.language, color: Colors.white),
      onSelected: (String languageCode) {
        languageService.changeLanguageByCode(languageCode);
      },
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem<String>(
          value: 'en',
          child: Row(
            children: [
              Text('🇺🇸 '),
              SizedBox(width: 8),
              Text('English'),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'es',
          child: Row(
            children: [
              Text('🇪🇸 '),
              SizedBox(width: 8),
              Text('Español'),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'hi',
          child: Row(
            children: [
              Text('🇮🇳 '),
              SizedBox(width: 8),
              Text('हिन्दी'),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'fr',
          child: Row(
            children: [
              Text('🇫🇷 '),
              SizedBox(width: 8),
              Text('Français'),
            ],
          ),
        ),
      ],
    );
  }
}