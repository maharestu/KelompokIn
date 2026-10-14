// lib/screens/task_progress_screen.dart

import 'package:flutter/material.dart';
import '../models/tugas_model.dart';
import '../models/anggota_model.dart';
import '../data/mock_database.dart';
import 'add_task_screen.dart';
import 'files_screen.dart';

class TaskProgressScreen extends StatefulWidget {
  final TugasModel tugas;
  final String kelompokId;

  const TaskProgressScreen({
    super.key,
    required this.tugas,
    required this.kelompokId,
  });

  @override
  State<TaskProgressScreen> createState() => _TaskProgressScreenState();
}

class _TaskProgressScreenState extends State<TaskProgressScreen> {
  late TugasModel _tugas;
  late List<AnggotaModel> _anggotaList;

  @override
  void initState() {
    super.initState();
    _tugas = widget.tugas;
    _initAnggotaList();
  }

  void _initAnggotaList() {
    if (_tugas.assignedAnggotaList.isNotEmpty) {
      _anggotaList = List.from(_tugas.assignedAnggotaList);
    } else {
      // Default sample matching screenshot 2
      _anggotaList = [
        const AnggotaModel(id: 'g1', nama: 'Galuh', role: 'Pemilik', progress: 1.0),
        const AnggotaModel(id: 'g2', nama: 'Andi', role: 'Anggota', progress: 0.7),
        const AnggotaModel(id: 'g3', nama: 'Budi', role: 'Anggota', progress: 0.5),
        const AnggotaModel(id: 'g4', nama: 'Siti', role: 'Anggota', progress: 0.0),
      ];
    }
  }

  double get _overallProgress {
    if (_tugas.progress > 0) return _tugas.progress;
    if (_anggotaList.isEmpty) return 0.0;
    final total = _anggotaList.fold<double>(0.0, (sum, a) => sum + a.progress);
    return total / _anggotaList.length;
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
          if (_tugas.assignedAnggotaList.isNotEmpty) {
            _anggotaList = List.from(_tugas.assignedAnggotaList);
          }
        });
      } else {
        final kelompok = MockDatabase.getKelompokById(widget.kelompokId);
        final updated = kelompok?.tugasList.firstWhere(
          (t) => t.id == _tugas.id,
          orElse: () => _tugas,
        );
        if (updated != null) {
          setState(() {
            _tugas = updated;
            if (_tugas.assignedAnggotaList.isNotEmpty) {
              _anggotaList = List.from(_tugas.assignedAnggotaList);
            }
          });
        }
      }
    }
  }

  void _showFileModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'File Tugas & Lampiran',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Color(0xFF64748B)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildFileItem(
                  'Wireframe_KelompokIn_v2.fig',
                  'Figma File • 12.4 MB',
                  Icons.draw_outlined,
                  const Color(0xFF2563EB),
                ),
                const SizedBox(height: 12),
                _buildFileItem(
                  'Design_System_Guidelines.pdf',
                  'PDF Document • 4.1 MB',
                  Icons.picture_as_pdf_outlined,
                  Colors.redAccent,
                ),
                const SizedBox(height: 12),
                _buildFileItem(
                  'Asset_Icons_Pack.zip',
                  'ZIP Archive • 8.6 MB',
                  Icons.folder_zip_outlined,
                  Colors.amber.shade800,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const FilesScreen()),
                            );
                          },
                          icon: const Icon(Icons.folder_open_outlined, color: Color(0xFF2563EB)),
                          label: const Text(
                            'Buka File',
                            style: TextStyle(
                              color: Color(0xFF2563EB),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF2563EB)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const FilesScreen()),
                            );
                          },
                          icon: const Icon(Icons.cloud_upload_outlined, color: Colors.white),
                          label: const Text(
                            'Upload File',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFileItem(String name, String meta, IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  meta,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.download_rounded, color: Color(0xFF2563EB), size: 22),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Mengunduh $name...'),
                  backgroundColor: const Color(0xFF2563EB),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final overallProg = _overallProgress;
    final displayStatus = _tugas.status == 'Belum Dimulai' ? 'Dalam Proses' : _tugas.status;

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
              } else if (value == 'selesai') {
                final updated = _tugas.copyWith(
                  status: 'Selesai',
                  isCompleted: true,
                  progress: 1.0,
                );
                MockDatabase.updateTugas(widget.kelompokId, updated);
                setState(() {
                  _tugas = updated;
                  _anggotaList = _anggotaList
                      .map((a) => AnggotaModel(
                            id: a.id,
                            nama: a.nama,
                            role: a.role,
                            avatarUrl: a.avatarUrl,
                            progress: 1.0,
                          ))
                      .toList();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tugas ditandai Selesai (100%)'),
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
                value: 'selesai',
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline, size: 18, color: Color(0xFF10B981)),
                    SizedBox(width: 10),
                    Text('Tandai Selesai (100%)'),
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
                        displayStatus,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Section Progress Total
                    const Text(
                      'Progress',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: LinearProgressIndicator(
                              value: overallProg.clamp(0.0, 1.0),
                              minHeight: 8,
                              backgroundColor: const Color(0xFFDBEAFE),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFF2563EB),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 18),
                        Text(
                          '${(overallProg * 100).toInt()}%',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 36),

                    // Section Anggota & Progress
                    const Text(
                      'Anggota & Progress',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ..._anggotaList.map((anggota) {
                      final isComplete = anggota.progress >= 1.0;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 22.0),
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
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    anggota.nama,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF1E293B),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: anggota.progress.clamp(0.0, 1.0),
                                      minHeight: 6,
                                      backgroundColor: const Color(0xFFDBEAFE),
                                      valueColor: const AlwaysStoppedAnimation<Color>(
                                        Color(0xFF2563EB),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 14),
                            SizedBox(
                              width: 44,
                              child: Text(
                                '${(anggota.progress * 100).toInt()}%',
                                textAlign: TextAlign.end,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Icon(
                              isComplete
                                  ? Icons.check_circle_outline_rounded
                                  : Icons.radio_button_unchecked_rounded,
                              color: const Color(0xFF1E293B),
                              size: 20,
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Tombol Lihat File di Bagian Bawah
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _showFileModal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),
                  child: const Text(
                    'Lihat File',
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
