import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/features/projects/models/project.dart';
import 'package:portfolio/features/projects/projects_data.dart';

void main() {
  group('projects data', () {
    test('is not empty', () {
      expect(projects, isNotEmpty);
    });

    test('has unique titles', () {
      final titles = projects.map((p) => p.title).toList();
      expect(titles.toSet().length, titles.length);
    });

    for (final project in projects) {
      group(project.title, () {
        test('has the required copy filled in', () {
          expect(project.title.trim(), isNotEmpty);
          expect(project.subtitle.trim(), isNotEmpty);
          expect(project.description.trim(), isNotEmpty);
          expect(project.techStack, isNotEmpty);
          expect(project.highlights.every((h) => h.trim().isNotEmpty), isTrue);
        });

        test('has no duplicate tech stack entries', () {
          expect(project.techStack.toSet().length, project.techStack.length);
        });

        test('links are absolute https URLs', () {
          for (final ProjectLink link in project.links) {
            final uri = Uri.tryParse(link.url);
            expect(uri, isNotNull, reason: link.url);
            expect(uri!.scheme, 'https', reason: link.url);
            expect(uri.host, isNotEmpty, reason: link.url);
            expect(link.tooltip.trim(), isNotEmpty, reason: link.url);
          }
        });

        test('links are not repeated', () {
          final urls = project.links.map((l) => l.url).toList();
          expect(urls.toSet().length, urls.length);
        });
      });
    }
  });
}
