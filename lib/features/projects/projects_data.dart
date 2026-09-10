import 'models/project.dart';

const List<Project> projects = [
  Project(
    title: 'CollegeLinkr',
    subtitle: 'B2B EdTech agent app · Architecture lead · iOS & Android',
    tag: 'Live on Play Store',
    description:
        'A B2B EdTech platform used by education consultants to manage the full college-admission '
        'lead lifecycle — browse colleges and courses, pick and track leads, submit applications, '
        'handle commission payouts, manage a wallet, and complete KYC. I led the architecture from '
        'the ground up: ~55,000 lines of hand-written Dart across 8 feature modules, backed by 34 '
        'widget and BLoC test files.',
    highlights: [
      'Session infrastructure: one Dio interceptor injects JWTs and queues concurrent requests behind a single refresh call on 401, plus a 15-minute inactivity timer that force-logs-out through an app-wide AuthBloc.',
      'Security hardening for KYC and financial data — certificate pinning, root/jailbreak detection, FLAG_SECURE screens, masked Aadhaar/PAN with biometric-gated reveal, and obfuscated release builds.',
      'Multi-flavor builds with separate dev/prod entry points selecting env config via --dart-define over one shared bootstrap.',
      'Commission-revert settlement flow and a Lead Marketplace with wallet or Razorpay payment and tiered recharge bonuses.',
      'Push-to-deep-link pipeline resolving FCM payloads and universal links through one shared handler.',
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
    subtitle: 'Student companion app · Solo developer · iOS & Android',
    description:
        'Companion app for prospective students to discover college programs, complete multi-step '
        'admission applications, pay fees, and track application status end to end. Built solo with '
        'a feature-first BLoC architecture across 6 modules.',
    highlights: [
      'JWT/OTP authentication with silent token refresh through a dedicated interceptor.',
      'Server-driven 6-step dynamic application form engine rendered from a backend JSON schema, so new fields ship without an app update.',
      'Razorpay fee payments with backend-verified status, in-app document upload and PDF previews.',
      'Deep linking with auth-gated go_router routing.',
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
    title: 'Flutter Metrics SDK & AI Performance Dashboard',
    subtitle: 'Open-source package · Full-stack side project',
    tag: 'Published on pub.dev',
    description:
        'A published Flutter performance-monitoring SDK with a companion web dashboard and backend. '
        'The SDK captures render-time, frame-drop, API-latency, and crash events with auto-flush on '
        'lifecycle changes, backed by 16 unit tests.',
    highlights: [
      'Flutter Web dashboard (fl_chart, go_router) showing real-time metrics with AI-generated, severity-scored insights.',
      'Node.js/Express + PostgreSQL backend with a JWT-authenticated ingestion API, per-key rate limiting, and SSE streaming.',
      'Gemini integration generating issue and recommendation reports automatically; Razorpay for subscription billing.',
    ],
    techStack: [
      'Flutter',
      'Dart',
      'Node.js',
      'PostgreSQL',
      'Gemini API',
      'fl_chart',
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
        url:
            'https://github.com/favadthottathil/ai-performance-intelligence-dashboard-Flutter-web',
        tooltip: 'Source code',
      ),
    ],
  ),
  Project(
    title: 'Promilo Mobile Application',
    subtitle: 'Core B2B platform · Company project',
    tag: 'Live on Play Store',
    description:
        'Promilo\'s core B2B mobile app, used by students and job seekers across India to explore '
        'opportunities and connect with companies.',
    highlights: [
      'Dynamic form engine driven by server-side schemas, so new fields ship without an app update.',
      'Clean Architecture applied across 15+ feature modules with MobX for state management.',
      'Razorpay in-app payments; app size reduced via R8/ProGuard shrinking.',
    ],
    techStack: ['Flutter', 'MobX', 'Clean Architecture', 'Razorpay'],
    links: [
      ProjectLink(
        type: ProjectLinkType.live,
        url: 'https://play.google.com/store/apps/details?id=com.promilo.app',
        tooltip: 'Live on Play Store',
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
