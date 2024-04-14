class ServerException implements Exception {
  final String ex;

  const ServerException(this.ex);
}

class NoDataException implements Exception {
  final String ex;

  const NoDataException(this.ex);
}

class CacheException implements Exception {
  final String ex;

  const CacheException(this.ex);
}

class ParsingException implements Exception {
  final String ex;

  const ParsingException(this.ex);
}

class InternalException implements Exception {
  final String ex;

  const InternalException(this.ex);
}
