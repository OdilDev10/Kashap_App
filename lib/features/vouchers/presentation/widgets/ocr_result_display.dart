import 'package:flutter/material.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:app/core/widgets/form_components.dart';

class OcrData {
  final double amount;
  final DateTime date;
  final String bank;
  final double confidence;

  OcrData({
    required this.amount,
    required this.date,
    required this.bank,
    required this.confidence,
  });
}

class OcrResultDisplay extends StatelessWidget {
  final OcrData data;
  final VoidCallback onConfirm;
  final VoidCallback onRetry;

  const OcrResultDisplay({
    super.key,
    required this.data,
    required this.onConfirm,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(symbol: 'RD\$ ', decimalDigits: 2);
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.ocrResults,
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        _ResultItem(
          label: l10n.detectedAmount,
          value: currencyFormat.format(data.amount),
          icon: Icons.monetization_on_outlined,
        ),
        _ResultItem(
          label: l10n.detectedDate,
          value: dateFormat.format(data.date),
          icon: Icons.calendar_today_outlined,
        ),
        _ResultItem(
          label: l10n.detectedBank,
          value: data.bank,
          icon: Icons.account_balance_outlined,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${l10n.confidence}: ', style: theme.textTheme.bodySmall),
            Text(
              '${(data.confidence * 100).toStringAsFixed(1)}%',
              style: theme.textTheme.bodySmall?.copyWith(
                color: data.confidence > 0.8 ? Colors.green : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: onConfirm,
          child: const Text('Confirmar Datos'),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: onRetry,
          child: const Text('Intentar de nuevo'),
        ),
      ],
    );
  }
}

class _ResultItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _ResultItem({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CardWrapper(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.bodySmall),
              Text(value, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
