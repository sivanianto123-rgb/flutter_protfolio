import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/app_theme.dart';

/// A small cartoon "coding buddy" pinned to a corner of the viewport — a
/// friendly mascot whose eyes track the cursor and whose whole body tilts
/// gently toward it, with a blinking terminal-cursor caret to keep the
/// coding theme explicit. Purely decorative; never intercepts input.
class CodingBuddy extends StatefulWidget {
  const CodingBuddy({super.key});

  @override
  State<CodingBuddy> createState() => _CodingBuddyState();
}

class _CodingBuddyState extends State<CodingBuddy>
    with SingleTickerProviderStateMixin {
  final GlobalKey _bodyKey = GlobalKey();
  late final Ticker _ticker;
  Offset _pointer = Offset.zero;
  Offset _gaze = Offset.zero;
  double _tilt = 0;
  bool _hasPointer = false;
  Timer? _blinkTimer;
  bool _blinking = false;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (MediaQuery.of(context).disableAnimations) return;
      _scheduleBlink();
    });
  }

  void _scheduleBlink() {
    _blinkTimer = Timer(Duration(milliseconds: 2600 + math.Random().nextInt(2200)), () {
      if (!mounted) return;
      setState(() => _blinking = true);
      Timer(const Duration(milliseconds: 140), () {
        if (!mounted) return;
        setState(() => _blinking = false);
        _scheduleBlink();
      });
    });
  }

  void _onTick(Duration elapsed) {
    final box = _bodyKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.attached || !_hasPointer) return;

    final center = box.localToGlobal(box.size.center(Offset.zero));
    final delta = _pointer - center;
    final distance = delta.distance;
    final direction = distance == 0 ? Offset.zero : delta / distance;

    final targetGaze = direction * math.min(distance / 40, 3.2);
    final targetTilt = (direction.dx * 0.05).clamp(-0.09, 0.09);

    if ((targetGaze - _gaze).distance < 0.05 &&
        (targetTilt - _tilt).abs() < 0.001) {
      return;
    }
    setState(() {
      _gaze += (targetGaze - _gaze) * 0.12;
      _tilt += (targetTilt - _tilt) * 0.12;
    });
  }

  void _onHover(PointerHoverEvent event) {
    _hasPointer = true;
    _pointer = event.position;
  }

  @override
  void dispose() {
    _ticker.dispose();
    _blinkTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reducedMotion = MediaQuery.of(context).disableAnimations;

    return IgnorePointer(
      child: Listener(
        onPointerHover: reducedMotion ? null : _onHover,
        behavior: HitTestBehavior.translucent,
        child: Transform.rotate(
          angle: reducedMotion ? 0 : _tilt,
          child: _BuddyBody(
            key: _bodyKey,
            gaze: reducedMotion ? Offset.zero : _gaze,
            blinking: _blinking,
          ),
        ),
      ),
    );
  }
}

class _BuddyBody extends StatelessWidget {
  final Offset gaze;
  final bool blinking;

  const _BuddyBody({super.key, required this.gaze, required this.blinking});

  @override
  Widget build(BuildContext context) {
    final body = Container(
      width: 76,
      height: 76,
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.18),
            blurRadius: 24,
            spreadRadius: -4,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Eye(gaze: gaze, blinking: blinking),
              const SizedBox(width: 10),
              _Eye(gaze: gaze, blinking: blinking),
            ],
          ),
          const SizedBox(height: 10),
          const _BlinkingCaret(),
        ],
      ),
    );

    return body
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .move(
          duration: 2600.ms,
          curve: Curves.easeInOut,
          begin: Offset.zero,
          end: const Offset(0, -8),
        );
  }
}

class _Eye extends StatelessWidget {
  final Offset gaze;
  final bool blinking;

  const _Eye({required this.gaze, required this.blinking});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: blinking ? 2 : 16,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.textPrimary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: blinking
          ? null
          : Transform.translate(
              offset: gaze,
              child: Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  shape: BoxShape.circle,
                ),
              ),
            ),
    );
  }
}

/// A tiny blinking "_" caret — keeps the "this mascot codes" idea legible
/// even at a glance.
class _BlinkingCaret extends StatelessWidget {
  const _BlinkingCaret();

  @override
  Widget build(BuildContext context) {
    final caret = Container(
      width: 14,
      height: 2.5,
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(2),
      ),
    );

    if (MediaQuery.of(context).disableAnimations) return caret;

    return caret
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .fadeOut(duration: 530.ms, curve: Curves.easeInOut)
        .then()
        .fadeIn(duration: 1.ms);
  }
}
