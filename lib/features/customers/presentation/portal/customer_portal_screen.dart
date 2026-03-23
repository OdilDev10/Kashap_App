import 'package:flutter/material.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:app/core/widgets/form_components.dart';

class CustomerPortalScreen extends StatelessWidget {
  const CustomerPortalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(symbol: 'RD\$ ', decimalDigits: 2);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.customerPortal),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hola, Juan',
              style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Resumen de tus préstamos activos',
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
            ),
            const SizedBox(height: 32),
            CardWrapper(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(l10n.totalDebt, style: theme.textTheme.bodySmall),
                  const SizedBox(height: 8),
                  Text(
                    currencyFormat.format(35000),
                    style: theme.textTheme.displaySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(height: 48),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.nextInstallment, style: theme.textTheme.bodySmall),
                          const Text('15 Mar 2026', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Monto', style: theme.textTheme.bodySmall),
                          Text(currencyFormat.format(5000), style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () => context.push('/vouchers/upload?installmentId=next'),
                    child: Text(l10n.payNow),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: _PortalMenuButton(
                    label: l10n.myLoans,
                    icon: Icons.assignment_outlined,
                    onTap: () => context.push('/my-loans'),
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _PortalMenuButton(
                    label: l10n.paymentHistory,
                    icon: Icons.history_outlined,
                    onTap: () => context.push('/my-payments'),
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PortalMenuButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const _PortalMenuButton({required this.label, required this.icon, required this.onTap, required this.color});

  @override
  Widget build(BuildContext context) {
    return CardWrapper(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
