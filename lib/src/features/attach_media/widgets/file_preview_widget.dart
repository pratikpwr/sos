import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sos_app/src/core/extensions/xfile_extension.dart';
import 'package:video_player/video_player.dart';

class XFilePreviewList extends StatelessWidget {
  final List<XFile> xfiles;

  const XFilePreviewList({Key? key, required this.xfiles}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: xfiles.length,
      itemBuilder: (context, index) {
        final XFile xfile = xfiles[index];

        return Card(
          child: Column(
            children: [
              // Display the thumbnail of the photo or video
              xfile.isVideo()
                  ? VideoPlayerWidget(xfile: xfile)
                  : Image.file(File(xfile.path)),

              // Display the file name
              Text(xfile.name),
            ],
          ),
        );
      },
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final XFile xfile;

  const VideoPlayerWidget({super.key, required this.xfile});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.xfile.path))
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : Container();
  }
}
