import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/motion/scroll_reveal.dart';
import '../../core/motion/tilt_3d.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/section_header.dart';
import 'models/skill_category.dart';
import 'skills_data.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cardWidth = width > 1100
        ? 340.0
        : width > 700
            ? 300.0
            : double.infinity;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ScrollReveal(
          child: SectionHeader(
            title: 'Skills & Tech',
            number: '04',
            caption: 'The toolkit I reach for',
          ),
        ),
        const SizedBox(height: 44),
        Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            for (final category in skillCategories)
              SizedBox(
                width: cardWidth,
                child: ScrollReveal(
                  child: _SkillCategoryCard(category: category),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _SkillCategoryCard extends StatelessWidget {
  const _SkillCategoryCard({required this.category});

  final SkillCategory category;

  @override
  Widget build(BuildContext context) {
    const accent = AppColors.primary;

    return Tilt3D(
      maxTilt: 0.09,
      lift: 14,
      scale: 1.02,
      child: GlassCard(
        padding: const EdgeInsets.all(26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(11),
                    color: accent.withValues(alpha: 0.14),
                    border: Border.all(color: accent.withValues(alpha: 0.3)),
                  ),
                  child: Icon(Icons.bolt_rounded, size: 18, color: accent),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    category.name,
                    style: GoogleFonts.outfit(
                      fontSize: 17.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final skill in category.skills)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.045),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.07),
                      ),
                    ),
                    child: Text(
                      skill,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 13,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
