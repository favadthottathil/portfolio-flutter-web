import 'package:url_launcher/url_launcher.dart';

import 'resume_downloader.dart';

void downloadResume() {
  launchUrl(Uri.parse(kResumeAssetPath));
}
