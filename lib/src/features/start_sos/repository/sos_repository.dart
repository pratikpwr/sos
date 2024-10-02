import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sos_app/src/core/constants/network.dart';
import 'package:sos_app/src/core/error/failures.dart';
import 'package:sos_app/src/core/network/api_client.dart';

import '../../../core/preferences/local_preferences.dart';

abstract class SOSRepository {
  Future<Either<Failure, int>> sendSOS({Position? position});

  Future<Either<Failure, List<int>>> attachMedia(int sosId, List<XFile> files);
}

class SOSRepositoryImpl implements SOSRepository {
  final ApiClient apiClient;
  final LocalPreferences prefs;

  SOSRepositoryImpl({
    required this.apiClient,
    required this.prefs,
  });

  @override
  Future<Either<Failure, int>> sendSOS({Position? position}) async {
    int userId = 5;


    try {
      final result = await apiClient.request(
        HttpMethod.post,
        '$baseUrl/api/SOS',
        body: jsonEncode({
          "lat": position?.latitude,
          "long": position?.longitude,
          "userId": userId,
          "createdOn": DateTime.now().toIso8601String(),
        }),
      );

      if (result.statusCode != null && result.statusCode! < 250) {
        return Right(result.data["sosId"]);
      } else {
        return const Left(ServerFailure());
      }
    } catch (err) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<int>>> attachMedia(
      int sosId, List<XFile> files) async {
    try {
      List<MultipartFile> multiPartFiles = [];

      for (XFile file in files) {
        multiPartFiles.add(
          await MultipartFile.fromFile(
            file.path,
            filename: file.name,
          ),
        );
      }

      FormData formData = FormData.fromMap({
        "SOSId": sosId,
        "Files": multiPartFiles,
      });

      final result = await apiClient.request(
        HttpMethod.post,
        '$baseUrl/api/SOSMediaFiles',
        body: formData,
      );

      if (result.statusCode != null && result.statusCode! < 250) {
        return Right(List<int>.from(result.data["mediaFileIds"].map((x) => x)));
      } else {
        return const Left(ServerFailure());
      }
    } catch (err) {
      return const Left(ServerFailure());
    }
  }
}
