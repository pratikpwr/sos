import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';

import '../error/failures.dart';

abstract class LocationUtil {
  Future<Either<Failure, Position>> getCurrentLocation();

  Stream<Position> getLocationStream();
}

class LocationUtilImpl implements LocationUtil {
  Future<(bool, String?)> checkPermissions() async {
    // Test if location services are enabled.
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return (false, 'Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return (false, 'Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return (
        false,
        'Location permissions are permanently denied, we cannot request permissions.'
      );
    }
    return (true, null);
  }

  @override
  Future<Either<Failure, Position>> getCurrentLocation() async {
    var (result, error) = await checkPermissions();
    if (!result && error != null) {
      return Left(LocationFailure(error));
    }

    final pos = await Geolocator.getCurrentPosition();
    return Right(pos);
  }

  @override
  Stream<Position> getLocationStream() {
    return Geolocator.getPositionStream();
  }
}
