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

  Future<Either<Failure, bool>> sendFCMToken({
    required String fcmToken,
  });
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
    await prefs.init();
    await prefs.set(PrefsConst.userId, user.id);
    return await prefs.set(PrefsConst.currentUser, user.toJson());
  }

  @override
  Future<Either<Failure, bool>> signIn({required String phone}) async {
    try {
      final result = await apiClient.request(
        HttpMethod.get,
        '$baseUrl/api/SignIn/$phone',
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
        HttpMethod.get,
        '$baseUrl/api/SignUp/$phone',
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
      final path = isSignIn ? 'SignInVerifyOtp' : 'SignUpVerifyOtp';
      final result = await apiClient.request(
        HttpMethod.post,
        '$baseUrl/api/$path',
        body: {'mobileNo': phone, 'otp': otp},
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

  @override
  Future<Either<Failure, bool>> sendFCMToken({
    required String fcmToken,
  }) async {
    final userId = prefs.get(PrefsConst.userId) ?? 5;
    try {
      final result = await apiClient.request(
        HttpMethod.put,
        '$baseUrl/api/FCMToken/$userId',
        body: {
          'fcmToken': fcmToken,
        },
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
}
