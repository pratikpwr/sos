import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sos_app/src/core/utils/utils.dart';
import 'package:sos_app/src/features/sos_details/screen/sos_details.dart';

import '../../../core/extensions/context_extension.dart';
import '../../../core/injector/injection_container.dart';
import '../providers/attach_media_provider.dart';
import '../widgets/file_preview_widget.dart';
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
          title: Text("We have sent Signal!"),
        ),
        body: Consumer<AttachMediaProvider>(
          builder: (context, provider, child) {
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
                        child: XFilePreviewList(xfiles: provider.files),
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
                            context.pushScreen(SOSDetails(sosId: widget.sosId));
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
                            provider.attachMediaToSOS(
                              sosId: widget.sosId,
                              onResponse: (status) {
                                if (status == AttachMediaUploadStatus.success) {
                                  context.pushScreen(
                                      SOSDetails(sosId: widget.sosId));
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
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
