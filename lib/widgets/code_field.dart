import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/app_theme.dart';

/// Fixed, full-viewport background of scattered monospace "code chips" that
/// float and drift gently, purely decorative and never interactive.
///
/// Mounted once behind the scrollable content (not inside it) so it stays
/// pinned to the viewport instead of scrolling away with the page.
class CodeField extends StatelessWidget {
  const CodeField({super.key});

  static const _chips = [
    _ChipSpec(
      text: 'Widget build()',
      top: 120,
      left: 60,
      delay: Duration.zero,
      rotation: -3,
    ),
    _ChipSpec(
      text: 'setState(() {})',
      top: 220,
      right: 80,
      delay: Duration(milliseconds: 1800),
      rotation: 4,
    ),
    _ChipSpec(
      text: 'Future<Experience>',
      bottom: 260,
      left: 90,
      delay: Duration(milliseconds: 3600),
      rotation: 2,
    ),
    _ChipSpec(
      text: 'const motion = true;',
      bottom: 140,
      right: 60,
      delay: Duration(milliseconds: 900),
      rotation: -2,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Opacity(
        opacity: 0.5,
        child: Stack(
          children: [for (final chip in _chips) _FloatingChip(spec: chip)],
        ),
      ),
    );
  }
}

class _ChipSpec {
  final String text;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final Duration delay;
  final double rotation;

  const _ChipSpec({
    required this.text,
    this.top,
    this.bottom,
    this.left,
    this.right,
    required this.delay,
    required this.rotation,
  });
}

class _FloatingChip extends StatelessWidget {
  final _ChipSpec spec;

  const _FloatingChip({required this.spec});

  @override
  Widget build(BuildContext context) {
    final reducedMotion = MediaQuery.of(context).disableAnimations;

    Widget chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
      ),
      child: Text(
        spec.text,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 13,
          color: AppColors.accent.withValues(alpha: 0.4),
        ),
      ),
    );

    if (!reducedMotion) {
      chip = chip
          .animate(
            onPlay: (controller) => controller.repeat(reverse: true),
            delay: spec.delay,
          )
          .move(
            duration: 8.seconds,
            curve: Curves.easeInOut,
            begin: Offset.zero,
            end: const Offset(0, -14),
          )
          .rotate(
            duration: 8.seconds,
            curve: Curves.easeInOut,
            begin: 0,
            end: spec.rotation / 360,
          );
    }

    return Positioned(
      top: spec.top,
      bottom: spec.bottom,
      left: spec.left,
      right: spec.right,
      child: chip,
    );
  }
}
