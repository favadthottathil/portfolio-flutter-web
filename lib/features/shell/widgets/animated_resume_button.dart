import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/resume_downloader.dart';

/// Gradient CTA with a glow that intensifies on hover.
class AnimatedResumeButton extends StatefulWidget {
  const AnimatedResumeButton({super.key, this.compact = false});

  final bool compact;

  @override
  State<AnimatedResumeButton> createState() => _AnimatedResumeButtonState();
}

class _AnimatedResumeButtonState extends State<AnimatedResumeButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: downloadResume,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(
            horizontal: widget.compact ? 16 : 22,
            vertical: widget.compact ? 10 : 13,
          ),
          decoration: BoxDecoration(
            gradient: AppColors.accentGradient,
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(
                  alpha: _hovered ? 0.45 : 0.2,
                ),
                blurRadius: _hovered ? 28 : 14,
                spreadRadius: _hovered ? -2 : -6,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.download_rounded,
                size: 17,
                color: AppColors.background,
              ),
              if (!widget.compact) ...[
                const SizedBox(width: 8),
                const Text(
                  'Resume',
                  style: TextStyle(
                    color: AppColors.background,
                    fontWeight: FontWeight.w800,
                    fontSize: 14.5,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
