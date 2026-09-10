import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/motion/tilt_3d.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glass_card.dart';
import '../models/experience_entry.dart';

class ExperienceCard extends StatelessWidget {
  const ExperienceCard({super.key, required this.entry, this.index = 0});

  final ExperienceEntry entry;
  final int index;

  @override
  Widget build(BuildContext context) {
    // Current role carries the accent; earlier roles recede to steel.
    final accent = index == 0 ? AppColors.primary : AppColors.steel;

    return Tilt3D(
      maxTilt: 0.05,
      lift: 12,
      scale: 1.008,
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ExperienceTitle(entry: entry, accent: accent),
            const SizedBox(height: 26),
            for (final bullet in entry.bullets)
              _BulletPoint(text: bullet, accent: accent),
          ],
        ),
      ),
    );
  }
}

class _ExperienceTitle extends StatelessWidget {
  const _ExperienceTitle({required this.entry, required this.accent});

  final ExperienceEntry entry;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 520;

        return Flex(
          direction: isMobile ? Axis.vertical : Axis.horizontal,
          crossAxisAlignment:
              isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                children: [
                  Text(
                    entry.title,
                    style: GoogleFonts.outfit(
                      fontSize: isMobile ? 20 : 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    entry.company,
                    style: GoogleFonts.outfit(
                      fontSize: isMobile ? 17 : 20,
                      fontWeight: FontWeight.w600,
                      color: accent,
                    ),
                  ),
                ],
              ),
            ),
            if (isMobile) const SizedBox(height: 10),
            Column(
              crossAxisAlignment:
                  isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(100),
                    border:
                        Border.all(color: Colors.white.withValues(alpha: 0.09)),
                  ),
                  child: Text(
                    entry.date,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.55),
                      fontWeight: FontWeight.w600,
                      fontFamily: 'monospace',
                      fontSize: 12.5,
                    ),
                  ),
                ),
                if (entry.location != null) ...[
                  const SizedBox(height: 7),
                  Text(
                    entry.location!,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.32),
                      fontSize: 12,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ],
            ),
          ],
        );
      },
    );
  }
}

class _BulletPoint extends StatelessWidget {
  const _BulletPoint({required this.text, required this.accent});

  final String text;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8, right: 14),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: accent,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: 0.6),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.66),
                fontSize: 15.5,
                height: 1.7,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
