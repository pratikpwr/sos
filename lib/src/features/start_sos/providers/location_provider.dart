import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sos_app/src/core/extensions/placemark_extension.dart';

import '../../../core/utils/location_util.dart';

class LocationProvider extends ChangeNotifier {
  final locationUtil = LocationUtilImpl();

  bool isLoading = false;
  bool hasError = false;

  Position? position;
  String address = "";

  Future<void> getLocation() async {
    isLoading = true;
    notifyListeners();
    try {
      final result = await locationUtil.getCurrentLocation();
      result.fold(
        (err) {
          isLoading = false;
          hasError = true;
          notifyListeners();
        },
        (pos) async {
          position = pos;
          List<Placemark> placeMarks = await placemarkFromCoordinates(
            pos.latitude,
            pos.longitude,
          );

          if (placeMarks.isEmpty) {
            address = "Lat : ${pos.latitude}, Long: ${pos.longitude}";
          } else {
            address = placeMarks.first.readableAddress();
          }

          isLoading = false;
          notifyListeners();
        },
      );
    } catch (err) {
      isLoading = false;
      hasError = true;
      notifyListeners();
    }
  }
}
