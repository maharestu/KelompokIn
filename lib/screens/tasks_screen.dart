// lib/screens/tasks_screen.dart

import 'package:flutter/material.dart';
import '../data/mock_database.dart';
import '../models/kelompok_model.dart';
import '../models/tugas_model.dart';
import '../widgets/tugas_card.dart';
import 'add_task_screen.dart';
import 'task_detail_screen.dart';
import 'task_progress_screen.dart';

class TasksScreen extends StatefulWidget {
  final ValueChanged<int>? onSwitchTab;

  const TasksScreen({super.key, this.onSwitchTab});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  String _selectedFilter = 'Semua';
  final List<String> _filters = ['Semua', 'Belum Selesai', 'Selesai'];

  @override
  Widget build(BuildContext context) {
    final allKelompok = MockDatabase.getKelompokList();
    final List<TugasModel> allTugas = MockDatabase.getAllTugas();

    final List<TugasModel> filteredTugas = allTugas.where((t) {
      if (_selectedFilter == 'Belum Selesai') return !t.isCompleted;
      if (_selectedFilter == 'Selesai') return t.isCompleted;
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Daftar Semua Tugas',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Color(0xFF2563EB)),
            onPressed: () async {
              if (allKelompok.isNotEmpty) {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTaskScreen(kelompokId: allKelompok.first.id),
                  ),
                );
                setState(() {});
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter Chips
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              color: Colors.white,
              child: Row(
                children: _filters.map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedFilter = filter;
                          });
                        }
                      },
                      selectedColor: const Color(0xFFDBEAFE),
                      labelStyle: TextStyle(
                        color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B),
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        fontSize: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const Divider(height: 1, color: Color(0xFFE2E8F0)),

            // List of Tasks
            Expanded(
              child: filteredTugas.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.task_alt, size: 56, color: Colors.grey.shade400),
                          const SizedBox(height: 12),
                          const Text(
                            'Tidak ada tugas pada filter ini.',
                            style: TextStyle(color: Color(0xFF64748B), fontSize: 15),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      itemCount: filteredTugas.length,
                      itemBuilder: (context, index) {
                        final tugas = filteredTugas[index];
                        final KelompokModel? kelompok = MockDatabase.getKelompokById(tugas.kelompokId);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (kelompok != null)
                              Padding(
                                padding: const EdgeInsets.only(left: 4, bottom: 4),
                                child: Text(
                                  kelompok.nama,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF2563EB),
                                  ),
                                ),
                              ),
                            TugasCard(
                              tugas: tugas,
                              onToggle: () {
                                setState(() {
                                  MockDatabase.toggleTugasSelesai(tugas.kelompokId, tugas.id);
                                });
                              },
                              onTap: () async {
                                final isNotStarted = tugas.status == 'Belum Dimulai';
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => isNotStarted
                                        ? TaskDetailScreen(tugas: tugas, kelompokId: tugas.kelompokId)
                                        : TaskProgressScreen(tugas: tugas, kelompokId: tugas.kelompokId),
                                  ),
                                );
                                if (result != null) {
                                  setState(() {});
                                }
                              },
                            ),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
