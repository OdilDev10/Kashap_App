import 'package:flutter/material.dart';
import 'package:app/l10n/app_localizations.dart';

class BankAccount {
  final String id;
  final String bankName;
  final String accountNumber;
  final String accountType;

  BankAccount({
    required this.id,
    required this.bankName,
    required this.accountNumber,
    required this.accountType,
  });
}

class BankAccountsManagerScreen extends StatefulWidget {
  final String lenderId;
  const BankAccountsManagerScreen({super.key, required this.lenderId});

  @override
  State<BankAccountsManagerScreen> createState() => _BankAccountsManagerScreenState();
}

class _BankAccountsManagerScreenState extends State<BankAccountsManagerScreen> {
  final List<BankAccount> _mockAccounts = [
    BankAccount(id: '1', bankName: 'Banco Popular', accountNumber: '123456789', accountType: 'Corriente'),
    BankAccount(id: '2', bankName: 'Banreservas', accountNumber: '987654321', accountType: 'Ahorros'),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.bankAccounts),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _mockAccounts.length,
        itemBuilder: (context, index) {
          final account = _mockAccounts[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                child: Icon(Icons.account_balance, color: theme.colorScheme.primary),
              ),
              title: Text(account.bankName, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${account.accountType} - ${account.accountNumber}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: () {},
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddAccountDialog(context, l10n);
        },
        label: Text(l10n.addAccount),
        icon: const Icon(Icons.add),
      ),
    );
  }

  void _showAddAccountDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.addAccount),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: l10n.bankName),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(labelText: l10n.accountNumber),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: l10n.accountType),
              items: const [
                DropdownMenuItem(value: 'savings', child: Text('Ahorros')),
                DropdownMenuItem(value: 'checking', child: Text('Corriente')),
              ],
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: Text(l10n.save)),
        ],
      ),
    );
  }
}
