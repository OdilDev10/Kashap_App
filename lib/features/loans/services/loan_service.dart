import 'package:app/core/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Installment {
  final String id;
  final int number;
  final double amount;
  final double paid;
  final DateTime dueDate;
  final String status;

  const Installment({
    required this.id,
    required this.number,
    required this.amount,
    required this.paid,
    required this.dueDate,
    required this.status,
  });

  factory Installment.fromJson(Map<String, dynamic> json) {
    return Installment(
      id: json['id']?.toString() ?? json['installment_id']?.toString() ?? '',
      number: (json['number'] as num?)?.toInt() ?? 0,
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      paid: (json['paid'] as num?)?.toDouble() ?? 0,
      dueDate: DateTime.tryParse(json['due_date']?.toString() ?? '') ?? DateTime.now(),
      status: json['status']?.toString() ?? 'pending',
    );
  }
}

class Loan {
  final String id;
  final String customerName;
  final double originalAmount;
  final double totalAmount;
  final double balance;
  final double interestRate;
  final String status;
  final String loanNumber;
  final List<Installment> installments;

  const Loan({
    required this.id,
    required this.customerName,
    required this.originalAmount,
    required this.totalAmount,
    required this.balance,
    required this.interestRate,
    required this.status,
    required this.loanNumber,
    required this.installments,
  });

  factory Loan.fromSummaryJson(Map<String, dynamic> json) {
    return Loan(
      id: json['loan_id']?.toString() ?? '',
      customerName: json['customer_name']?.toString() ?? '',
      originalAmount: (json['principal'] as num?)?.toDouble() ?? 0,
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0,
      balance: (json['balance'] as num?)?.toDouble() ?? 0,
      interestRate: (json['interest_rate'] as num?)?.toDouble() ?? 0,
      status: json['status']?.toString() ?? 'approved',
      loanNumber: json['loan_number']?.toString() ?? '',
      installments: const [],
    );
  }

  factory Loan.fromDetailJson(Map<String, dynamic> json) {
    final installments = json['installments'];
    return Loan(
      id: json['loan_id']?.toString() ?? '',
      customerName: json['customer_name']?.toString() ?? '',
      originalAmount: (json['principal'] as num?)?.toDouble() ?? 0,
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0,
      balance: (json['balance'] as num?)?.toDouble() ?? 0,
      interestRate: (json['interest_rate'] as num?)?.toDouble() ?? 0,
      status: json['status']?.toString() ?? 'approved',
      loanNumber: json['loan_number']?.toString() ?? '',
      installments: installments is List
          ? installments
                .whereType<Map>()
                .map((item) => Installment.fromJson(Map<String, dynamic>.from(item)))
                .toList()
          : const [],
    );
  }
}

class LoanApplication {
  final String id;
  final String customerId;
  final String customerName;
  final double amount;
  final double interestRate;
  final int installments;
  final String frequency;
  final String status;
  final String? purpose;
  final DateTime createdAt;

  const LoanApplication({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.amount,
    required this.interestRate,
    required this.installments,
    required this.frequency,
    required this.status,
    required this.createdAt,
    required this.purpose,
  });

  factory LoanApplication.fromJson(Map<String, dynamic> json) {
    return LoanApplication(
      id: json['application_id']?.toString() ?? '',
      customerId: json['customer_id']?.toString() ?? '',
      customerName: json['customer_name']?.toString() ?? '',
      amount: (json['requested_amount'] as num?)?.toDouble() ?? 0,
      interestRate: (json['requested_interest_rate'] as num?)?.toDouble() ?? 0,
      installments: (json['requested_installments_count'] as num?)?.toInt() ?? 0,
      frequency: json['requested_frequency']?.toString() ?? 'monthly',
      status: json['status']?.toString() ?? 'submitted',
      purpose: json['purpose']?.toString(),
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }
}

class PaymentRecord {
  final String id;
  final String customerName;
  final double amount;
  final String status;
  final DateTime date;

  const PaymentRecord({
    required this.id,
    required this.customerName,
    required this.amount,
    required this.status,
    required this.date,
  });

  factory PaymentRecord.fromJson(Map<String, dynamic> json) {
    return PaymentRecord(
      id: json['payment_id']?.toString() ?? '',
      customerName: json['customer_name']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      status: json['status']?.toString() ?? 'under_review',
      date: DateTime.tryParse(json['submitted_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }
}

class LoanApplicationCreateInput {
  final String? customerId;
  final double amount;
  final double interestRate;
  final int installmentsCount;
  final String frequency;
  final String purpose;

  const LoanApplicationCreateInput({
    required this.customerId,
    required this.amount,
    required this.interestRate,
    required this.installmentsCount,
    required this.frequency,
    required this.purpose,
  });

  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'requested_amount': amount,
      'requested_interest_rate': interestRate,
      'requested_installments_count': installmentsCount,
      'requested_frequency': frequency,
      'purpose': purpose,
    };
  }
}

class LoanService {
  static const _storage = FlutterSecureStorage();

  Future<List<LoanApplication>> getLoanApplications() async {
    final response = await ApiClient.instance.get<Map<String, dynamic>>(
      '/loan-applications/',
      options: await _authorizedOptions(),
    );
    final items = response.data?['applications'];
    if (items is! List) {
      return const [];
    }
    return items
        .whereType<Map>()
        .map((item) => LoanApplication.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<void> createLoanApplication(LoanApplicationCreateInput input) async {
    await ApiClient.instance.post<Map<String, dynamic>>(
      '/loan-applications/',
      data: input.toJson(),
      options: await _authorizedOptions(),
    );
  }

  Future<List<Loan>> getLoans() async {
    final response = await ApiClient.instance.get<Map<String, dynamic>>(
      '/loans/',
      options: await _authorizedOptions(),
    );
    final items = response.data?['loans'];
    if (items is! List) {
      return const [];
    }
    return items
        .whereType<Map>()
        .map((item) => Loan.fromSummaryJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<Loan> getLoanById(String loanId) async {
    final response = await ApiClient.instance.get<Map<String, dynamic>>(
      '/loans/$loanId',
      options: await _authorizedOptions(),
    );
    return Loan.fromDetailJson(response.data ?? const <String, dynamic>{});
  }

  Future<List<PaymentRecord>> getPendingPayments() async {
    final response = await ApiClient.instance.get<Map<String, dynamic>>(
      '/payments/',
      options: await _authorizedOptions(),
    );
    final items = response.data?['payments'];
    if (items is! List) {
      return const [];
    }
    return items
        .whereType<Map>()
        .map((item) => PaymentRecord.fromJson(Map<String, dynamic>.from(item)))
        .toList();
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
      if (payload is Map && payload['detail'] is String) {
        return payload['detail'] as String;
      }
      if (payload is Map && payload['message'] is String) {
        return payload['message'] as String;
      }
    }
    return 'No se pudo completar la operación de préstamos.';
  }
}
