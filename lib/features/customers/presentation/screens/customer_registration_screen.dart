import 'package:flutter/material.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/form_components.dart';

class CustomerRegistrationScreen extends StatefulWidget {
  const CustomerRegistrationScreen({super.key});

  @override
  State<CustomerRegistrationScreen> createState() => _CustomerRegistrationScreenState();
}

class _CustomerRegistrationScreenState extends State<CustomerRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _documentNumberController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _creditLimitController = TextEditingController();
  String _selectedDocumentType = 'Cédula';

  @override
  void dispose() {
    _fullNameController.dispose();
    _documentNumberController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _creditLimitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.addCustomer),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InputField(
                controller: _fullNameController,
                label: l10n.fullName,
                prefixIcon: Icons.person_outline,
                validator: (v) => (v == null || v.isEmpty) ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      value: _selectedDocumentType,
                      decoration: InputDecoration(labelText: l10n.documentType),
                      items: const [
                        DropdownMenuItem(value: 'Cédula', child: Text('Cédula')),
                        DropdownMenuItem(value: 'RNC', child: Text('RNC')),
                        DropdownMenuItem(value: 'Pasaporte', child: Text('Pasaporte')),
                      ],
                      onChanged: (v) => setState(() => _selectedDocumentType = v!),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: InputField(
                      controller: _documentNumberController,
                      label: l10n.documentNumber,
                      keyboardType: TextInputType.number,
                      validator: (v) => (v == null || v.isEmpty) ? 'Campo requerido' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              InputField(
                controller: _phoneController,
                label: l10n.phone,
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (v) => (v == null || v.isEmpty) ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 20),
              InputField(
                controller: _emailController,
                label: l10n.email,
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              InputField(
                controller: _creditLimitController,
                label: l10n.creditLimit,
                prefixIcon: Icons.monetization_on_outlined,
                keyboardType: TextInputType.number,
                validator: (v) => (v == null || v.isEmpty) ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _handleSave,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                ),
                child: Text(l10n.save),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      // TODO: Call CustomerService to save
      context.pop();
    }
  }
}
