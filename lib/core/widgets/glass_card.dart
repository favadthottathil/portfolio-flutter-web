import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Frosted surface with a soft top-light gradient and hairline stroke.
///
/// Deliberately does NOT use a [BackdropFilter]. There are ~16 of these on the
/// page, each of which would sample the animated background behind it every
/// frame — on web that is the difference between smooth and janky scrolling.
/// The same look is achieved with a translucent tinted fill over the dark
/// background, which costs nothing to composite.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 24,
    this.accent,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;

  /// When set, tints the stroke and adds a matching outer glow.
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 500;
    final radius = BorderRadius.circular(borderRadius);

    return RepaintBoundary(
      child: Container(
        padding: padding ?? EdgeInsets.all(isWide ? 36 : 22),
        decoration: BoxDecoration(
          borderRadius: radius,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.surfaceHigh.withValues(alpha: 0.78),
              AppColors.surfaceLow.withValues(alpha: 0.72),
            ],
          ),
          border: Border.all(
            color:
                accent?.withValues(alpha: 0.35) ?? AppColors.glassStroke(0.09),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: (accent ?? Colors.black).withValues(
                alpha: accent != null ? 0.18 : 0.45,
              ),
              blurRadius: accent != null ? 40 : 30,
              spreadRadius: accent != null ? -8 : -12,
              offset: const Offset(0, 18),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
