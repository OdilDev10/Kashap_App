import 'package:flutter/material.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:app/core/widgets/form_components.dart';
import 'package:app/features/loans/services/loan_service.dart';

class MyLoansScreen extends StatefulWidget {
  const MyLoansScreen({super.key});

  @override
  State<MyLoansScreen> createState() => _MyLoansScreenState();
}

class _MyLoansScreenState extends State<MyLoansScreen> {
  final _loanService = LoanService();
  late Future<List<Loan>> _loansFuture;

  @override
  void initState() {
    super.initState();
    _loansFuture = _loanService.getLoans();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(symbol: 'RD\$ ', decimalDigits: 2);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myLoans),
      ),
      body: FutureBuilder<List<Loan>>(
        future: _loansFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final loans = snapshot.data ?? [];
          if (loans.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_late_outlined, size: 64, color: theme.disabledColor),
                  const SizedBox(height: 16),
                  Text(l10n.noActiveLoans),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: loans.length,
            itemBuilder: (context, index) {
              final loan = loans[index];
              final progress = 1 - (loan.balance / loan.originalAmount);
              
              return CardWrapper(
                onTap: () => context.push('/loans/${loan.id}'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Préstamo #${loan.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        _StatusChip(status: loan.status),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      currencyFormat.format(loan.balance),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(l10n.balance, style: theme.textTheme.bodySmall),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${(progress * 100).toInt()}% Pagado', style: theme.textTheme.bodySmall),
                        Text(currencyFormat.format(loan.originalAmount), style: theme.textTheme.bodySmall),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final isActive = status == 'active';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: (isActive ? Colors.green : Colors.grey).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: isActive ? Colors.green : Colors.grey),
      ),
    );
  }
}
