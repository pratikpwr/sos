import 'package:image_picker/image_picker.dart';

const kPhotoExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp', 'heic'];
const kVideoExtensions = ['mp4', 'mov', 'avi', 'mkv', 'flv', 'm4v'];

extension XFileExt on XFile {
  bool isPhoto() {
    final String extension = path.split('.').last.toLowerCase();
    return kPhotoExtensions.contains(extension);
  }

  bool isVideo() {
    final String extension = path.split('.').last.toLowerCase();
    return kVideoExtensions.contains(extension);
  }
}
