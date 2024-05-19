import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../../core/constants/network.dart';
import '../../../core/error/failures.dart';
import '../../../core/network/api_client.dart';
import '../../../core/preferences/local_preferences.dart';
import '../models/sos_details_model.dart';

abstract class SOSDetailsRepository {
  Future<Either<Failure, SosDetailsModel>> sosDetails(int sosId);

  Future<Either<Failure, bool>> markSafe(int sosId);

  Future<Either<Failure, bool>> acceptRequest(int sosId);
}

class SOSDetailsRepositoryImpl implements SOSDetailsRepository {
  final ApiClient apiClient;
  final LocalPreferences prefs;

  SOSDetailsRepositoryImpl({
    required this.apiClient,
    required this.prefs,
  });

  @override
  Future<Either<Failure, SosDetailsModel>> sosDetails(int sosId) async {
    try {
      final result = await apiClient.request(
        HttpMethod.get,
        '$baseUrl/api/sosdetails/$sosId',
      );

      if (result.statusCode != null && result.statusCode! < 250) {
        final details = SosDetailsModel.fromJson(result.data);
        return Right(details);
      } else {
        return const Left(ServerFailure());
      }
    } catch (err) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> markSafe(int sosId) async {
    try {
      final result = await apiClient.request(
        HttpMethod.put,
        '$baseUrl/api/MarkSafeSOS/$sosId',
      );

      if (result.statusCode != null && result.statusCode! < 250) {
        // bool sosActive = result.data["isActive"];
        return Right(result.data["isSafe"]);
      } else {
        return const Left(ServerFailure());
      }
    } catch (err) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> acceptRequest(int sosId) async {
    int userId = 5;

    final data = {
      "userId": userId,
      "sosId": sosId,
    };

    try {
      final result = await apiClient.request(
        HttpMethod.post,
        '$baseUrl/api/SOSResponder',
        body: jsonEncode(data),
      );

      if (result.statusCode != null && result.statusCode! < 250) {
        return Right(result.data["userId"] != null);
      } else {
        return const Left(ServerFailure());
      }
    } catch (err) {
      return const Left(ServerFailure());
    }
  }
}
