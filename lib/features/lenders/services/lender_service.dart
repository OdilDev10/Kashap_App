import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:app/core/api_client.dart';

class Lender {
  final String id;
  final String legalName;
  final String commercialName;
  final String lenderType;
  final String documentType;
  final String documentNumber;
  final String email;
  final String phone;
  final String status;

  const Lender({
    required this.id,
    required this.legalName,
    required this.commercialName,
    required this.lenderType,
    required this.documentType,
    required this.documentNumber,
    required this.email,
    required this.phone,
    required this.status,
  });

  factory Lender.fromJson(Map<String, dynamic> json) {
    return Lender(
      id: json['id']?.toString() ?? '',
      legalName: json['legal_name']?.toString() ?? '',
      commercialName: json['commercial_name']?.toString() ?? '',
      lenderType: json['lender_type']?.toString() ?? 'financial',
      documentType: json['document_type']?.toString() ?? '',
      documentNumber: json['document_number']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      status: json['status']?.toString() ?? 'pending',
    );
  }
}

class LenderInput {
  final String legalName;
  final String commercialName;
  final String lenderType;
  final String documentType;
  final String documentNumber;
  final String email;
  final String phone;
  final String status;

  const LenderInput({
    required this.legalName,
    required this.commercialName,
    required this.lenderType,
    required this.documentType,
    required this.documentNumber,
    required this.email,
    required this.phone,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'legal_name': legalName,
      'commercial_name': commercialName.isEmpty ? null : commercialName,
      'lender_type': lenderType,
      'document_type': documentType,
      'document_number': documentNumber,
      'email': email,
      'phone': phone,
      'status': status,
    };
  }
}

class LenderService {
  static const _storage = FlutterSecureStorage();

  Future<List<Lender>> getLenders() async {
    final response = await ApiClient.instance.get<Map<String, dynamic>>(
      '/lenders',
      options: await _authorizedOptions(),
    );
    final items = response.data?['items'];
    if (items is! List) {
      return const [];
    }
    return items
        .whereType<Map>()
        .map((item) => Lender.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<Lender> createLender(LenderInput input) async {
    final response = await ApiClient.instance.post<Map<String, dynamic>>(
      '/lenders',
      data: input.toJson(),
      options: await _authorizedOptions(),
    );
    return Lender.fromJson(response.data ?? const <String, dynamic>{});
  }

  Future<Lender> updateLender(String lenderId, LenderInput input) async {
    final response = await ApiClient.instance.patch<Map<String, dynamic>>(
      '/lenders/$lenderId',
      data: input.toJson(),
      options: await _authorizedOptions(),
    );
    return Lender.fromJson(response.data ?? const <String, dynamic>{});
  }

  Future<Options> _authorizedOptions() async {
    final token = await _storage.read(key: 'jwt_token');
    return Options(
      headers: token == null ? null : {'Authorization': 'Bearer $token'},
    );
  }

  static String extractError(Object error) {
    if (error is DioException) {
      final payload = error.response?.data;
      if (payload is Map && payload['error'] is Map) {
        final message = payload['error']['message'];
        if (message is String && message.isNotEmpty) {
          return message;
        }
      }
      if (payload is Map && payload['message'] is String) {
        return payload['message'] as String;
      }
    }
    return 'No se pudo completar la operación con lenders.';
  }
}
