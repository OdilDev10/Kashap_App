import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiClient {
  ApiClient._();

  static final Dio instance = Dio(
    BaseOptions(
      baseUrl: dotenv.maybeGet('API_BASE_URL') ?? 'http://localhost:8000/api/v1',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );
}
