import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../data/resume_data.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_section.dart';

/// Experience: vertical timeline of roles with highlights.
class ExperienceSection extends StatelessWidget {
  final GlobalKey sectionKey;

  const ExperienceSection({super.key, required this.sectionKey});

  @override
  Widget build(BuildContext context) {
    final isMobile = Breakpoints.isMobile(context);

    return Container(
      key: sectionKey,
      width: double.infinity,
      color: AppColors.surface.withValues(alpha: 0.35),
      padding: EdgeInsets.symmetric(
        horizontal: Breakpoints.horizontalPadding(context),
        vertical: isMobile ? 60 : 100,
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
                    const Text(
                      '/ WHERE I\'VE WORKED',
                      style: TextStyle(
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
                  'Experience',
                  style: TextStyle(
                    fontSize: isMobile ? 34 : 48,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -1,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 48),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 780),
                  child: Column(
                    children: [
                      for (var i = 0; i < experience.length; i++)
                        _TimelineEntry(
                          entry: experience[i],
                          index: i,
                          isLast: i == experience.length - 1,
                          isMobile: isMobile,
                        ),
                    ],
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

class _TimelineEntry extends StatelessWidget {
  final ExperienceEntry entry;
  final int index;
  final bool isLast;
  final bool isMobile;

  const _TimelineEntry({
    required this.entry,
    required this.index,
    required this.isLast,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline rail: dot + connecting line.
              Column(
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    margin: const EdgeInsets.only(top: 6),
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(width: 2, color: AppColors.border),
                    ),
                ],
              ),
              const SizedBox(width: 28),
              // Content card.
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 48),
                  child: Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 12,
                          runSpacing: 6,
                          children: [
                            Text(
                              entry.title,
                              style: TextStyle(
                                fontSize: isMobile ? 20 : 24,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                entry.dates,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.accent,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          entry.company,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 18),
                        for (final highlight in entry.highlights)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 7, right: 12),
                                  child: Icon(
                                    Icons.circle,
                                    size: 5,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    highlight,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      height: 1.55,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
        .animate(delay: (120 * index).ms)
        .fadeIn(duration: 500.ms)
        .slideX(begin: 0.08, end: 0, curve: Curves.easeOutCubic);
  }
}
