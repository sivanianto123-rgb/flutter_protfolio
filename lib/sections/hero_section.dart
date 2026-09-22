import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/app_theme.dart';
import '../widgets/buttons.dart';
import '../widgets/video_background.dart';

/// Full-viewport hero: left-aligned editorial headline, kicker, and a
/// bottom row (subtitle + CTA) offset to sit under the headline's second
/// line — mirrors the reference design rather than a centered layout.
class HeroSection extends StatelessWidget {
  final ValueListenable<double> scrollOffset;
  final VoidCallback onScrollDown;
  final String kickerIndex;
  final String kickerLabel;
  final String headlineLine1;
  final String headlineLine2;
  final String accentWord;
  final String subtitle;

  const HeroSection({
    super.key,
    required this.scrollOffset,
    required this.onScrollDown,
    required this.kickerIndex,
    required this.kickerLabel,
    required this.headlineLine1,
    required this.headlineLine2,
    required this.accentWord,
    required this.subtitle,
  });

  static const _backgroundVideoUrl =
      'https://d8j0ntlcm91z4.cloudfront.net/user_38xzZboKViGWJOttwIXH07lWA1P/hf_20260809_012548_ef22562c-c0ae-4816-ad9d-f8922af4e6a7.mp4';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = Breakpoints.isMobile(context);
    final width = size.width;
    final headlineSize = isMobile
        ? 48.0
        : (width < 1400 ? 88.0 : 116.0);

    return SizedBox(
      height: size.height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Full-bleed looping background video.
          const VideoBackground(videoUrl: _backgroundVideoUrl),

          // Dark scrim so headline/nav stay legible over the video.
          Container(
            color: AppColors.background.withValues(alpha: 0.62),
          ),

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

          // Foreground content, left-aligned and vertically centered.
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Breakpoints.horizontalPadding(context),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          kickerIndex,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.accent,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          kickerLabel.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                            letterSpacing: 2.2,
                          ),
                        ),
                      ],
                    )
                    .animate()
                    .fadeIn(duration: 500.ms)
                    .slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic),
                const SizedBox(height: 24),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1060),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                            headlineLine1,
                            style: TextStyle(
                              fontSize: headlineSize,
                              fontWeight: FontWeight.w500,
                              height: 0.98,
                              letterSpacing: -1.5,
                              color: AppColors.textPrimary,
                            ),
                          )
                          .animate()
                          .fadeIn(duration: 800.ms, delay: 200.ms)
                          .slideY(
                            begin: 0.3,
                            end: 0,
                            curve: Curves.easeOutCubic,
                          ),
                      _buildHeadlineLine2(headlineSize)
                          .animate()
                          .fadeIn(duration: 800.ms, delay: 350.ms)
                          .slideY(
                            begin: 0.3,
                            end: 0,
                            curve: Curves.easeOutCubic,
                          ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final bottomRow = isMobile
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _subtitleText(isMobile),
                              const SizedBox(height: 28),
                              _exploreLink(),
                            ],
                          )
                        : Padding(
                            padding: EdgeInsets.only(
                              left: constraints.maxWidth * 0.42,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(child: _subtitleText(isMobile)),
                                const SizedBox(width: 32),
                                _exploreLink(),
                              ],
                            ),
                          );
                    return bottomRow
                        .animate()
                        .fadeIn(duration: 700.ms, delay: 650.ms)
                        .slideY(
                          begin: 0.3,
                          end: 0,
                          curve: Curves.easeOutCubic,
                        );
                  },
                ),
              ],
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

  Widget _subtitleText(bool isMobile) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Text(
        subtitle,
        style: TextStyle(
          fontSize: isMobile ? 16 : 17,
          height: 1.6,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _exploreLink() {
    return TextArrowLink(
      label: 'EXPLORE MY WORK',
      icon: Icons.arrow_downward_rounded,
      onPressed: onScrollDown,
    );
  }

  // Renders headlineLine2 with its leading accentWord (if it's a prefix of
  // the line) in the serif display accent style, the remainder plain.
  Widget _buildHeadlineLine2(double fontSize) {
    final baseStyle = TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      height: 0.98,
      letterSpacing: -1.5,
      color: AppColors.textPrimary,
    );

    if (!headlineLine2.startsWith(accentWord)) {
      return Text(headlineLine2, style: baseStyle);
    }

    final rest = headlineLine2.substring(accentWord.length);
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: accentWord,
            style: AppTheme.display(fontSize: fontSize, color: AppColors.accent),
          ),
          TextSpan(text: rest, style: baseStyle),
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
