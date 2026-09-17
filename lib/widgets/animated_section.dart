import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Wraps a section's content and plays a fade + slide-up entrance animation
/// the first time it scrolls into view, then stays put.
class AnimatedSection extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const AnimatedSection({
    super.key,
    required this.child,
    this.delay = Duration.zero,
  });

  @override
  State<AnimatedSection> createState() => _AnimatedSectionState();
}

class _AnimatedSectionState extends State<AnimatedSection> {
  final GlobalKey _boxKey = GlobalKey();
  ScrollPosition? _scrollPosition;
  bool _visible = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final position = Scrollable.maybeOf(context)?.position;
    if (position != _scrollPosition) {
      _scrollPosition?.removeListener(_checkVisibility);
      _scrollPosition = position;
      _scrollPosition?.addListener(_checkVisibility);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkVisibility());
  }

  @override
  void dispose() {
    _scrollPosition?.removeListener(_checkVisibility);
    super.dispose();
  }

  void _checkVisibility() {
    if (_visible || !mounted) return;
    final renderObject = _boxKey.currentContext?.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.attached) return;

    final screenHeight = MediaQuery.of(context).size.height;
    final position = renderObject.localToGlobal(Offset.zero);
    final triggerPoint = screenHeight * 0.88;

    if (position.dy < triggerPoint) {
      setState(() => _visible = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Important: the invisible branch must NOT mount `widget.child` — if it
    // did, any independently-animated descendants (e.g. staggered list
    // items) would run their entrance animation immediately on first frame,
    // invisibly, instead of when this section actually scrolls into view.
    return KeyedSubtree(
      key: _boxKey,
      child: _visible
          ? widget.child
                .animate(delay: widget.delay)
                .fadeIn(duration: 700.ms, curve: Curves.easeOut)
                .slideY(
                  begin: 0.12,
                  end: 0,
                  duration: 700.ms,
                  curve: Curves.easeOutCubic,
                )
          : const SizedBox.shrink(),
    );
  }
}
