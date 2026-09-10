import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/gradient_text.dart';

class StatItem {
  const StatItem({required this.value, required this.label});

  final String value;
  final String label;
}

/// Row of headline metrics shown under the hero copy.
class StatStrip extends StatelessWidget {
  const StatStrip({super.key, required this.stats});

  final List<StatItem> stats;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 40,
      runSpacing: 28,
      children: [
        for (final stat in stats)
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GradientText(
                stat.value,
                style: GoogleFonts.outfit(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                stat.label,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.45),
                  fontSize: 13,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: 44,
                height: 2,
                decoration: BoxDecoration(
                  gradient: AppColors.accentGradient,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
