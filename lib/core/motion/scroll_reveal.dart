import 'package:flutter/material.dart';

/// Broadcasts scroll ticks from the page's single [ScrollController] so that
/// [ScrollReveal] descendants can check their own visibility. The reveals live
/// inside the scroll view, so a [NotificationListener] above them would never
/// see their notifications — they listen to this instead.
class ScrollRevealScope extends InheritedNotifier<Listenable> {
  const ScrollRevealScope({
    super.key,
    required Listenable controller,
    required super.child,
  }) : super(notifier: controller);

  static Listenable? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ScrollRevealScope>()
        ?.notifier;
  }
}

/// Fades and lifts [child] into place the first time it scrolls into view.
class ScrollReveal extends StatefulWidget {
  const ScrollReveal({
    super.key,
    required this.child,
    this.offsetY = 40,
    this.duration = const Duration(milliseconds: 700),
  });

  final Widget child;
  final double offsetY;
  final Duration duration;

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal> {
  final GlobalKey _key = GlobalKey();
  Listenable? _scrollSignal;
  bool _revealed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_revealed) return;

    final signal = ScrollRevealScope.maybeOf(context);
    if (identical(signal, _scrollSignal)) return;
    _scrollSignal?.removeListener(_check);
    _scrollSignal = signal?..addListener(_check);
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  @override
  void dispose() {
    _scrollSignal?.removeListener(_check);
    super.dispose();
  }

  void _check() {
    if (_revealed || !mounted) return;

    final renderObject = _key.currentContext?.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.attached) return;

    final viewportHeight = MediaQuery.of(context).size.height;
    final topInViewport = renderObject.localToGlobal(Offset.zero).dy;
    if (topInViewport < viewportHeight * 0.9) {
      // Reveal is one-way, so stop measuring on every scroll tick once done.
      _scrollSignal?.removeListener(_check);
      _scrollSignal = null;
      setState(() => _revealed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      key: _key,
      offset: _revealed ? Offset.zero : Offset(0, widget.offsetY / 100),
      duration: widget.duration,
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        opacity: _revealed ? 1 : 0,
        duration: widget.duration,
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
