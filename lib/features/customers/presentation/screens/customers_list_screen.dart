import 'package:app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:app/core/widgets/form_components.dart';
import 'package:app/features/customers/services/customer_service.dart';

class CustomersListScreen extends StatefulWidget {
  const CustomersListScreen({super.key});

  @override
  State<CustomersListScreen> createState() => _CustomersListScreenState();
}

class _CustomersListScreenState extends State<CustomersListScreen> {
  final _customerService = CustomerService();
  final _searchController = TextEditingController();
  bool _isLoading = true;
  String? _errorMessage;
  List<Customer> _customers = const [];

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCustomers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final customers = await _customerService.getCustomers();
      if (!mounted) {
        return;
      }
      setState(() {
        _customers = customers;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = CustomerService.extractError(error);
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
    final query = _searchController.text.trim().toLowerCase();
    final customers = _customers.where((customer) {
      if (query.isEmpty) {
        return true;
      }
      return customer.fullName.toLowerCase().contains(query) ||
          customer.email.toLowerCase().contains(query) ||
          customer.documentNumber.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.customersTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadCustomers,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadCustomers,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: InputField(
                label: l10n.searchCustomer,
                prefixIcon: Icons.search,
                controller: _searchController,
                onChanged: (_) => setState(() {}),
              ),
            ),
            Expanded(
              child: _buildBody(context, customers, currencyFormat, theme, l10n),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.push('/customers/new');
          if (mounted) {
            await _loadCustomers();
          }
        },
        label: Text(l10n.addCustomer),
        icon: const Icon(Icons.person_add_alt_1),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    List<Customer> customers,
    NumberFormat currencyFormat,
    ThemeData theme,
    AppLocalizations l10n,
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
                onPressed: _loadCustomers,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (customers.isEmpty) {
      return const Center(child: Text('No hay clientes registrados.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: customers.length,
      itemBuilder: (context, index) {
        final customer = customers[index];
        return CardWrapper(
          onTap: () => context.push('/customers/${customer.id}'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      customer.fullName,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _StatusChip(status: customer.status),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.phone_outlined, size: 16, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(customer.phone),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.email_outlined, size: 16, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(child: Text(customer.email)),
                ],
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l10n.creditLimit, style: theme.textTheme.bodySmall),
                  Text(
                    currencyFormat.format(customer.creditLimit),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
    final isActive = status == 'active';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: (isActive ? Colors.green : Colors.red).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: isActive ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}
