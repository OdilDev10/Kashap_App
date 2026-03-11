import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingProvider extends ChangeNotifier {
  static const String _kOnboardingKey = 'onboarding_completed';
  final SharedPreferences _prefs;
  
  bool _isCompleted = false;

  bool get isCompleted => _isCompleted;

  OnboardingProvider(this._prefs) {
    _isCompleted = _prefs.getBool(_kOnboardingKey) ?? false;
  }

  Future<void> completeOnboarding() async {
    _isCompleted = true;
    await _prefs.setBool(_kOnboardingKey, true);
    notifyListeners();
  }
  
  Future<void> resetOnboarding() async {
    _isCompleted = false;
    await _prefs.setBool(_kOnboardingKey, false);
    notifyListeners();
  }
}
