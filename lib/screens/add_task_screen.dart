// lib/screens/add_task_screen.dart

import 'package:flutter/material.dart';
import '../data/mock_database.dart';
import '../models/kelompok_model.dart';
import '../models/tugas_model.dart';

class AddTaskScreen extends StatefulWidget {
  final String kelompokId;
  final TugasModel? existingTugas;

  const AddTaskScreen({
    super.key,
    required this.kelompokId,
    this.existingTugas,
  });

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _namaTugasController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

  String? _selectedAnggota;
  DateTime? _selectedDate;
  String _selectedStatus = 'Belum Dimulai';

  final List<String> _statusOptions = [
    'Belum Dimulai',
    'Dalam Proses',
    'Sedang Dikerjakan',
    'Selesai',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.existingTugas != null) {
      _namaTugasController.text = widget.existingTugas!.judul;
      _deskripsiController.text = widget.existingTugas!.deskripsi;
      _selectedAnggota = widget.existingTugas!.assignedToNama;
      if (_statusOptions.contains(widget.existingTugas!.status)) {
        _selectedStatus = widget.existingTugas!.status;
      }
    }
  }

  @override
  void dispose() {
    _namaTugasController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  String _formatIndonesianDate(DateTime date) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  void _pickDeadline() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2563EB),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1E293B),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _handleSave() {
    final nama = _namaTugasController.text.trim();
    if (nama.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama tugas wajib diisi!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final deadlineText = _selectedDate != null
        ? _formatIndonesianDate(_selectedDate!)
        : (widget.existingTugas?.deadline ?? '14 Oktober 2026');

    final isEditing = widget.existingTugas != null;
    if (isEditing) {
      final updatedTugas = widget.existingTugas!.copyWith(
        judul: nama,
        deskripsi: _deskripsiController.text.trim(),
        deadline: deadlineText,
        status: _selectedStatus,
        assignedToNama: _selectedAnggota,
        isCompleted: _selectedStatus == 'Selesai',
        progress: _selectedStatus == 'Selesai'
            ? 1.0
            : (_selectedStatus == 'Belum Dimulai'
                ? 0.0
                : (widget.existingTugas!.progress > 0 ? widget.existingTugas!.progress : 0.6)),
      );

      MockDatabase.updateTugas(widget.kelompokId, updatedTugas);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tugas "$nama" berhasil diperbarui!'),
          backgroundColor: const Color(0xFF2563EB),
        ),
      );

      Navigator.pop(context, updatedTugas);
      return;
    }

    final newTugas = TugasModel(
      id: 'tugas_${DateTime.now().millisecondsSinceEpoch}',
      kelompokId: widget.kelompokId,
      judul: nama,
      deskripsi: _deskripsiController.text.trim(),
      deadline: deadlineText,
      status: _selectedStatus,
      assignedToNama: _selectedAnggota,
      isCompleted: _selectedStatus == 'Selesai',
      progress: _selectedStatus == 'Selesai' ? 1.0 : (_selectedStatus == 'Sedang Dikerjakan' ? 0.5 : 0.0),
    );

    MockDatabase.addTugas(widget.kelompokId, newTugas);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tugas "$nama" berhasil ditambahkan!'),
        backgroundColor: const Color(0xFF2563EB),
      ),
    );

    Navigator.pop(context, newTugas);
  }

  @override
  Widget build(BuildContext context) {
    final KelompokModel? kelompok = MockDatabase.getKelompokById(widget.kelompokId);
    final anggotaList = kelompok?.anggotaList ?? [];
    final isEditing = widget.existingTugas != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF1E293B),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Text(
          isEditing ? 'Edit Tugas' : 'Tambah Tugas',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Nama Tugas
              _buildFieldLabel('Nama Tugas'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _namaTugasController,
                hintText: 'Contoh: Desain UI/UX',
              ),

              const SizedBox(height: 20),

              // 2. Deskripsi
              _buildFieldLabel('Deskripsi'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _deskripsiController,
                hintText: 'Jelaskan detail tugas...',
                maxLines: 4,
              ),

              const SizedBox(height: 20),

              // 3. Anggota
              _buildFieldLabel('Anggota'),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF334155),
                    width: 1.2,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedAnggota,
                    isExpanded: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Color(0xFF475569),
                    ),
                    hint: const Text(
                      'Pilih anggota',
                      style: TextStyle(
                        color: Color(0xFF475569),
                        fontSize: 15,
                      ),
                    ),
                    items: anggotaList.map((a) {
                      return DropdownMenuItem<String>(
                        value: a.nama,
                        child: Text(
                          a.nama,
                          style: const TextStyle(
                            color: Color(0xFF1E293B),
                            fontSize: 15,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedAnggota = val;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 4. Deadline
              _buildFieldLabel('Deadline'),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickDeadline,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF334155),
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDate != null
                            ? _formatIndonesianDate(_selectedDate!)
                            : 'Pilih tanggal',
                        style: TextStyle(
                          fontSize: 15,
                          color: _selectedDate != null
                              ? const Color(0xFF1E293B)
                              : const Color(0xFF475569),
                        ),
                      ),
                      const Icon(
                        Icons.calendar_today_outlined,
                        color: Color(0xFF475569),
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 5. Status Awal
              _buildFieldLabel('Status Awal'),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF334155),
                    width: 1.2,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedStatus,
                    isExpanded: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Color(0xFF475569),
                    ),
                    items: _statusOptions.map((st) {
                      return DropdownMenuItem<String>(
                        value: st,
                        child: Text(
                          st,
                          style: const TextStyle(
                            color: Color(0xFF1E293B),
                            fontSize: 15,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedStatus = val;
                        });
                      }
                    },
                  ),
                ),
              ),

              const SizedBox(height: 36),

              // Tombol Simpan
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),
                  child: Text(
                    isEditing ? 'Simpan Perubahan' : 'Simpan',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1E293B),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(
        fontSize: 15,
        color: Color(0xFF1E293B),
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFF64748B),
          fontSize: 15,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF334155),
            width: 1.2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF2563EB),
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
