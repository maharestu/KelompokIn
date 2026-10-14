// lib/screens/task_detail_screen.dart

import 'package:flutter/material.dart';
import '../models/tugas_model.dart';
import '../models/anggota_model.dart';
import '../data/mock_database.dart';
import 'add_task_screen.dart';

class TaskDetailScreen extends StatefulWidget {
  final TugasModel tugas;
  final String kelompokId;

  const TaskDetailScreen({
    super.key,
    required this.tugas,
    required this.kelompokId,
  });

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late TugasModel _tugas;

  @override
  void initState() {
    super.initState();
    _tugas = widget.tugas;
  }

  void _navigateToEdit() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskScreen(
          kelompokId: widget.kelompokId,
          existingTugas: _tugas,
        ),
      ),
    );

    if (result != null && mounted) {
      if (result is TugasModel) {
        setState(() {
          _tugas = result;
        });
      } else {
        // Reload from database
        final kelompok = MockDatabase.getKelompokById(widget.kelompokId);
        final updated = kelompok?.tugasList.firstWhere(
          (t) => t.id == _tugas.id,
          orElse: () => _tugas,
        );
        if (updated != null) {
          setState(() {
            _tugas = updated;
          });
        }
      }
    }
  }

  List<AnggotaModel> _getAnggotaList() {
    if (_tugas.assignedAnggotaList.isNotEmpty) {
      return _tugas.assignedAnggotaList;
    }
    // Fallback: look in group
    final kelompok = MockDatabase.getKelompokById(widget.kelompokId);
    if (kelompok != null && kelompok.anggotaList.isNotEmpty) {
      return kelompok.anggotaList;
    }
    // Default fallback
    return [
      const AnggotaModel(id: 'g1', nama: 'Galuh (Pemilik)', role: 'Pemilik'),
      const AnggotaModel(id: 'g2', nama: 'Andi', role: 'Anggota'),
      const AnggotaModel(id: 'g3', nama: 'Budi', role: 'Anggota'),
      const AnggotaModel(id: 'g4', nama: 'Siti', role: 'Anggota'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final anggotaList = _getAnggotaList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left_rounded,
            color: Color(0xFF1E293B),
            size: 28,
          ),
          onPressed: () => Navigator.pop(context, true),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_horiz_rounded,
              color: Color(0xFF1E293B),
              size: 26,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (value) {
              if (value == 'edit') {
                _navigateToEdit();
              } else if (value == 'proses') {
                final updated = _tugas.copyWith(
                  status: 'Dalam Proses',
                  progress: 0.5,
                );
                MockDatabase.updateTugas(widget.kelompokId, updated);
                setState(() {
                  _tugas = updated;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Status diubah ke Dalam Proses'),
                    backgroundColor: Color(0xFF2563EB),
                  ),
                );
              } else if (value == 'selesai') {
                final updated = _tugas.copyWith(
                  status: 'Selesai',
                  isCompleted: true,
                  progress: 1.0,
                );
                MockDatabase.updateTugas(widget.kelompokId, updated);
                setState(() {
                  _tugas = updated;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tugas ditandai Selesai'),
                    backgroundColor: Color(0xFF10B981),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined, size: 18, color: Color(0xFF1E293B)),
                    SizedBox(width: 10),
                    Text('Edit Tugas'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'proses',
                child: Row(
                  children: [
                    Icon(Icons.pending_actions_outlined, size: 18, color: Color(0xFF2563EB)),
                    SizedBox(width: 10),
                    Text('Ubah ke Dalam Proses'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'selesai',
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline, size: 18, color: Color(0xFF10B981)),
                    SizedBox(width: 10),
                    Text('Tandai Selesai'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Judul Tugas
                    Text(
                      _tugas.judul,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Status Badge Pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: const Color(0xFF1E293B),
                          width: 1.2,
                        ),
                      ),
                      child: Text(
                        _tugas.status,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Section Deskripsi
                    const Text(
                      'Deskripsi',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _tugas.deskripsi.isEmpty
                          ? 'Membuat desain antarmuka untuk aplikasi KelompokIn sesuai dengan wireframe yang sudah dibuat.'
                          : _tugas.deskripsi,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Section Anggota
                    const Text(
                      'Anggota',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...anggotaList.map((anggota) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14.0),
                        child: Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF1F5F9),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.person,
                                color: Color(0xFF1E293B),
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                anggota.nama,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 20),

                    // Section Deadline
                    const Text(
                      'Deadline',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 20,
                          color: Color(0xFF1E293B),
                        ),
                        const SizedBox(width: 14),
                        Text(
                          _tugas.deadline,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            // Tombol Edit Tugas di Bagian Bawah
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _navigateToEdit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),
                  child: const Text(
                    'Edit Tugas',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
