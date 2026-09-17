import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/resume_data.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_section.dart';
import '../widgets/buttons.dart';

/// Contact/CTA: email, GitHub, LinkedIn links, and a resume-download button.
class ContactSection extends StatelessWidget {
  final GlobalKey sectionKey;

  const ContactSection({super.key, required this.sectionKey});

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

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
        child: AnimatedSection(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Let's build something",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isMobile ? 38 : 68,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1.5,
                  height: 1.1,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Text(
                  "I'm open to new Flutter roles and freelance projects. "
                  "Reach out — I'd love to hear about what you're building.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 18,
                    height: 1.6,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 48),
              PrimaryButton(
                label: 'Download Résumé',
                icon: Icons.download_rounded,
                onPressed: () => _launch(PersonalInfo.resumeUrl),
              ),
              const SizedBox(height: 40),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 16,
                runSpacing: 16,
                children: [
                  HoverLink(
                    label: PersonalInfo.email,
                    icon: Icons.email_outlined,
                    onPressed: () => _launch('mailto:${PersonalInfo.email}'),
                  ),
                  HoverLink(
                    label: 'GitHub',
                    icon: Icons.code_rounded,
                    onPressed: () => _launch(PersonalInfo.githubUrl),
                  ),
                  HoverLink(
                    label: 'LinkedIn',
                    icon: Icons.business_center_outlined,
                    onPressed: () => _launch(PersonalInfo.linkedinUrl),
                  ),
                ],
              ),
              const SizedBox(height: 80),
              Text(
                '© ${DateTime.now().year} ${PersonalInfo.name}. Built with Flutter.',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
