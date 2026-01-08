import 'package:dio/dio.dart';
import 'package:employees_app/core/config/app_config_provider.dart';
import 'package:employees_app/core/network/dio_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final Provider<Dio> employeesApiDioProvider = .new(
  (ref) => createDioClient(
    baseUrl: ref.watch(appConfigProvider).employeesApiBaseUrl,
  ),
);
