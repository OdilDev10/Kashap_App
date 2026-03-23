import 'dart:io';
import 'package:flutter/material.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app/core/widgets/ui_components.dart';

class VoucherUploadScreen extends StatefulWidget {
  final String installmentId;
  const VoucherUploadScreen({super.key, required this.installmentId});

  @override
  State<VoucherUploadScreen> createState() => _VoucherUploadScreenState();
}

class _VoucherUploadScreenState extends State<VoucherUploadScreen> {
  File? _image;
  final _picker = ImagePicker();
  bool _isUploading = false;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source, imageQuality: 80);
      if (pickedFile != null) {
        setState(() => _image = File(pickedFile.path));
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar.show(context: context, message: 'Error al seleccionar imagen', isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.uploadVoucher),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
                ),
                child: _image == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo_outlined, size: 64, color: theme.colorScheme.primary),
                          const SizedBox(height: 16),
                          Text(l10n.selectFile),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.file(_image!, fit: BoxFit.cover),
                      ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt_outlined),
                    label: const Text('Cámara'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text('Galería'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: (_image == null || _isUploading) ? null : _handleUpload,
              child: _isUploading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(l10n.uploadVoucher),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleUpload() async {
    setState(() => _isUploading = true);
    // TODO: Call VoucherService
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      CustomSnackBar.show(context: context, message: AppLocalizations.of(context)!.voucherUploaded);
      context.pop();
    }
  }
}
