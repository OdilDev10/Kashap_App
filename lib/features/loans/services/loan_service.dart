import 'package:dio/dio.dart';

class LoanApplication {
  final String id;
  final String customerId;
  final String customerName;
  final double amount;
  final int installments;
  final String frequency;
  final String status;
  final DateTime createdAt;

  LoanApplication({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.amount,
    required this.installments,
    required this.frequency,
    required this.status,
    required this.createdAt,
  });

  factory LoanApplication.fromJson(Map<String, dynamic> json) {
    return LoanApplication(
      id: json['id']?.toString() ?? '',
      customerId: json['customer_id']?.toString() ?? '',
      customerName: json['customer_name'] ?? 'Cliente',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      installments: json['installments'] ?? 0,
      frequency: json['frequency'] ?? 'monthly',
      status: json['status'] ?? 'pending',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class LoanService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:8000/api/v1'));

  Future<List<LoanApplication>> getLoanApplications() async {
    try {
      // Mocking for now
      await Future.delayed(const Duration(seconds: 1));
      return [
        LoanApplication(
          id: '1',
          customerId: '1',
          customerName: 'Juan Pérez',
          amount: 50000,
          installments: 12,
          frequency: 'monthly',
          status: 'pending',
          createdAt: DateTime.now(),
        ),
      ];
    } catch (e) {
      rethrow;
    }
  }
}
