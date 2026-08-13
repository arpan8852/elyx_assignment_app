class ServerException implements Exception {
  final String message;

  ServerException({required this.message});
}

class NetworkException implements Exception {
  final String message;

  NetworkException({required this.message});
}

class TimeoutException implements Exception {
  final String message;

  TimeoutException({required this.message});
}

class UnauthorizedException implements Exception {
  final String message;

  UnauthorizedException({required this.message});
}

class ParsingException implements Exception {
  final String message;

  ParsingException({required this.message});
}
