class Lender {
  final String id;
  final String legalName;
  final String email;
  final String phone;
  final String status;

  Lender({
    required this.id,
    required this.legalName,
    required this.email,
    required this.phone,
    required this.status,
  });

  factory Lender.fromJson(Map<String, dynamic> json) {
    return Lender(
      id: json['id']?.toString() ?? '',
      legalName: json['legal_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      status: json['status'] ?? 'active',
    );
  }
}

class LenderService {
  Future<List<Lender>> getLenders() async {
    // TODO: Add Auth interceptor to add JWT token
    try {
      // Mocking for now as we are in FE task
      await Future.delayed(const Duration(seconds: 1));
      return [
        Lender(id: '1', legalName: 'Prestamista Pro', email: 'pro@lender.com', phone: '809-555-0101', status: 'active'),
        Lender(id: '2', legalName: 'Inversiones RD', email: 'info@inversiones.do', phone: '829-555-0202', status: 'active'),
      ];
    } catch (e) {
      rethrow;
    }
  }
}
