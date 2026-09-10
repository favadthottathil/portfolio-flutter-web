import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/motion/aurora_background.dart';
import '../../core/motion/neural_field.dart';
import '../../core/motion/pointer_tracker.dart';
import '../../core/motion/scroll_reveal.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/gradient_text.dart';
import '../about/about_section.dart';
import '../experience/experience_section.dart';
import '../hero/hero_section.dart';
import '../projects/projects_section.dart';
import '../skills/skills_section.dart';
import 'widgets/animated_resume_button.dart';
import 'widgets/nav_bar_item.dart';

const double _desktopBreakpoint = 900;

class PortfolioShell extends StatefulWidget {
  const PortfolioShell({super.key});

  @override
  State<PortfolioShell> createState() => _PortfolioShellState();
}

class _PortfolioShellState extends State<PortfolioShell> {
  final ScrollController _scrollController = ScrollController();

  /// Scroll state is published through notifiers rather than setState: only the
  /// background layers and the progress bar rebuild on scroll, instead of the
  /// whole page tree on every tick.
  final ValueNotifier<double> _scrollOffset = ValueNotifier(0);
  final ValueNotifier<double> _progress = ValueNotifier(0);
  final ValueNotifier<bool> _navCondensed = ValueNotifier(false);

  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    _scrollOffset.dispose();
    _progress.dispose();
    _navCondensed.dispose();
    super.dispose();
  }

  void _handleScroll() {
    final position = _scrollController.position;
    final pixels = position.pixels;

    _scrollOffset.value = pixels;
    _progress.value = position.maxScrollExtent <= 0
        ? 0
        : (pixels / position.maxScrollExtent).clamp(0.0, 1.0);
    _navCondensed.value = pixels > 12;
  }

  void _scrollToSection(GlobalKey key) {
    final sectionContext = key.currentContext;
    if (sectionContext == null) return;
    Scrollable.ensureVisible(
      sectionContext,
      duration: const Duration(milliseconds: 850),
      curve: Curves.easeInOutCubic,
      alignment: 0.06,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > _desktopBreakpoint;
    final horizontalPadding = isDesktop
        ? (size.width * 0.13).clamp(60.0, 220.0)
        : 20.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: PointerTracker(
        child: Builder(
          builder: (context) {
            final pointer = PointerTracker.of(context);

            return Stack(
              children: [
                Positioned.fill(
                  child: AuroraBackground(
                    pointer: pointer,
                    scrollOffset: _scrollOffset,
                  ),
                ),
                Positioned.fill(
                  child: NeuralField(
                    pointer: pointer,
                    nodeCount: isDesktop ? 62 : 28,
                    linkDistance: isDesktop ? 155 : 110,
                  ),
                ),
                Positioned.fill(child: IgnorePointer(child: _buildVignette())),

                ScrollRevealScope(
                  controller: _scrollController,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding.toDouble(),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: isDesktop ? 170 : 120),
                          const HeroSection(),
                          SizedBox(height: isDesktop ? 160 : 90),
                          AboutSection(key: _aboutKey),
                          SizedBox(height: isDesktop ? 160 : 90),
                          ExperienceSection(key: _experienceKey),
                          SizedBox(height: isDesktop ? 160 : 90),
                          ProjectsSection(key: _projectsKey),
                          SizedBox(height: isDesktop ? 160 : 90),
                          SkillsSection(key: _skillsKey),
                          SizedBox(height: isDesktop ? 140 : 80),
                          const _Footer(),
                          SizedBox(height: isDesktop ? 70 : 48),
                        ],
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: _buildNavBar(context, isDesktop),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Darkens the edges so the animated background never competes with text.
  Widget _buildVignette() {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          radius: 1.1,
          colors: [
            Colors.transparent,
            AppColors.background.withValues(alpha: 0.55),
          ],
          stops: const [0.55, 1.0],
        ),
      ),
    );
  }

  Widget _buildNavBar(BuildContext context, bool isDesktop) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: ValueListenableBuilder<bool>(
          valueListenable: _navCondensed,
          builder: (context, condensed, child) => AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              color: AppColors.background.withValues(
                alpha: condensed ? 0.72 : 0.35,
              ),
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withValues(
                    alpha: condensed ? 0.07 : 0.02,
                  ),
                ),
              ),
            ),
            child: child,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 32 : 18,
                    vertical: 14,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildWordmark(),
                      if (isDesktop)
                        Row(
                          children: [
                            NavBarItem(
                              title: 'About',
                              onPressed: () => _scrollToSection(_aboutKey),
                            ),
                            NavBarItem(
                              title: 'Experience',
                              onPressed: () => _scrollToSection(_experienceKey),
                            ),
                            NavBarItem(
                              title: 'Projects',
                              onPressed: () => _scrollToSection(_projectsKey),
                            ),
                            NavBarItem(
                              title: 'Skills',
                              onPressed: () => _scrollToSection(_skillsKey),
                            ),
                            const SizedBox(width: 14),
                            const AnimatedResumeButton(),
                          ],
                        )
                      else
                        const AnimatedResumeButton(compact: true),
                    ],
                  ),
                ),
              ),
              _buildProgressBar(),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildWordmark() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            gradient: AppColors.accentGradient,
            borderRadius: BorderRadius.circular(9),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.35),
                blurRadius: 16,
                spreadRadius: -3,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            'F',
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w900,
              fontSize: 17,
              color: AppColors.background,
            ),
          ),
        ),
        const SizedBox(width: 11),
        GradientText(
          'Favad T',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w800,
            fontSize: 19,
            letterSpacing: -0.6,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    return SizedBox(
      height: 2,
      child: Align(
        alignment: Alignment.centerLeft,
        child: RepaintBoundary(
          child: ValueListenableBuilder<double>(
            valueListenable: _progress,
            builder: (context, progress, child) => FractionallySizedBox(
              widthFactor: progress <= 0 ? 0.0001 : progress,
              child: child,
            ),
            child: const DecoratedBox(
              decoration: BoxDecoration(gradient: AppColors.accentGradient),
            ),
          ),
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 60,
            height: 2,
            decoration: BoxDecoration(
              gradient: AppColors.accentGradient,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 26),
          Text(
            'Designed & built with Flutter Web',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.45),
              fontSize: 14,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '© ${DateTime.now().year} Favad Thottathil',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.28),
              fontSize: 13,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}
