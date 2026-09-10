import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class TechChip extends StatelessWidget {
  const TechChip({super.key, required this.label, this.accent});

  final String label;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final color = accent ?? AppColors.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color.withValues(alpha: 0.95),
          fontSize: 12.5,
          fontFamily: 'monospace',
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
