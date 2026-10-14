// lib/screens/register_screen.dart

import 'package:flutter/material.dart';
import '../data/mock_database.dart';
import '../widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // FUNGSI LOGIKA REGISTER
  // Catatan: Saat ini menggunakan MockDatabase, nantinya diganti dengan Supabase
  // ---------------------------------------------------------------------------
  void _handleRegister() async {
    final String name = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;
    final String confirmPassword = _confirmPasswordController.text;

    // 1. Validasi field kosong
    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showSnackbar('Semua kolom wajib diisi!', Colors.redAccent);
      return;
    }

    // 2. Validasi format email sederhana
    if (!email.contains('@') || !email.contains('.')) {
      _showSnackbar('Format email tidak valid!', Colors.redAccent);
      return;
    }

    // 3. Validasi panjang password
    if (password.length < 6) {
      _showSnackbar('Password minimal 6 karakter!', Colors.redAccent);
      return;
    }

    // 4. Validasi kesamaan konfirmasi password
    if (password != confirmPassword) {
      _showSnackbar('Konfirmasi password tidak cocok!', Colors.redAccent);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulasi loading jaringan ringan
    await Future.delayed(const Duration(milliseconds: 600));

    // 5. Eksekusi register
    // TODO [SUPABASE]: Ganti blok MockDatabase.register dengan pemanggilan Supabase:
    // try {
    //   final response = await Supabase.instance.client.auth.signUp(
    //     email: email,
    //     password: password,
    //     data: {'nama_lengkap': name},
    //   );
    //   // Tampilkan notifikasi konfirmasi email atau arahkan ke Login
    // } catch (e) {
    //   // Tangani error dari Supabase
    // }
    final bool success = MockDatabase.register(name, email, password);

    setState(() {
      _isLoading = false;
    });

    if (!mounted) return;

    if (success) {
      // Pendaftaran berhasil
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Pendaftaran Berhasil!'),
          content: Text('Akun untuk $name berhasil dibuat. Silakan login.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
                Navigator.pop(context); // Kembali ke halaman Login
              },
              child: const Text('Ke Halaman Login'),
            ),
          ],
        ),
      );
    } else {
      // Email sudah ada
      _showSnackbar('Email sudah terdaftar! Gunakan email lain.', Colors.redAccent);
    }
  }

  void _showSnackbar(String message, Color bgColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: bgColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1E293B), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),

              // Judul Halaman
              const Text(
                'Daftar',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),

              // Subjudul Halaman
              const Text(
                'Buat akun baru untuk mulai mengelola tugas kelompok.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 32),

              // 1. Input Nama Lengkap
              CustomTextField(
                controller: _nameController,
                hintText: 'Nama Lengkap',
                prefixIcon: Icons.person_outline,
              ),

              const SizedBox(height: 16),

              // 2. Input Email
              CustomTextField(
                controller: _emailController,
                hintText: 'Email',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 16),

              // 3. Input Password
              CustomTextField(
                controller: _passwordController,
                hintText: 'Password',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
              ),

              const SizedBox(height: 16),

              // 4. Input Konfirmasi Password
              CustomTextField(
                controller: _confirmPasswordController,
                hintText: 'Konfirmasi Password',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
              ),

              const SizedBox(height: 28),

              // 5. Tombol Daftar
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Daftar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 24),

              // 6. Link Balik ke Login
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Sudah punya akun? ',
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        'Masuk',
                        style: TextStyle(
                          color: Color(0xFF2563EB),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
