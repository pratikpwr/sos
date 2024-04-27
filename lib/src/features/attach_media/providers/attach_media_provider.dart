import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../start_sos/repository/sos_repository.dart';

enum AttachMediaUploadStatus {
  initial,
  uploading,
  success,
  failed;
}

class AttachMediaProvider extends ChangeNotifier {
  final SOSRepository _repository;

  AttachMediaProvider(this._repository);

  AttachMediaUploadStatus uploadStatus = AttachMediaUploadStatus.initial;

  List<XFile> files = [];

  Future<void> attachMediaToSOS({
    required int sosId,
    required Function(AttachMediaUploadStatus status) onResponse,
  }) async {
    uploadStatus = AttachMediaUploadStatus.uploading;
    notifyListeners();

    final result = await _repository.attachMedia(sosId, files);

    result.fold(
      (failure) {
        uploadStatus = AttachMediaUploadStatus.failed;
        onResponse(uploadStatus);
      },
      (id) {
        uploadStatus = AttachMediaUploadStatus.success;
        onResponse(uploadStatus);
      },
    );

    notifyListeners();
  }
}
