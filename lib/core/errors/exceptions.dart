/// Base exception class
abstract class AppException implements Exception {
  final String message;
  final String? code;

  const AppException(this.message, {this.code});

  @override
  String toString() => message;
}

/// Server exception
class ServerException extends AppException {
  const ServerException(super.message, {super.code});
}

/// Network exception
class NetworkException extends AppException {
  const NetworkException(super.message, {super.code});
}

/// Authentication exception
class AuthenticationException extends AppException {
  const AuthenticationException(super.message, {super.code});
}

/// Authorization exception
class AuthorizationException extends AppException {
  const AuthorizationException(super.message, {super.code});
}

/// Validation exception
class ValidationException extends AppException {
  const ValidationException(super.message, {super.code});
}

/// Cache exception
class CacheException extends AppException {
  const CacheException(super.message, {super.code});
}

/// Unknown exception
class UnknownException extends AppException {
  const UnknownException(super.message, {super.code});
}
