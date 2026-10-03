import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/features/skills/skills_data.dart';

void main() {
  group('skills data', () {
    test('category names are unique', () {
      final names = skillCategories.map((c) => c.name).toList();
      expect(names.toSet().length, names.length);
    });

    test('every category has skills', () {
      for (final category in skillCategories) {
        expect(category.skills, isNotEmpty, reason: category.name);
      }
    });

    test('no skill is listed twice across the page', () {
      final all = [
        for (final c in skillCategories)
          for (final s in c.skills) s.toLowerCase(),
      ];
      final dupes = all.where((s) => all.indexOf(s) != all.lastIndexOf(s));
      expect(dupes.toSet(), isEmpty);
    });
  });
}
