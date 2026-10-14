// lib/models/user_model.dart

/// Blueprint data user untuk aplikasi KelompokIn
class UserModel {
  final String id;
  final String namaLengkap;
  final String email;
  final String password;

  UserModel({
    required this.id,
    required this.namaLengkap,
    required this.email,
    required this.password,
  });
}
