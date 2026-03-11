class Customer {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String status;
  final double creditLimit;

  Customer({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.status,
    required this.creditLimit,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id']?.toString() ?? '',
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      status: json['status'] ?? 'active',
      creditLimit: (json['credit_limit'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class CustomerService {
  Future<List<Customer>> getCustomers() async {
    try {
      // Mocking for now
      await Future.delayed(const Duration(seconds: 1));
      return [
        Customer(id: '1', fullName: 'Juan Pérez', email: 'juan@email.com', phone: '809-111-2222', status: 'active', creditLimit: 50000),
        Customer(id: '2', fullName: 'María García', email: 'maria@email.com', phone: '829-333-4444', status: 'active', creditLimit: 75000),
      ];
    } catch (e) {
      rethrow;
    }
  }
}
