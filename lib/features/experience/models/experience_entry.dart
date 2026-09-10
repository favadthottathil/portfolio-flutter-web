class ExperienceEntry {
  const ExperienceEntry({
    required this.title,
    required this.company,
    required this.date,
    required this.bullets,
    this.location,
  });

  final String title;
  final String company;
  final String date;
  final List<String> bullets;
  final String? location;
}
