import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../theme/app_theme.dart';

/// Wraps [child] with a custom pointer: a dot that snaps instantly to the
/// mouse and a ring that eases toward it each frame.
///
/// Stays a no-op on touch devices — the overlay and the hidden system
/// cursor only activate once a real [PointerHoverEvent] is observed, which
/// touch input never produces.
class CustomCursor extends StatefulWidget {
  final Widget child;

  const CustomCursor({super.key, required this.child});

  @override
  State<CustomCursor> createState() => _CustomCursorState();
}

class _CustomCursorState extends State<CustomCursor>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  Offset _target = Offset.zero;
  Offset _ringPosition = Offset.zero;
  bool _hasPointer = false;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  void _onTick(Duration elapsed) {
    if (!_hasPointer) return;
    final delta = _target - _ringPosition;
    if (delta.distance < 0.1) return;
    setState(() => _ringPosition += delta * 0.22);
  }

  void _onHover(PointerHoverEvent event) {
    setState(() {
      _target = event.position;
      if (!_hasPointer) {
        _hasPointer = true;
        _ringPosition = event.position;
      }
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reducedMotion = MediaQuery.of(context).disableAnimations;

    return MouseRegion(
      cursor: _hasPointer ? SystemMouseCursors.none : MouseCursor.defer,
      child: Listener(
        onPointerHover: _onHover,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            widget.child,
            if (_hasPointer && !reducedMotion)
              IgnorePointer(
                child: Stack(
                  children: [
                    Positioned(
                      left: _ringPosition.dx - 14,
                      top: _ringPosition.dy - 14,
                      child: _CursorRing(),
                    ),
                    Positioned(
                      left: _target.dx - 3,
                      top: _target.dy - 3,
                      child: _CursorDot(),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CursorDot extends StatelessWidget {
  const _CursorDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: const BoxDecoration(
        color: AppColors.accent,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _CursorRing extends StatelessWidget {
  const _CursorRing();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.6),
          width: 1.4,
        ),
      ),
    );
  }
}
