import 'package:app/core/widgets/form_components.dart';
import 'package:app/features/loans/services/loan_service.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentsListScreen extends StatefulWidget {
  const PaymentsListScreen({super.key});

  @override
  State<PaymentsListScreen> createState() => _PaymentsListScreenState();
}

class _PaymentsListScreenState extends State<PaymentsListScreen> {
  final _loanService = LoanService();
  bool _isLoading = true;
  String? _errorMessage;
  List<PaymentRecord> _payments = const [];

  @override
  void initState() {
    super.initState();
    _loadPayments();
  }

  Future<void> _loadPayments() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final payments = await _loanService.getPendingPayments();
      if (!mounted) {
        return;
      }
      setState(() {
        _payments = payments;
      });
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
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(symbol: 'RD\$ ', decimalDigits: 2);
    final dateFormat = DateFormat('dd/MM HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.paymentsTitle),
        actions: [
          IconButton(
            onPressed: _isLoading ? null : _loadPayments,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadPayments,
        child: _buildBody(theme, currencyFormat, dateFormat),
      ),
    );
  }

  Widget _buildBody(ThemeData theme, NumberFormat currencyFormat, DateFormat dateFormat) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadPayments,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (_payments.isEmpty) {
      return const Center(child: Text('No hay pagos pendientes de revisión.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _payments.length,
      itemBuilder: (context, index) {
        final payment = _payments[index];
        return CardWrapper(
          onTap: () {},
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.receipt_long_outlined, color: Colors.blue),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(payment.customerName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(dateFormat.format(payment.date), style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    currencyFormat.format(payment.amount),
                    style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                  ),
                  _StatusChip(status: payment.status),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status.toUpperCase(),
        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.blue),
      ),
    );
  }
}
