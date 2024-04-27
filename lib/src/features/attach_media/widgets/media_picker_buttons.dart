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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final photo = await _picker.pickImage(
                    source: ImageSource.camera, imageQuality: 50);

                if (photo != null) {
                  widget.onMediaPicked([photo]);
                }
              },
              child: const Text('Take Photo'),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () async {
                final XFile? video = await _picker.pickVideo(
                  source: ImageSource.camera,
                );
                if (video != null) {
                  widget.onMediaPicked([video]);
                }
              },
              child: const Text('Record Video'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final photos = await _picker.pickMultiImage(imageQuality: 50);

                if (photos.isNotEmpty) {
                  widget.onMediaPicked(photos);
                }
              },
              child: const Text('Select Photos'),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () async {
                final videos =
                    await _picker.pickMultipleMedia(imageQuality: 50);
                if (videos.isNotEmpty) {
                  widget.onMediaPicked(videos);
                }
              },
              child: const Text('Select Videos'),
            ),
          ],
        ),
      ],
    );
  }
}
