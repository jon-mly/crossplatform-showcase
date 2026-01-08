import 'package:employees_app/presentation/style/fonts.dart';
import 'package:employees_app/presentation/style/spacings.dart';
import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.text,
    required this.color,
    this.semanticLabel,
  });

  final String text;
  final Color color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? text,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: color.withAlpha(30),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: .symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.s),
          child: Row(
            mainAxisSize: .min,
            children: [
              Text(text, style: AppFonts.text.copyWith(color: color)),
              AppSpacing.horizontalS,
              Container(
                height: 6,
                width: 6,
                decoration: BoxDecoration(shape: .circle, color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
