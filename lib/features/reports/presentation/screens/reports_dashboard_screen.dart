import 'package:flutter/material.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:app/core/widgets/form_components.dart';

class ReportsDashboardScreen extends StatelessWidget {
  const ReportsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.compactCurrency(symbol: 'RD\$ ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.reportsTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.portfolioSummary, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                _StatCard(
                  label: l10n.totalPortfolio,
                  value: currencyFormat.format(1250000),
                  icon: Icons.account_balance_wallet_outlined,
                  color: theme.colorScheme.primary,
                ),
                _StatCard(
                  label: l10n.activeLoans,
                  value: '48',
                  icon: Icons.assignment_outlined,
                  color: Colors.blue,
                ),
                _StatCard(
                  label: l10n.delinquencyRate,
                  value: '4.2%',
                  icon: Icons.warning_amber_rounded,
                  color: Colors.orange,
                ),
                _StatCard(
                  label: l10n.collectedThisMonth,
                  value: currencyFormat.format(320000),
                  icon: Icons.trending_up_rounded,
                  color: Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 32),
            CardWrapper(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Salud de la Cartera', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 24),
                  _buildSimpleBar('Al día', 0.85, Colors.green),
                  const SizedBox(height: 12),
                  _buildSimpleBar('Mora 1-30 días', 0.10, Colors.orange),
                  const SizedBox(height: 12),
                  _buildSimpleBar('Mora +30 días', 0.05, Colors.red),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleBar(String label, double percent, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 12)),
            Text('${(percent * 100).toInt()}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: percent,
          color: color,
          backgroundColor: color.withValues(alpha: 0.1),
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(value, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: color)),
          Text(label, style: theme.textTheme.bodySmall?.copyWith(fontSize: 10)),
        ],
      ),
    );
  }
}
