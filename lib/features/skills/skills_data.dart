import 'models/skill_category.dart';

const List<SkillCategory> skillCategories = [
  SkillCategory(
    name: 'Flutter & Mobile',
    skills: [
      'Flutter',
      'Dart',
      'Android',
      'iOS',
      'Material Design',
      'Cupertino',
      'go_router (deep linking)',
    ],
  ),
  SkillCategory(
    name: 'Architecture',
    skills: [
      'Clean Architecture',
      'MVVM',
      'SOLID',
      'OOP',
      'get_it / injectable',
      'freezed',
    ],
  ),
  SkillCategory(
    name: 'State Management',
    skills: ['BLoC / flutter_bloc', 'MobX', 'Provider', 'GetX', 'Riverpod'],
  ),
  SkillCategory(
    name: 'Networking & Backend',
    skills: [
      'REST APIs',
      'Dio / Retrofit',
      'Firebase (Auth, Firestore, FCM, Crashlytics)',
      'Push Notifications',
      'Node.js',
    ],
  ),
  SkillCategory(
    name: 'Local Storage & Security',
    skills: [
      'Hive',
      'Drift',
      'SQLite',
      'SharedPreferences',
      'flutter_secure_storage',
      'JWT Auth',
      'Certificate Pinning',
    ],
  ),
  SkillCategory(
    name: 'Testing & Quality',
    skills: [
      'Unit / Widget / Integration Tests',
      'mocktail',
      'mockito',
      'Appium',
      'Code Reviews',
      'Performance & App Size Optimization',
    ],
  ),
  SkillCategory(
    name: 'Release & DevOps',
    skills: [
      'Google Play Console',
      'App Store Connect',
      'TestFlight',
      'CI/CD',
      'GitHub Actions',
      'Azure DevOps',
      'Git',
    ],
  ),
  SkillCategory(
    name: 'Tools & Integrations',
    skills: [
      'Razorpay',
      'Google Maps',
      'VideoSDK',
      'Gemini API',
      'Postman',
      'Figma',
      'Claude Code',
      'OpenAI Codex',
      'Agile / Scrum',
    ],
  ),
];
