import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/gradient_text.dart';
import '../../core/widgets/hover_button.dart';
import '../../core/widgets/typing_text.dart';
import 'widgets/status_pill.dart';
import 'widgets/stat_strip.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  static const _email = 'favadfavad2@gmail.com';
  static const _githubUrl = 'https://github.com/favadthottathil';
  static const _linkedInUrl = 'https://www.linkedin.com/in/favadthottathil';

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 800;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const StatusPill(label: 'Available for Flutter roles')
                .animate()
                .fadeIn(duration: 600.ms)
                .slideY(begin: -0.4, end: 0, curve: Curves.easeOutCubic),

            const SizedBox(height: 28),

            GradientText(
                  'Favad Thottathil',
                  gradient: AppColors.chromeGradient,
                  style: GoogleFonts.outfit(
                    fontSize: isDesktop ? 88 : 46,
                    fontWeight: FontWeight.w900,
                    height: 1.02,
                    letterSpacing: -3,
                  ),
                )
                .animate()
                .fadeIn(delay: 150.ms, duration: 900.ms)
                .slideY(begin: 0.18, end: 0, curve: Curves.easeOutCubic),

            const SizedBox(height: 10),

            SizedBox(
              height: isDesktop ? 62 : 42,
              child: TypingText(
                phrases: const [
                  'Flutter Developer.',
                  'Clean Architecture advocate.',
                  'BLoC & MobX at scale.',
                  'CI/CD and release owner.',
                ],
                style: GoogleFonts.outfit(
                  fontSize: isDesktop ? 44 : 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.white.withValues(alpha: 0.55),
                  height: 1.1,
                  letterSpacing: -1,
                ),
              ),
            ).animate().fadeIn(delay: 400.ms, duration: 800.ms),

            const SizedBox(height: 36),

            SizedBox(
                  width: isDesktop
                      ? constraints.maxWidth * 0.62
                      : constraints.maxWidth,
                  child: Text(
                    '3.4+ years in Flutter, building Android and iOS apps for a live B2B company. '
                    'I led the architecture for CollegeLinkr — a B2B EdTech platform — from the ground up '
                    'with Clean Architecture and BLoC, and I own the full release pipeline: CI/CD, code '
                    'signing, Play Store and App Store publishing.',
                    style: TextStyle(
                      fontSize: isDesktop ? 18 : 15.5,
                      color: Colors.white.withValues(alpha: 0.62),
                      height: 1.85,
                      letterSpacing: 0.3,
                    ),
                  ),
                )
                .animate()
                .fadeIn(delay: 600.ms, duration: 800.ms)
                .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),

            const SizedBox(height: 44),

            Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    HoverButton(
                      text: 'Get In Touch',
                      icon: Icons.mail_rounded,
                      isPrimary: true,
                      onPressed: () => launchUrl(Uri.parse('mailto:$_email')),
                    ),
                    HoverButton(
                      text: 'GitHub',
                      icon: Icons.code_rounded,
                      isPrimary: false,
                      onPressed: () => launchUrl(Uri.parse(_githubUrl)),
                    ),
                    HoverButton(
                      text: 'LinkedIn',
                      icon: Icons.person_outline_rounded,
                      isPrimary: false,
                      onPressed: () => launchUrl(Uri.parse(_linkedInUrl)),
                    ),
                  ],
                )
                .animate()
                .fadeIn(delay: 800.ms, duration: 800.ms)
                .scale(begin: const Offset(0.94, 0.94), curve: Curves.easeOutBack),

            SizedBox(height: isDesktop ? 72 : 48),

            const StatStrip(
              stats: [
                StatItem(value: '3.4+', label: 'Years in Flutter'),
                StatItem(value: '55k', label: 'Lines of Dart architected'),
                StatItem(value: '30%', label: 'Manual QA time cut'),
                StatItem(value: '2', label: 'Apps live on Play Store'),
              ],
            ).animate().fadeIn(delay: 1000.ms, duration: 900.ms).slideY(
                  begin: 0.15,
                  end: 0,
                  curve: Curves.easeOutCubic,
                ),
          ],
        );
      },
    );
  }
}
