// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import '../data/mock_database.dart';
import '../models/kelompok_model.dart';
import '../widgets/kelompok_card.dart';
import '../widgets/section_header.dart';
import 'create_group_screen.dart';
import 'group_detail_screen.dart';
import 'notification_screen.dart';
import 'calendar_screen.dart';

class HomeScreen extends StatefulWidget {
  final ValueChanged<int>? onSwitchTab;

  const HomeScreen({super.key, this.onSwitchTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<KelompokModel> allKelompok = MockDatabase.getKelompokList();
    final filteredKelompok = _searchQuery.isEmpty
        ? allKelompok
        : allKelompok.where((k) {
            final query = _searchQuery.toLowerCase();
            final matchName = k.nama.toLowerCase().contains(query);
            final matchTask = k.tugasList.any((t) => t.judul.toLowerCase().contains(query));
            return matchName || matchTask;
          }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),

              // Header KelompokIn + Calendar + Bell Notification
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'KelompokIn',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                      letterSpacing: -0.5,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.calendar_month_outlined,
                          color: Color(0xFF1E293B),
                          size: 26,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CalendarScreen(
                                onSwitchTab: widget.onSwitchTab,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.notifications_none_rounded,
                          color: Color(0xFF1E293B),
                          size: 26,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                    width: 1.2,
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val.trim();
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Cari kelompok atau tugas...',
                    hintStyle: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 15,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: Color(0xFF64748B),
                      size: 22,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Section Header: Kelompok Saya & Lihat Semua
              SectionHeader(
                title: 'Kelompok Saya',
                actionTitle: 'Lihat Semua',
                onActionTap: () {
                  if (widget.onSwitchTab != null) {
                    widget.onSwitchTab!(1); // Beralih ke tab tugas
                  }
                },
              ),

              const SizedBox(height: 16),

              // List Card Kelompok
              if (filteredKelompok.isEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 36),
                  alignment: Alignment.center,
                  child: const Text(
                    'Tidak ada kelompok ditemukan.',
                    style: TextStyle(color: Color(0xFF64748B)),
                  ),
                )
              else
                ...filteredKelompok.map((kelompok) {
                  return KelompokCard(
                    kelompok: kelompok,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GroupDetailScreen(
                            kelompokId: kelompok.id,
                            onSwitchTab: widget.onSwitchTab,
                          ),
                        ),
                      );
                      setState(() {});
                    },
                  );
                }),

              const SizedBox(height: 12),

              // Tombol "+ Buat Kelompok Baru"
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateGroupScreen(),
                      ),
                    );
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),
                  child: const Text(
                    '+ Buat Kelompok Baru',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
