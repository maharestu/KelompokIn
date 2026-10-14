// lib/screens/group_detail_screen.dart

import 'package:flutter/material.dart';
import '../data/mock_database.dart';
import '../models/kelompok_model.dart';
import '../models/tugas_model.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/tugas_card.dart';
import 'add_task_screen.dart';
import 'members_screen.dart';
import 'task_detail_screen.dart';
import 'task_progress_screen.dart';

class GroupDetailScreen extends StatefulWidget {
  final String kelompokId;
  final ValueChanged<int>? onSwitchTab;

  const GroupDetailScreen({
    super.key,
    required this.kelompokId,
    this.onSwitchTab,
  });

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _bottomNavIndex = 1; // Default highlighted as "Tugas" as in screenshot 2

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.edit_outlined, color: Color(0xFF1E293B)),
                  title: const Text('Edit Kelompok'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Fitur Edit Kelompok')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person_add_outlined, color: Color(0xFF1E293B)),
                  title: const Text('Undang Anggota'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tautan undangan telah disalin!')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.exit_to_app, color: Colors.redAccent),
                  title: const Text('Keluar dari Kelompok', style: TextStyle(color: Colors.redAccent)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final KelompokModel? kelompok = MockDatabase.getKelompokById(widget.kelompokId);

    if (kelompok == null) {
      return Scaffold(
        appBar: AppBar(leading: const BackButton()),
        body: const Center(child: Text('Kelompok tidak ditemukan')),
      );
    }

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
        actions: [
          IconButton(
            icon: const Icon(
              Icons.more_horiz,
              color: Color(0xFF1E293B),
              size: 24,
            ),
            onPressed: _showMoreOptions,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),

          // Header Avatar Besar & Info Kelompok
          Center(
            child: Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFE2E8F0),
                  width: 1.2,
                ),
              ),
              child: const Icon(
                Icons.person,
                size: 52,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Nama Kelompok
          Text(
            kelompok.nama,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),

          // Subtitle: X anggota · Y tugas (Bisa ditap untuk buka MembersScreen)
          InkWell(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MembersScreen(kelompokId: widget.kelompokId),
                ),
              );
              setState(() {});
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Text(
                '${kelompok.totalAnggota} anggota · ${kelompok.totalTugas} tugas',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),

          const SizedBox(height: 18),

          // Custom 3 Tabs: Tugas, Anggota, File
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFFE2E8F0),
                  width: 1,
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF2563EB),
              unselectedLabelColor: const Color(0xFF64748B),
              labelStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              indicatorColor: const Color(0xFF2563EB),
              indicatorWeight: 2.8,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: const [
                Tab(text: 'Tugas'),
                Tab(text: 'Anggota'),
                Tab(text: 'File'),
              ],
            ),
          ),

          // Isi TabBarView
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // 1. Tab Tugas (Sesuai Screenshot 2)
                _buildTugasTab(kelompok),

                // 2. Tab Anggota
                _buildAnggotaTab(kelompok),

                // 3. Tab File
                _buildFileTab(),
              ],
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _bottomNavIndex,
        onTap: (index) {
          if (index == 0) {
            // Kembali ke Beranda
            Navigator.pop(context);
          } else {
            setState(() {
              _bottomNavIndex = index;
            });
            if (widget.onSwitchTab != null) {
              Navigator.pop(context);
              widget.onSwitchTab!(index);
            }
          }
        },
      ),
    );
  }

  // Widget Tab Tugas
  Widget _buildTugasTab(KelompokModel kelompok) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      children: [
        // Row: "Daftar Tugas" + Tombol "+ Tambah"
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Daftar Tugas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTaskScreen(kelompokId: kelompok.id),
                  ),
                );
                if (result == true) {
                  setState(() {});
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                '+ Tambah',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),

        // List Tugas
        if (kelompok.tugasList.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40),
            alignment: Alignment.center,
            child: const Text(
              'Belum ada tugas dibuat.',
              style: TextStyle(color: Color(0xFF64748B)),
            ),
          )
        else
          ...kelompok.tugasList.map((tugas) {
            return TugasCard(
              tugas: tugas,
              onToggle: () {
                setState(() {
                  MockDatabase.toggleTugasSelesai(kelompok.id, tugas.id);
                });
              },
              onTap: () {
                _navigateToTaskDetail(tugas);
              },
            );
          }),
      ],
    );
  }

  // Widget Tab Anggota
  Widget _buildAnggotaTab(KelompokModel kelompok) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${kelompok.anggotaList.length} Anggota',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MembersScreen(kelompokId: kelompok.id),
                  ),
                );
                setState(() {});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                '+ Kelola',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...kelompok.anggotaList.map((anggota) {
          final isOwner = anggota.role.toLowerCase().contains('pemilik') ||
              anggota.role.toLowerCase().contains('ketua');
          return InkWell(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MembersScreen(kelompokId: kelompok.id),
                ),
              );
              setState(() {});
            },
            borderRadius: BorderRadius.circular(14),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF8FAFC),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person, color: Color(0xFF1E293B), size: 28),
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
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          anggota.role,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isOwner)
                    const Icon(Icons.workspace_premium_outlined, color: Color(0xFF1E293B), size: 22)
                  else
                    const Icon(Icons.chevron_right, color: Color(0xFF94A3B8), size: 20),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  // Widget Tab File
  Widget _buildFileTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open_rounded,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          const Text(
            'Belum ada file diunggah',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Unggah dokumen pendukung untuk kelompok ini.',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToTaskDetail(TugasModel tugas) async {
    final isNotStarted = tugas.status == 'Belum Dimulai';
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => isNotStarted
            ? TaskDetailScreen(tugas: tugas, kelompokId: widget.kelompokId)
            : TaskProgressScreen(tugas: tugas, kelompokId: widget.kelompokId),
      ),
    );

    if (result != null) {
      setState(() {});
    }
  }
}
