import 'package:flutter/material.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/user_type_provider.dart';
import '../../../../widgets/exit_confirmation.dart';
import '../../../../core/api_client.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Common Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _documentNumberController = TextEditingController();
  
  // Customer Specific
  final _fullNameController = TextEditingController();
  
  // Lender Specific
  final _legalNameController = TextEditingController();
  String _selectedLenderType = 'personal';
  
  String _selectedDocumentType = 'Cédula';
  bool _obscurePassword = true;
  bool _acceptTerms = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _documentNumberController.dispose();
    _fullNameController.dispose();
    _legalNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final userType = context.watch<UserTypeProvider>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await showExitConfirmation(context);
        if (shouldPop && context.mounted) {
          context.go('/login');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.registerTitle),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    userType.isLender ? l10n.userTypeLender : l10n.userTypeCustomer,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(l10n.registerSubtitle),
                  const SizedBox(height: 32),
                  
                  if (userType.isCustomer) ...[
                    TextFormField(
                      controller: _fullNameController,
                      decoration: InputDecoration(
                        labelText: l10n.fullName,
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                      validator: (value) => (value == null || value.isEmpty) ? l10n.fullName : null,
                    ),
                  ] else ...[
                    TextFormField(
                      controller: _legalNameController,
                      decoration: InputDecoration(
                        labelText: l10n.legalName,
                        prefixIcon: const Icon(Icons.business_outlined),
                      ),
                      validator: (value) => (value == null || value.isEmpty) ? l10n.legalName : null,
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedLenderType,
                      decoration: InputDecoration(
                        labelText: l10n.lenderType,
                        prefixIcon: const Icon(Icons.category_outlined),
                      ),
                      items: [
                        DropdownMenuItem(value: 'personal', child: Text(l10n.personal)),
                        DropdownMenuItem(value: 'business', child: Text(l10n.business)),
                      ],
                      onChanged: (value) => setState(() => _selectedLenderType = value!),
                    ),
                  ],
                  
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedDocumentType,
                          decoration: InputDecoration(labelText: l10n.documentType),
                          items: const [
                            DropdownMenuItem(value: 'Cédula', child: Text('Cédula')),
                            DropdownMenuItem(value: 'RNC', child: Text('RNC')),
                            DropdownMenuItem(value: 'Pasaporte', child: Text('Pasaporte')),
                          ],
                          onChanged: (value) => setState(() => _selectedDocumentType = value!),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          controller: _documentNumberController,
                          decoration: InputDecoration(labelText: l10n.documentNumber),
                          keyboardType: TextInputType.number,
                          validator: (value) => (value == null || value.isEmpty) ? l10n.documentNumber : null,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: l10n.phone,
                      prefixIcon: const Icon(Icons.phone_outlined),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) => (value == null || value.isEmpty) ? l10n.phone : null,
                  ),
                  
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: l10n.email,
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) return l10n.email;
                      if (!value.contains('@')) return 'Email inválido';
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: l10n.password,
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return l10n.password;
                      if (value.length < 6) return 'Mínimo 6 caracteres';
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: l10n.confirmPassword,
                      prefixIcon: const Icon(Icons.lock_reset),
                    ),
                    validator: (value) => (value != _passwordController.text) ? l10n.passwordsDoNotMatch : null,
                  ),
                  
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Checkbox(
                        value: _acceptTerms,
                        onChanged: (value) => setState(() => _acceptTerms = value ?? false),
                      ),
                      Expanded(
                        child: Text(l10n.acceptTerms, style: const TextStyle(fontSize: 14)),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: !_acceptTerms || _isLoading ? null : _handleRegister,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : Text(l10n.registerButton),
                  ),
                  
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(l10n.alreadyHaveAccount),
                      TextButton(
                        onPressed: () => context.go('/login'),
                        child: Text(l10n.login),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final userType = context.read<UserTypeProvider>();

    setState(() => _isLoading = true);

    try {
      if (userType.isCustomer) {
        await ApiClient.instance.post(
          '/auth/register',
          data: {
            'email': _emailController.text.trim(),
            'password': _passwordController.text,
            'first_name': _firstNameFromFullName(_fullNameController.text),
            'last_name': _lastNameFromFullName(_fullNameController.text),
          },
        );
      } else {
        await ApiClient.instance.post(
          '/auth/register/lender',
          data: {
            'email': _emailController.text.trim(),
            'password': _passwordController.text,
            'legal_name': _legalNameController.text.trim(),
            'lender_type': _selectedLenderType == 'business' ? 'financial' : 'individual',
            'document_type': _selectedDocumentType,
            'document_number': _documentNumberController.text.trim(),
            'phone': _phoneController.text.trim(),
          },
        );
      }

      if (mounted) {
        context.go('/verify-email?email=${Uri.encodeComponent(_emailController.text.trim())}');
      }
    } on DioException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_extractError(error))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _firstNameFromFullName(String fullName) {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    return parts.first;
  }

  String _lastNameFromFullName(String fullName) {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return 'Usuario';
    }
    return parts.skip(1).join(' ');
  }

  String _extractError(DioException error) {
    final payload = error.response?.data;
    if (payload is Map && payload['error'] is Map && payload['error']['message'] is String) {
      return payload['error']['message'] as String;
    }
    if (payload is Map && payload['message'] is String) {
      return payload['message'] as String;
    }
    return 'No se pudo completar el registro.';
  }
}
