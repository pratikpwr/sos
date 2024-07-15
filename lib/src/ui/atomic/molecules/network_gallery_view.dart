import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sos_app/src/core/extensions/context_extension.dart';
import 'package:sos_app/src/core/extensions/string_extension.dart';
import 'package:video_player/video_player.dart';

class NetworkGalleryView extends StatefulWidget {
  final List<String> mediaFiles;

  NetworkGalleryView({required this.mediaFiles});

  @override
  State<NetworkGalleryView> createState() => _NetworkGalleryViewState();
}

class _NetworkGalleryViewState extends State<NetworkGalleryView> {
  bool isPlaying = false;
  late VideoPlayerController videoController;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
      ),
      itemCount: widget.mediaFiles.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            _showMediaDialog(context, widget.mediaFiles[index]);
          },
          child: GridTile(
            child: _buildMediaPreview(widget.mediaFiles[index]),
          ),
        );
      },
    );
  }

  Widget _buildMediaPreview(String media, {bool isPreview = true}) {
    return FutureBuilder<String>(
      future: identifyUrlType(media),
      // This calls the method to identify the media type
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // Once the future is complete, check the media type
          if (snapshot.data == 'video') {
            // If it's a video, initialize and return a video player widget
            videoController = VideoPlayerController.networkUrl(
              Uri.parse(media),
            );
            return FutureBuilder(
              future: videoController.initialize(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return isPreview
                      ? Stack(
                          children: [
                            VideoPlayer(videoController),
                            Positioned.fill(
                              child: InkWell(
                                onTap: () {
                                  _showMediaDialog(context, media);
                                },
                                child: Icon(
                                  Icons.play_arrow_rounded,
                                  size: 52,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        )
                      : AspectRatio(
                          aspectRatio: videoController.value.aspectRatio,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              AspectRatio(
                                aspectRatio: videoController.value.aspectRatio,
                                child: VideoPlayer(videoController),
                              ),
                              Positioned.fill(
                                child: SizedBox(
                                  child: isPlaying
                                      ? InkWell(
                                          onTap: () {
                                            videoController.pause();
                                            setState(() {
                                              isPlaying = false;
                                            });
                                          },
                                          child: Icon(
                                            Icons.pause_rounded,
                                            size: 52,
                                            color: Colors.white,
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () {
                                            videoController.play();
                                            setState(() {
                                              isPlaying = true;
                                            });
                                          },
                                          child: Icon(
                                            Icons.play_arrow_rounded,
                                            size: 52,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              )
                            ],
                          ),
                        );
                } else {
                  return const CupertinoActivityIndicator();
                }
              },
            );
          } else if (snapshot.data == 'image') {
            // Wrap the Image.network widget with InteractiveViewer for zoom capability
            return InteractiveViewer(
              panEnabled: true,
              // Set it to false to prevent panning.
              boundaryMargin: EdgeInsets.all(12),
              minScale: 0.5,
              maxScale: 4,
              child: Image.network(
                media,
              ),
            );
          } else {
            // If the media type is unknown or an error occurred, handle accordingly
            return Center(child: Text('Unable to load media'));
          }
        } else {
          // While waiting for the future to complete, show a loading indicator
          return const CupertinoActivityIndicator();
        }
      },
    );
  }

  void _showMediaDialog(BuildContext context, String media) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 24),
                SizedBox(
                  height: context.screenWidth * 0.9,
                  width: context.screenWidth * 0.9,
                  child: _buildMediaPreview(media, isPreview: false),
                ),
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
                      if (isPlaying) {
                        videoController.pause();
                        setState(() {
                          isPlaying = false;
                        });
                      }
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

  Future<String> identifyUrlType(String url) async {
    if (url.isVideo()) {
      return 'video';
    } else if (url.isPhoto()) {
      return 'image';
    }

    try {
      Dio dio = Dio();

      // Configure Dio to follow redirects
      dio.options.followRedirects = true;
      dio.options.maxRedirects = 5;

      // Use GET request instead of HEAD to handle redirects better
      Response response = await dio.get(
        url,
        options: Options(
          validateStatus: (status) => status! < 500,
          responseType: ResponseType.bytes,
        ),
      );

      if (response.statusCode == 200) {
        String? contentType = response.headers.value('content-type');

        if (contentType != null) {
          if (contentType.startsWith('image/')) {
            return 'image';
          } else if (contentType.startsWith('video/')) {
            return 'video';
          }
        }

        // If content-type is not set, try to determine from the data
        if (response.data is List<int>) {
          List<int> bytes = response.data;
          if (bytes.length > 2) {
            // Check for common image file signatures
            if (bytes[0] == 0xFF && bytes[1] == 0xD8) return 'image'; // JPEG
            if (bytes[0] == 0x89 && bytes[1] == 0x50) return 'image'; // PNG
            if (bytes[0] == 0x47 && bytes[1] == 0x49) return 'image'; // GIF
          }
        }
      }

      return 'unknown (Status: ${response.statusCode})';
    } catch (e) {
      print('Error: $e');

      if (url.isVideo()) {
        return 'video';
      } else if (url.isPhoto()) {
        return 'image';
      }
      return 'error';
    }
  }
}
