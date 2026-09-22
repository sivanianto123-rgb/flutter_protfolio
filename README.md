# Sivani — Flutter Developer Portfolio

A single-page Flutter Web portfolio for a Flutter developer based in
Chennai, India — dark, motion-heavy, code-themed design with a full-bleed
video hero, left-aligned editorial layout, and a live typing-code animation.

**Live site:** https://sivanianto123-rgb.github.io/flutter_protfolio/

## Sections

- **Home** — full-bleed looping video background, custom cursor, floating
  monospace "code chip" decorations.
- **Work** — one illustrated feature row per project (Phonics Learning App,
  Daily UI Screens, Ecommerce App), each linking out to the real thing.
- **Story** — bio, a live typing-code animation, and skills.
- **Experience** — work history timeline.
- **Contact** — resume download and contact links.

## Stack

- Flutter Web, no state management library — plain `StatefulWidget`/
  `ValueNotifier` throughout.
- [`flutter_animate`](https://pub.dev/packages/flutter_animate) for entrance
  and looping animations.
- [`url_launcher`](https://pub.dev/packages/url_launcher) for outbound
  links (email, GitHub, resume, project links).
- `package:web` + `dart:ui_web` platform views for the native HTML
  `<video>` background (no Flutter video codec dependency).
- Manrope and Instrument Serif bundled locally as font assets — not fetched
  from Google Fonts at runtime — so the site doesn't depend on
  `fonts.gstatic.com` being reachable for a visitor to see the right type.

## Content

All resume/project copy lives in one place: `lib/data/resume_data.dart`.
Update name, bio, experience, and project entries there — the rest of the
app is presentational and reads from it.

## Running locally

```bash
flutter pub get
flutter run -d chrome
```

## Deploying

Pushing to `main` triggers `.github/workflows/deploy.yml`, which builds
with `flutter build web --release --no-web-resources-cdn` (CanvasKit
bundled locally rather than fetched from a CDN at runtime, for the same
reliability reason as the fonts) and deploys to GitHub Pages.
