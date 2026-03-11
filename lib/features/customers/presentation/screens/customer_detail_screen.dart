import 'package:flutter/material.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/widgets/form_components.dart';
import '../../services/customer_service.dart';

class CustomerDetailScreen extends StatefulWidget {
  final String customerId;
  const CustomerDetailScreen({super.key, required this.customerId});

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _customerService = CustomerService();
  late Future<Customer?> _customerFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // In a real app we would call getCustomerById
    _customerFuture = _customerService.getCustomers().then(
      (list) => list.firstWhere((c) => c.id == widget.customerId),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.customerDetail),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l10n.personalInfo),
            Tab(text: l10n.loans),
            Tab(text: l10n.documents),
          ],
        ),
      ),
      body: FutureBuilder<Customer?>(
        future: _customerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final customer = snapshot.data;
          if (customer == null) return const Center(child: Text('Cliente no encontrado'));

          return TabBarView(
            controller: _tabController,
            children: [
              _buildPersonalInfo(customer, theme, l10n),
              _buildLoansList(customer, theme, l10n),
              _buildDocumentsList(customer, theme, l10n),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/loan-applications/new?customerId=${widget.customerId}'),
        label: Text(l10n.newLoanApplication),
        icon: const Icon(Icons.add_chart_outlined),
      ),
    );
  }

  Widget _buildPersonalInfo(Customer customer, ThemeData theme, AppLocalizations l10n) {
    final currencyFormat = NumberFormat.currency(symbol: 'RD\$ ', decimalDigits: 2);
    
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        CardWrapper(
          child: Column(
            children: [
              const CircleAvatar(
                radius: 40,
                child: Icon(Icons.person, size: 40),
              ),
              const SizedBox(height: 16),
              Text(customer.fullName, style: theme.textTheme.headlineSmall),
              const SizedBox(height: 8),
              _StatusChip(status: customer.status),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildInfoRow(Icons.email_outlined, l10n.email, customer.email, theme),
        _buildInfoRow(Icons.phone_outlined, l10n.phone, customer.phone, theme),
        _buildInfoRow(Icons.credit_card_outlined, l10n.creditLimit, currencyFormat.format(customer.creditLimit), theme),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, ThemeData theme) {
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

  Widget _buildLoansList(Customer customer, ThemeData theme, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_edu_outlined, size: 64, color: theme.disabledColor),
          const SizedBox(height: 16),
          Text(l10n.noLoans, style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }

  Widget _buildDocumentsList(Customer customer, ThemeData theme, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open_outlined, size: 64, color: theme.disabledColor),
          const SizedBox(height: 16),
          Text(l10n.noDocuments, style: theme.textTheme.bodyLarge),
        ],
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: (isActive ? Colors.green : Colors.red).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: isActive ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}
