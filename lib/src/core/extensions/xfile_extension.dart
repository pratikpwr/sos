import 'package:image_picker/image_picker.dart';

const _photoExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp', 'heic'];
const _videoExtensions = ['mp4', 'mov', 'avi', 'mkv', 'flv', 'm4v'];

extension XFileExt on XFile {
  bool isPhoto() {
    final String extension = path.split('.').last.toLowerCase();
    return _photoExtensions.contains(extension);
  }

  bool isVideo() {
    final String extension = path.split('.').last.toLowerCase();
    return _videoExtensions.contains(extension);
  }
}
