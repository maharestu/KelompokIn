// lib/data/mock_database.dart

import '../models/user_model.dart';
import '../models/kelompok_model.dart';
import '../models/tugas_model.dart';
import '../models/anggota_model.dart';

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
  // Current active logged in user
  static UserModel? currentUser = _users.first;

  // Daftar user dummy yang disimpan sementara di memori aplikasi
  static final List<UserModel> _users = [
    UserModel(
      id: 'user_001',
      namaLengkap: 'Galuh Maha Restu',
      email: 'galuh@student.ac.id',
      password: 'password123',
    ),
    UserModel(
      id: 'user_002',
      namaLengkap: 'Budi Santoso',
      email: 'budi@email.com',
      password: 'password123',
    ),
    UserModel(
      id: 'user_003',
      namaLengkap: 'Siti Rahayu',
      email: 'siti@email.com',
      password: 'siti1234',
    ),
  ];

  // Daftar file dummy (sesuai screenshot Halaman File)
  static final List<Map<String, String>> _fileList = [
    {
      'title': 'Desain_UI.fig',
      'date': '1 Jun 2026',
      'size': '2.4 MB',
      'type': 'fig',
    },
    {
      'title': 'Dokumentasi.pdf',
      'date': '3 Jun 2026',
      'size': '1.2 MB',
      'type': 'pdf',
    },
    {
      'title': 'Source_Code.zip',
      'date': '5 Jun 2026',
      'size': '8.7 MB',
      'type': 'zip',
    },
    {
      'title': 'Revisi_Desain.png',
      'date': '7 Jun 2026',
      'size': '3.1 MB',
      'type': 'png',
    },
  ];

  // Daftar kelompok dummy
  static final List<KelompokModel> _kelompokList = [
    KelompokModel(
      id: 'kelompok_001',
      nama: 'Project KelompokIn',
      deskripsi: 'Pengembangan aplikasi mobile kolaborasi tugas kelompok KelompokIn.',
      anggotaList: [
        const AnggotaModel(id: 'g1', nama: 'Galuh', role: 'Pemilik'),
        const AnggotaModel(id: 'g2', nama: 'Shidqy', role: 'Anggota'),
        const AnggotaModel(id: 'g3', nama: 'Ori', role: 'Anggota'),
        const AnggotaModel(id: 'g4', nama: 'Riza', role: 'Anggota'),
        const AnggotaModel(id: 'g5', nama: 'Januar', role: 'Anggota'),
      ],
      tugasList: [
        TugasModel(
          id: 't1',
          kelompokId: 'kelompok_001',
          judul: 'Desain UI/UX',
          deskripsi: 'Membuat desain antarmuka untuk aplikasi KelompokIn sesuai dengan wireframe yang sudah dibuat.',
          deadline: '10 Jun 2026',
          status: 'Belum Dimulai',
          assignedToNama: 'Galuh',
          assignedAnggotaList: [
            const AnggotaModel(id: 'g1', nama: 'Galuh', role: 'Pemilik', progress: 0.0),
            const AnggotaModel(id: 'g2', nama: 'Shidqy', role: 'Anggota', progress: 0.0),
            const AnggotaModel(id: 'g3', nama: 'Ori', role: 'Anggota', progress: 0.0),
            const AnggotaModel(id: 'g4', nama: 'Riza', role: 'Anggota', progress: 0.0),
          ],
          progress: 0.0,
          isCompleted: false,
        ),
        TugasModel(
          id: 't2',
          kelompokId: 'kelompok_001',
          judul: 'Frontend Web',
          deskripsi: 'Mengimplementasikan slicing UI Flutter dari design Figma ke komponen interaktif.',
          deadline: '12 Jun 2026',
          status: 'Dalam Proses',
          assignedToNama: 'Shidqy',
          assignedAnggotaList: [
            const AnggotaModel(id: 'g1', nama: 'Galuh', role: 'Pemilik', progress: 1.0),
            const AnggotaModel(id: 'g2', nama: 'Shidqy', role: 'Anggota', progress: 0.7),
            const AnggotaModel(id: 'g3', nama: 'Ori', role: 'Anggota', progress: 0.5),
            const AnggotaModel(id: 'g4', nama: 'Riza', role: 'Anggota', progress: 0.0),
          ],
          progress: 0.6,
          isCompleted: false,
        ),
        TugasModel(
          id: 't3',
          kelompokId: 'kelompok_001',
          judul: 'Backend API',
          deskripsi: 'Membuat endpoint REST API serta konfigurasi skema basis data.',
          deadline: '15 Jun 2026',
          status: 'Sedang Dikerjakan',
          assignedToNama: 'Ori',
          assignedAnggotaList: [
            const AnggotaModel(id: 'g3', nama: 'Ori', role: 'Anggota', progress: 0.4),
            const AnggotaModel(id: 'g4', nama: 'Riza', role: 'Anggota', progress: 0.2),
          ],
          progress: 0.3,
          isCompleted: false,
        ),
        TugasModel(
          id: 't4',
          kelompokId: 'kelompok_001',
          judul: 'Testing & QA Integration',
          deskripsi: 'Uji integrasi modul dan fungsionalitas keseluruhan aplikasi.',
          deadline: '18 Jun 2026',
          status: 'Belum Dimulai',
          assignedToNama: 'Januar',
          assignedAnggotaList: [
            const AnggotaModel(id: 'g5', nama: 'Januar', role: 'Anggota', progress: 0.0),
          ],
          progress: 0.0,
          isCompleted: false,
        ),
        TugasModel(
          id: 't5',
          kelompokId: 'kelompok_001',
          judul: 'Penyusunan Laporan Akhir',
          deskripsi: 'Menyusun dokumentasi dan laporan hasil proyek.',
          deadline: '20 Jun 2026',
          status: 'Belum Dimulai',
          assignedToNama: 'Galuh',
          assignedAnggotaList: [
            const AnggotaModel(id: 'g1', nama: 'Galuh', role: 'Pemilik', progress: 0.0),
          ],
          progress: 0.0,
          isCompleted: false,
        ),
        TugasModel(
          id: 't6',
          kelompokId: 'kelompok_001',
          judul: 'Demo & Presentasi Proyek',
          deskripsi: 'Presentasi hasil proyek di hadapan dosen pengampu.',
          deadline: '27 Jun 2026',
          status: 'Belum Dimulai',
          assignedToNama: 'Galuh',
          assignedAnggotaList: [
            const AnggotaModel(id: 'g1', nama: 'Galuh', role: 'Pemilik', progress: 0.0),
            const AnggotaModel(id: 'g2', nama: 'Shidqy', role: 'Anggota', progress: 0.0),
          ],
          progress: 0.0,
          isCompleted: false,
        ),
      ],
    ),
    KelompokModel(
      id: 'kelompok_002',
      nama: 'Project Laravel',
      deskripsi: 'Pengembangan REST API dan Web Portal Administrasi menggunakan Laravel 11.',
      anggotaList: [
        const AnggotaModel(id: 'a1', nama: 'Budi Santoso', role: 'Ketua'),
        const AnggotaModel(id: 'a2', nama: 'Siti Rahayu', role: 'UI/UX Designer'),
        const AnggotaModel(id: 'a3', nama: 'Ahmad Fauzi', role: 'Backend Developer'),
        const AnggotaModel(id: 'a4', nama: 'Rizky Pratama', role: 'Frontend Developer'),
        const AnggotaModel(id: 'a5', nama: 'Dewi Lestari', role: 'QA Tester'),
      ],
      tugasList: [
        TugasModel(
          id: 't7',
          kelompokId: 'kelompok_002',
          judul: 'Setup State Management',
          deskripsi: 'Konfigurasi arsitektur state management dan dependency injection.',
          deadline: '16 Oktober 2026',
          status: 'Sedang Dikerjakan',
          assignedToNama: 'Budi Santoso',
          assignedAnggotaList: [
            const AnggotaModel(id: 'a1', nama: 'Budi Santoso', role: 'Ketua', progress: 0.5),
          ],
          progress: 0.5,
          isCompleted: false,
        ),
      ],
    ),
  ];

  // ----------------------------------------------------------
  // LOGIKA LOGIN
  // ----------------------------------------------------------
  static UserModel? login(String emailOrUsername, String password) {
    for (UserModel user in _users) {
      if (user.email.toLowerCase() == emailOrUsername.trim().toLowerCase() &&
          user.password == password) {
        currentUser = user;
        return user;
      }
    }
    return null;
  }

  // ----------------------------------------------------------
  // LOGIKA REGISTER
  // ----------------------------------------------------------
  static bool register(String namaLengkap, String email, String password) {
    for (UserModel user in _users) {
      if (user.email.toLowerCase() == email.trim().toLowerCase()) {
        return false;
      }
    }

    final String newId = 'user_${DateTime.now().millisecondsSinceEpoch}';
    final newUser = UserModel(
      id: newId,
      namaLengkap: namaLengkap.trim(),
      email: email.trim(),
      password: password,
    );
    _users.add(newUser);
    currentUser = newUser;
    return true;
  }

  // ----------------------------------------------------------
  // LOGIKA LUPA PASSWORD / RESET EMAIL
  // ----------------------------------------------------------
  static bool checkEmailExists(String email) {
    for (UserModel user in _users) {
      if (user.email.toLowerCase() == email.trim().toLowerCase()) {
        return true;
      }
    }
    return false;
  }

  // ----------------------------------------------------------
  // LOGIKA KELOMPOK & TUGAS
  // ----------------------------------------------------------
  static List<KelompokModel> getKelompokList() {
    return _kelompokList;
  }

  static KelompokModel? getKelompokById(String id) {
    try {
      return _kelompokList.firstWhere((k) => k.id == id);
    } catch (_) {
      return null;
    }
  }

  static void addKelompok(String nama, String deskripsi) {
    final newId = 'kelompok_${DateTime.now().millisecondsSinceEpoch}';
    _kelompokList.add(
      KelompokModel(
        id: newId,
        nama: nama,
        deskripsi: deskripsi,
        anggotaList: [
          AnggotaModel(
            id: currentUser?.id ?? 'a_user',
            nama: currentUser?.namaLengkap ?? 'Saya',
            role: 'Ketua',
          ),
        ],
        tugasList: [],
      ),
    );
  }

  static void addTugas(String kelompokId, TugasModel tugas) {
    final kelompok = getKelompokById(kelompokId);
    if (kelompok != null) {
      kelompok.tugasList.insert(0, tugas);
    }
  }

  static void updateTugas(String kelompokId, TugasModel updatedTugas) {
    final kelompok = getKelompokById(kelompokId);
    if (kelompok != null) {
      final index = kelompok.tugasList.indexWhere((t) => t.id == updatedTugas.id);
      if (index != -1) {
        kelompok.tugasList[index] = updatedTugas;
      }
    }
  }

  static void toggleTugasSelesai(String kelompokId, String tugasId) {
    final kelompok = getKelompokById(kelompokId);
    if (kelompok != null) {
      final index = kelompok.tugasList.indexWhere((t) => t.id == tugasId);
      if (index != -1) {
        final current = kelompok.tugasList[index];
        final newIsCompleted = !current.isCompleted;
        kelompok.tugasList[index] = current.copyWith(
          isCompleted: newIsCompleted,
          status: newIsCompleted ? 'Selesai' : 'Sedang Dikerjakan',
          progress: newIsCompleted ? 1.0 : (current.progress == 1.0 ? 0.5 : current.progress),
        );
      }
    }
  }

  static List<TugasModel> getAllTugas() {
    final List<TugasModel> all = [];
    for (var k in _kelompokList) {
      all.addAll(k.tugasList);
    }
    return all;
  }

  // ----------------------------------------------------------
  // LOGIKA FILE
  // ----------------------------------------------------------
  static List<Map<String, String>> getFiles() {
    return _fileList;
  }

  static void addFile(Map<String, String> file) {
    _fileList.insert(0, file);
  }

  static void removeFile(String title) {
    _fileList.removeWhere((f) => f['title'] == title);
  }

  // ----------------------------------------------------------
  // LOGIKA ANGGOTA
  // ----------------------------------------------------------
  static void addAnggota(String kelompokId, AnggotaModel anggota) {
    final kelompok = getKelompokById(kelompokId);
    if (kelompok != null) {
      kelompok.anggotaList.add(anggota);
    }
  }

  static void removeAnggota(String kelompokId, String anggotaId) {
    final kelompok = getKelompokById(kelompokId);
    if (kelompok != null) {
      kelompok.anggotaList.removeWhere((a) => a.id == anggotaId);
    }
  }
}

