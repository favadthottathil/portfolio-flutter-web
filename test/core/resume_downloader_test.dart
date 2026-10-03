import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/core/utils/resume_downloader.dart';

void main() {
  group('resume download paths', () {
    test('the bundled resume PDF exists at the asset path', () {
      final file = File(kResumeAssetPath);
      expect(file.existsSync(), isTrue, reason: kResumeAssetPath);
      // Guard against an accidentally committed empty/placeholder file.
      expect(file.lengthSync(), greaterThan(1024));
      expect(String.fromCharCodes(file.readAsBytesSync().take(5)), '%PDF-');
    });

    test(
      'web URL carries the extra assets/ prefix Flutter web serves under',
      () {
        // See CLAUDE.md: Flutter web serves bundled assets one level deeper,
        // so the raw <a href> must not reuse the asset key.
        expect(kResumeWebUrl, 'assets/$kResumeAssetPath');
      },
    );

    test('download file name is a pdf', () {
      expect(kResumeDownloadFileName, endsWith('.pdf'));
    });
  });
}
