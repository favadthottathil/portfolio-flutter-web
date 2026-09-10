import 'package:flutter/material.dart';

import '../../core/motion/scroll_reveal.dart';
import '../../core/widgets/section_header.dart';
import 'projects_data.dart';
import 'widgets/project_card.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ScrollReveal(
          child: SectionHeader(
            title: 'Selected Works',
            number: '03',
            caption: 'Production apps and platforms I have shipped',
          ),
        ),
        const SizedBox(height: 44),
        for (var i = 0; i < projects.length; i++) ...[
          if (i > 0) const SizedBox(height: 28),
          ScrollReveal(
            child: ProjectCard(project: projects[i]),
          ),
        ],
      ],
    );
  }
}
