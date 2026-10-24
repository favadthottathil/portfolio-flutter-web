import 'models/project.dart';

const List<Project> projects = [
  Project(
    title: 'Navarasami Home Services',
    subtitle: 'Two mobile apps · Freelance project · Aug 2026 – Present',
    tag: 'In progress',
    description:
        'A home-services platform delivered as two Flutter apps: a Customer app for booking '
        'services and a Service Adviser app for field staff. Designed for easy maintenance, with '
        'secure sign-in and protected user data.',
    highlights: [
      'Customer app: service booking, quotations, Razorpay payments, complaint tracking, and notifications.',
      'Service Adviser app: attendance check-in, site visits, material requests, and location tracking for field staff.',
      'Clean Architecture and BLoC across both apps.',
      '160+ automated test files and an automatic release process (GitHub Actions, Fastlane) with signed builds and Firebase Crashlytics crash reporting.',
    ],
    techStack: [
      'Flutter',
      'BLoC',
      'Clean Architecture',
      'Razorpay',
      'GitHub Actions',
      'Fastlane',
      'Crashlytics',
    ],
  ),
  Project(
    title: 'CollegeLinkr',
    subtitle: 'Agent app · Technical lead · iOS & Android · Jun – Aug 2026',
    tag: 'Live on Play Store · 50+ downloads',
    description:
        'An app for education consultants to find, manage and track college-admission leads from '
        'start to finish — browse the college directory, pick leads from a marketplace, submit and '
        'track applications, handle commissions, manage a wallet, and complete KYC. I led the '
        'technical planning from the ground up: ~55,000 lines of hand-written Dart across 8 feature '
        'modules, backed by 34 automated test files and live crash monitoring.',
    highlights: [
      'Lead Marketplace with an in-app wallet, Razorpay online payments, and tiered bonus offers on recharges.',
      'College directory and application tracking with commission and refund countdowns, so consultants always know where each case stands.',
      'Session security: one Dio interceptor injects JWTs and queues concurrent requests behind a single refresh call on 401, plus automatic logout after 15 minutes of inactivity.',
      'KYC and payment hardening — certificate pinning, screenshot blocking (FLAG_SECURE) on payment and KYC screens, and obfuscated release builds.',
      'FCM push notifications with deep links that open the right screen when tapped, plus in-app banners for important announcements.',
    ],
    techStack: [
      'Flutter',
      'BLoC',
      'Clean Architecture',
      'Dio + Retrofit',
      'get_it / injectable',
      'freezed',
      'go_router',
      'Razorpay',
      'FCM',
    ],
    links: [
      ProjectLink(
        type: ProjectLinkType.live,
        url:
            'https://play.google.com/store/apps/details?id=com.member.collegelinkr.app',
        tooltip: 'Live on Play Store',
      ),
    ],
  ),
  Project(
    title: 'CollegeLinkr Student',
    subtitle: 'Admission app · Solo developer · iOS & Android · Jun – Aug 2026',
    description:
        'Built entirely on my own: an app for students to discover colleges, apply for admission, '
        'pay fees, and track their application status end to end. Feature-first BLoC architecture '
        'across 6 modules.',
    highlights: [
      'Server-driven 6-step application form rendered from a backend JSON schema, so changes go live without an app update.',
      'OTP login with JWT sessions and silent token refresh, keeping users signed in safely.',
      'Razorpay fee payments confirmed by the server before an application is marked as paid.',
      'Document upload, in-app PDF preview, and deep links that open the right screen after login via auth-gated go_router routing.',
    ],
    techStack: [
      'Flutter',
      'BLoC',
      'Clean Architecture',
      'go_router',
      'Razorpay',
    ],
  ),
  Project(
    title: 'Promilo Mobile Application',
    subtitle: 'B2B platform · Company project · Mar 2024 – Aug 2026',
    tag: 'Live on Play Store · 100K+ downloads · 4.7 rating',
    description:
        'Promilo\'s busy B2B mobile app, with 100K+ downloads and a 4.7-star rating on the Play Store. '
        'I maintained and improved it, owning multiple features end to end.',
    highlights: [
      'Flexible form system driven by server-side schemas, plus in-app video calling (VideoSDK) so users can meet and share details inside the app.',
      'Made the app 33% smaller (45 MB → 30 MB) through app size optimization, including R8/ProGuard shrinking.',
      'Automated testing suite (42+ test cases) that cut manual testing effort by 30%.',
      'Push notifications and crash reporting, polished screens from design mockups, and releases to the Play Store and App Store.',
    ],
    techStack: [
      'Flutter',
      'MobX',
      'Clean Architecture',
      'VideoSDK',
      'Firebase',
      'Razorpay',
    ],
    links: [
      ProjectLink(
        type: ProjectLinkType.live,
        url: 'https://play.google.com/store/apps/details?id=com.promilo.app',
        tooltip: 'Live on Play Store',
      ),
    ],
  ),
  Project(
    title: 'Flutter Metrics SDK & AI Performance Dashboard',
    subtitle: 'Open-source package · Full-stack side project',
    tag: 'Published on pub.dev',
    description:
        'A published Flutter performance-monitoring SDK with a companion web dashboard and backend. '
        'The SDK captures render-time, frame-drop, API-latency, and crash events with auto-flush on '
        'lifecycle changes, backed by 16 unit tests.',
    highlights: [
      'Built the whole system end to end — from in-app data collection to the final dashboard.',
      'Flutter Web dashboard (fl_chart, go_router) showing real-time metrics with AI-generated, severity-scored insights.',
      'Node.js/Express + PostgreSQL backend with a JWT-authenticated ingestion API, per-key rate limiting, and SSE streaming.',
      'Gemini integration generating issue and recommendation reports automatically; Razorpay for subscription billing.',
      'Server and database packaged with Docker so the whole system starts with one command; automated builds publish the image and it runs live on Render.',
    ],
    techStack: [
      'Flutter',
      'Dart',
      'Node.js',
      'PostgreSQL',
      'Gemini API',
      'fl_chart',
      'Docker',
    ],
    links: [
      ProjectLink(
        type: ProjectLinkType.package,
        url: 'https://pub.dev/packages/flutter_metrics_sdk',
        tooltip: 'pub.dev package',
      ),
      ProjectLink(
        type: ProjectLinkType.dashboard,
        url: 'https://ai-performance-intelligence-dashboa.vercel.app',
        tooltip: 'Live dashboard',
      ),
      ProjectLink(
        type: ProjectLinkType.source,
        url: 'https://github.com/favadthottathil/flutter_metrics_sdk',
        tooltip: 'SDK source',
      ),
      ProjectLink(
        type: ProjectLinkType.source,
        url:
            'https://github.com/favadthottathil/ai-performance-intelligence-dashboard-Flutter-web',
        tooltip: 'Dashboard source',
      ),
      ProjectLink(
        type: ProjectLinkType.source,
        url:
            'https://github.com/favadthottathil/ai-performance-intelligence-backend',
        tooltip: 'Backend source',
      ),
    ],
  ),
  Project(
    title: 'Zenith AI',
    subtitle: 'Cross-platform AI app · Personal project',
    description:
        'An AI-powered mobile app that streams instant, live answers from Google Gemini. I built '
        'both the Flutter app and its FastAPI server.',
    highlights: [
      'Live, streamed AI responses over WebSocket, powered by the Google Gemini API.',
      'Full-stack ownership — Flutter frontend plus a Python (FastAPI) server, both built and deployed solo.',
      'Server packaged with Docker so it runs the same everywhere, with secrets kept out of the code; automated builds publish the image to GitHub Container Registry.',
    ],
    techStack: [
      'Flutter',
      'Dart',
      'FastAPI',
      'WebSocket',
      'Gemini API',
      'Docker',
    ],
    links: [
      ProjectLink(
        type: ProjectLinkType.live,
        url:
            'https://drive.google.com/file/d/1UoRn2k7PXIjdUzWEVpdQZbUjQZpA6Hz4/view?usp=sharing',
        tooltip: 'Download Android APK',
      ),
      ProjectLink(
        type: ProjectLinkType.source,
        url: 'https://github.com/favadthottathil/ZenithAI-FrontEnd',
        tooltip: 'Frontend source',
      ),
      ProjectLink(
        type: ProjectLinkType.source,
        url: 'https://github.com/favadthottathil/ZenithAI-Backend-python',
        tooltip: 'Backend source',
      ),
    ],
  ),
  Project(
    title: 'Flutter Gemini Chat',
    subtitle: 'AI chat app · Personal project',
    description:
        'An AI chat app with LLM integration that streams Google Gemini replies live as they are '
        'written, backed by 98 automated tests.',
    highlights: [
      'Gemini replies stream into the chat live as they are written.',
      'Backed by 98 automated tests.',
    ],
    techStack: ['Flutter', 'Dart', 'Gemini API'],
    links: [
      ProjectLink(
        type: ProjectLinkType.source,
        url: 'https://github.com/favadthottathil/flutter-gemini-chat',
        tooltip: 'View on GitHub',
      ),
    ],
  ),
  Project(
    title: 'flutter_device_insights',
    subtitle: 'Open-source Flutter plugin · Android & iOS',
    description:
        'A free, open-source Flutter plugin that lets apps read device details such as battery '
        'level and phone model on Android and iOS, using native code through Platform Channels.',
    highlights: [
      'Native integration in Kotlin (Android) and Swift (iOS).',
      'Native code reaches Dart through Platform Channels.',
    ],
    techStack: ['Flutter', 'Dart', 'Kotlin', 'Swift', 'Platform Channels'],
    links: [
      ProjectLink(
        type: ProjectLinkType.source,
        url: 'https://github.com/favadthottathil/flutter_device_insights',
        tooltip: 'View on GitHub',
      ),
    ],
  ),
  Project(
    title: 'Appium Automation Suite',
    subtitle: 'Mobile test automation · Promilo',
    description:
        'A mobile test-automation framework covering the core regression flows of the Promilo app, '
        'built to replace repetitive manual QA before each release.',
    highlights: [
      '42+ automated test cases across key user journeys.',
      'Cut manual regression testing time by 30% per release.',
    ],
    techStack: ['Appium', 'Java', 'TestNG', 'UiAutomator2'],
  ),
];
