import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/api_client.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;
  final String? token;

  const EmailVerificationScreen({
    super.key,
    required this.email,
    this.token,
  });

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool _isLoading = false;
  bool _isVerified = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.token != null && widget.token!.isNotEmpty) {
      _verifyEmail();
    }
  }

  Future<void> _verifyEmail() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await ApiClient.instance.post(
        '/auth/verify-email',
        data: {
          'token': widget.token,
        },
      );
      if (mounted) {
        setState(() => _isVerified = true);
      }
    } on DioException catch (error) {
      if (mounted) {
        setState(() => _error = _extractError(error));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _extractError(DioException error) {
    final payload = error.response?.data;
    if (payload is Map && payload['error'] is Map && payload['error']['message'] is String) {
      return payload['error']['message'] as String;
    }
    if (payload is Map && payload['message'] is String) {
      return payload['message'] as String;
    }
    return 'No se pudo verificar el correo.';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verificar Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.mark_email_read_outlined, size: 80, color: Colors.blue),
            const SizedBox(height: 32),
            Text(
              'Verifica tu correo electrónico',
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            if (widget.email.isNotEmpty) ...[
              Text(
                'Hemos enviado un enlace de confirmación a:',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                widget.email,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
            const SizedBox(height: 24),
            Text(
              _isLoading
                  ? 'Verificando enlace...'
                  : _isVerified
                      ? 'Tu correo fue verificado correctamente. Ya puedes iniciar sesión.'
                      : _error ??
                          'Por favor, revisa tu bandeja de entrada (y la carpeta de spam) y haz clic en el enlace para activar tu cuenta.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => context.go('/login'),
              child: const Text('Ir al Login'),
            ),
            const SizedBox(height: 16),
            if (widget.token != null && widget.token!.isNotEmpty && !_isVerified)
              TextButton(
                onPressed: _isLoading ? null : _verifyEmail,
                child: const Text('Reintentar verificación'),
              ),
          ],
        ),
      ),
    );
  }
}
