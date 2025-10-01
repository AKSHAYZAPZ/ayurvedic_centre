import 'branch.dart';

class Treatment {
  final String id;
  final String name;
  final String duration;
  final String price;
  final bool isActive;
  final String createdAt;
  final String updatedAt;
  final List<Branch> branches;

  Treatment({
    required this.id,
    required this.name,
    required this.duration,
    required this.price,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.branches,
  });

  factory Treatment.fromJson(Map<String, dynamic> json) {
    return Treatment(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? json['title'] ?? '',
      duration: json['duration'] ?? '',
      price: json['price']?.toString() ?? '',
      isActive: json['is_active'] ?? false,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      branches: (json['branches'] as List? ?? [])
          .map((e) => Branch.fromJson(e))
          .toList(),
    );
  }
}
