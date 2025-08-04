// lib/model/owner_model.dart

class OwnerModel {
  final int id;
  final String name;
  final String email;
  final String phoneNumber;

  OwnerModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
  });

  factory OwnerModel.fromJson(Map<String, dynamic> json) {
    return OwnerModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
    };
  }
}
