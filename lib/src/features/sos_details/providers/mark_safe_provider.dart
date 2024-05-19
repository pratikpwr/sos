import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';

import '../repository/sos_details_repository.dart';

class MarkSafeProvider extends ChangeNotifier {
  final SOSDetailsRepository repository;

  MarkSafeProvider(this.repository);

  ActionSliderController? _controller;

  ActionSliderController? get sliderController => _controller;

  setSliderController(ActionSliderController? controller) {
    _controller = controller;
    notifyListeners();
  }

  Future<void> markSafe(int sosId, {required VoidCallback onSafe}) async {
    _controller?.loading();
    notifyListeners();

    final result = await repository.markSafe(sosId);
    result.fold(
      (failure) {
        _resetSliderFailure();
      },
      (isSafe) {
        if (isSafe) {
          _controller?.success();
          onSafe();
        } else {
          _resetSliderFailure();
        }
      },
    );

    notifyListeners();
  }

  _resetSliderFailure() {
    _controller?.failure();
    Future.delayed(
      const Duration(seconds: 1),
      () {
        _controller?.reset();
        notifyListeners();
      },
    );
  }
}
