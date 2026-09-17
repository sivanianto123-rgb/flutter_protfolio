import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/app_theme.dart';

/// Full-viewport hero: big animated name + tagline, scroll-down indicator,
/// entrance animation on load, and a subtle parallax background.
class HeroSection extends StatelessWidget {
  final ValueListenable<double> scrollOffset;
  final VoidCallback onScrollDown;
  final String name;
  final String tagline;
  final String subtitle;

  const HeroSection({
    super.key,
    required this.scrollOffset,
    required this.onScrollDown,
    required this.name,
    required this.tagline,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = Breakpoints.isMobile(context);
    final nameSize = isMobile ? 56.0 : (size.width < 1400 ? 104.0 : 128.0);
    final taglineSize = isMobile ? 22.0 : 32.0;

    return SizedBox(
      height: size.height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Subtle parallax background glow.
          ValueListenableBuilder<double>(
            valueListenable: scrollOffset,
            builder: (context, offset, child) {
              return Transform.translate(
                offset: Offset(0, offset * 0.35),
                child: child,
              );
            },
            child: Stack(
              children: [
                Positioned(
                  top: -180,
                  right: -120,
                  child: _glow(AppColors.accent.withValues(alpha: 0.28), 420),
                ),
                Positioned(
                  bottom: -160,
                  left: -140,
                  child: _glow(AppColors.accent.withValues(alpha: 0.14), 380),
                ),
              ],
            ),
          ),

          // Foreground content.
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Breakpoints.horizontalPadding(context),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                        tagline,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: taglineSize,
                          fontWeight: FontWeight.w500,
                          color: AppColors.accent,
                          letterSpacing: -0.5,
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 150.ms)
                      .slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic),
                  const SizedBox(height: 16),
                  Text(
                        name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: nameSize,
                          fontWeight: FontWeight.w800,
                          height: 1.05,
                          letterSpacing: -2,
                          color: AppColors.textPrimary,
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 800.ms, delay: 300.ms)
                      .slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic)
                      .then()
                      .shimmer(
                        duration: 1400.ms,
                        color: AppColors.accent.withValues(alpha: 0.5),
                      ),
                  const SizedBox(height: 28),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 620),
                    child:
                        Text(
                              subtitle,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isMobile ? 16 : 19,
                                height: 1.5,
                                color: AppColors.textSecondary,
                              ),
                            )
                            .animate()
                            .fadeIn(duration: 700.ms, delay: 650.ms)
                            .slideY(
                              begin: 0.3,
                              end: 0,
                              curve: Curves.easeOutCubic,
                            ),
                  ),
                ],
              ),
            ),
          ),

          // Scroll-down indicator.
          Positioned(
            bottom: 36,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: onScrollDown,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: const _BouncingScrollHint().animate().fadeIn(
                    duration: 800.ms,
                    delay: 1200.ms,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _glow(Color color, double diameter) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
      ),
    );
  }
}

/// The "SCROLL" label + bouncing chevron shown at the bottom of the hero.
///
/// Uses a plain [AnimationController] (rather than flutter_animate's
/// `repeat()`) because that driver is ticker-based: it stops cleanly when
/// this widget is disposed, instead of leaving a self-rescheduling timer
/// behind.
class _BouncingScrollHint extends StatefulWidget {
  const _BouncingScrollHint();

  @override
  State<_BouncingScrollHint> createState() => _BouncingScrollHintState();
}

class _BouncingScrollHintState extends State<_BouncingScrollHint>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat(reverse: true);
  late final Animation<double> _offset = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  ).drive(Tween<double>(begin: 0, end: 10));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _offset,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _offset.value),
          child: child,
        );
      },
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'SCROLL',
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 3,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 10),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.textSecondary,
            size: 28,
          ),
        ],
      ),
    );
  }
}
