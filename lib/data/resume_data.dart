// =============================================================================
// PLACEHOLDER RESUME DATA
// -----------------------------------------------------------------------------
// Every value below is a placeholder. This file is the single source of
// truth for the content rendered across the site (Hero, About, Experience,
// Projects, Contact). Swap in your real information here — nothing else in
// the app needs to change.
// =============================================================================

/// Top-level personal / contact info.
class PersonalInfo {
  PersonalInfo._();

  // TODO: replace with your real name and tagline.
  static const String name = 'Alex Rivera';
  static const String tagline = 'Flutter Developer';
  static const String heroSubtitle =
      'I design and build fast, beautiful, cross-platform apps with Flutter — '
      'from pixel-perfect UI to production-grade architecture.';

  // TODO: replace with your real bio.
  static const String bio =
      'I\'m a mobile engineer who fell in love with Flutter for letting me ship '
      'one beautiful codebase to iOS, Android, and the web. I care about smooth '
      '60fps interactions, clean architecture, and building UI that feels as '
      'polished as the products I admire most.';

  // TODO: replace with your real contact details.
  static const String email = 'alex.rivera@example.com';
  static const String githubUrl = 'https://github.com/example';
  static const String linkedinUrl = 'https://www.linkedin.com/in/example';
  // TODO: host your actual resume PDF somewhere and link it here.
  static const String resumeUrl = 'https://example.com/alex-rivera-resume.pdf';
}

/// A single skill pill shown in the About section.
class Skill {
  final String name;
  const Skill(this.name);
}

// TODO: adjust this list to reflect your real skill set.
const List<Skill> skills = [
  Skill('Dart'),
  Skill('Flutter'),
  Skill('Bloc'),
  Skill('Riverpod'),
  Skill('Firebase'),
  Skill('CI/CD'),
  Skill('Platform Channels'),
  Skill('REST & GraphQL'),
  Skill('Clean Architecture'),
  Skill('Unit & Widget Testing'),
  Skill('Animations'),
  Skill('Responsive UI'),
];

/// A single role in the Experience timeline.
class ExperienceEntry {
  final String company;
  final String title;
  final String dates;
  final List<String> highlights;

  const ExperienceEntry({
    required this.company,
    required this.title,
    required this.dates,
    required this.highlights,
  });
}

// TODO: replace with your real work history.
const List<ExperienceEntry> experience = [
  ExperienceEntry(
    company: 'Nimbus Labs',
    title: 'Senior Flutter Developer',
    dates: '2023 — Present',
    highlights: [
      'Led the migration of a legacy native app to a single Flutter codebase, cutting release cycle time by 40%.',
      'Built and open-sourced an internal design-system package now used across 5 production apps.',
      'Mentored 3 junior engineers on Bloc architecture, testing strategy, and CI/CD best practices.',
    ],
  ),
  ExperienceEntry(
    company: 'Orbit Software',
    title: 'Flutter Developer',
    dates: '2021 — 2023',
    highlights: [
      'Shipped a Firebase-backed social app from 0 to 100k+ downloads in under a year.',
      'Implemented platform channels to bridge native iOS/Android camera and biometric APIs.',
      'Reduced cold-start time by 35% through widget tree profiling and lazy loading.',
    ],
  ),
  ExperienceEntry(
    company: 'Pixel & Co.',
    title: 'Mobile Developer (Flutter)',
    dates: '2019 — 2021',
    highlights: [
      'Built and maintained e-commerce app UI serving 50k+ monthly active users.',
      'Set up automated CI/CD pipelines with Fastlane and GitHub Actions.',
      'Collaborated directly with design to build a reusable animated component library.',
    ],
  ),
];

/// A single project card in the Projects section.
class ProjectEntry {
  final String name;
  final String description;
  final List<String> tech;

  const ProjectEntry({
    required this.name,
    required this.description,
    required this.tech,
  });
}

// TODO: replace with your real projects.
const List<ProjectEntry> projects = [
  ProjectEntry(
    name: 'Aurora',
    description: 'A habit-tracking app with fluid, physics-based animations and offline-first sync.',
    tech: ['Flutter', 'Riverpod', 'Firebase', 'Hive'],
  ),
  ProjectEntry(
    name: 'Flowline',
    description: 'A collaborative kanban board for small teams, built for web and desktop from one codebase.',
    tech: ['Flutter Web', 'Bloc', 'WebSockets', 'GraphQL'],
  ),
  ProjectEntry(
    name: 'Pulse',
    description: 'A fitness companion app with live workout tracking via platform channels and HealthKit.',
    tech: ['Flutter', 'Platform Channels', 'HealthKit', 'CI/CD'],
  ),
  ProjectEntry(
    name: 'Marketspace',
    description: 'A peer-to-peer marketplace app with real-time chat, payments, and push notifications.',
    tech: ['Flutter', 'Firebase', 'Stripe', 'FCM'],
  ),
];
