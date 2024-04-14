import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String? message;
  final List properties = const <dynamic>[];

  const Failure([this.message, properties]);

  @override
  List<Object?> get props => properties;
}

class ServerFailure extends Failure {
  const ServerFailure([super.message]);
}

class InternalFailure extends Failure {
  const InternalFailure([super.message]);
}

class NoDataFailure extends Failure {
  const NoDataFailure([super.message]);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message]);
}

class ParsingFailure extends Failure {
  const ParsingFailure([super.message]);
}

class NoInternetFailure extends Failure {
  const NoInternetFailure([super.message]);
}

class LocationFailure extends Failure {
  const LocationFailure([super.message]);
}
