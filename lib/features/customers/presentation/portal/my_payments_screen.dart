import 'package:flutter/material.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:app/core/widgets/form_components.dart';

class CustomerPayment {
  final String id;
  final double amount;
  final DateTime date;
  final String status;

  CustomerPayment({
    required this.id,
    required this.amount,
    required this.date,
    required this.status,
  });
}

class MyPaymentsScreen extends StatefulWidget {
  const MyPaymentsScreen({super.key});

  @override
  State<MyPaymentsScreen> createState() => _MyPaymentsScreenState();
}

class _MyPaymentsScreenState extends State<MyPaymentsScreen> {
  final List<CustomerPayment> _mockPayments = [
    CustomerPayment(id: '1', amount: 5000, date: DateTime.now().subtract(const Duration(days: 30)), status: 'approved'),
    CustomerPayment(id: '2', amount: 5000, date: DateTime.now().subtract(const Duration(days: 2)), status: 'review'),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(symbol: 'RD\$ ', decimalDigits: 2);
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myPayments),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _mockPayments.length,
        itemBuilder: (context, index) {
          final payment = _mockPayments[index];
          final isApproved = payment.status == 'approved';

          return CardWrapper(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (isApproved ? Colors.green : Colors.orange).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isApproved ? Icons.check_circle_outline : Icons.history_toggle_off_rounded,
                    color: isApproved ? Colors.green : Colors.orange,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(currencyFormat.format(payment.amount), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(dateFormat.format(payment.date), style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
                _StatusBadge(status: payment.status, l10n: l10n),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  final AppLocalizations l10n;
  const _StatusBadge({required this.status, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final isApproved = status == 'approved';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (isApproved ? Colors.green : Colors.orange).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isApproved ? 'APROBADO' : 'EN REVISIÓN',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: isApproved ? Colors.green : Colors.orange,
        ),
      ),
    );
  }
}
