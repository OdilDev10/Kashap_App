import 'package:flutter/material.dart';

import 'api_client.dart';

class AppConfigProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isLoaded = false;
  String? _error;
  String _appName = 'Cuota';
  String _version = '0.0.0';
  String _environment = 'development';
  Map<String, bool> _features = const {};

  bool get isLoading => _isLoading;
  bool get isLoaded => _isLoaded;
  String? get error => _error;
  String get appName => _appName;
  String get version => _version;
  String get environment => _environment;
  Map<String, bool> get features => _features;

  Future<void> load() async {
    if (_isLoading || _isLoaded) {
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiClient.instance.get<Map<String, dynamic>>('/app/config');
      final data = response.data ?? const <String, dynamic>{};

      _appName = data['app_name'] as String? ?? _appName;
      _version = data['version'] as String? ?? _version;
      _environment = data['environment'] as String? ?? _environment;
      _features = Map<String, bool>.from(data['features'] as Map? ?? const {});
      _isLoaded = true;
    } catch (_) {
      _error = 'No se pudo cargar la configuración inicial.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
