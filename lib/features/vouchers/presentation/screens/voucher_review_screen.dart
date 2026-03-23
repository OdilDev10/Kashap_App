import 'package:flutter/material.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:app/core/widgets/form_components.dart';
import 'package:app/features/vouchers/presentation/widgets/ocr_result_display.dart';

class VoucherReviewScreen extends StatefulWidget {
  final String paymentId;
  const VoucherReviewScreen({super.key, required this.paymentId});

  @override
  State<VoucherReviewScreen> createState() => _VoucherReviewScreenState();
}

class _VoucherReviewScreenState extends State<VoucherReviewScreen> {
  late OcrData _ocrData;
  final _amountController = TextEditingController();
  final _bankController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    // Mocking OCR result
    _ocrData = OcrData(
      amount: 5000.0,
      date: DateTime.now(),
      bank: 'Banco Popular',
      confidence: 0.92,
    );
    _amountController.text = _ocrData.amount.toString();
    _bankController.text = _ocrData.bank;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.voucherReview),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              color: Colors.black12,
              child: const Center(
                child: Icon(Icons.image_outlined, size: 100, color: Colors.grey),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!_isEditing)
                    OcrResultDisplay(
                      data: _ocrData,
                      onConfirm: _handleApprove,
                      onRetry: () => setState(() => _isEditing = true),
                    )
                  else ...[
                    Text(l10n.manualCorrection, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 24),
                    InputField(
                      label: l10n.amount,
                      controller: _amountController,
                      prefixIcon: Icons.monetization_on_outlined,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    InputField(
                      label: l10n.bankName,
                      controller: _bankController,
                      prefixIcon: Icons.account_balance_outlined,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () => setState(() => _isEditing = false),
                      child: Text(l10n.save),
                    ),
                  ],
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: _handleReject,
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.redAccent),
                    child: Text(l10n.rejectPayment),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleApprove() {
    // TODO: Call API
    context.pop();
  }

  void _handleReject() {
    // TODO: Call API
    context.pop();
  }
}
