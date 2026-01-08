import 'package:easy_localization/easy_localization.dart';
import 'package:employees_app/presentation/providers/ui/scaffold_messenger_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final NotifierProvider<SnackbarProviderNotifier, void> snackbarProvider = .new(
  SnackbarProviderNotifier.new,
);

class SnackbarProviderNotifier extends Notifier<void> {
  @override
  void build() {}

  void showErrorSnackbar(String message, {VoidCallback? onRetry}) {
    ref
        .read(scaffoldMessengerKeyProvider)
        .currentState
        ?.showSnackBar(
          SnackBar(
            content: Text(message),
            behavior: .floating,
            action: onRetry != null
                ? SnackBarAction(label: 'error.retry'.tr(), onPressed: onRetry)
                : null,
          ),
        );
  }
}
