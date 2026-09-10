import 'package:web/web.dart' as web;

import 'resume_downloader.dart';

void downloadResume() {
  final anchor = web.document.createElement('a') as web.HTMLAnchorElement
    ..href = kResumeWebUrl
    ..download = kResumeDownloadFileName
    ..target = '_blank';
  web.document.body?.append(anchor);
  anchor.click();
  anchor.remove();
}
