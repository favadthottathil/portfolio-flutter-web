import 'package:flutter/material.dart';

enum ProjectLinkType { live, source, dashboard, package }

class ProjectLink {
  const ProjectLink({
    required this.type,
    required this.url,
    required this.tooltip,
  });

  final ProjectLinkType type;
  final String url;
  final String tooltip;

  IconData get icon {
    switch (type) {
      case ProjectLinkType.live:
        return Icons.open_in_new_rounded;
      case ProjectLinkType.source:
        return Icons.code_rounded;
      case ProjectLinkType.dashboard:
        return Icons.dashboard_rounded;
      case ProjectLinkType.package:
        return Icons.inventory_2_rounded;
    }
  }
}

class Project {
  const Project({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.techStack,
    this.highlights = const [],
    this.links = const [],
    this.tag,
  });

  final String title;

  /// Short role/platform line shown under the title.
  final String subtitle;
  final String description;
  final List<String> techStack;

  /// Bulleted engineering details revealed under the description.
  final List<String> highlights;
  final List<ProjectLink> links;

  /// Optional status chip, e.g. "Live on Play Store".
  final String? tag;
}
