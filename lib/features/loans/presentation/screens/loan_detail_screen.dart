import 'package:app/core/widgets/form_components.dart';
import 'package:app/features/loans/services/loan_service.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class LoanDetailScreen extends StatefulWidget {
  const LoanDetailScreen({super.key, required this.loanId});

  final String loanId;

  @override
  State<LoanDetailScreen> createState() => _LoanDetailScreenState();
}

class _LoanDetailScreenState extends State<LoanDetailScreen> {
  final _loanService = LoanService();
  bool _isLoading = true;
  String? _errorMessage;
  Loan? _loan;

  @override
  void initState() {
    super.initState();
    _loadLoan();
  }

  Future<void> _loadLoan() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final loan = await _loanService.getLoanById(widget.loanId);
      if (!mounted) {
        return;
      }
      setState(() {
        _loan = loan;
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
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.loanDetail),
      ),
      body: _buildBody(theme, l10n, currencyFormat, dateFormat, context),
    );
  }

  Widget _buildBody(
    ThemeData theme,
    AppLocalizations l10n,
    NumberFormat currencyFormat,
    DateFormat dateFormat,
    BuildContext context,
  ) {
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
                onPressed: _loadLoan,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    final loan = _loan;
    if (loan == null) {
      return const Center(child: Text('Préstamo no encontrado'));
    }

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        CardWrapper(
          child: Column(
            children: [
              Text(
                loan.customerName,
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(loan.loanNumber, style: theme.textTheme.bodySmall),
              const SizedBox(height: 16),
              Text(
                currencyFormat.format(loan.balance),
                style: theme.textTheme.displaySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(l10n.balance, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          l10n.installmentsSchedule,
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...loan.installments.map(
          (inst) => _buildInstallmentItem(inst, currencyFormat, dateFormat, theme, context),
        ),
      ],
    );
  }

  Widget _buildInstallmentItem(
    Installment inst,
    NumberFormat cur,
    DateFormat df,
    ThemeData theme,
    BuildContext context,
  ) {
    final isPaid = inst.status == 'paid';

    return CardWrapper(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (isPaid ? Colors.green : Colors.orange).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Text(
              '${inst.number}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isPaid ? Colors.green : Colors.orange,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cur.format(inst.amount), style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('Vence: ${df.format(inst.dueDate)}', style: theme.textTheme.bodySmall),
                if (inst.paid > 0) Text('Pagado: ${cur.format(inst.paid)}'),
              ],
            ),
          ),
          if (!isPaid)
            ElevatedButton(
              onPressed: () => context.push('/vouchers/upload?installmentId=${inst.id}'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(80, 36),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              child: const Text('Pagar'),
            )
          else
            const Icon(Icons.check_circle, color: Colors.green),
        ],
      ),
    );
  }
}
