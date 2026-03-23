import 'package:app/core/widgets/form_components.dart';
import 'package:app/features/loans/services/loan_service.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class LoanApplicationsListScreen extends StatefulWidget {
  const LoanApplicationsListScreen({super.key});

  @override
  State<LoanApplicationsListScreen> createState() => _LoanApplicationsListScreenState();
}

class _LoanApplicationsListScreenState extends State<LoanApplicationsListScreen> {
  final _loanService = LoanService();
  bool _isLoading = true;
  String? _errorMessage;
  List<LoanApplication> _applications = const [];

  @override
  void initState() {
    super.initState();
    _loadApplications();
  }

  Future<void> _loadApplications() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final apps = await _loanService.getLoanApplications();
      if (!mounted) {
        return;
      }
      setState(() {
        _applications = apps;
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
        title: Text(l10n.loanApplications),
        actions: [
          IconButton(
            onPressed: _isLoading ? null : _loadApplications,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadApplications,
        child: _buildBody(theme, l10n, currencyFormat),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.push('/loan-applications/new');
          if (mounted) {
            await _loadApplications();
          }
        },
        label: Text(l10n.newLoanApplication),
        icon: const Icon(Icons.add),
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
                onPressed: _loadApplications,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (_applications.isEmpty) {
      return const Center(child: Text('No hay solicitudes pendientes.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _applications.length,
      itemBuilder: (context, index) {
        final app = _applications[index];
        return CardWrapper(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      app.customerName,
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  _StatusChip(status: app.status),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                currencyFormat.format(app.amount),
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text('${app.installments} ${l10n.installments} - ${app.frequency}'),
              const SizedBox(height: 4),
              Text('Interés: ${app.interestRate.toStringAsFixed(2)}%'),
              if ((app.purpose ?? '').isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(app.purpose!),
              ],
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
    Color color;
    switch (status) {
      case 'submitted':
      case 'under_review':
        color = Colors.orange;
        break;
      case 'approved':
        color = Colors.green;
        break;
      case 'rejected':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}
