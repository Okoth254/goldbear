import 'package:dio/dio.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

class MedusaService {
  static final MedusaService instance = MedusaService._internal();
  late final Dio dio;

  // Use the host machine's local IP address for physical device testing
  String get baseUrl {
    if (kIsWeb) {
      return 'http://192.168.1.33:9000';
    } else if (Platform.isAndroid) {
      return 'http://192.168.1.33:9000'; // Override emulator IP for physical testing
    } else {
      return 'http://192.168.1.33:9000'; // iOS/Windows/macOS
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
