import 'dart:async';

import 'package:flutter/material.dart';

import '../models/sos_details_model.dart';
import '../repository/sos_details_repository.dart';

enum SosDetailsStatus {
  initial,
  loading,
  success,
  failed;
}

class SOSDetailsProvider extends ChangeNotifier {
  final SOSDetailsRepository repository;

  SOSDetailsProvider(this.repository);

  SosDetailsStatus sosStatus = SosDetailsStatus.initial;
  SosDetailsModel? sosDetails;

  bool _disposed = false;
  bool _stopSyncing = false;

  int n = 0;

  Future<void> getSOSDetails(int sosId) async {
    // recheck sos details
    Timer.periodic(const Duration(seconds: 30), (timer) {
      if (!_disposed && !_stopSyncing) getSOSDetails(sosId);
    });

    if (sosDetails == null) sosStatus = SosDetailsStatus.loading;
    if (!_disposed) notifyListeners();

    final result = await repository.sosDetails(sosId);
    result.fold(
      (failure) {
        sosStatus = SosDetailsStatus.failed;
      },
      (details) {
        sosStatus = SosDetailsStatus.success;
        sosDetails = details;
      },
    );

    if (!_disposed) notifyListeners();
  }

  void stopSyncing() {
    _stopSyncing = true;
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
