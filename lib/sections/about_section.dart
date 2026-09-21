import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../data/resume_data.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_section.dart';
import '../widgets/typing_code.dart';

/// Story: left column kicker + headline, right column lead + bio + a live
/// typing-code card + skills pills. Left-aligned two-column editorial
/// layout (stacked on mobile), not centered.
class AboutSection extends StatelessWidget {
  final GlobalKey sectionKey;

  const AboutSection({super.key, required this.sectionKey});

  @override
  Widget build(BuildContext context) {
    final isMobile = Breakpoints.isMobile(context);

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
            child: isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _StoryIntro(),
                      const SizedBox(height: 48),
                      const _StoryCopy(),
                    ],
                  )
                : IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: const _StoryIntro()),
                        const SizedBox(width: 80),
                        Expanded(child: const _StoryCopy()),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _StoryIntro extends StatelessWidget {
  const _StoryIntro();

  @override
  Widget build(BuildContext context) {
    final isMobile = Breakpoints.isMobile(context);
    final headlineSize = isMobile ? 44.0 : 68.0;
    final baseStyle = TextStyle(
      fontSize: headlineSize,
      fontWeight: FontWeight.w500,
      height: 0.95,
      letterSpacing: -1.2,
      color: AppColors.textPrimary,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              PersonalInfo.storyKickerIndex,
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
              '/ ${PersonalInfo.storyKickerLabel.toUpperCase()}',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(PersonalInfo.storyHeadlineLine1, style: baseStyle),
        Text(
          PersonalInfo.storyHeadlineLine2,
          style: AppTheme.display(fontSize: headlineSize, color: AppColors.accent),
        ),
      ],
    );
  }
}

class _StoryCopy extends StatelessWidget {
  const _StoryCopy();

  @override
  Widget build(BuildContext context) {
    final isMobile = Breakpoints.isMobile(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          PersonalInfo.storyLead,
          style: TextStyle(
            fontSize: isMobile ? 20 : 24,
            fontWeight: FontWeight.w400,
            height: 1.35,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          PersonalInfo.bio,
          style: TextStyle(
            fontSize: isMobile ? 15.5 : 16,
            height: 1.75,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 36),
        const TypingCode(),
        const SizedBox(height: 40),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (var i = 0; i < skills.length; i++)
              _SkillPill(skill: skills[i], index: i),
          ],
        ),
      ],
    );
  }
}

class _SkillPill extends StatelessWidget {
  final Skill skill;
  final int index;

  const _SkillPill({required this.skill, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(
            skill.name,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        )
        .animate(delay: (40 * index).ms)
        .fadeIn(duration: 400.ms)
        .scale(begin: const Offset(0.85, 0.85), end: const Offset(1, 1));
  }
}
