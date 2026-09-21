import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_portfolio/data/resume_data.dart';
import 'package:flutter_portfolio/main.dart';

void main() {
  testWidgets('Portfolio app renders the hero name and tagline', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const PortfolioApp());
    await tester.pump();

    // The name renders in both the hero heading and the nav bar brand.
    expect(find.text(PersonalInfo.name), findsWidgets);
    expect(find.text(PersonalInfo.tagline), findsOneWidget);

    // Let the one-shot, delayed entrance animations finish, then unmount,
    // so no timers are left pending when flutter_test checks invariants.
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
