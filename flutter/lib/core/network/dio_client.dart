import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';

Dio createDioClient({required String baseUrl}) {
  final Dio dioClient = .new(
    .new(
      baseUrl: baseUrl,
      connectTimeout: const .new(seconds: 5),
      receiveTimeout: const .new(seconds: 15),
    ),
  );
  dioClient.interceptors.add(
    RetryInterceptor(
      dio: dioClient,
      retries: 3,
      retryDelays: const [
        Duration(seconds: 1),
        Duration(seconds: 2),
        Duration(seconds: 3),
      ],
    ),
  );
  return dioClient;
}
