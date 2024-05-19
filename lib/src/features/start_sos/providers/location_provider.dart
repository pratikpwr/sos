import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sos_app/src/core/extensions/placemark_extension.dart';

import '../../../core/utils/location_util.dart';

class LocationProvider extends ChangeNotifier {
  final LocationUtil locationUtil;

  LocationProvider(this.locationUtil);

  bool isLoading = false;
  bool hasError = false;

  Position? position;
  String address = "";

  Future<void> getLocation({
    bool isCurrent = true,
    double? lat,
    double? long,
  }) async {
    isLoading = true;
    notifyListeners();

    if (!isCurrent) {
      if (lat != null && long != null) {
        address = await _getAddress(lat, long);
      } else {
        address = "Not Available";
      }

      isLoading = false;
      notifyListeners();
      return;
    }

    // else get current location
    try {
      final result = await locationUtil.getCurrentLocation();
      result.fold(
        (err) {
          isLoading = false;
          hasError = true;
        },
        (pos) async {
          position = pos;
          address = await _getAddress(pos.latitude, pos.longitude);
          isLoading = false;
        },
      );
    } catch (err) {
      isLoading = false;
      hasError = true;
    }

    notifyListeners();
  }

  Future<String> _getAddress(
    double lat,
    double long,
  ) async {
    List<Placemark> placeMarks = await placemarkFromCoordinates(lat, long);

    if (placeMarks.isEmpty) {
      return "Lat : ${lat}, Long: ${long}";
    } else {
      return placeMarks.first.readableAddress();
    }
  }
}
