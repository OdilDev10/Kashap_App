import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/settings_provider.dart';

class LanguageToggle extends StatelessWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    
    return IconButton(
      icon: Text(
        settings.locale.languageCode.toUpperCase(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      onPressed: () {
        final newLang = settings.locale.languageCode == 'es' ? 'en' : 'es';
        settings.setLocale(newLang);
      },
      tooltip: settings.locale.languageCode == 'es' ? 'Cambiar a inglés' : 'Cambiar a español',
    );
  }
}
