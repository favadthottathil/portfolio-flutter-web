import 'dart:async';

import 'package:flutter/material.dart';

/// Cycles through [phrases], typing and deleting each one with a blinking
/// caret — the "terminal" motif common to AI product sites.
class TypingText extends StatefulWidget {
  const TypingText({
    super.key,
    required this.phrases,
    required this.style,
    this.caretColor,
    this.typingSpeed = const Duration(milliseconds: 55),
    this.deletingSpeed = const Duration(milliseconds: 28),
    this.holdDuration = const Duration(milliseconds: 1600),
  });

  final List<String> phrases;
  final TextStyle style;
  final Color? caretColor;
  final Duration typingSpeed;
  final Duration deletingSpeed;
  final Duration holdDuration;

  @override
  State<TypingText> createState() => _TypingTextState();
}

class _TypingTextState extends State<TypingText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _caret;
  Timer? _timer;
  int _phraseIndex = 0;
  int _charCount = 0;
  bool _deleting = false;

  @override
  void initState() {
    super.initState();
    _caret = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat();
    _scheduleNext(widget.typingSpeed);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _caret.dispose();
    super.dispose();
  }

  void _scheduleNext(Duration delay) {
    _timer?.cancel();
    _timer = Timer(delay, _tick);
  }

  void _tick() {
    if (!mounted) return;
    final phrase = widget.phrases[_phraseIndex];

    if (!_deleting) {
      if (_charCount < phrase.length) {
        setState(() => _charCount++);
        _scheduleNext(widget.typingSpeed);
      } else {
        _deleting = true;
        _scheduleNext(widget.holdDuration);
      }
      return;
    }

    if (_charCount > 0) {
      setState(() => _charCount--);
      _scheduleNext(widget.deletingSpeed);
    } else {
      _deleting = false;
      _phraseIndex = (_phraseIndex + 1) % widget.phrases.length;
      _scheduleNext(widget.typingSpeed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final caretColor =
        widget.caretColor ?? Theme.of(context).colorScheme.primary;
    final visible = widget.phrases[_phraseIndex].substring(0, _charCount);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(child: Text(visible, style: widget.style)),
        FadeTransition(
          opacity: _caret.drive(
            TweenSequence<double>([
              TweenSequenceItem(tween: ConstantTween(1.0), weight: 50),
              TweenSequenceItem(tween: ConstantTween(0.0), weight: 50),
            ]),
          ),
          child: Container(
            width: 3,
            height: (widget.style.fontSize ?? 16) * 1.05,
            margin: const EdgeInsets.only(left: 6),
            decoration: BoxDecoration(
              color: caretColor,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: caretColor.withValues(alpha: 0.7),
                  blurRadius: 12,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
