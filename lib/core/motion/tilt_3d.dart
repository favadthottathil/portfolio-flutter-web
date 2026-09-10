import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Wraps [child] in a perspective transform that tilts toward the cursor,
/// with an optional specular sheen that tracks the same position.
///
/// Hover state is held in [ValueNotifier]s driving an [AnimatedBuilder], so
/// moving the cursor repaints only the transform — it never rebuilds [child].
class Tilt3D extends StatefulWidget {
  const Tilt3D({
    super.key,
    required this.child,
    this.maxTilt = 0.12,
    this.lift = 12,
    this.scale = 1.02,
    this.borderRadius = 24,
    this.sheen = true,
  });

  final Widget child;

  /// Maximum rotation in radians applied on each axis.
  final double maxTilt;

  /// Z-translation applied while hovered, in logical pixels.
  final double lift;
  final double scale;
  final double borderRadius;
  final bool sheen;

  @override
  State<Tilt3D> createState() => _Tilt3DState();
}

class _Tilt3DState extends State<Tilt3D> with SingleTickerProviderStateMixin {
  /// Eased 0..1 hover weight; the tilt and sheen both scale by this.
  late final AnimationController _hover = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 240),
  );
  late final Animation<double> _weight = CurvedAnimation(
    parent: _hover,
    curve: Curves.easeOutCubic,
  );

  final ValueNotifier<Offset> _pointer = ValueNotifier(Offset.zero);

  @override
  void dispose() {
    _hover.dispose();
    _pointer.dispose();
    super.dispose();
  }

  void _onHover(PointerHoverEvent event, Size size) {
    if (size.isEmpty) return;
    _pointer.value = Offset(
      ((event.localPosition.dx / size.width) * 2 - 1).clamp(-1.0, 1.0),
      ((event.localPosition.dy / size.height) * 2 - 1).clamp(-1.0, 1.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return MouseRegion(
          onEnter: (_) => _hover.forward(),
          onExit: (_) {
            _pointer.value = Offset.zero;
            _hover.reverse();
          },
          onHover: (event) => _onHover(event, constraints.biggest),
          child: AnimatedBuilder(
            animation: Listenable.merge([_weight, _pointer]),
            builder: (context, child) {
              final weight = _weight.value;
              final pointer = _pointer.value * weight;

              final matrix = Matrix4.identity()
                ..setEntry(3, 2, 0.0012)
                ..rotateX(-pointer.dy * widget.maxTilt)
                ..rotateY(pointer.dx * widget.maxTilt)
                ..translateByDouble(0.0, 0.0, widget.lift * weight, 1.0);

              final scale = 1 + (widget.scale - 1) * weight;
              matrix.scaleByDouble(scale, scale, 1.0, 1.0);

              return Transform(
                alignment: Alignment.center,
                transform: matrix,
                child: widget.sheen
                    ? _Sheen(
                        pointer: _pointer.value,
                        opacity: weight,
                        borderRadius: widget.borderRadius,
                        child: child!,
                      )
                    : child,
              );
            },
            child: RepaintBoundary(child: widget.child),
          ),
        );
      },
    );
  }
}

class _Sheen extends StatelessWidget {
  const _Sheen({
    required this.pointer,
    required this.opacity,
    required this.borderRadius,
    required this.child,
  });

  final Offset pointer;
  final double opacity;
  final double borderRadius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (opacity > 0.01)
          Positioned.fill(
            child: IgnorePointer(
              child: Opacity(
                opacity: opacity.clamp(0.0, 1.0),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                    gradient: RadialGradient(
                      center: Alignment(pointer.dx, pointer.dy),
                      radius: 0.9,
                      colors: [
                        Colors.white.withValues(alpha: 0.10),
                        Colors.white.withValues(alpha: 0.02),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.35, 1.0],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
