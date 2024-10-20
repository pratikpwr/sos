import 'package:dartz/dartz.dart';
import 'package:sos_app/src/core/constants/prefs_const.dart';
import 'package:sos_app/src/core/error/exception.dart';
import 'package:sos_app/src/core/error/failures.dart';
import 'package:sos_app/src/core/utils/notification_config.dart';
import 'package:sos_app/src/features/auth/models/user_profile_model.dart';

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

  Future<Either<Failure, UserProfileModel>> verifyOtp({
    required String phone,
    required String otp,
    required bool isSignIn,
  });

  Future<Either<Failure, UserProfileModel?>> getCurrentUser();

  Future<Either<Failure, bool>> sendFCMToken({
    required String fcmToken,
    int? userId,
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
  Future<Either<Failure, UserProfileModel?>> getCurrentUser() async {
    final userJson = await prefs.get(PrefsConst.currentUser);
    if (userJson == null) {
      return const Left(CacheFailure());
    }
    return Right(userProfileModelFromJson(userJson));
  }

  Future<bool> saveUser(UserProfileModel user) async {
    await prefs.init();
    await prefs.set(PrefsConst.userId, user.userId);
    return await prefs.set(
        PrefsConst.currentUser, userProfileModelToJson(user));
  }

  @override
  Future<Either<Failure, bool>> signIn({required String phone}) async {
    try {
      final result = await apiClient.request(
        HttpMethod.get,
        '$baseUrl/api/SignIn/$phone',
      );

      if (result.statusCode == 200) {
        return const Right(true);
      } else {
        return Left(ServerFailure(result.data['message']));
      }
    } on NotFoundException catch (err) {
      return const Left(NotFoundFailure());
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
    } on NotFoundException catch (err) {
      return const Left(NotFoundFailure());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfileModel>> verifyOtp({
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
        final user = UserProfileModel.fromJson(result.data);
        await saveUser(user);
        NotificationConfig.fcmToken(userId: user.userId);
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
    int? userId,
  }) async {
    final user = userId ?? prefs.get(PrefsConst.userId);
    try {
      final result = await apiClient.request(
        HttpMethod.put,
        '$baseUrl/api/FCMToken/$user',
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
