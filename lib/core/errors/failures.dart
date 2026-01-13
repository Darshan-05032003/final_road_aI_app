import 'exceptions.dart';

/// Base failure class
abstract class Failure {
  final String message;
  final String? code;

  const Failure(this.message, {this.code});

  @override
  String toString() => message;
}

/// Server failure
class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.code});

  factory ServerFailure.fromException(ServerException exception) {
    return ServerFailure(exception.message, code: exception.code);
  }
}

/// Network failure
class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.code});

  factory NetworkFailure.fromException(NetworkException exception) {
    return NetworkFailure(exception.message, code: exception.code);
  }
}

/// Authentication failure
class AuthenticationFailure extends Failure {
  const AuthenticationFailure(super.message, {super.code});

  factory AuthenticationFailure.fromException(AuthenticationException exception) {
    return AuthenticationFailure(exception.message, code: exception.code);
  }
}

/// Authorization failure
class AuthorizationFailure extends Failure {
  const AuthorizationFailure(super.message, {super.code});

  factory AuthorizationFailure.fromException(AuthorizationException exception) {
    return AuthorizationFailure(exception.message, code: exception.code);
  }
}

/// Validation failure
class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {super.code});

  factory ValidationFailure.fromException(ValidationException exception) {
    return ValidationFailure(exception.message, code: exception.code);
  }
}

/// Cache failure
class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.code});

  factory CacheFailure.fromException(CacheException exception) {
    return CacheFailure(exception.message, code: exception.code);
  }
}

/// Unknown failure
class UnknownFailure extends Failure {
  const UnknownFailure(super.message, {super.code});

  factory UnknownFailure.fromException(UnknownException exception) {
    return UnknownFailure(exception.message, code: exception.code);
  }
}
