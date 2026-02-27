import 'package:dio/dio.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

class MedusaService {
  static final MedusaService instance = MedusaService._internal();
  late final Dio dio;

  // For Android emulator, use 10.0.2.2. Otherwise, use localhost.
  String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:9000';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:9000';
    } else {
      return 'http://localhost:9000'; // iOS/Windows/macOS
    }
  }

  MedusaService._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Logging Interceptor for easier debugging
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint('DIO Requests => ${options.method} ${options.uri}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint(
            'DIO Response <= ${response.statusCode} ${response.requestOptions.uri}',
          );
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          debugPrint('DIO Error: ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }
}
