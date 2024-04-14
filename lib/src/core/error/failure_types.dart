import 'failures.dart';

enum FailureType {
  server,
  notFound,
  noData,
  noInternet,
  internal,
  unknown;

  static FailureType fromFailure(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return FailureType.server;
      case NoDataFailure:
        return FailureType.noData;
      case NoInternetFailure:
        return FailureType.noInternet;
      case InternalFailure:
        return FailureType.internal;
      default:
        return FailureType.unknown;
    }
  }

  String get message {
    switch (this) {
      case FailureType.server:
        return 'Server Failure';
      case FailureType.notFound:
        return 'Not Found';
      case FailureType.noData:
        return 'No Data';
      case FailureType.noInternet:
        return 'No Internet';
      case FailureType.internal:
        return 'Internal Failure';
      default:
        return 'Unknown Failure';
    }
  }
}
