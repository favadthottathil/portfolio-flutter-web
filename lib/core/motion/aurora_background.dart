import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../theme/app_theme.dart';

/// Slow-drifting mesh-gradient blobs behind the page content.
class AuroraBackground extends StatefulWidget {
  const AuroraBackground({
    super.key,
    required this.pointer,
    required this.scrollOffset,
  });

  final ValueListenable<Offset> pointer;
  final ValueListenable<double> scrollOffset;

  @override
  State<AuroraBackground> createState() => _AuroraBackgroundState();
}

class _AuroraBackgroundState extends State<AuroraBackground>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;

  /// Driven directly by the ticker so the painter repaints without ever
  /// rebuilding a widget.
  final ValueNotifier<double> _seconds = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(
      (elapsed) => _seconds.value = elapsed.inMilliseconds / 1000,
    )..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _seconds.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
        child: CustomPaint(
          painter: _AuroraPainter(
            seconds: _seconds,
            pointer: widget.pointer,
            scrollOffset: widget.scrollOffset,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _AuroraPainter extends CustomPainter {
  _AuroraPainter({
    required this.seconds,
    required this.pointer,
    required this.scrollOffset,
  }) : super(
          repaint: Listenable.merge([seconds, pointer, scrollOffset]),
        );

  final ValueListenable<double> seconds;
  final ValueListenable<Offset> pointer;
  final ValueListenable<double> scrollOffset;

  // Amber pools with cool steel fill light — no competing hues.
  static const _blobs = [
    _Blob(AppColors.primary, Offset(0.15, 0.12), 0.42, 0.55, 0.0),
    _Blob(AppColors.steel, Offset(0.85, 0.35), 0.50, 0.42, 1.8),
    _Blob(AppColors.primaryDeep, Offset(0.35, 0.85), 0.36, 0.38, 3.4),
    _Blob(AppColors.steel, Offset(0.70, 0.75), 0.30, 0.30, 5.1),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final seconds = this.seconds.value;
    final pointer = this.pointer.value;
    final scrollOffset = this.scrollOffset.value;

    for (final blob in _blobs) {
      final t = seconds * 0.12 + blob.phase;
      final depth = 26 * blob.intensity;
      final center = Offset(
        (blob.center.dx + math.cos(t) * 0.05) * size.width +
            pointer.dx * depth,
        (blob.center.dy + math.sin(t * 0.9) * 0.05) * size.height +
            pointer.dy * depth -
            scrollOffset * 0.06,
      );
      final radius = blob.radius * size.shortestSide *
          (1 + 0.06 * math.sin(t * 1.3));

      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..shader = RadialGradient(
            colors: [
              blob.color.withValues(alpha: 0.30 * blob.intensity),
              blob.color.withValues(alpha: 0.0),
            ],
          ).createShader(Rect.fromCircle(center: center, radius: radius)),
      );
    }
  }

  @override
  bool shouldRepaint(_AuroraPainter oldDelegate) => false;
}

class _Blob {
  const _Blob(
    this.color,
    this.center,
    this.radius,
    this.intensity,
    this.phase,
  );

  final Color color;
  final Offset center;
  final double radius;
  final double intensity;
  final double phase;
}
