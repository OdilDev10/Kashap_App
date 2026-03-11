import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

import '../../../../core/api_client.dart';

enum AuthStatus { initial, unauthenticated, authenticated, loading }

class AuthProvider extends ChangeNotifier {
  static const String _kTokenKey = 'jwt_token';
  static const String _kRefreshTokenKey = 'refresh_token';
  final _storage = const FlutterSecureStorage();
  
  AuthStatus _status = AuthStatus.initial;
  String? _token;
  String? _refreshToken;
  String? _errorMessage;
  Map<String, dynamic>? _user;

  AuthStatus get status => _status;
  String? get token => _token;
  String? get refreshToken => _refreshToken;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get user => _user;

  AuthProvider() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkAuth();
    });
  }

  Future<void> checkAuth() async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
    
    _token = await _storage.read(key: _kTokenKey);
    _refreshToken = await _storage.read(key: _kRefreshTokenKey);

    if (_token == null) {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return;
    }

    try {
      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/auth/me',
        options: Options(
          headers: {
            'Authorization': 'Bearer $_token',
          },
        ),
      );
      _user = response.data;
      _status = AuthStatus.authenticated;
    } catch (_) {
      await logout(notify: false);
      _status = AuthStatus.unauthenticated;
    }

    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiClient.instance.post<Map<String, dynamic>>(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      final data = response.data ?? const <String, dynamic>{};

      _token = data['access_token'] as String?;
      _refreshToken = data['refresh_token'] as String?;
      _user = Map<String, dynamic>.from(data['user'] as Map? ?? const {});

      if (_token == null) {
        throw Exception('Missing access token');
      }

      await _storage.write(key: _kTokenKey, value: _token);
      if (_refreshToken != null) {
        await _storage.write(key: _kRefreshTokenKey, value: _refreshToken);
      }

      _status = AuthStatus.authenticated;
    } on DioException catch (error) {
      _errorMessage = _extractError(error);
      _status = AuthStatus.unauthenticated;
    } catch (_) {
      _errorMessage = 'No se pudo iniciar sesión.';
      _status = AuthStatus.unauthenticated;
    } finally {
      notifyListeners();
    }
  }

  Future<void> logout({bool notify = true}) async {
    await _storage.delete(key: _kTokenKey);
    await _storage.delete(key: _kRefreshTokenKey);
    _token = null;
    _refreshToken = null;
    _user = null;
    _errorMessage = null;
    _status = AuthStatus.unauthenticated;
    if (notify) {
      notifyListeners();
    }
  }

  String _extractError(DioException error) {
    final payload = error.response?.data;
    if (payload is Map && payload['error'] is Map) {
      final message = payload['error']['message'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
    }

    if (payload is Map && payload['message'] is String) {
      return payload['message'] as String;
    }

    return 'Ocurrió un error de autenticación.';
  }
}
