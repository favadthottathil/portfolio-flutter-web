import 'package:flutter/material.dart';

import '../../core/motion/scroll_reveal.dart';
import '../../core/motion/tilt_3d.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/section_header.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  static const _paragraphs = [
    'I did not start in software. I trained as a land surveyor at Government ITI, Areekode, '
        'then moved into code — a year as a trainee Flutter developer at Brototype in Calicut, '
        'building real Dart projects under mentorship, turned that into a career. Counting that '
        'year, I have been working in Flutter for 3.4+ years.',
    'Since joining Promilo I have worked on production mobile apps that real businesses depend on: '
        'lead pipelines, KYC and payments, release engineering. I care most about the parts that '
        'are invisible when they work — session handling that does not drop users, architecture '
        'that survives the next feature, tests that catch the regression before QA does.',
    'I am based in Bengaluru, originally from the Malabar region of Kerala, and I work in '
        'Malayalam and English. Outside the day job I publish open-source Flutter packages and '
        'take on selective freelance work.',
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ScrollReveal(
          child: SectionHeader(
            title: 'About',
            number: '01',
            caption: 'How I got here',
          ),
        ),
        const SizedBox(height: 44),
        ScrollReveal(
          child: Tilt3D(
            maxTilt: 0.04,
            lift: 10,
            scale: 1.006,
            child: GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < _paragraphs.length; i++) ...[
                    if (i > 0) const SizedBox(height: 20),
                    Text(
                      _paragraphs[i],
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: i == 0 ? 0.78 : 0.6),
                        fontSize: isWide ? 16.5 : 15,
                        height: 1.85,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                  const SizedBox(height: 28),
                  Container(
                    height: 1,
                    color: Colors.white.withValues(alpha: 0.07),
                  ),
                  const SizedBox(height: 22),
                  Wrap(
                    spacing: 28,
                    runSpacing: 16,
                    children: const [
                      _Fact(label: 'Based in', value: 'Bengaluru, India'),
                      _Fact(label: 'From', value: 'Kerala, India'),
                      _Fact(label: 'Languages', value: 'Malayalam, English'),
                      _Fact(label: 'Open to', value: 'Flutter roles'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.3),
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
