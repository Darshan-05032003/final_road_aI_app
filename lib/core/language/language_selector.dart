import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_road_app/core/language/bloc/language_bloc.dart';
import 'package:smart_road_app/core/language/bloc/language_event.dart';
import 'package:smart_road_app/core/language/bloc/language_state.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) {
        return PopupMenuButton<String>(
          icon: const Icon(Icons.language, color: Colors.white),
          tooltip: 'Change Language',
          onSelected: (String languageCode) {
            context.read<LanguageBloc>().add(
              ChangeLanguageByCodeEvent(languageCode),
            );
          },
          itemBuilder: (BuildContext context) {
            final currentLanguageCode = state.currentLanguageCode;
            
            return [
              _buildMenuItem('en', 'English', '🇺🇸', currentLanguageCode),
              _buildMenuItem('es', 'Español', '🇪🇸', currentLanguageCode),
              _buildMenuItem('hi', 'हिन्दी', '🇮🇳', currentLanguageCode),
              _buildMenuItem('fr', 'Français', '🇫🇷', currentLanguageCode),
            ];
          },
        );
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