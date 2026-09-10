import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';
import 'gradient_text.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    required this.number,
    this.caption,
  });

  final String title;
  final String number;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 500;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                ),
                color: AppColors.primary.withValues(alpha: 0.07),
              ),
              child: Text(
                number,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 13,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 16),
            GradientText(
              title,
              gradient: AppColors.chromeGradient,
              style: GoogleFonts.outfit(
                fontSize: isWide ? 38 : 27,
                fontWeight: FontWeight.w800,
                letterSpacing: -1.2,
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.14),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        if (caption != null) ...[
          const SizedBox(height: 12),
          Text(
            caption!,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.4),
              fontSize: 14.5,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ],
    );
  }
}
