// lib/screens/calendar_screen.dart

import 'package:flutter/material.dart';
import '../data/mock_database.dart';
import '../widgets/custom_bottom_nav.dart';
import 'task_detail_screen.dart';
import 'task_progress_screen.dart';

class CalendarScreen extends StatefulWidget {
  final ValueChanged<int>? onSwitchTab;

  const CalendarScreen({super.key, this.onSwitchTab});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final int _bottomNavIndex = 0; // Beranda tab selected as in screenshot
  int _selectedDay = 10;
  int _currentMonthIndex = 5; // 0-indexed: 5 = Juni
  final int _currentYear = 2026;

  final List<String> _months = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];

  // Highlighted deadlines in June 2026:
  // Solid blue: 10, 15, 18
  // Light blue: 20, 27
  final Set<int> _solidBlueDays = {10, 15, 18};
  final Set<int> _lightBlueDays = {20, 27};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAFC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF1E293B),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title: Kalender Deadline
              const Text(
                'Kalender Deadline',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 20),

              // Calendar Card Container
              _buildCalendarCard(),

              const SizedBox(height: 28),

              // Section: Terdekat
              const Text(
                'Terdekat',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),

              const SizedBox(height: 14),

              // Upcoming Deadlines Card
              _buildUpcomingCard(),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _bottomNavIndex,
        onTap: (index) {
          if (index == 0) {
            Navigator.pop(context);
          } else {
            Navigator.pop(context);
            if (widget.onSwitchTab != null) {
              widget.onSwitchTab!(index);
            }
          }
        },
      ),
    );
  }

  // Widget Kalender Card
  Widget _buildCalendarCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0x05000000),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header: <  Juni 2026  >
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: Color(0xFF2563EB), size: 24),
                onPressed: () {
                  setState(() {
                    if (_currentMonthIndex > 0) _currentMonthIndex--;
                  });
                },
              ),
              Text(
                '${_months[_currentMonthIndex]} $_currentYear',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: Color(0xFF2563EB), size: 24),
                onPressed: () {
                  setState(() {
                    if (_currentMonthIndex < 11) _currentMonthIndex++;
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Days of week row: Sen  Sel  Rab  Kam  Jum  Sab  Min
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _DayHeader(label: 'Sen'),
              _DayHeader(label: 'Sel'),
              _DayHeader(label: 'Rab'),
              _DayHeader(label: 'Kam'),
              _DayHeader(label: 'Jum'),
              _DayHeader(label: 'Sab'),
              _DayHeader(label: 'Min'),
            ],
          ),

          const SizedBox(height: 14),

          // Calendar Grid (35 cells: 1-30 Juni + 1-5 Juli)
          _buildMonthGrid(),
        ],
      ),
    );
  }

  Widget _buildMonthGrid() {
    final rows = [
      [1, 2, 3, 4, 5, 6, 7],
      [8, 9, 10, 11, 12, 13, 14],
      [15, 16, 17, 18, 19, 20, 21],
      [22, 23, 24, 25, 26, 27, 28],
      [29, 30, -1, -2, -3, -4, -5], // negative indicates next month days
    ];

    return Column(
      children: rows.map((week) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: week.map((day) {
              final isNextMonth = day < 0;
              final dayNumber = isNextMonth ? -day : day;
              final isSolidBlue = !isNextMonth && _solidBlueDays.contains(dayNumber);
              final isLightBlue = !isNextMonth && _lightBlueDays.contains(dayNumber);
              final isSelected = !isNextMonth && _selectedDay == dayNumber;

              return GestureDetector(
                onTap: () {
                  if (!isNextMonth) {
                    setState(() {
                      _selectedDay = dayNumber;
                    });
                  }
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSolidBlue
                        ? const Color(0xFF2563EB)
                        : (isLightBlue
                            ? const Color(0xFF60A5FA)
                            : (isSelected && !isSolidBlue && !isLightBlue
                                ? const Color(0xFFEFF6FF)
                                : Colors.transparent)),
                    border: (isSelected && !isSolidBlue && !isLightBlue)
                        ? Border.all(color: const Color(0xFF2563EB), width: 1.5)
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      '$dayNumber',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: (isSolidBlue || isLightBlue || isSelected)
                            ? FontWeight.bold
                            : FontWeight.w400,
                        color: (isSolidBlue || isLightBlue)
                            ? Colors.white
                            : (isNextMonth
                                ? const Color(0xFFCBD5E1)
                                : const Color(0xFF1E293B)),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  // Widget Section Terdekat Card
  Widget _buildUpcomingCard() {
    final upcomingList = [
      {
        'title': 'Desain UI/UX',
        'date': '10 Jun 2026',
        'color': const Color(0xFF1E293B), // Dark slate
        'kelompokId': 'kelompok_001',
        'taskId': 't1',
      },
      {
        'title': 'Frontend Web',
        'date': '12 Jun 2026',
        'color': const Color(0xFFE07A5F), // Terracotta / coral
        'kelompokId': 'kelompok_001',
        'taskId': 't2',
      },
      {
        'title': 'Backend API',
        'date': '15 Jun 2026',
        'color': const Color(0xFF38BDF8), // Sky blue
        'kelompokId': 'kelompok_001',
        'taskId': 't3',
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0x05000000),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < upcomingList.length; i++) ...[
            _buildUpcomingItem(
              title: upcomingList[i]['title'] as String,
              date: upcomingList[i]['date'] as String,
              dotColor: upcomingList[i]['color'] as Color,
              onTap: () {
                _navigateToTask(
                  upcomingList[i]['kelompokId'] as String,
                  upcomingList[i]['taskId'] as String,
                );
              },
            ),
            if (i < upcomingList.length - 1)
              const Divider(height: 1, indent: 56, endIndent: 16, color: Color(0xFFF1F5F9)),
          ],
        ],
      ),
    );
  }

  Widget _buildUpcomingItem({
    required String title,
    required String date,
    required Color dotColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: dotColor,
          shape: BoxShape.circle,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1E293B),
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 2.0),
        child: Text(
          date,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF64748B),
          ),
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Color(0xFF94A3B8),
        size: 20,
      ),
      onTap: onTap,
    );
  }

  void _navigateToTask(String kelompokId, String taskId) {
    final kelompok = MockDatabase.getKelompokById(kelompokId);
    if (kelompok == null) return;

    try {
      final tugas = kelompok.tugasList.firstWhere((t) => t.id == taskId);
      final isNotStarted = tugas.status == 'Belum Dimulai';
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => isNotStarted
              ? TaskDetailScreen(tugas: tugas, kelompokId: kelompokId)
              : TaskProgressScreen(tugas: tugas, kelompokId: kelompokId),
        ),
      );
    } catch (_) {}
  }
}

class _DayHeader extends StatelessWidget {
  final String label;

  const _DayHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1E293B),
          ),
        ),
      ),
    );
  }
}
