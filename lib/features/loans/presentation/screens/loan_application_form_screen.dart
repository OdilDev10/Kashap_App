import 'package:app/core/widgets/form_components.dart';
import 'package:app/features/loans/services/loan_service.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoanApplicationFormScreen extends StatefulWidget {
  const LoanApplicationFormScreen({super.key, this.customerId});

  final String? customerId;

  @override
  State<LoanApplicationFormScreen> createState() => _LoanApplicationFormScreenState();
}

class _LoanApplicationFormScreenState extends State<LoanApplicationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _loanService = LoanService();
  final _amountController = TextEditingController();
  final _interestRateController = TextEditingController(text: '15');
  final _installmentsController = TextEditingController();
  final _purposeController = TextEditingController();
  String _selectedFrequency = 'monthly';
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void dispose() {
    _amountController.dispose();
    _interestRateController.dispose();
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
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) => (v == null || v.isEmpty) ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 20),
              InputField(
                controller: _interestRateController,
                label: 'Interés (%)',
                prefixIcon: Icons.percent,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                initialValue: _selectedFrequency,
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
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _isSaving ? null : _handleSubmit,
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(l10n.apply),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final amount = double.tryParse(_amountController.text.trim().replaceAll(',', '.'));
    final rate = double.tryParse(_interestRateController.text.trim().replaceAll(',', '.'));
    final installments = int.tryParse(_installmentsController.text.trim());

    if (amount == null || rate == null || installments == null) {
      setState(() {
        _errorMessage = 'Hay valores numéricos inválidos en el formulario.';
      });
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      await _loanService.createLoanApplication(
        LoanApplicationCreateInput(
          customerId: widget.customerId,
          amount: amount,
          interestRate: rate,
          installmentsCount: installments,
          frequency: _selectedFrequency,
          purpose: _purposeController.text.trim(),
        ),
      );

      if (!mounted) {
        return;
      }
      context.pop();
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = LoanService.extractError(error);
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }
}
