import 'package:flutter/material.dart';

import '../data/resume_data.dart';
import '../theme/app_theme.dart';

/// Full-width, inverted-color band with the skills list scrolling
/// horizontally in a continuous, seamless loop.
class SkillsMarquee extends StatefulWidget {
  const SkillsMarquee({super.key});

  @override
  State<SkillsMarquee> createState() => _SkillsMarqueeState();
}

class _SkillsMarqueeState extends State<SkillsMarquee>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final GlobalKey _groupKey = GlobalKey();
  double _groupWidth = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    )..repeat();
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureGroup());
  }

  void _measureGroup() {
    final box = _groupKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    if (box.size.width != _groupWidth) {
      setState(() => _groupWidth = box.size.width);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reducedMotion = MediaQuery.of(context).disableAnimations;
    final group = Row(
      mainAxisSize: MainAxisSize.min,
      children: [for (final skill in skills) _MarqueeItem(label: skill.name)],
    );

    return Container(
      color: AppColors.accent,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 22),
      child: ClipRect(
        child: SizedBox(
          height: 30,
          child: reducedMotion
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  child: Row(children: [group, group]),
                )
              : AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    final offset = _groupWidth == 0
                        ? 0.0
                        : -_controller.value * _groupWidth;
                    return OverflowBox(
                      maxWidth: double.infinity,
                      alignment: Alignment.centerLeft,
                      child: Transform.translate(
                        offset: Offset(offset, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            KeyedSubtree(key: _groupKey, child: group),
                            group,
                            group,
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}

class _MarqueeItem extends StatelessWidget {
  final String label;

  const _MarqueeItem({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
              color: AppColors.background,
            ),
          ),
          const SizedBox(width: 24),
          Icon(
            Icons.circle,
            size: 6,
            color: AppColors.background.withValues(alpha: 0.45),
          ),
        ],
      ),
    );
  }
}
