import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/resume_data.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_section.dart';

/// Work: left-aligned kicker + headline, then one full-width "feature row"
/// per project (illustrated visual + copy, sides alternating), instead of a
/// symmetric grid of cards — mirrors the reference's editorial layout.
class ProjectsSection extends StatelessWidget {
  final GlobalKey sectionKey;

  const ProjectsSection({super.key, required this.sectionKey});

  @override
  Widget build(BuildContext context) {
    final isMobile = Breakpoints.isMobile(context);
    final headlineSize = isMobile ? 44.0 : 72.0;

    return Container(
      key: sectionKey,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: Breakpoints.horizontalPadding(context),
        vertical: isMobile ? 80 : 140,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Breakpoints.maxContentWidth),
          child: AnimatedSection(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      PersonalInfo.workKickerIndex,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accent,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '/ ${PersonalInfo.workKickerLabel.toUpperCase()}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  PersonalInfo.workHeadlineLine1,
                  style: TextStyle(
                    fontSize: headlineSize,
                    fontWeight: FontWeight.w500,
                    height: 0.98,
                    letterSpacing: -1.5,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  PersonalInfo.workHeadlineLine2,
                  style: AppTheme.display(
                    fontSize: headlineSize,
                    color: AppColors.accent,
                  ),
                ),
                SizedBox(height: isMobile ? 56 : 96),
                for (var i = 0; i < projects.length; i++)
                  Padding(
                    padding: EdgeInsets.only(bottom: isMobile ? 64 : 120),
                    child: _ProjectFeature(
                      project: projects[i],
                      index: i,
                      isMobile: isMobile,
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

class _ProjectFeature extends StatefulWidget {
  final ProjectEntry project;
  final int index;
  final bool isMobile;

  const _ProjectFeature({
    required this.project,
    required this.index,
    required this.isMobile,
  });

  @override
  State<_ProjectFeature> createState() => _ProjectFeatureState();
}

class _ProjectFeatureState extends State<_ProjectFeature> {
  bool _hovering = false;

  Future<void> _openUrl() async {
    final url = widget.project.url;
    if (url == null) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final clickable = widget.project.url != null;
    final reversed = !widget.isMobile && widget.index.isOdd;

    final visual = _buildVisual();
    final copy = _ProjectCopy(project: widget.project, index: widget.index);

    Widget content = widget.isMobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [visual, const SizedBox(height: 32), copy],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: reversed
                ? [
                    Expanded(flex: 4, child: copy),
                    const SizedBox(width: 56),
                    Expanded(flex: 6, child: visual),
                  ]
                : [
                    Expanded(flex: 6, child: visual),
                    const SizedBox(width: 56),
                    Expanded(flex: 4, child: copy),
                  ],
          );

    content = MouseRegion(
      cursor: clickable ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(onTap: clickable ? _openUrl : null, child: content),
    );

    return content
        .animate(delay: (80 * widget.index).ms)
        .fadeIn(duration: 500.ms)
        .slideY(begin: 0.06, end: 0, curve: Curves.easeOutCubic);
  }

  Widget _buildVisual() {
    final scale = _hovering ? 1.015 : 1.0;
    final child = switch (widget.index) {
      0 => _PhonicsVisual(hovering: _hovering),
      1 => _ScreensVisual(hovering: _hovering),
      _ => _EcommerceVisual(hovering: _hovering),
    };

    return AnimatedScale(
      scale: scale,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      child: Container(
        height: widget.isMobile ? 320 : 420,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _hovering ? AppColors.accent : AppColors.border,
            width: 1.2,
          ),
        ),
        child: child,
      ),
    );
  }
}

class _ProjectCopy extends StatelessWidget {
  final ProjectEntry project;
  final int index;

  const _ProjectCopy({required this.project, required this.index});

  @override
  Widget build(BuildContext context) {
    final isMobile = Breakpoints.isMobile(context);
    final titleLines = project.name.split('\n');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '0${index + 1}',
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              project.type.toUpperCase(),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.accent,
                letterSpacing: 1.2,
              ),
            ),
            if (project.badge != null) ...[
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  project.badge!,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accent,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 14),
        for (final line in titleLines)
          Text(
            line,
            style: TextStyle(
              fontSize: isMobile ? 28 : 38,
              fontWeight: FontWeight.w500,
              height: 1.05,
              letterSpacing: -0.8,
              color: AppColors.textPrimary,
            ),
          ),
        const SizedBox(height: 18),
        Text(
          project.description,
          style: const TextStyle(
            fontSize: 15,
            height: 1.7,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 22),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final tech in project.tech)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  tech,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

/// Mockup 1 — Phonics Learning App: a bright accent-tinted phone frame with
/// a soundwave and a "Wonderful!" feedback chip, echoing the shipped app's
/// speech-feedback UI without depending on any real screenshot.
class _PhonicsVisual extends StatelessWidget {
  final bool hovering;

  const _PhonicsVisual({required this.hovering});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.accent,
      alignment: Alignment.center,
      child: Container(
        width: 190,
        height: 340,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.background, width: 6),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(width: 28, height: 4, color: AppColors.accent),
                Container(
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                for (var i = 0; i < 7; i++)
                  _SoundBar(index: i, active: hovering),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Wonderful!',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  color: AppColors.background,
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class _SoundBar extends StatelessWidget {
  final int index;
  final bool active;

  const _SoundBar({required this.index, required this.active});

  @override
  Widget build(BuildContext context) {
    final heights = [14.0, 26.0, 40.0, 18.0, 34.0, 20.0, 12.0];
    final bar = Container(
      width: 4,
      height: heights[index % heights.length],
      margin: const EdgeInsets.symmetric(horizontal: 2.5),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(4),
      ),
    );
    return bar
        .animate(onPlay: (c) => c.repeat(reverse: true), delay: (90 * index).ms)
        .scaleY(
          duration: 700.ms,
          curve: Curves.easeInOut,
          begin: 0.5,
          end: 1,
        );
  }
}

/// Mockup 2 — Daily UI Screens: a fanned stack of real screenshots pulled
/// straight from the flutter_ui repo, so this links out to something worth
/// clicking rather than a promise.
class _ScreensVisual extends StatelessWidget {
  final bool hovering;

  const _ScreensVisual({required this.hovering});

  static const _urls = [
    'https://raw.githubusercontent.com/sivanianto123-rgb/flutter_ui/main/boba/flutter_01.png',
    'https://raw.githubusercontent.com/sivanianto123-rgb/flutter_ui/main/coffeestore/flutter_01.png',
    'https://raw.githubusercontent.com/sivanianto123-rgb/flutter_ui/main/spotify/flutter_01.png',
  ];

  @override
  Widget build(BuildContext context) {
    const rotations = [-0.12, 0.0, 0.12];
    const offsets = [-70.0, 0.0, 70.0];

    return Container(
      color: AppColors.surfaceElevated,
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (var i = 0; i < _urls.length; i++)
            Transform.translate(
              offset: Offset(offsets[i], i == 1 ? -8 : 8),
              child: Transform.rotate(
                angle: rotations[i],
                child: _ScreenshotCard(url: _urls[i]),
              ),
            ),
        ],
      ),
    );
  }
}

class _ScreenshotCard extends StatelessWidget {
  final String url;

  const _ScreenshotCard({required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 240,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 3),
        boxShadow: const [
          BoxShadow(color: Colors.black45, blurRadius: 24, offset: Offset(0, 12)),
        ],
      ),
      child: Image.network(
        url,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const ColoredBox(color: AppColors.surface);
        },
        errorBuilder: (context, error, stack) =>
            const ColoredBox(color: AppColors.surface),
      ),
    );
  }
}

/// Mockup 3 — Ecommerce App: a fanned stack of real screenshots from the
/// actual site (Monolith, a made-to-order sneaker studio) — landing, the
/// product grid, the 3D configurator, and checkout, telling the full
/// browse-to-purchase story rather than just the hero.
class _EcommerceVisual extends StatelessWidget {
  final bool hovering;

  const _EcommerceVisual({required this.hovering});

  static const _assets = [
    'assets/ecommerce/grid.png',
    'assets/ecommerce/hero.png',
    'assets/ecommerce/configurator.png',
    'assets/ecommerce/checkout.png',
  ];

  @override
  Widget build(BuildContext context) {
    const rotations = [-0.12, -0.04, 0.04, 0.12];
    const offsets = [-96.0, -32.0, 32.0, 96.0];
    const verticalOffsets = [16.0, -10.0, -10.0, 16.0];

    return Container(
      color: AppColors.surfaceElevated,
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (var i = 0; i < _assets.length; i++)
            Transform.translate(
              offset: Offset(offsets[i], verticalOffsets[i]),
              child: Transform.rotate(
                angle: rotations[i],
                child: _BrowserShot(asset: _assets[i], width: 190),
              ),
            ),
        ],
      ),
    );
  }
}

/// A small "browser window" frame around a real, landscape screenshot —
/// used for the Ecommerce mockup, which (unlike the phone-shaped Daily UI
/// Screens cards) is a desktop web app.
class _BrowserShot extends StatelessWidget {
  final String asset;
  final double width;

  const _BrowserShot({required this.asset, this.width = 220});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border, width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black45, blurRadius: 24, offset: Offset(0, 12)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 16,
            width: double.infinity,
            color: AppColors.surface,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                for (final _ in List.filled(3, null))
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.textSecondary.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          AspectRatio(
            aspectRatio: 900 / 494,
            child: Image.asset(asset, fit: BoxFit.cover),
          ),
        ],
      ),
    );
  }
}
