// lib/data/mock_database.dart

import '../models/user_model.dart';

// ===========================================================
// ⚠️  MOCK DATABASE — HANYA UNTUK DEVELOPMENT / TESTING UI
//
// Cara Migrasi ke Supabase Nanti:
// 1. Tambahkan dependency: flutter pub add supabase_flutter
// 2. Buat file service terpisah (misalnya: lib/services/auth_service.dart)
// 3. Ganti pemanggilan MockDatabase.login() dan MockDatabase.register()
//    dengan Supabase client auth.
// ===========================================================

class MockDatabase {
  // Daftar user dummy yang disimpan sementara di memori aplikasi
  // TODO [SUPABASE]: Hapus list ini, data autentikasi dan profil akan tersimpan di Supabase
  static final List<UserModel> _users = [
    UserModel(
      id: 'user_001',
      namaLengkap: 'Budi Santoso',
      email: 'budi@email.com',
      password: 'password123',
    ),
    UserModel(
      id: 'user_002',
      namaLengkap: 'Siti Rahayu',
      email: 'siti@email.com',
      password: 'siti1234',
    ),
    UserModel(
      id: 'user_003',
      namaLengkap: 'Ahmad Fauzi',
      email: 'ahmad@email.com',
      password: 'ahmad5678',
    ),
  ];

  // ----------------------------------------------------------
  // LOGIKA LOGIN
  // TODO [SUPABASE]: Ganti blok fungsi ini dengan:
  //   final response = await Supabase.instance.client.auth.signInWithPassword(
  //     email: email,
  //     password: password,
  //   );
  // ----------------------------------------------------------
  static UserModel? login(String emailOrUsername, String password) {
    for (UserModel user in _users) {
      // Boleh login menggunakan email yang terdaftar
      if (user.email.toLowerCase() == emailOrUsername.trim().toLowerCase() &&
          user.password == password) {
        return user; // Berhasil login
      }
    }
    return null; // Gagal login (user/password tidak cocok)
  }

  // ----------------------------------------------------------
  // LOGIKA REGISTER
  // TODO [SUPABASE]: Ganti blok fungsi ini dengan:
  //   final response = await Supabase.instance.client.auth.signUp(
  //     email: email,
  //     password: password,
  //     data: {'nama_lengkap': namaLengkap},
  //   );
  // ----------------------------------------------------------
  static bool register(String namaLengkap, String email, String password) {
    // 1. Cek apakah email sudah terdaftar
    for (UserModel user in _users) {
      if (user.email.toLowerCase() == email.trim().toLowerCase()) {
        return false; // Email sudah digunakan
      }
    }

    // 2. Generate ID dummy dan tambahkan user baru
    // TODO [SUPABASE]: ID akan di-generate otomatis oleh Supabase Auth (UUID)
    final String newId = 'user_${DateTime.now().millisecondsSinceEpoch}';
    _users.add(
      UserModel(
        id: newId,
        namaLengkap: namaLengkap.trim(),
        email: email.trim(),
        password: password,
      ),
    );

    return true; // Berhasil daftar
  }

  // ----------------------------------------------------------
  // LOGIKA LUPA PASSWORD / RESET EMAIL
  // TODO [SUPABASE]: Ganti blok fungsi ini dengan:
  //   await Supabase.instance.client.auth.resetPasswordForEmail(email);
  // ----------------------------------------------------------
  static bool checkEmailExists(String email) {
    for (UserModel user in _users) {
      if (user.email.toLowerCase() == email.trim().toLowerCase()) {
        return true;
      }
    }
    return false;
  }
}
