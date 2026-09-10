import 'package:flutter/material.dart';

import '../../core/motion/scroll_reveal.dart';
import '../../core/widgets/section_header.dart';
import 'experience_data.dart';
import 'widgets/experience_card.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ScrollReveal(
          child: SectionHeader(
            title: 'Experience',
            number: '02',
            caption: 'Where I have been building',
          ),
        ),
        const SizedBox(height: 44),
        for (var i = 0; i < experienceEntries.length; i++) ...[
          if (i > 0) const SizedBox(height: 28),
          ScrollReveal(
            child: ExperienceCard(entry: experienceEntries[i], index: i),
          ),
        ],
      ],
    );
  }
}
