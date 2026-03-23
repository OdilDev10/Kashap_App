import 'package:app/core/widgets/form_components.dart';
import 'package:app/features/loans/services/loan_service.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class LoansListScreen extends StatefulWidget {
  const LoansListScreen({super.key});

  @override
  State<LoansListScreen> createState() => _LoansListScreenState();
}

class _LoansListScreenState extends State<LoansListScreen> {
  final _loanService = LoanService();
  bool _isLoading = true;
  String? _errorMessage;
  List<Loan> _loans = const [];

  @override
  void initState() {
    super.initState();
    _loadLoans();
  }

  Future<void> _loadLoans() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final loans = await _loanService.getLoans();
      if (!mounted) {
        return;
      }
      setState(() {
        _loans = loans;
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

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.loansTitle),
        actions: [
          IconButton(
            onPressed: _isLoading ? null : _loadLoans,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadLoans,
        child: _buildBody(theme, l10n, currencyFormat),
      ),
    );
  }

  Widget _buildBody(ThemeData theme, AppLocalizations l10n, NumberFormat currencyFormat) {
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
                onPressed: _loadLoans,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (_loans.isEmpty) {
      return const Center(child: Text('No hay préstamos activos.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _loans.length,
      itemBuilder: (context, index) {
        final loan = _loans[index];
        return CardWrapper(
          onTap: () => context.push('/loans/${loan.id}'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      loan.customerName,
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  _StatusChip(status: loan.status),
                ],
              ),
              const SizedBox(height: 8),
              Text(loan.loanNumber, style: theme.textTheme.bodySmall),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.balance, style: theme.textTheme.bodySmall),
                        Text(
                          currencyFormat.format(loan.balance),
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Monto Original', style: theme.textTheme.bodySmall),
                        Text(
                          currencyFormat.format(loan.originalAmount),
                          style: theme.textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 32),
              LinearProgressIndicator(
                value: loan.totalAmount <= 0 ? 0 : 1 - (loan.balance / loan.totalAmount),
                backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
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
    final isActive = status == 'active';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: (isActive ? Colors.green : Colors.grey).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: isActive ? Colors.green : Colors.grey,
        ),
      ),
    );
  }
}
