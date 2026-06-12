import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

void downloadResume() {
  if (kIsWeb) {
    final web.HTMLAnchorElement anchor =
        web.document.createElement('a') as web.HTMLAnchorElement;
    anchor.href = 'assets/assets/resume_updated_28_03.pdf';
    anchor.download = 'resume_updated_28_03.pdf';
    anchor.click();
  } else {
    launchUrl(Uri.parse('assets/resume_updated_28_03.pdf'));
  }
}

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Favad T - Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B0C10),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF21E6C1), // Neon Cyan accent
          secondary: Color(0xFF6C63FF), // Purple accent
          surface: Color(0xFF1F2833),
          background: Color(0xFF0B0C10),
        ),
        textTheme: GoogleFonts.outfitTextTheme(
          Theme.of(context).textTheme,
        ).apply(bodyColor: Colors.white, displayColor: Colors.white),
      ),
      home: const MainPortfolioPage(),
    );
  }
}

class MainPortfolioPage extends StatefulWidget {
  const MainPortfolioPage({super.key});

  @override
  State<MainPortfolioPage> createState() => _MainPortfolioPageState();
}

class _MainPortfolioPageState extends State<MainPortfolioPage> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0;

  // Keys for scrolling to specific sections
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 80),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.background.withValues(alpha: 0.5),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                          'Favad   T',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w900,
                            fontSize: 26,
                            letterSpacing: -1,
                          ),
                        )
                        .animate(
                          onPlay: (controller) =>
                              controller.repeat(reverse: true),
                        )
                        .shimmer(
                          duration: 3000.ms,
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.3),
                        ),
                    if (isDesktop)
                      Row(
                        children: [
                          _NavBarItem(
                            title: 'Experience',
                            onPressed: () => _scrollToSection(_experienceKey),
                          ),
                          _NavBarItem(
                            title: 'Projects',
                            onPressed: () => _scrollToSection(_projectsKey),
                          ),
                          _NavBarItem(
                            title: 'Skills',
                            onPressed: () => _scrollToSection(_skillsKey),
                          ),
                          const SizedBox(width: 24),
                          _AnimatedResumeButton(),
                        ],
                      )
                    else
                      IconButton(
                        icon: const Icon(Icons.download),
                        onPressed: _launchPdf,
                        color: Theme.of(context).colorScheme.primary,
                      ).animate().scale(
                        delay: 500.ms,
                        duration: 500.ms,
                        curve: Curves.easeOutBack,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Animated Background Orbs
          Positioned(
            top: -100 + (_scrollOffset * 0.2),
            left: -100,
            child: _GlowingOrb(
              color: Theme.of(context).colorScheme.primary,
              size: 400,
            ),
          ),
          Positioned(
            top: size.height * 0.4 - (_scrollOffset * 0.1),
            right: -150,
            child: _GlowingOrb(
              color: Theme.of(context).colorScheme.secondary,
              size: 500,
            ),
          ),
          Positioned(
            bottom: -200 + (_scrollOffset * 0.3),
            left: size.width * 0.2,
            child: _GlowingOrb(color: Colors.pinkAccent, size: 300),
          ),

          // Main Content
          SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? size.width * 0.15 : 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: isDesktop ? 160 : 100),
                  const HeroSection(),
                  SizedBox(height: isDesktop ? 150 : 80),
                  ExperienceSection(key: _experienceKey),
                  SizedBox(height: isDesktop ? 150 : 80),
                  ProjectsSection(key: _projectsKey),
                  SizedBox(height: isDesktop ? 150 : 80),
                  SkillsSection(key: _skillsKey),
                  SizedBox(height: isDesktop ? 150 : 80),
                  _buildFooter(),
                  SizedBox(height: isDesktop ? 60 : 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _launchPdf() {
    downloadResume();
  }

  Widget _buildFooter() {
    return Center(
      child: Text(
        'Designed & Built with Flutter Web\n© Favad T',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.4),
          fontSize: 14,
          height: 1.5,
          letterSpacing: 1.2,
        ),
      ).animate().fadeIn(duration: 1000.ms),
    );
  }

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
      );
    }
  }
}

class _GlowingOrb extends StatelessWidget {
  final Color color;
  final double size;

  const _GlowingOrb({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [color.withValues(alpha: 0.15), Colors.transparent],
            ),
          ),
        )
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .scaleXY(
          begin: 1.0,
          end: 1.2,
          curve: Curves.easeInOut,
          duration: 4000.ms,
        )
        .moveY(begin: 0, end: 20, duration: 3000.ms, curve: Curves.easeInOut);
  }
}

class _NavBarItem extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const _NavBarItem({required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: Colors.white.withValues(alpha: 0.8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0);
  }
}

class _AnimatedResumeButton extends StatefulWidget {
  @override
  State<_AnimatedResumeButton> createState() => _AnimatedResumeButtonState();
}

class _AnimatedResumeButtonState extends State<_AnimatedResumeButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            transform: Matrix4.identity()..scale(isHovered ? 1.05 : 1.0),
            child: ElevatedButton(
              onPressed: () {
                downloadResume();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isHovered
                    ? Colors.white
                    : Theme.of(context).colorScheme.primary,
                foregroundColor: const Color(0xFF0B0C10),
                elevation: isHovered ? 15 : 0,
                shadowColor: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.5),
                padding: const EdgeInsets.symmetric(
                  // Reverted padding
                  horizontal: 24,
                  vertical: 18,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Download Resume',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(delay: 400.ms, duration: 600.ms)
        .scale(curve: Curves.easeOutBack);
  }
}

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 800;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                  'Favad T.',
                  style: GoogleFonts.outfit(
                    fontSize: isDesktop ? 90 : 56,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.0,
                    letterSpacing: -2,
                  ),
                )
                .animate()
                .fadeIn(delay: 200.ms, duration: 800.ms)
                .shimmer(delay: 1000.ms, duration: 2000.ms)
                .slideY(begin: 0.2, end: 0, curve: Curves.easeOutCubic),

            Text(
                  'Engineering digital experiences.',
                  style: GoogleFonts.outfit(
                    fontSize: isDesktop ? 64 : 40,
                    fontWeight: FontWeight.w800,
                    color: Colors.white.withValues(alpha: 0.4),
                    height: 1.1,
                    letterSpacing: -1,
                  ),
                )
                .animate()
                .fadeIn(delay: 400.ms, duration: 800.ms)
                .slideY(begin: 0.2, end: 0, curve: Curves.easeOutCubic),

            const SizedBox(height: 40),

            SizedBox(
                  width: isDesktop
                      ? constraints.maxWidth * 0.6
                      : constraints.maxWidth * 0.95,
                  child: Text(
                    'I’m a Flutter Developer with 2+ years of experience building production mobile applications for live B2B platforms. '
                    'Specializing in Clean Architecture, state management (MobX, BLoC), API-driven rendering, and high-performance scalable systems.',
                    style: TextStyle(
                      fontSize: isDesktop ? 18 : 16,
                      color: Colors.white.withValues(alpha: 0.6),
                      height: 1.8,
                      letterSpacing: 0.5,
                    ),
                  ),
                )
                .animate()
                .fadeIn(delay: 600.ms, duration: 800.ms)
                .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),

            const SizedBox(height: 56),

            Row(
                  children: [
                    _HoverButton(
                      text: 'Get In Touch',
                      icon: Icons.mail_rounded,
                      isPrimary: true,
                      onPressed: () =>
                          launchUrl(Uri.parse('mailto:favadfavad2@gmail.com')),
                    ),
                    const SizedBox(width: 20),
                    _HoverButton(
                      text: 'GitHub',
                      icon: Icons.code_rounded,
                      isPrimary: false,
                      onPressed: () => launchUrl(
                        Uri.parse('https://github.com/favadthottathil'),
                      ),
                    ),
                  ],
                )
                .animate()
                .fadeIn(delay: 800.ms, duration: 800.ms)
                .scale(
                  begin: const Offset(0.9, 0.9),
                  curve: Curves.easeOutBack,
                ),
          ],
        );
      },
    );
  }
}

class _HoverButton extends StatefulWidget {
  final String text;
  final IconData icon;
  final bool isPrimary;
  final VoidCallback onPressed;

  const _HoverButton({
    required this.text,
    required this.icon,
    required this.isPrimary,
    required this.onPressed,
  });

  @override
  State<_HoverButton> createState() => _HoverButtonState();
}

class _HoverButtonState extends State<_HoverButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()..translate(0.0, isHovered ? -5.0 : 0.0),
        child: widget.isPrimary
            ? ElevatedButton.icon(
                onPressed: widget.onPressed,
                icon: Icon(widget.icon),
                label: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 18.0,
                    horizontal: 8.0,
                  ),
                  child: Text(
                    widget.text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: const Color(0xFF0B0C10),
                  elevation: isHovered ? 20 : 0,
                  shadowColor: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              )
            : OutlinedButton.icon(
                onPressed: widget.onPressed,
                icon: Icon(widget.icon),
                label: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 18.0,
                    horizontal: 8.0,
                  ),
                  child: Text(
                    widget.text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: isHovered
                      ? Theme.of(context).colorScheme.primary
                      : Colors.white,
                  side: BorderSide(
                    color: isHovered
                        ? Theme.of(context).colorScheme.primary
                        : Colors.white.withValues(alpha: 0.3),
                    width: 2,
                  ),
                  backgroundColor: isHovered
                      ? Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.1)
                      : Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String number;

  const SectionHeader({super.key, required this.title, required this.number});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          number,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 24,
            fontFamily: 'monospace',
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 16),
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: MediaQuery.of(context).size.width > 500 ? 36 : 28,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 800.ms).slideX(begin: -0.1, end: 0);
  }
}

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Experience', number: '01.'),
        const SizedBox(height: 40),
        const _GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ExperienceTitle(
                title: 'Flutter Developer',
                company: '@ Promilo (Sawara Solution Pvt Ltd)',
                date: 'Mar 2024 - present',
              ),
              SizedBox(height: 32),
              _BulletPoint(
                'Built and shipped production features for Promilo, a B2B platform connecting businesses and students.',
              ),
              _BulletPoint(
                'Integrated the Milli AI Assistant, enabling conversational AI features and rendering dynamic AI responses.',
              ),
              _BulletPoint(
                'Built a dynamic form rendering engine for business-configured fields fetched from API, eliminating hardcoded UI logic.',
              ),
              _BulletPoint(
                'Implemented a local analytics event tracking system to capture user interactions and visibility into feature usage.',
              ),
              _BulletPoint(
                'Architected the app using Clean Architecture and MobX, making modules independently testable.',
              ),
              _BulletPoint(
                'Built an Appium-based mobile test automation framework in Java for core user flows.',
              ),
              _BulletPoint(
                'Managed production builds, versioning strategy, and release cycles on Google Play Store.',
              ),
            ],
          ),
        ).animate().fadeIn(duration: 800.ms, delay: 200.ms).slideY(begin: 0.1, end: 0),
      ],
    );
  }
}

class _ExperienceTitle extends StatelessWidget {
  final String title;
  final String company;
  final String date;

  const _ExperienceTitle({
    required this.title,
    required this.company,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 500;
        return Flex(
          direction: isMobile ? Axis.vertical : Axis.horizontal,
          crossAxisAlignment: isMobile
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: isMobile ? 20 : 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  company,
                  style: GoogleFonts.outfit(
                    fontSize: isMobile ? 18 : 20,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            if (isMobile) const SizedBox(height: 8),
            Text(
              date,
              style: const TextStyle(
                color: Colors.white54,
                fontWeight: FontWeight.w500,
                fontFamily: 'monospace',
                fontSize: 14,
              ),
            ),
          ],
        );
      },
    );
  }
}

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Selected Works', number: '02.'),
        const SizedBox(height: 40),
        _ProjectCard(
              title: 'AI Performance Intelligence Platform',
              description:
                  'A comprehensive Flutter Performance Analytics SDK and Node.js/PostgreSQL backend. '
                  'Collects real-user metrics including render times, interaction latency, and crash events. '
                  'Integrates Gemini AI to detect bottlenecks automatically. Features secure telemetry ingestion '
                  'and a Web dashboard with JWT-based authentication for real-time visualization.',
              techStack: const [
                'Flutter SDK',
                'Node.js',
                'PostgreSQL',
                'Gemini API',
                'JWT',
              ],
              links: [
                _ProjectLink(
                  icon: Icons.open_in_new_rounded,
                  url: 'https://ai-performance-intelligence-dashboa.vercel.app',
                  tooltip: 'Live Dashboard',
                ),
                _ProjectLink(
                  icon: Icons.code_rounded,
                  url:
                      'https://github.com/favadthottathil/ai-performance-intelligence-dashboard-Flutter-web',
                  tooltip: 'Source Code',
                ),
              ],
            )
            .animate()
            .fadeIn(duration: 800.ms, delay: 200.ms)
            .scale(begin: const Offset(0.95, 0.95), curve: Curves.easeOutCubic),
      ],
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final String title;
  final String description;
  final List<String> techStack;
  final List<_ProjectLink> links;

  const _ProjectCard({
    required this.title,
    required this.description,
    required this.techStack,
    required this.links,
  });

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutQuart,
        transform: Matrix4.identity()..translate(0.0, isHovered ? -10.0 : 0.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: EdgeInsets.all(
                MediaQuery.of(context).size.width > 500 ? 40 : 20,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isHovered
                      ? Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.5)
                      : Colors.white.withValues(alpha: 0.1),
                  width: 1.5,
                ),
                boxShadow: isHovered
                    ? [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.15),
                          blurRadius: 30,
                          spreadRadius: -5,
                        ),
                      ]
                    : [],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                            Icons.folder_open_rounded,
                            color: Theme.of(context).colorScheme.primary,
                            size: 50,
                          )
                          .animate(target: isHovered ? 1 : 0)
                          .scaleXY(end: 1.1)
                          .shake(hz: 4, curve: Curves.easeInOut),
                      Row(
                        children: widget.links.map((link) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child:
                                IconButton(
                                      icon: Icon(link.icon, size: 28),
                                      color: Colors.white.withValues(
                                        alpha: 0.6,
                                      ),
                                      hoverColor: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      tooltip: link.tooltip,
                                      onPressed: () {
                                        if (link.url != '#')
                                          launchUrl(Uri.parse(link.url));
                                      },
                                    )
                                    .animate(target: isHovered ? 1 : 0)
                                    .slideY(
                                      begin: 0.2,
                                      end: 0,
                                      duration: 200.ms,
                                    ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    widget.title,
                    style: GoogleFonts.outfit(
                      fontSize: MediaQuery.of(context).size.width > 500
                          ? 28
                          : 22,
                      fontWeight: FontWeight.bold,
                      color: isHovered
                          ? Theme.of(context).colorScheme.primary
                          : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.description,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: MediaQuery.of(context).size.width > 500
                          ? 17
                          : 15,
                      height: 1.7,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: widget.techStack
                        .map((tech) => _TechChip(label: tech))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProjectLink {
  final IconData icon;
  final String url;
  final String tooltip;
  _ProjectLink({required this.icon, required this.url, required this.tooltip});
}

class _TechChip extends StatelessWidget {
  final String label;
  const _TechChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 14,
          fontFamily: 'monospace',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  final Map<String, List<String>> _skillCategories = const {
    'Languages & Core': ['Dart', 'Node.js', 'PostgreSQL', 'Express'],
    'Mobile & Cross-Platform': ['Flutter', 'Android', 'iOS', 'Web'],
    'Architecture & State': ['Clean Architecture', 'MobX', 'BLoC', 'Provider', 'MVC'],
    'Testing & Automation': ['Appium', 'Flutter Integration Driver', 'Unit & Widget Testing'],
    'Tools & Services': ['Firebase', 'REST API Design', 'Git', 'Google Play Store'],
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Skills & Tech', number: '03.'),
        const SizedBox(height: 40),
        Wrap(
          spacing: 24,
          runSpacing: 24,
          children: _skillCategories.entries.map((entry) {
            return SizedBox(
                  width: MediaQuery.of(context).size.width > 500
                      ? 320
                      : double.infinity,
                  child: _GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.key,
                          style: GoogleFonts.outfit(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ...entry.value.map(
                          (skill) => Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Row(
                              children: [
                                Icon(
                                      Icons.arrow_right_rounded,
                                      size: 24,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    )
                                    .animate(
                                      onPlay: (controller) =>
                                          controller.repeat(reverse: true),
                                    )
                                    .moveX(begin: 0, end: 5, duration: 1000.ms),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    skill,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .animate()
                .fadeIn(duration: 800.ms)
                .scale(begin: const Offset(0.9, 0.9));
          }).toList(),
        ),
      ],
    );
  }
}

class _BulletPoint extends StatelessWidget {
  final String text;
  const _BulletPoint(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.play_arrow_rounded,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.all(
            MediaQuery.of(context).size.width > 500 ? 40 : 24,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
