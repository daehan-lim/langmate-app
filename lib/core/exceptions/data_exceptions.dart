/// Exception thrown when an API call fails.
///
/// Contains information about the HTTP status code and response data.
class ApiException implements Exception {
  final int? statusCode;
  final dynamic data;

  ApiException({this.statusCode, this.data});

  @override
  String toString() {
    return 'ApiException: statusCode=$statusCode; data=$data';
  }
}

/// Exception thrown when a network error occurs.
///
/// Used for connectivity issues, timeouts, etc.
class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);

  @override
  String toString() {
    return 'NetworkException: $message';
  }
}

/// Exception thrown when environment variables are missing or invalid.
///
/// Used when required API keys or configuration values are not found.
class EnvFileException implements Exception {
  final String message;

  EnvFileException(this.message);

  @override
  String toString() {
    return 'EnvFileException: $message';
  }
}
