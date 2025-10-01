import 'branch.dart';

class Patient {
  final String id;
  final String name;
  final String phone;
  final String address;
  final double totalAmount;
  final double discountAmount;
  final double advanceAmount;
  final double balanceAmount;
  final String dateTime;
  final Branch branch;
  final String user;
  final String payment;
  final bool isActive;
  final List<PatientDetail> details;

  Patient({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.totalAmount,
    required this.discountAmount,
    required this.advanceAmount,
    required this.balanceAmount,
    required this.dateTime,
    required this.branch,
    required this.user,
    required this.payment,
    required this.isActive,
    required this.details,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      totalAmount:
          double.tryParse(json['total_amount']?.toString() ?? '0') ?? 0.0,
      discountAmount:
          double.tryParse(json['discount_amount']?.toString() ?? '0') ?? 0.0,
      advanceAmount:
          double.tryParse(json['advance_amount']?.toString() ?? '0') ?? 0.0,
      balanceAmount:
          double.tryParse(json['balance_amount']?.toString() ?? '0') ?? 0.0,
      dateTime: json['date_nd_time'] ?? '',
      branch: Branch.fromJson(json['branch'] ?? {}),
      user: json['user'] ?? '',
      payment: json['payment'] ?? '',
      isActive: json['is_active'] ?? false,
      details: (json['patientdetails_set'] as List? ?? [])
          .map((e) => PatientDetail.fromJson(e))
          .toList(),
    );
  }
}

class PatientDetail {
  final String id;
  final String male;
  final String female;
  final String treatmentId;
  final String treatmentName;

  PatientDetail({
    required this.id,
    required this.male,
    required this.female,
    required this.treatmentId,
    required this.treatmentName,
  });

  factory PatientDetail.fromJson(Map<String, dynamic> json) {
    return PatientDetail(
      id: json['id']?.toString() ?? '',
      male: json['male'] ?? '',
      female: json['female'] ?? '',
      treatmentId: json['treatment']?.toString() ?? '',
      treatmentName: json['treatment_name'] ?? '',
    );
  }
}
