import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:app/core/api_client.dart';

class Customer {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String status;
  final double creditLimit;
  final String documentType;
  final String documentNumber;

  const Customer({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.status,
    required this.creditLimit,
    required this.documentType,
    required this.documentNumber,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      status: json['status']?.toString() ?? 'active',
      creditLimit: (json['credit_limit'] as num?)?.toDouble() ?? 0.0,
      documentType: json['document_type']?.toString() ?? '',
      documentNumber: json['document_number']?.toString() ?? '',
    );
  }
}

class CustomerCreateInput {
  final String fullName;
  final String documentType;
  final String documentNumber;
  final String phone;
  final String email;
  final double creditLimit;

  const CustomerCreateInput({
    required this.fullName,
    required this.documentType,
    required this.documentNumber,
    required this.phone,
    required this.email,
    required this.creditLimit,
  });

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'document_type': documentType,
      'document_number': documentNumber,
      'phone': phone,
      'email': email,
      'credit_limit': creditLimit,
    };
  }
}

class CustomerService {
  static const _storage = FlutterSecureStorage();

  Future<List<Customer>> getCustomers({int skip = 0, int limit = 20}) async {
    final response = await ApiClient.instance.get<Map<String, dynamic>>(
      '/customers',
      queryParameters: {'skip': skip, 'limit': limit},
      options: await _authorizedOptions(),
    );
    final items = response.data?['items'];
    if (items is! List) {
      return const [];
    }

    return items
        .whereType<Map>()
        .map((item) => Customer.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<Customer> getCustomerById(String customerId) async {
    final response = await ApiClient.instance.get<Map<String, dynamic>>(
      '/customers/$customerId',
      options: await _authorizedOptions(),
    );
    return Customer.fromJson(response.data ?? const <String, dynamic>{});
  }

  Future<Customer> createCustomer(CustomerCreateInput input) async {
    final response = await ApiClient.instance.post<Map<String, dynamic>>(
      '/customers',
      data: input.toJson(),
      options: await _authorizedOptions(),
    );
    return Customer.fromJson(response.data ?? const <String, dynamic>{});
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
    return 'No se pudo completar la operación con clientes.';
  }
}
