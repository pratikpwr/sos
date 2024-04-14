import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

const int kMaxSeconds = 2;

class SOSButtonProvider extends ChangeNotifier {
  bool isPressed = false;
  int countDownSeconds = kMaxSeconds;
  String buttonText = "SOS";

  Timer? _timer;
  bool? hasVibration;

  Future<void> startSOS({
    required AnimationController animationController,
    required VoidCallback onSend,
  }) async {
    isPressed = true;
    notifyListeners();

    hasVibration ??= await Vibration.hasVibrator();

    buttonText = "${countDownSeconds + 1}";
    notifyListeners();

    if (hasVibration ?? false) {
      Vibration.vibrate(
        duration: 1000,
        amplitude: 255 ~/ countDownSeconds,
      );
    }

    animationController.forward();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countDownSeconds > 0) {
        animationController.reset();
        animationController.forward();

        if (hasVibration ?? false) {
          Vibration.vibrate(
            duration: 1000,
            amplitude: 255 ~/ countDownSeconds,
          );
        }
        final newValue = countDownSeconds - 1;

        countDownSeconds = newValue;
        buttonText = "${newValue + 1}";
        notifyListeners();
      } else {
        timer.cancel();
        if (isPressed) {
          onSend();
          buttonText = "SENT";
          notifyListeners();
        }
      }
    });
  }

  void stopSOS(AnimationController controller) {
    isPressed = true;

    if (hasVibration ?? false) Vibration.cancel();
    _timer?.cancel();

    countDownSeconds = kMaxSeconds;
    buttonText = "SOS";
    controller.reset();

    notifyListeners();
  }
}
