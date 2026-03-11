import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/settings_provider.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    
    return IconButton(
      icon: Icon(
        settings.isDarkMode ? Icons.light_mode : Icons.dark_mode,
      ),
      onPressed: () => settings.toggleTheme(),
      tooltip: settings.isDarkMode ? 'Modo claro' : 'Modo oscuro',
    );
  }
}
