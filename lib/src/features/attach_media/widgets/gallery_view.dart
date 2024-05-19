import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sos_app/src/core/extensions/context_extension.dart';
import 'package:sos_app/src/core/extensions/xfile_extension.dart';
import 'package:video_player/video_player.dart';

class GalleryView extends StatelessWidget {
  final List<XFile> mediaFiles;

  GalleryView({required this.mediaFiles});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
      ),
      itemCount: mediaFiles.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            _showMediaDialog(context, mediaFiles[index]);
          },
          child: GridTile(
            child: _buildMediaPreview(mediaFiles[index]),
          ),
        );
      },
    );
  }

  Widget _buildMediaPreview(XFile media, {bool isPreview = true}) {
    final videoController = VideoPlayerController.file(File(media.path));
    // Check if media is image or video and return appropriate preview
    if (media.isVideo()) {
      // For videos, return a video player widget
      return FutureBuilder(
        future: videoController.initialize(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                VideoPlayer(videoController),
                Positioned.fill(
                  child: SizedBox(
                    height: 52,
                    width: 52,
                    child: InkWell(
                      onTap: () {
                        if (isPreview) return;
                        videoController.play();
                      },
                      child: Icon(
                        Icons.play_arrow_rounded,
                        size: 52,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const CupertinoActivityIndicator();
          }
        },
      );
    } else {
      // For images, return an image widget
      return Image.file(File(media.path), fit: BoxFit.cover);
    }
  }

  void _showMediaDialog(BuildContext context, XFile media) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            height: context.screenHeight * 0.7,
            width: context.screenWidth * 0.8,
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 24),
                _buildMediaPreview(media, isPreview: false),
                SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.black38),
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    iconSize: 42,
                    onPressed: () {
                      context.popScreen();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
