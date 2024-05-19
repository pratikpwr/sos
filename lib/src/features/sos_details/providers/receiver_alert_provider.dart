import 'package:flutter/material.dart';
import 'package:sos_app/src/features/sos_details/repository/sos_details_repository.dart';

enum SosAcceptStatus {
  initial,
  loading,
  success,
  failed;
}

class ReceiverAlertProvider extends ChangeNotifier {
  final SOSDetailsRepository repository;

  ReceiverAlertProvider(this.repository);

  SosAcceptStatus acceptStatus = SosAcceptStatus.initial;

  Future<void> acceptSOSRequest(int sosId,
      {required VoidCallback onAccept}) async {
    acceptStatus = SosAcceptStatus.loading;
    notifyListeners();

    final result = await repository.acceptRequest(sosId);
    result.fold(
      (failure) {
        acceptStatus = SosAcceptStatus.failed;
      },
      (_) {
        acceptStatus = SosAcceptStatus.success;
        onAccept();
      },
    );

    notifyListeners();
  }
}
