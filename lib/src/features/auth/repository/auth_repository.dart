import 'package:dartz/dartz.dart';
import 'package:sos_app/src/core/constants/prefs_const.dart';
import 'package:sos_app/src/core/error/failures.dart';
import 'package:sos_app/src/features/sos_details/models/user_details_model.dart';

import '../../../core/constants/network.dart';
import '../../../core/network/api_client.dart';
import '../../../core/preferences/local_preferences.dart';

abstract class AuthRepository {
  Future<Either<Failure, bool>> signIn({
    required String phone,
  });

  Future<Either<Failure, bool>> signUp({
    required String phone,
  });

  Future<Either<Failure, UserDetailsModel>> verifyOtp({
    required String phone,
    required String otp,
    required bool isSignIn,
  });

  Future<Either<Failure, UserDetailsModel?>> getCurrentUser();
}

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient apiClient;
  final LocalPreferences prefs;

  AuthRepositoryImpl({
    required this.apiClient,
    required this.prefs,
  });

  @override
  Future<Either<Failure, UserDetailsModel?>> getCurrentUser() async {
    final userJson = await prefs.get(PrefsConst.currentUser);
    if (userJson == null) {
      return const Left(CacheFailure());
    }
    return Right(UserDetailsModel.fromJson(userJson));
  }

  Future<bool> saveUser(UserDetailsModel user) async {
    return await prefs.set(PrefsConst.currentUser, user.toJson());
  }

  @override
  Future<Either<Failure, bool>> signIn({required String phone}) async {
    try {
      final result = await apiClient.request(
        HttpMethod.post,
        '$baseUrl/api/signin',
        body: {'phone': phone},
      );

      if (result.statusCode == 404) {
        return Left(NoDataFailure('User not found'));
      } else if (result.statusCode == 200) {
        return Right(true);
      } else {
        return Left(ServerFailure(result.data['message']));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> signUp({required String phone}) async {
    try {
      final result = await apiClient.request(
        HttpMethod.post,
        '$baseUrl/api/signup',
        body: {'phone': phone},
      );

      if (result.statusCode == 200) {
        return Right(true);
      } else {
        return Left(ServerFailure(result.data['message']));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserDetailsModel>> verifyOtp({
    required String phone,
    required String otp,
    required bool isSignIn,
  }) async {
    try {
      final result = await apiClient.request(
        HttpMethod.post,
        '$baseUrl/api/verifyotp',
        body: {'phone': phone, 'otp': otp},
      );

      if (result.statusCode == 404) {
        return Left(NoDataFailure('User not found'));
      } else if (result.statusCode == 200) {
        final user = UserDetailsModel.fromJson(result.data['data']);
        saveUser(user);
        return Right(user);
      } else {
        return Left(ServerFailure(result.data['message']));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
