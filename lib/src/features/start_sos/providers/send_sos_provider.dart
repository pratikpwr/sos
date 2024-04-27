import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sos_app/src/features/start_sos/repository/sos_repository.dart';

enum SosStatus {
  initial,
  loading,
  sent,
  failed;
}

class SendSOSProvider extends ChangeNotifier {
  final SOSRepository _repository;

  SendSOSProvider(this._repository);

  SosStatus sosStatus = SosStatus.initial;
  int? sosId;

  Future<void> sendSOS({
    required Position? position,
    required Function(SosStatus status, int? sosId) onResponse,
  }) async {
    final result = await _repository.sendSOS(position: position);

    result.fold(
      (failure) {
        sosStatus = SosStatus.failed;
        onResponse(sosStatus, null);
      },
      (id) {
        sosStatus = SosStatus.sent;
        sosId = id;

        onResponse(sosStatus, sosId);
      },
    );

    notifyListeners();
  }
}
