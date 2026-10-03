import 'models/experience_entry.dart';

const List<ExperienceEntry> experienceEntries = [
  ExperienceEntry(
    title: 'Flutter Developer',
    company: '@ Promilo (Sawara Solution Pvt Ltd)',
    date: 'Mar 2024 - Aug 2026',
    location: 'Bengaluru, India',
    bullets: [
      'Built and maintained multiple features of Promilo, a B2B mobile app with 100K+ downloads and a 4.7-star rating on the Play Store, using Clean Architecture and MobX.',
      'Cut the app\'s size by 33% (45 MB → 30 MB) through app size optimization, so it downloads faster and uses less storage.',
      'Led the technical planning of CollegeLinkr and built its companion Student app solo — launching two apps on Android and iOS in 3 months (Jun–Aug 2026) with Clean Architecture and BLoC.',
      'Built a secure auth and data layer for CollegeLinkr\'s financial and KYC data: a Dio/Retrofit interceptor that injects JWTs and queues concurrent requests behind one refresh call on 401, certificate pinning, and screenshot blocking on sensitive screens.',
      'Set up GitHub Actions CI that runs quality checks on every change, and owned releases end to end — signed builds through Play Store and App Store publishing.',
      'Added FCM push notifications and Crashlytics crash monitoring, and turned Figma designs into responsive screens that work across phone sizes.',
      'Built an automated testing suite (42+ test cases) that reduced manual regression testing effort by 30%; worked in Agile/Scrum sprints and took part in code reviews.',
    ],
  ),
  ExperienceEntry(
    title: 'Trainee Flutter Developer',
    company: '@ Brototype',
    date: 'Nov 2022 - Oct 2023',
    location: 'Calicut, Kerala',
    bullets: [
      'Completed a one-year Flutter training and internship program — built Android and iOS apps in Flutter/Dart under mentorship, covering widgets, state management, REST API integration, and deployment.',
    ],
  ),
];
