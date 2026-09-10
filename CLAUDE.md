# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

A single-page Flutter Web portfolio site for Favad T. It is a Flutter app with the `web` platform as the actual deployment target — other platform folders (`android`, `ios`, `linux`, `macos`, `windows`) are template scaffolding from `flutter create` and are not actively used or maintained.

## Commands

```bash
flutter pub get              # install dependencies
flutter run -d chrome        # run locally in a browser with hot reload
flutter build web            # production build -> build/web
flutter analyze              # static analysis (uses analysis_options.yaml / flutter_lints)
```

There is no `test/` directory and no tests currently in the project.

### Deployment

Deployed on Vercel (see [vercel.json](vercel.json)). The build command is [build.sh](build.sh), which clones the `stable` Flutter SDK into the workspace at build time (Vercel's build image has no Flutter preinstalled) and runs `flutter build web`. Output directory is `build/web`, with a catch-all rewrite to `index.html` for client-side routing.

## Architecture

There is no routing, no state management library, and no backend. The app is a feature-first modular structure under [lib/](lib/):

```
lib/
  main.dart                     # entry point: MaterialApp + theme wiring
  core/
    theme/app_theme.dart        # AppColors (accent/chrome gradients) + ThemeData
    motion/                     # animation + 3D primitives (see below)
    utils/resume_downloader.dart      # conditional-import facade (web vs io)
    utils/resume_downloader_web.dart  # web impl (package:web, <a download>)
    utils/resume_downloader_io.dart   # non-web fallback (url_launcher)
    widgets/                    # shared presentational widgets (GlassCard, SectionHeader, HoverButton, GradientText, TypingText)
  features/
    shell/                      # PortfolioShell: nav bar, scroll orchestration, background layers, footer
    hero/                       # HeroSection + status pill + stat strip
    about/                      # AboutSection (narrative + quick facts)
    experience/                 # ExperienceSection + models/ + widgets/
    projects/                   # ProjectsSection + models/ + widgets/
    skills/                     # SkillsSection + models/
```

Each content feature (`experience`, `projects`, `skills`) follows the same shape: a `models/` folder with a plain immutable data class, a top-level `<feature>_data.dart` file holding a hardcoded `const List<Model>` (this is the only "data source" — there is no backend, so there's deliberately no repository/data-source abstraction layer), a `<feature>_section.dart` public widget that renders the list with staggered entrance animations, and a `widgets/` folder for section-local presentational pieces. Follow this same shape when adding a new section.

Key structural points:

- **`PortfolioShell`** (in [lib/features/shell/portfolio_shell.dart](lib/features/shell/portfolio_shell.dart)) is the composition root for the page: it owns the `ScrollController`, scroll offset and progress state, the `GlobalKey`s used for scroll-to-section navigation, the floating nav bar with its scroll-progress indicator, and the stacked background layers (aurora → neural field → vignette → content → nav). It lays out `HeroSection` → `AboutSection` → `ExperienceSection` → `ProjectsSection` → `SkillsSection` → footer inside one `SingleChildScrollView`. Section headers are numbered `01`–`04` in that order — renumber them if you insert a section.
- **Navigation is scroll-based, not route-based.** The nav bar's `NavBarItem`s call `Scrollable.ensureVisible` on `GlobalKey`s attached to each section widget, rather than navigating to a new screen. The nav is a `Positioned` overlay in the `Stack` (not a `Scaffold.appBar`) so the background layers can render beneath it, and its opacity increases once scrolled past ~12px.
- **Responsive breakpoint is `900px` width in the shell** (`isDesktop = size.width > 900`); individual widgets check their own thresholds (`800` in the hero, `500`–`520` in cards) via `MediaQuery`/`LayoutBuilder` rather than a shared responsive utility. Below the breakpoint the nav collapses to a compact resume button and the neural field halves its node count.
- **Visual style is "glassmorphism over near-black, with one accent."** Theme colors live in `AppColors`/`AppTheme` ([lib/core/theme/app_theme.dart](lib/core/theme/app_theme.dart)): background `0xFF08090B` with a `surfaceLow`/`surface`/`surfaceHigh` ramp, a single amber accent (`primary` `0xFFE8B33C`, plus `primaryBright`/`primaryDeep` for gradient stops), and `steel` `0xFF7C8899` for secondary emphasis.
  - **The palette is deliberately monochrome apart from amber — do not add a second brand hue.** An earlier version cycled four accent colors per card and read as a rainbow; that was removed on purpose. New surfaces should use `AppColors.primary` for the accent and `steel` when something needs to recede.
  - Two gradients, used for different jobs: `accentGradient` is an amber-only metallic sweep (resume CTA, wordmark badge, stat underlines, scroll-progress bar), while `chromeGradient` is a near-white sweep used for long headline text (the hero name, `SectionHeader` titles) so amber stays a signal rather than filling every heading.
  - `GlassCard` renders the frosted surfaces and takes an optional `accent` that tints its stroke and outer glow.
- **The motion layer lives in [lib/core/motion/](lib/core/motion/)** and is what gives the page its "AI era" feel. Four pieces, all driven from `PortfolioShell`:
  - `PointerTracker` — an `InheritedWidget` publishing the cursor position normalized to `-1..1`; background layers read it via `PointerTracker.of(context)` instead of each installing its own `MouseRegion`.
  - `AuroraBackground` — `Ticker`-driven `CustomPaint` of drifting radial-gradient blobs, heavily blurred via `ImageFiltered`, parallaxed by pointer and scroll offset.
  - `NeuralField` — `CustomPaint` constellation of drifting nodes joined by proximity links (the neural-net motif). Node count and link distance are reduced on mobile for performance.
  - `Tilt3D` — perspective transform (`Matrix4..setEntry(3, 2, 0.0012)` plus `rotateX`/`rotateY`) that tilts a card toward the cursor with a cursor-tracking specular sheen. Wraps the experience, project, and skill cards.
  - `ScrollReveal` / `ScrollRevealScope` — sections fade and lift in as they enter the viewport. Note the reveals live *inside* the scroll view, so a `NotificationListener` above them would never see their notifications; instead `PortfolioShell` passes its `ScrollController` down through `ScrollRevealScope` (an `InheritedNotifier`) and each `ScrollReveal` listens to it and measures its own `RenderBox`.
- **Animations otherwise use `flutter_animate`** (the `.animate()...` chained modifiers) for entrance effects and micro-interactions; the hero role line cycles through phrases via `TypingText`. Hover state is tracked manually via `MouseRegion` + local `_hovered` bools in small `StatefulWidget`s (`HoverButton`, `ProjectCard`, `NavBarItem`, `AnimatedResumeButton`).
### Scroll performance — read before touching the scroll path

Scrolling is the thing most likely to regress here, and every rule below exists because breaking it caused visible jank:

- **Never call `setState` on scroll or pointer movement.** `PortfolioShell` publishes scroll state through `ValueNotifier`s (`_scrollOffset`, `_progress`, `_navCondensed`) and `PointerTracker` exposes the cursor as a `ValueListenable<Offset>`. An earlier version called `setState` in the scroll listener, which rebuilt all five sections and every card on every tick. If you need scroll or pointer state somewhere new, listen to the notifier — do not lift it into widget state.
- **The background painters take listenables, not values.** `AuroraBackground` and `NeuralField` pass their `Ticker`/pointer/scroll notifiers into `CustomPainter`'s `repaint:` via `Listenable.merge`, read `.value` inside `paint()`, and return `shouldRepaint => false`. This repaints the canvas without rebuilding a single widget. Both are wrapped in `RepaintBoundary`.
- **`GlassCard` must not use `BackdropFilter`.** There are ~16 cards on the page; each live blur would resample the animated background every frame. It uses a translucent tinted fill that looks equivalent over the dark background and costs nothing. The nav bar is the *only* `BackdropFilter` on the page — it overlays scrolling content, so it earns one.
- **`Tilt3D` drives its transform from an `AnimationController` + `ValueNotifier`,** with the card passed as `AnimatedBuilder`'s `child` so hovering repaints the transform without rebuilding card content.
- **`ScrollReveal` detaches its listener once revealed** (and `didChangeDependencies` early-returns when already revealed), so sections stop measuring `localToGlobal` on every tick after they animate in.
- **Scroll physics are set globally** in `_AppScrollBehavior` ([lib/main.dart](lib/main.dart)): `ClampingScrollPhysics` (iOS-style `BouncingScrollPhysics` feels wrong on desktop web), mouse/trackpad added to `dragDevices`, and the default scrollbar suppressed since the nav draws its own progress bar. Don't set `physics:` on the `SingleChildScrollView` — that would override this.
- **Fonts** come from `google_fonts` (`GoogleFonts.outfit` / `outfitTextTheme`), fetched at runtime rather than bundled.
- **External links** (email, GitHub, project/store links) are opened via `url_launcher`; each `Project`'s `links` list carries a `ProjectLinkType` (`live`, `source`, `dashboard`, `package`) that maps to an icon in [lib/features/projects/models/project.dart](lib/features/projects/models/project.dart).
- **Resume download** ([lib/core/utils/resume_downloader.dart](lib/core/utils/resume_downloader.dart)) uses a conditional-import facade — `resume_downloader_web.dart` (creates and clicks an `<a download>` via `package:web`) is selected when `dart.library.js_interop` is available, otherwise `resume_downloader_io.dart` (falls back to `launchUrl`) is used. This avoids importing `package:web` on non-web builds. The PDF lives at [assets/Favad_Thottathil_Resume.pdf](assets/Favad_Thottathil_Resume.pdf) and is bundled via the whole `assets/` directory in [pubspec.yaml](pubspec.yaml).
  - **Two different path constants, deliberately.** `kResumeAssetPath` is the Flutter asset key (`assets/<file>`); `kResumeWebUrl` is what the browser fetches and carries an extra prefix (`assets/assets/<file>`), because Flutter web serves bundled assets one level deeper. The web downloader builds a raw `<a href>` rather than going through Flutter's asset loader, so it must use `kResumeWebUrl`. If the resume 404s on download, this mismatch is the first thing to check — confirm with `find build/web/assets -iname "*.pdf"` after a build.
- **Content lives in `<feature>_data.dart` files, not in widgets.** Resume/CV changes should land there (`experience_data.dart`, `projects_data.dart`, `skills_data.dart`, and the `_paragraphs`/stat lists in `about_section.dart` and `hero_section.dart`) rather than in the presentational code.
