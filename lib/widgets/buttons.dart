import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// A solid accent-filled pill button with a subtle hover/tap scale.
class PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _hovering = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final scale = _pressed ? 0.96 : (_hovering ? 1.04 : 1.0);
    return _Magnetic(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovering = true),
        onExit: (_) => setState(() => _hovering = false),
        child: GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          onTap: widget.onPressed,
          child: AnimatedScale(
            scale: scale,
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 18,
              ),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.label,
                    style: const TextStyle(
                      color: AppColors.background,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  if (widget.icon != null) ...[
                    const SizedBox(width: 8),
                    Icon(widget.icon, color: AppColors.background, size: 18),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// An outlined pill button, for secondary actions.
class SecondaryButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  @override
  State<SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton> {
  bool _hovering = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final scale = _pressed ? 0.96 : (_hovering ? 1.04 : 1.0);
    return _Magnetic(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovering = true),
        onExit: (_) => setState(() => _hovering = false),
        child: GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          onTap: widget.onPressed,
          child: AnimatedScale(
            scale: scale,
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 18,
              ),
              decoration: BoxDecoration(
                color: _hovering
                    ? AppColors.surfaceElevated
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: AppColors.border, width: 1.4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.label,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  if (widget.icon != null) ...[
                    const SizedBox(width: 8),
                    Icon(widget.icon, color: AppColors.textPrimary, size: 18),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// An inline text link that underlines/brightens on hover, for icon-style
/// contact links (email, GitHub, LinkedIn).
class HoverLink extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const HoverLink({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  State<HoverLink> createState() => _HoverLinkState();
}

class _HoverLinkState extends State<HoverLink> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return _Magnetic(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovering = true),
        onExit: (_) => setState(() => _hovering = false),
        child: GestureDetector(
          onTap: widget.onPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: _hovering
                  ? AppColors.surfaceElevated
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: _hovering ? AppColors.accent : AppColors.border,
                width: 1.2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.icon,
                  size: 18,
                  color: _hovering
                      ? AppColors.accent
                      : AppColors.textSecondary,
                ),
                const SizedBox(width: 10),
                Text(
                  widget.label,
                  style: TextStyle(
                    color: _hovering
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A minimal underlined text link with an icon, magnetic on hover — for the
/// hero's "Explore my work" CTA and similar inline calls to action that
/// shouldn't look like a filled/outlined button.
class TextArrowLink extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const TextArrowLink({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  State<TextArrowLink> createState() => _TextArrowLinkState();
}

class _TextArrowLinkState extends State<TextArrowLink> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return _Magnetic(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovering = true),
        onExit: (_) => setState(() => _hovering = false),
        child: GestureDetector(
          onTap: widget.onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.accent.withValues(alpha: _hovering ? 1 : 0.6),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.label,
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(width: 14),
                Icon(widget.icon, color: AppColors.accent, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Gives its child a "magnetic" hover pull: translates it up to ~18% of the
/// pointer's offset from its own center, toward the pointer, easing back to
/// zero once the pointer leaves.
class _Magnetic extends StatefulWidget {
  final Widget child;

  const _Magnetic({required this.child});

  @override
  State<_Magnetic> createState() => _MagneticState();
}

class _MagneticState extends State<_Magnetic> {
  final GlobalKey _key = GlobalKey();
  Offset _pull = Offset.zero;

  void _updatePull(PointerEvent event) {
    final box = _key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    final center = box.size.center(Offset.zero);
    final delta = event.localPosition - center;
    setState(() => _pull = delta * 0.18);
  }

  void _reset() {
    if (_pull == Offset.zero) return;
    setState(() => _pull = Offset.zero);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: _updatePull,
      onExit: (_) => _reset(),
      child: AnimatedContainer(
        key: _key,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(_pull.dx, _pull.dy, 0),
        transformAlignment: Alignment.center,
        child: widget.child,
      ),
    );
  }
}
