import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// Nav pill that fills with an accent wash and lifts on hover.
class NavBarItem extends StatefulWidget {
  const NavBarItem({super.key, required this.title, required this.onPressed});

  final String title;
  final VoidCallback onPressed;

  @override
  State<NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<NavBarItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: _hovered
                ? AppColors.primary.withValues(alpha: 0.1)
                : Colors.transparent,
            border: Border.all(
              color: _hovered
                  ? AppColors.primary.withValues(alpha: 0.32)
                  : Colors.transparent,
            ),
          ),
          child: Text(
            widget.title,
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
              color: _hovered
                  ? AppColors.primary
                  : Colors.white.withValues(alpha: 0.72),
            ),
          ),
        ),
      ),
    );
  }
}
