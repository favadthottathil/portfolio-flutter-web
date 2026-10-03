import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/features/experience/experience_data.dart';

/// `Mon YYYY - Mon YYYY` or `Mon YYYY - Present`.
final _dateRange = RegExp(
  r'^(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) \d{4} - '
  r'((Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) \d{4}|Present)$',
);

void main() {
  group('experience data', () {
    test('is not empty', () {
      expect(experienceEntries, isNotEmpty);
    });

    for (final entry in experienceEntries) {
      group('${entry.title} ${entry.company}', () {
        test('has a well-formed date range', () {
          expect(entry.date, matches(_dateRange));
        });

        test('has at least one non-empty bullet', () {
          expect(entry.bullets, isNotEmpty);
          expect(entry.bullets.every((b) => b.trim().isNotEmpty), isTrue);
        });

        test('company uses the "@ Company" display convention', () {
          expect(entry.company, startsWith('@ '));
        });
      });
    }

    test('at most one role is marked Present', () {
      final current = experienceEntries.where(
        (e) => e.date.endsWith('Present'),
      );
      expect(current.length, lessThanOrEqualTo(1));
    });
  });
}
