import 'package:easy_localization/easy_localization.dart';

sealed class AppException implements Exception {
  const AppException(this.messageLocKey);

  final String messageLocKey;

  String toMessage() => messageLocKey.tr();
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'error.networkUnavailable']);
}

class NotFoundException extends AppException {
  const NotFoundException([super.message = 'error.notFound']);
}

class ServerException extends AppException {
  const ServerException([super.message = 'error.server']);
}

// Based on further needs, add exceptions types.
