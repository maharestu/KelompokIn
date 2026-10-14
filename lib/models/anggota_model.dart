// lib/models/anggota_model.dart

class AnggotaModel {
  final String id;
  final String nama;
  final String role;
  final String? avatarUrl;
  final double progress; // 0.0 to 1.0

  const AnggotaModel({
    required this.id,
    required this.nama,
    this.role = 'Anggota',
    this.avatarUrl,
    this.progress = 0.0,
  });
}
