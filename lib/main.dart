import 'package:flutter/material.dart';

import 'data/resume_data.dart';
import 'sections/about_section.dart';
import 'sections/contact_section.dart';
import 'sections/experience_section.dart';
import 'sections/hero_section.dart';
import 'sections/projects_section.dart';
import 'theme/app_theme.dart';
import 'widgets/code_field.dart';
import 'widgets/coding_buddy.dart';
import 'widgets/custom_cursor.dart';
import 'widgets/nav_bar.dart';
import 'widgets/skills_marquee.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '${PersonalInfo.name} · ${PersonalInfo.tagline}',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const CustomCursor(child: PortfolioPage()),
    );
  }
}

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<double> _scrollOffset = ValueNotifier(0);

  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  bool _scrolledPastTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _scrollOffset.dispose();
    super.dispose();
  }

  void _onScroll() {
    _scrollOffset.value = _scrollController.offset;
    final scrolled = _scrollController.offset > 8;
    if (scrolled != _scrolledPastTop) {
      setState(() => _scrolledPastTop = scrolled);
    }
  }

  // Scrolls so the target section's top aligns with the viewport top.
  //
  // Scrollable.ensureVisible() is unreliable here: several sections are
  // taller than the viewport, and its "minimal scroll to reveal" semantics
  // can under-scroll (or no-op) when the target can't fully fit on screen.
  // Computing the absolute offset directly and driving the controller is
  // deterministic regardless of section height.
  void _scrollTo(GlobalKey key) {
    final targetContext = key.currentContext;
    if (targetContext == null) return;
    final targetBox = targetContext.findRenderObject() as RenderBox?;
    if (targetBox == null || !targetBox.attached) return;

    final scrollableState = Scrollable.of(targetContext);
    final viewportBox =
        scrollableState.context.findRenderObject() as RenderBox?;
    if (viewportBox == null) return;

    final targetOffset =
        targetBox.localToGlobal(Offset.zero, ancestor: viewportBox).dy +
        _scrollController.offset;

    _scrollController.animateTo(
      targetOffset.clamp(0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const Positioned.fill(child: CodeField()),
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                KeyedSubtree(
                  key: _heroKey,
                  child: HeroSection(
                    scrollOffset: _scrollOffset,
                    onScrollDown: () => _scrollTo(_projectsKey),
                    kickerIndex: PersonalInfo.heroKickerIndex,
                    kickerLabel: PersonalInfo.heroKickerLabel,
                    headlineLine1: PersonalInfo.heroHeadlineLine1,
                    headlineLine2: PersonalInfo.heroHeadlineLine2,
                    accentWord: PersonalInfo.heroAccentWord,
                    subtitle: PersonalInfo.heroSubtitle,
                  ),
                ),
                ProjectsSection(sectionKey: _projectsKey),
                AboutSection(sectionKey: _aboutKey),
                ExperienceSection(sectionKey: _experienceKey),
                const SkillsMarquee(),
                ContactSection(sectionKey: _contactKey),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: NavBar(
              scrolled: _scrolledPastTop,
              brand: PersonalInfo.name,
              items: [
                NavItem(label: 'Home', onTap: () => _scrollTo(_heroKey)),
                NavItem(label: 'Work', onTap: () => _scrollTo(_projectsKey)),
                NavItem(label: 'Story', onTap: () => _scrollTo(_aboutKey)),
                NavItem(label: 'Contact', onTap: () => _scrollTo(_contactKey)),
              ],
            ),
          ),
          const Positioned(
            right: 28,
            bottom: 28,
            child: CodingBuddy(),
          ),
        ],
      ),
    );
  }
}
