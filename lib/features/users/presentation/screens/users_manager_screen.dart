import 'package:flutter/material.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/core/widgets/form_components.dart';

class InternalUser {
  final String id;
  final String name;
  final String email;
  final String role;
  final String status;

  InternalUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
  });
}

class UsersManagerScreen extends StatefulWidget {
  const UsersManagerScreen({super.key});

  @override
  State<UsersManagerScreen> createState() => _UsersManagerScreenState();
}

class _UsersManagerScreenState extends State<UsersManagerScreen> {
  final List<InternalUser> _mockUsers = [
    InternalUser(id: '1', name: 'Admin Principal', email: 'admin@kashap.do', role: 'admin', status: 'active'),
    InternalUser(id: '2', name: 'Carlos Oficial', email: 'carlos@kashap.do', role: 'officer', status: 'active'),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.usersTitle),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _mockUsers.length,
        itemBuilder: (context, index) {
          final user = _mockUsers[index];
          return CardWrapper(
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                  child: Text(user.name[0]),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(user.email, style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getRoleName(user.role, l10n),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text(l10n.addUser),
        icon: const Icon(Icons.person_add_alt_outlined),
      ),
    );
  }

  String _getRoleName(String role, AppLocalizations l10n) {
    switch (role) {
      case 'admin': return l10n.admin;
      case 'manager': return l10n.manager;
      case 'officer': return l10n.officer;
      default: return role;
    }
  }
}
