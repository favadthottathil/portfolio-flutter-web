import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../theme/app_theme.dart';

/// Animated constellation of drifting nodes joined by proximity links —
/// a neural-network motif rendered on a single canvas.
class NeuralField extends StatefulWidget {
  const NeuralField({
    super.key,
    required this.pointer,
    this.nodeCount = 60,
    this.linkDistance = 150,
  });

  final int nodeCount;
  final double linkDistance;

  /// Normalized pointer (-1..1) used to parallax the whole field.
  final ValueListenable<Offset> pointer;

  @override
  State<NeuralField> createState() => _NeuralFieldState();
}

class _NeuralFieldState extends State<NeuralField>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  late final List<_Node> _nodes;
  final ValueNotifier<double> _seconds = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    final random = math.Random(7);
    _nodes = List.generate(widget.nodeCount, (_) => _Node.random(random));
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
      child: CustomPaint(
        painter: _NeuralPainter(
          nodes: _nodes,
          seconds: _seconds,
          linkDistance: widget.linkDistance,
          pointer: widget.pointer,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _Node {
  _Node({
    required this.origin,
    required this.speed,
    required this.phase,
    required this.radius,
    required this.amplitude,
  });

  /// Position in normalized 0..1 space.
  final Offset origin;
  final double speed;
  final double phase;
  final double radius;
  final double amplitude;

  factory _Node.random(math.Random random) {
    return _Node(
      origin: Offset(random.nextDouble(), random.nextDouble()),
      speed: 0.15 + random.nextDouble() * 0.35,
      phase: random.nextDouble() * math.pi * 2,
      radius: 1.0 + random.nextDouble() * 1.8,
      amplitude: 0.02 + random.nextDouble() * 0.05,
    );
  }

  Offset positionAt(double seconds, Size size) {
    final t = seconds * speed + phase;
    return Offset(
      (origin.dx + math.cos(t) * amplitude) * size.width,
      (origin.dy + math.sin(t * 0.8) * amplitude) * size.height,
    );
  }
}

class _NeuralPainter extends CustomPainter {
  _NeuralPainter({
    required this.nodes,
    required this.seconds,
    required this.linkDistance,
    required this.pointer,
  }) : super(repaint: Listenable.merge([seconds, pointer]));

  final List<_Node> nodes;
  final ValueListenable<double> seconds;
  final double linkDistance;
  final ValueListenable<Offset> pointer;

  @override
  void paint(Canvas canvas, Size size) {
    final seconds = this.seconds.value;
    final pointer = this.pointer.value;
    final parallax = Offset(pointer.dx * 18, pointer.dy * 18);
    final positions = [
      for (final node in nodes) node.positionAt(seconds, size) + parallax,
    ];

    final linkPaint = Paint()..strokeWidth = 0.8;
    final maxDistanceSquared = linkDistance * linkDistance;

    for (var i = 0; i < positions.length; i++) {
      for (var j = i + 1; j < positions.length; j++) {
        final delta = positions[i] - positions[j];
        final distanceSquared = delta.distanceSquared;
        if (distanceSquared > maxDistanceSquared) continue;

        final strength = 1 - (math.sqrt(distanceSquared) / linkDistance);
        linkPaint.color = Color.lerp(
          AppColors.steel,
          AppColors.primary,
          strength,
        )!.withValues(alpha: strength * 0.14);
        canvas.drawLine(positions[i], positions[j], linkPaint);
      }
    }

    final nodePaint = Paint();
    for (var i = 0; i < positions.length; i++) {
      final pulse = 0.6 + 0.4 * math.sin(seconds * 1.6 + nodes[i].phase);
      nodePaint.color = AppColors.primary.withValues(alpha: 0.35 * pulse);
      canvas.drawCircle(positions[i], nodes[i].radius, nodePaint);
    }
  }

  @override
  bool shouldRepaint(_NeuralPainter oldDelegate) => false;
}
