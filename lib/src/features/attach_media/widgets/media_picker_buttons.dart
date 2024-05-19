import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoAndVideoPickerButton extends StatefulWidget {
  const PhotoAndVideoPickerButton({
    super.key,
    required this.onMediaPicked,
  });

  final Function(List<XFile>) onMediaPicked;

  @override
  State<PhotoAndVideoPickerButton> createState() =>
      _PhotoAndVideoPickerButtonState();
}

class _PhotoAndVideoPickerButtonState extends State<PhotoAndVideoPickerButton> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          icon: const Icon(
            Icons.camera_alt_rounded,
            size: 28,
          ),
          onPressed: () async {
            final photo = await _picker.pickImage(
                source: ImageSource.camera, imageQuality: 50);

            if (photo != null) {
              widget.onMediaPicked([photo]);
            }
          },
          label: const Text('Take Photo'),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          icon: const Icon(
            Icons.videocam_rounded,
            size: 28,
          ),
          onPressed: () async {
            final XFile? video = await _picker.pickVideo(
              source: ImageSource.camera,
            );
            if (video != null) {
              widget.onMediaPicked([video]);
            }
          },
          label: const Text('Record Video'),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          icon: const Icon(
            Icons.perm_media_rounded,
            size: 28,
          ),
          onPressed: () async {
            final videos = await _picker.pickMultipleMedia(imageQuality: 50);
            if (videos.isNotEmpty) {
              widget.onMediaPicked(videos);
            }
          },
          label: const Text('Select From Gallery'),
        ),
      ],
    );
  }
}
