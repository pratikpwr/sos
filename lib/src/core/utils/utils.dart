import 'package:dartz/dartz.dart';

import '../error/exception.dart';
import '../error/failures.dart';
import '../network/network_info.dart';

Future<Either<Failure, T>> resultOrFailure<T>({
  required NetworkInfo networkInfo,
  required Future<T> Function() callback,
}) async {
  if (await networkInfo.isConnected) {
    try {
      return Right(await callback());
    } on NoDataException {
      return const Left(NoDataFailure());
    } on ServerException {
      return const Left(ServerFailure());
    } on ParsingException {
      return const Left(ParsingFailure());
    } on CacheException {
      return const Left(CacheFailure());
    }
  } else {
    return const Left(NoInternetFailure());
  }
}
