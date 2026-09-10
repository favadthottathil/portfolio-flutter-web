import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/motion/tilt_3d.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glass_card.dart';
import '../models/project.dart';
import 'tech_chip.dart';

class ProjectCard extends StatefulWidget {
  const ProjectCard({super.key, required this.project});

  final Project project;

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 500;
    const accent = AppColors.primary;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Tilt3D(
        maxTilt: 0.07,
        lift: 18,
        scale: 1.015,
        child: GlassCard(
          accent: _hovered ? accent : null,
          padding: EdgeInsets.all(isWide ? 38 : 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ProjectGlyph(accent: accent, hovered: _hovered),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Wrap(
                        alignment: WrapAlignment.end,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (widget.project.tag != null)
                            _StatusTag(
                              label: widget.project.tag!,
                              accent: accent,
                            ),
                          for (final link in widget.project.links)
                            _LinkButton(link: link, accent: accent),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Text(
                widget.project.title,
                style: GoogleFonts.outfit(
                  fontSize: isWide ? 27 : 21,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  height: 1.25,
                  color: _hovered ? accent : Colors.white,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                widget.project.subtitle,
                style: TextStyle(
                  color: accent.withValues(alpha: 0.8),
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.project.description,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.62),
                  fontSize: isWide ? 16 : 14.5,
                  height: 1.75,
                  letterSpacing: 0.2,
                ),
              ),
              if (widget.project.highlights.isNotEmpty) ...[
                const SizedBox(height: 20),
                for (final highlight in widget.project.highlights)
                  _Highlight(text: highlight, accent: accent),
              ],
              const SizedBox(height: 26),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final tech in widget.project.techStack)
                    TechChip(label: tech, accent: accent),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class _Highlight extends StatelessWidget {
  const _Highlight({required this.text, required this.accent});

  final String text;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5, right: 11),
            child: Icon(
              Icons.chevron_right_rounded,
              size: 16,
              color: accent.withValues(alpha: 0.8),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 14,
                height: 1.65,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusTag extends StatelessWidget {
  const _StatusTag({required this.label, required this.accent});

  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: accent.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
          ),
          const SizedBox(width: 7),
          Text(
            label,
            style: TextStyle(
              color: accent,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectGlyph extends StatelessWidget {
  const _ProjectGlyph({required this.accent, required this.hovered});

  final Color accent;
  final bool hovered;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 320),
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withValues(alpha: hovered ? 0.32 : 0.16),
            accent.withValues(alpha: 0.04),
          ],
        ),
        border: Border.all(color: accent.withValues(alpha: hovered ? 0.6 : 0.3)),
        boxShadow: hovered
            ? [
                BoxShadow(
                  color: accent.withValues(alpha: 0.35),
                  blurRadius: 24,
                  spreadRadius: -4,
                ),
              ]
            : null,
      ),
      child: Icon(Icons.terminal_rounded, color: accent, size: 26),
    );
  }
}

class _LinkButton extends StatefulWidget {
  const _LinkButton({required this.link, required this.accent});

  final ProjectLink link;
  final Color accent;

  @override
  State<_LinkButton> createState() => _LinkButtonState();
}

class _LinkButtonState extends State<_LinkButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.link.tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: () => launchUrl(Uri.parse(widget.link.url)),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 240),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _hovered
                  ? widget.accent.withValues(alpha: 0.16)
                  : Colors.white.withValues(alpha: 0.04),
              border: Border.all(
                color: _hovered
                    ? widget.accent.withValues(alpha: 0.5)
                    : Colors.white.withValues(alpha: 0.1),
              ),
            ),
            child: Icon(
              widget.link.icon,
              size: 19,
              color: _hovered
                  ? widget.accent
                  : Colors.white.withValues(alpha: 0.6),
            ),
          ),
        ),
      ),
    ).animate(target: _hovered ? 1 : 0).scaleXY(end: 1.08, duration: 200.ms);
  }
}
