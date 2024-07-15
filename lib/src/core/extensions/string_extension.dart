import 'package:sos_app/src/core/extensions/xfile_extension.dart';

extension StringExtension on String {
  bool isPhoto() {
    final String extension = split('.').last.toLowerCase();
    return kPhotoExtensions.contains(extension);
  }

  bool isVideo() {
    final String extension = split('.').last.toLowerCase();
    return kVideoExtensions.contains(extension);
  }
}
