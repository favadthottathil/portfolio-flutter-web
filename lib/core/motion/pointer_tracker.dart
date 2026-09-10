import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Publishes the pointer position (normalized to -1..1 around the viewport
/// centre) as a [ValueListenable], so background layers can react to the cursor
/// without rebuilding the page tree on every mouse move.
class PointerTracker extends StatefulWidget {
  const PointerTracker({super.key, required this.child});

  final Widget child;

  static ValueListenable<Offset> of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_PointerScope>();
    assert(scope != null, 'PointerTracker.of() called outside a PointerTracker');
    return scope!.pointer;
  }

  @override
  State<PointerTracker> createState() => _PointerTrackerState();
}

class _PointerTrackerState extends State<PointerTracker> {
  final ValueNotifier<Offset> _pointer = ValueNotifier(Offset.zero);

  @override
  void dispose() {
    _pointer.dispose();
    super.dispose();
  }

  void _update(Offset position, Size size) {
    if (size.isEmpty) return;
    _pointer.value = Offset(
      ((position.dx / size.width) * 2 - 1).clamp(-1.0, 1.0),
      ((position.dy / size.height) * 2 - 1).clamp(-1.0, 1.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        return MouseRegion(
          opaque: false,
          onHover: (event) => _update(event.localPosition, size),
          onExit: (_) => _pointer.value = Offset.zero,
          child: _PointerScope(pointer: _pointer, child: widget.child),
        );
      },
    );
  }
}

class _PointerScope extends InheritedWidget {
  const _PointerScope({required this.pointer, required super.child});

  final ValueListenable<Offset> pointer;

  @override
  bool updateShouldNotify(_PointerScope oldWidget) =>
      oldWidget.pointer != pointer;
}
