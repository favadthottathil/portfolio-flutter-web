import 'resume_downloader_io.dart'
    if (dart.library.js_interop) 'resume_downloader_web.dart' as impl;

/// Flutter asset key, as declared in pubspec.yaml.
const String kResumeAssetPath = 'assets/Favad_Thottathil_Resume.pdf';

/// URL the browser fetches. Flutter web serves bundled assets under an extra
/// `assets/` prefix, so this is not the same string as [kResumeAssetPath].
const String kResumeWebUrl = 'assets/$kResumeAssetPath';

const String kResumeDownloadFileName = 'Favad_Thottathil_Resume.pdf';

void downloadResume() => impl.downloadResume();
