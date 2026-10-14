// lib/screens/members_screen.dart

import 'package:flutter/material.dart';
import '../data/mock_database.dart';
import '../models/anggota_model.dart';
import '../models/kelompok_model.dart';

class MembersScreen extends StatefulWidget {
  final String kelompokId;

  const MembersScreen({super.key, required this.kelompokId});

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  void _showAddMemberDialog() {
    final nameController = TextEditingController();
    String selectedRole = 'Anggota';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              'Tambah Anggota',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'Nama Lengkap',
                    hintText: 'Misal: Budi Santoso',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: selectedRole,
                  decoration: InputDecoration(
                    labelText: 'Peran (Role)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Anggota', child: Text('Anggota')),
                    DropdownMenuItem(value: 'Frontend', child: Text('Frontend')),
                    DropdownMenuItem(value: 'Backend', child: Text('Backend')),
                    DropdownMenuItem(value: 'UI/UX Designer', child: Text('UI/UX Designer')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setDialogState(() {
                        selectedRole = val;
                      });
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () {
                  final name = nameController.text.trim();
                  if (name.isNotEmpty) {
                    final newAnggota = AnggotaModel(
                      id: 'g_${DateTime.now().millisecondsSinceEpoch}',
                      nama: name,
                      role: selectedRole,
                    );
                    MockDatabase.addAnggota(widget.kelompokId, newAnggota);
                    Navigator.pop(context);
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$name berhasil ditambahkan!')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Tambah', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showMemberOptions(AnggotaModel anggota) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.badge_outlined, color: Color(0xFF1E293B)),
                  title: Text('Ubah Peran: ${anggota.nama}'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Ubah peran anggota')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person_remove_outlined, color: Colors.redAccent),
                  title: const Text('Keluarkan dari Kelompok', style: TextStyle(color: Colors.redAccent)),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      MockDatabase.removeAnggota(widget.kelompokId, anggota.id);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${anggota.nama} telah dikeluarkan')),
                    );
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
    final List<AnggotaModel> anggotaList = kelompok?.anggotaList ?? [];

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
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section: Title "Anggota", Subtitle "5 anggota", Button "+ Tambah"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Anggota',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${anggotaList.length} anggota',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: _showAddMemberDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
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
            ),

            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xFFE2E8F0)),

            // Member list
            Expanded(
              child: ListView.separated(
                itemCount: anggotaList.length,
                separatorBuilder: (context, index) => const Divider(
                  height: 1,
                  color: Color(0xFFF1F5F9),
                  indent: 20,
                  endIndent: 20,
                ),
                itemBuilder: (context, index) {
                  final anggota = anggotaList[index];
                  final isOwner = anggota.role.toLowerCase().contains('pemilik') ||
                      anggota.role.toLowerCase().contains('ketua') ||
                      index == 0;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    child: Row(
                      children: [
                        // Person silhouette in circle
                        Container(
                          width: 46,
                          height: 46,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF8FAFC),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.person,
                              size: 30,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Nama & Role
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                anggota.nama,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                anggota.role,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Trailing: Crown for owner, ⋮ for others
                        if (isOwner)
                          const Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: _CrownIcon(),
                          )
                        else
                          IconButton(
                            icon: const Icon(
                              Icons.more_vert,
                              color: Color(0xFF1E293B),
                              size: 22,
                            ),
                            onPressed: () => _showMemberOptions(anggota),
                          ),
                      ],
                    ),
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

/// Custom painted crown icon matching the design screenshot
class _CrownIcon extends StatelessWidget {
  const _CrownIcon();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(22, 18),
      painter: _CrownPainter(),
    );
  }
}

class _CrownPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1E293B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    // Bottom curve
    path.moveTo(1, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.5, size.height * 0.9, size.width - 1, size.height * 0.7);
    // Up to right peak
    path.lineTo(size.width - 2, size.height * 0.2);
    // Down to middle right notch
    path.lineTo(size.width * 0.7, size.height * 0.5);
    // Up to center peak
    path.lineTo(size.width * 0.5, 1);
    // Down to middle left notch
    path.lineTo(size.width * 0.3, size.height * 0.5);
    // Up to left peak
    path.lineTo(2, size.height * 0.2);
    // Close to bottom left
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
