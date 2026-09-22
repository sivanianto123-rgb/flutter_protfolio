// =============================================================================
// RESUME DATA
// -----------------------------------------------------------------------------
// Single source of truth for content rendered across the site (Hero, About,
// Experience, Projects, Contact).
// =============================================================================

/// Top-level personal / contact info.
class PersonalInfo {
  PersonalInfo._();

  static const String name = 'Sivani';
  static const String fullName = 'T. Sivani';
  static const String tagline = 'Flutter Developer';
  static const String location = 'Chennai, India';
  static const String heroKickerIndex = '01';
  static const String heroKickerLabel = 'Flutter Developer · Chennai';

  // Giant hero statement — split into two lines to match the reference
  // layout; the second line's first word is rendered as the accent flourish.
  static const String heroHeadlineLine1 = 'I make digital';
  static const String heroHeadlineLine2 = 'experiences move.';
  static const String heroAccentWord = 'experiences';

  static const String heroSubtitle =
      'Cross-platform apps with responsive interfaces, playful motion, and '
      'thoughtful engineering.';

  static const String storyKickerIndex = '03';
  static const String storyKickerLabel = 'My story';
  static const String storyHeadlineLine1 = 'Code with';
  static const String storyHeadlineLine2 = 'character.';
  static const String storyAccentWord = 'character.';

  static const String storyLead =
      "I'm a developer who cares about the moment an interface stops "
      'feeling static and starts feeling intuitive.';

  static const String bio =
      'From debugging native audio sessions to shaping a mascot\'s '
      'emotional states, I work across code and motion to make complex '
      'interactions feel simple — comfortable across the full Flutter '
      'stack, including Rive for interactive vector animation. Based in '
      'Chennai, India.';

  static const String workKickerIndex = '02';
  static const String workKickerLabel = 'Selected work';
  static const String workHeadlineLine1 = 'Built to feel';
  static const String workHeadlineLine2 = 'alive.';
  static const String workAccentWord = 'alive.';

  static const String email = 'sivanianto123@gmail.com';
  static const String phone = '+91 9486415807';
  static const String githubUrl = 'https://github.com/sivanianto123-rgb';

  // TODO: add your real LinkedIn profile URL — the Contact section hides the
  // LinkedIn button automatically until this is set.
  static const String? linkedinUrl = null;

  // Resume PDF is shipped alongside the built site — see web/resume.pdf.
  static const String resumeUrl = 'resume.pdf';
}

/// A single skill pill shown in the About section.
class Skill {
  final String name;
  const Skill(this.name);
}

const List<Skill> skills = [
  Skill('Dart'),
  Skill('Flutter'),
  Skill('JavaScript'),
  Skill('Python'),
  Skill('SQL'),
  Skill('speech_to_text'),
  Skill('Lottie'),
  Skill('Rive'),
  Skill('Figma-to-Flutter'),
  Skill('REST & GraphQL'),
  Skill('Clean Architecture'),
  Skill('Modular Architecture'),
  Skill('google_fonts'),
  Skill('Responsive UI'),
  Skill('Git/GitHub'),
  Skill('Agile/Scrum'),
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

const List<ExperienceEntry> experience = [
  ExperienceEntry(
    company: 'Coreillustrio',
    title: 'Flutter Developer',
    dates: 'Jun 2025 — Present',
    highlights: [
      'Shipped a cross-platform (iOS, Android, Web) Flutter phonics-learning '
          'app for early-childhood users, owning feature development across a '
          'modular, data-driven screen and widget architecture.',
      'Built a real-time speech-recognition feature (speech_to_text) with a '
          'custom lenient-matching engine — syllable, phonetic, and '
          'partial-word comparisons — so young children get accurate feedback '
          'despite imperfect pronunciation.',
      'Root-caused and fixed a native iOS bug where speech recognition and '
          'audio playback (soundpool) conflicted over the AVAudioSession; '
          'redesigned the interaction into a sequential play-then-listen '
          'state machine with runtime permissions via permission_handler.',
      'Designed an animated feedback system (Lottie/dotlottie) built around '
          'a multi-emotion mascot, and converted Figma designs into '
          'pixel-perfect, responsive Flutter UI collaborating on REST/GraphQL '
          'API integration in an agile workflow.',
    ],
  ),
  ExperienceEntry(
    company: 'Larsen and Toubro',
    title: 'Data Analyst Intern',
    dates: 'Jun 2023 — Jul 2023',
    highlights: [
      'Normalized production datasets and presented database-normalization '
          'concepts to the team, identifying and correcting existing data '
          'errors using MySQL Workbench.',
    ],
  ),
];

/// A single project card in the Projects section.
class ProjectEntry {
  final String name;
  final String type;
  final String description;
  final List<String> tech;
  final String? url;
  final String? badge;

  const ProjectEntry({
    required this.name,
    required this.type,
    required this.description,
    required this.tech,
    this.url,
    this.badge,
  });
}

const List<ProjectEntry> projects = [
  ProjectEntry(
    name: 'Phonics learning,\nmade playful.',
    type: 'Shipped product · Coreillustrio',
    description:
        'A cross-platform Flutter app that teaches early readers with '
        'real-time speech recognition, lenient phonetic matching, and an '
        'animated Lottie mascot that reacts to a child\'s performance.',
    tech: ['Flutter', 'speech_to_text', 'Lottie', 'GraphQL'],
    badge: 'Production',
  ),
  ProjectEntry(
    name: 'Daily UI screens,\nrebuilt for practice.',
    type: 'Ongoing · Design practice',
    description:
        'A running gallery of Flutter UI screens I design and rebuild daily '
        '— pixel-perfect layouts, animation practice, and Figma-to-Flutter '
        'implementation.',
    tech: ['Flutter', 'Figma', 'UI/UX'],
    url: 'https://sivanianto123-rgb.github.io/flutter_ui/',
    badge: 'Daily',
  ),
  ProjectEntry(
    name: 'An e-commerce\nexperience.',
    type: 'Monolith · Made-to-order sneakers',
    description:
        'A Flutter ecommerce app with a live 3D product configurator — spin '
        'a sneaker, recolor every panel, and check out — backed by Firebase '
        'Auth and Firestore.',
    tech: ['Flutter', 'Firebase', 'Riverpod', '3D Configurator'],
    url: 'https://monolithe-sneaker.web.app',
    badge: 'Shipped',
  ),
];
