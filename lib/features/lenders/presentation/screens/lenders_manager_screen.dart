import 'package:app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:app/features/lenders/services/lender_service.dart';

class LendersManagerScreen extends StatefulWidget {
  const LendersManagerScreen({super.key});

  @override
  State<LendersManagerScreen> createState() => _LendersManagerScreenState();
}

class _LendersManagerScreenState extends State<LendersManagerScreen> {
  final _lenderService = LenderService();
  final _searchController = TextEditingController();
  bool _isLoading = true;
  String? _errorMessage;
  List<Lender> _lenders = const [];

  @override
  void initState() {
    super.initState();
    _loadLenders();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadLenders() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final lenders = await _lenderService.getLenders();
      if (!mounted) {
        return;
      }
      setState(() {
        _lenders = lenders;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = LenderService.extractError(error);
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _openLenderForm({Lender? lender}) async {
    final wasSaved = await showDialog<bool>(
      context: context,
      builder: (context) => _LenderFormDialog(
        lender: lender,
        lenderService: _lenderService,
      ),
    );

    if (wasSaved == true) {
      await _loadLenders();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final query = _searchController.text.trim().toLowerCase();
    final lenders = _lenders.where((lender) {
      if (query.isEmpty) {
        return true;
      }
      return lender.legalName.toLowerCase().contains(query) ||
          lender.email.toLowerCase().contains(query) ||
          lender.documentNumber.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.lendersTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadLenders,
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => _openLenderForm(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadLenders,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Buscar lender...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: query.isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                          icon: const Icon(Icons.close),
                        ),
                  fillColor: theme.colorScheme.surface,
                ),
              ),
            ),
            Expanded(
              child: _buildBody(context, lenders),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openLenderForm(),
        label: Text(l10n.addLender),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(BuildContext context, List<Lender> lenders) {
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
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadLenders,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (lenders.isEmpty) {
      return const Center(
        child: Text('No hay lenders disponibles.'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: lenders.length,
      itemBuilder: (context, index) {
        final lender = lenders[index];
        return _LenderCard(
          lender: lender,
          onEdit: () => _openLenderForm(lender: lender),
        );
      },
    );
  }
}

class _LenderCard extends StatelessWidget {
  const _LenderCard({
    required this.lender,
    required this.onEdit,
  });

  final Lender lender;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    lender.legalName,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    lender.status.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _MetaRow(icon: Icons.email_outlined, value: lender.email),
            const SizedBox(height: 4),
            _MetaRow(icon: Icons.phone_outlined, value: lender.phone),
            const SizedBox(height: 4),
            _MetaRow(
              icon: Icons.badge_outlined,
              value: '${lender.documentType}: ${lender.documentNumber}',
            ),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => context.push('/lenders/${lender.id}/bank-accounts'),
                  icon: const Icon(Icons.account_balance_outlined, size: 18),
                  label: Text(l10n.bankAccounts),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined),
                  color: theme.colorScheme.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({
    required this.icon,
    required this.value,
  });

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(value)),
      ],
    );
  }
}

class _LenderFormDialog extends StatefulWidget {
  const _LenderFormDialog({
    required this.lenderService,
    this.lender,
  });

  final LenderService lenderService;
  final Lender? lender;

  @override
  State<_LenderFormDialog> createState() => _LenderFormDialogState();
}

class _LenderFormDialogState extends State<_LenderFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _legalNameController;
  late final TextEditingController _commercialNameController;
  late final TextEditingController _documentNumberController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late String _documentType;
  late String _lenderType;
  late String _status;
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final lender = widget.lender;
    _legalNameController = TextEditingController(text: lender?.legalName ?? '');
    _commercialNameController = TextEditingController(
      text: lender?.commercialName ?? '',
    );
    _documentNumberController = TextEditingController(
      text: lender?.documentNumber ?? '',
    );
    _emailController = TextEditingController(text: lender?.email ?? '');
    _phoneController = TextEditingController(text: lender?.phone ?? '');
    _documentType = lender?.documentType.isNotEmpty == true
        ? lender!.documentType
        : 'RNC';
    _lenderType = lender?.lenderType.isNotEmpty == true
        ? lender!.lenderType
        : 'financial';
    _status = lender?.status.isNotEmpty == true ? lender!.status : 'pending';
  }

  @override
  void dispose() {
    _legalNameController.dispose();
    _commercialNameController.dispose();
    _documentNumberController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    final input = LenderInput(
      legalName: _legalNameController.text.trim(),
      commercialName: _commercialNameController.text.trim(),
      lenderType: _lenderType,
      documentType: _documentType,
      documentNumber: _documentNumberController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      status: _status,
    );

    try {
      if (widget.lender == null) {
        await widget.lenderService.createLender(input);
      } else {
        await widget.lenderService.updateLender(widget.lender!.id, input);
      }

      if (!mounted) {
        return;
      }
      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = LenderService.extractError(error);
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(widget.lender == null ? l10n.addLender : l10n.editLender),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _legalNameController,
                decoration: InputDecoration(labelText: l10n.legalName),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? l10n.legalName : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _commercialNameController,
                decoration: const InputDecoration(labelText: 'Nombre comercial'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _lenderType,
                decoration: const InputDecoration(labelText: 'Tipo de lender'),
                items: const [
                  DropdownMenuItem(value: 'financial', child: Text('Financial')),
                  DropdownMenuItem(value: 'individual', child: Text('Individual')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _lenderType = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _documentType,
                decoration: InputDecoration(labelText: l10n.documentType),
                items: const [
                  DropdownMenuItem(value: 'RNC', child: Text('RNC')),
                  DropdownMenuItem(value: 'Cédula', child: Text('Cédula')),
                  DropdownMenuItem(value: 'Pasaporte', child: Text('Pasaporte')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _documentType = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _documentNumberController,
                decoration: InputDecoration(labelText: l10n.documentNumber),
                validator: (value) => value == null || value.trim().isEmpty
                    ? l10n.documentNumber
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: l10n.email),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.email;
                  }
                  if (!value.contains('@')) {
                    return 'Email inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: l10n.phone),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? l10n.phone : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _status,
                decoration: const InputDecoration(labelText: 'Estado'),
                items: const [
                  DropdownMenuItem(value: 'pending', child: Text('Pending')),
                  DropdownMenuItem(value: 'active', child: Text('Active')),
                  DropdownMenuItem(value: 'suspended', child: Text('Suspended')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _status = value;
                    });
                  }
                },
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(false),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _submit,
          child: _isSaving
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.save),
        ),
      ],
    );
  }
}
