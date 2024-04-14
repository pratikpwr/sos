import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sos_app/src/core/error/failures.dart';
import 'package:sos_app/src/core/network/api_client.dart';

import '../../../core/preferences/local_preferences.dart';

abstract class SOSRepository {
  Future<Either<Failure, String>> sendSOS({Position? position});

  Future<Either<Failure, List<String>>> uploadMedia();

  Future<Either<Failure, bool>> attachMediaToSOS({
    required String sosId,
    required List<String> ids,
  });
}

class SOSRepositoryImpl implements SOSRepository {
  final ApiClient apiClient;
  final LocalPreferences prefs;

  SOSRepositoryImpl({
    required this.apiClient,
    required this.prefs,
  });

  @override
  Future<Either<Failure, String>> sendSOS({Position? position}) async {
    await Future.delayed(Duration(milliseconds: 300));
    return Right("sosId");
  }

  @override
  Future<Either<Failure, List<String>>> uploadMedia() async {
    await Future.delayed(Duration(milliseconds: 300));
    return Right(["id1", "id3"]);
  }

  @override
  Future<Either<Failure, bool>> attachMediaToSOS({
    required String sosId,
    required List<String> ids,
  }) async {
    await Future.delayed(Duration(milliseconds: 300));
    return Right(true);
  }
}
