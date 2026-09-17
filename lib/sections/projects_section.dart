import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../data/resume_data.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_section.dart';

/// Projects: large Apple-product-style cards with hover/tap scale.
class ProjectsSection extends StatelessWidget {
  final GlobalKey sectionKey;

  const ProjectsSection({super.key, required this.sectionKey});

  @override
  Widget build(BuildContext context) {
    final isMobile = Breakpoints.isMobile(context);
    final isDesktop = Breakpoints.isDesktop(context);
    final columns = isMobile ? 1 : (isDesktop ? 2 : 1);

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
                  'Projects',
                  style: TextStyle(
                    fontSize: isMobile ? 40 : 64,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1.5,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 64),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: projects.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    mainAxisSpacing: 24,
                    crossAxisSpacing: 24,
                    childAspectRatio: columns == 1 ? 1.5 : 1.3,
                  ),
                  itemBuilder: (context, index) {
                    return _ProjectCard(project: projects[index], index: index);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final ProjectEntry project;
  final int index;

  const _ProjectCard({required this.project, required this.index});

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hovering = false;
  bool _pressed = false;

  static const _gradients = [
    [Color(0xFF1D2B64), Color(0xFF0A0E23)],
    [Color(0xFF360033), Color(0xFF0B0014)],
    [Color(0xFF0F2027), Color(0xFF06090A)],
    [Color(0xFF283048), Color(0xFF0B0F1A)],
  ];

  @override
  Widget build(BuildContext context) {
    final scale = _pressed ? 0.97 : (_hovering ? 1.02 : 1.0);
    final gradient = _gradients[widget.index % _gradients.length];

    return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hovering = true),
          onExit: (_) => setState(() => _hovering = false),
          child: GestureDetector(
            onTapDown: (_) => setState(() => _pressed = true),
            onTapUp: (_) => setState(() => _pressed = false),
            onTapCancel: () => setState(() => _pressed = false),
            child: AnimatedScale(
              scale: scale,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: gradient,
                  ),
                  border: Border.all(
                    color: _hovering ? AppColors.accent : AppColors.border,
                    width: 1.4,
                  ),
                  boxShadow: _hovering
                      ? [
                          BoxShadow(
                            color: AppColors.accent.withValues(alpha: 0.25),
                            blurRadius: 40,
                            spreadRadius: -8,
                          ),
                        ]
                      : [],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.project.name,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.8,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          widget.project.description,
                          style: const TextStyle(
                            fontSize: 15.5,
                            height: 1.55,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final tech in widget.project.tech)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              tech,
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .animate(delay: (100 * widget.index).ms)
        .fadeIn(duration: 500.ms)
        .scale(begin: const Offset(0.92, 0.92), end: const Offset(1, 1));
  }
}
