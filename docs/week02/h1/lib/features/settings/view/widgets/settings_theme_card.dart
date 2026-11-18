import 'package:flutter/material.dart';

class SettingsThemeCard extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const SettingsThemeCard({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF101726) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDarkMode ? const Color(0xFF26334D) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: SwitchListTile(
          value: isDarkMode,
          onChanged: (_) => onToggleTheme(),
          activeTrackColor: const Color(0xFFEAB308),
          secondary: Icon(
            isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
            color: const Color(0xFFEAB308),
          ),
          title: Text(
            isDarkMode ? 'Obsidian Dark Mode' : 'Parchment Light Mode',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          subtitle: Text(
            isDarkMode ? 'Mythic RPG Obsidian Theme' : 'Royal Parchment Theme',
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
