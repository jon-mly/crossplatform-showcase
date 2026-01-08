import 'package:employees_app/presentation/style/radius.dart';
import 'package:employees_app/presentation/style/spacings.dart';
import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: AppRadius.cardBorderRadius,
      ),
      padding: AppSpacing.cardPaddingAll,
      child: child,
    );
  }
}
