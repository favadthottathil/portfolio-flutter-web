import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class HoverButton extends StatefulWidget {
  const HoverButton({
    super.key,
    required this.text,
    required this.icon,
    required this.isPrimary,
    required this.onPressed,
  });

  final String text;
  final IconData icon;
  final bool isPrimary;
  final VoidCallback onPressed;

  @override
  State<HoverButton> createState() => _HoverButtonState();
}

class _HoverButtonState extends State<HoverButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()
          ..translateByDouble(0.0, isHovered ? -5.0 : 0.0, 0.0, 1.0),
        child: widget.isPrimary ? _buildPrimary(context) : _buildOutlined(context),
      ),
    );
  }

  Widget _buildLabel() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 8.0),
      child: Text(
        widget.text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildPrimary(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: widget.onPressed,
      icon: Icon(widget.icon),
      label: _buildLabel(),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: AppColors.background,
        elevation: isHovered ? 20 : 0,
        shadowColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildOutlined(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return OutlinedButton.icon(
      onPressed: widget.onPressed,
      icon: Icon(widget.icon),
      label: _buildLabel(),
      style: OutlinedButton.styleFrom(
        foregroundColor: isHovered ? primary : Colors.white,
        side: BorderSide(
          color: isHovered ? primary : Colors.white.withValues(alpha: 0.3),
          width: 2,
        ),
        backgroundColor: isHovered
            ? primary.withValues(alpha: 0.1)
            : Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
