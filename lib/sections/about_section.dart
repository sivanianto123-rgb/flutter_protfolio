import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../data/resume_data.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_section.dart';

/// About: short bio + a skills pill-cluster.
class AboutSection extends StatelessWidget {
  final GlobalKey sectionKey;

  const AboutSection({super.key, required this.sectionKey});

  @override
  Widget build(BuildContext context) {
    final isMobile = Breakpoints.isMobile(context);

    return Container(
      key: sectionKey,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height,
      ),
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: Breakpoints.horizontalPadding(context),
        vertical: 120,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Breakpoints.maxContentWidth),
          child: AnimatedSection(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'About',
                  style: TextStyle(
                    fontSize: isMobile ? 40 : 64,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1.5,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 32),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: Text(
                    PersonalInfo.bio,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isMobile ? 17 : 21,
                      height: 1.6,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 56),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    for (var i = 0; i < skills.length; i++)
                      _SkillPill(skill: skills[i], index: i),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
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
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(
            skill.name,
            style: const TextStyle(
              fontSize: 15,
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
