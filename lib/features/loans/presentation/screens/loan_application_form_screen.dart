import 'package:flutter/material.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/form_components.dart';

class LoanApplicationFormScreen extends StatefulWidget {
  final String? customerId;
  const LoanApplicationFormScreen({super.key, this.customerId});

  @override
  State<LoanApplicationFormScreen> createState() => _LoanApplicationFormScreenState();
}

class _LoanApplicationFormScreenState extends State<LoanApplicationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _installmentsController = TextEditingController();
  final _purposeController = TextEditingController();
  String _selectedFrequency = 'monthly';

  @override
  void dispose() {
    _amountController.dispose();
    _installmentsController.dispose();
    _purposeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.newLoanApplication),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Detalles del Préstamo',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              InputField(
                controller: _amountController,
                label: l10n.amount,
                prefixIcon: Icons.monetization_on_outlined,
                keyboardType: TextInputType.number,
                validator: (v) => (v == null || v.isEmpty) ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 20),
              InputField(
                controller: _installmentsController,
                label: l10n.installments,
                prefixIcon: Icons.repeat_on_outlined,
                keyboardType: TextInputType.number,
                validator: (v) => (v == null || v.isEmpty) ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedFrequency,
                decoration: InputDecoration(
                  labelText: l10n.frequency,
                  prefixIcon: const Icon(Icons.calendar_today_outlined),
                ),
                items: [
                  DropdownMenuItem(value: 'weekly', child: Text(l10n.weekly)),
                  DropdownMenuItem(value: 'biweekly', child: Text(l10n.biweekly)),
                  DropdownMenuItem(value: 'monthly', child: Text(l10n.monthly)),
                ],
                onChanged: (v) => setState(() => _selectedFrequency = v!),
              ),
              const SizedBox(height: 20),
              InputField(
                controller: _purposeController,
                label: l10n.purpose,
                prefixIcon: Icons.info_outline,
                validator: (v) => (v == null || v.isEmpty) ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _handleSubmit,
                child: Text(l10n.apply),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      // TODO: Call LoanService to submit
      context.pop();
    }
  }
}
