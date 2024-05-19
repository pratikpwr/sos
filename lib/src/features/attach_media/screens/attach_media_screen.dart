import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/extensions/context_extension.dart';
import '../../../core/injector/injection_container.dart';
import '../../../core/utils/utils.dart';
import '../../sos_details/screen/user_sos_details_screen.dart';
import '../providers/attach_media_provider.dart';
import '../widgets/gallery_view.dart';
import '../widgets/media_picker_buttons.dart';

class AttachMediaScreen extends StatefulWidget {
  const AttachMediaScreen({
    super.key,
    required this.sosId,
  });

  final int sosId;

  @override
  State<AttachMediaScreen> createState() => _AttachMediaScreenState();
}

class _AttachMediaScreenState extends State<AttachMediaScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => AttachMediaProvider(sl()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("We have sent Signal!"),
        ),
        body: Consumer<AttachMediaProvider>(
          builder: (context, provider, child) {
            if (provider.uploadStatus == AttachMediaUploadStatus.uploading) {
              return Center(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CupertinoActivityIndicator(
                    radius: 32,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Uploading...",
                    style: context.textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ));
            }
            return Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Do you want to share Photos or Videos of your Emergency?",
                        style: context.textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      PhotoAndVideoPickerButton(
                        onMediaPicked: (files) {
                          setState(() {
                            provider.files.addAll(files);
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 300,
                        child: GalleryView(mediaFiles: provider.files),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            context.pushScreen(UserSOSDetailsScreen(sosId: widget.sosId));
                          },
                          child: const Text('SKIP'),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (provider.files.isEmpty) {
                              showSnackBar(context, 'Attach Files to Send');
                              return;
                            }
                            provider.attachMediaToSOS(
                              sosId: widget.sosId,
                              onResponse: (status) {
                                if (status == AttachMediaUploadStatus.success) {
                                  context.pushScreen(
                                      UserSOSDetailsScreen(sosId: widget.sosId));
                                } else if (status ==
                                    AttachMediaUploadStatus.failed) {
                                  showSnackBar(
                                      context, "Failed to attach Media");
                                }
                              },
                            );
                          },
                          child: const Text('UPLOAD'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
