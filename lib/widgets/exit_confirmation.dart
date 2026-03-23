import 'package:flutter/material.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/core/widgets/ui_components.dart';

Future<bool> showExitConfirmation(BuildContext context) async {
  final l10n = AppLocalizations.of(context)!;
  bool shouldExit = false;

  await CustomDialog.show(
    context: context,
    title: l10n.exitTitle,
    content: l10n.exitMessage,
    confirmLabel: 'Salir',
    onConfirm: () {
      shouldExit = true;
    },
  );

  return shouldExit;
}
