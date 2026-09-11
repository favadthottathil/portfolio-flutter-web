import 'models/experience_entry.dart';

const List<ExperienceEntry> experienceEntries = [
  ExperienceEntry(
    title: 'Flutter Developer',
    company: '@ Promilo (Sawara Solution Pvt Ltd)',
    date: 'Mar 2024 - Present',
    location: 'Bengaluru, India',
    bullets: [
      'Lead the architecture and development of CollegeLinkr, a B2B EdTech platform, across 8 feature modules built on Clean Architecture and BLoC.',
      'Build and maintain production features for Promilo\'s B2B mobile platform, applying Clean Architecture across 15+ feature modules with MobX.',
      'Designed the networking layer with Dio and Retrofit — a single interceptor injects JWTs and queues concurrent requests behind one refresh call on 401 — to safely handle financial and KYC data.',
      'Hardened the app for KYC/payments: certificate pinning, root & jailbreak detection, FLAG_SECURE screens, masked PII with biometric-gated reveal, and obfuscated release builds.',
      'Set up GitHub Actions pipelines for both apps and own the release process end to end — signed AAB builds, multi-flavor dev/prod entry points, through to Play Store and App Store publishing.',
      'Built an Appium automation suite (Java, TestNG, UiAutomator2) covering 42+ test cases that cut manual regression testing time by 30% per release.',
    ],
  ),
  ExperienceEntry(
    title: 'Trainee Flutter Developer',
    company: '@ Brototype',
    date: 'Nov 2022 - Oct 2023',
    location: 'Calicut, Kerala',
    bullets: [
      'Completed an intensive year-long Flutter & mobile development program — built real Flutter/Dart projects under mentorship, covering widgets, state management, REST API integration, and Android/iOS deployment.',
    ],
  ),
];
