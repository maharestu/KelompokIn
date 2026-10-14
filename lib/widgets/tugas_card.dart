// lib/widgets/tugas_card.dart

import 'package:flutter/material.dart';
import '../models/tugas_model.dart';

class TugasCard extends StatelessWidget {
  final TugasModel tugas;
  final VoidCallback onToggle;
  final VoidCallback? onTap;

  const TugasCard({
    super.key,
    required this.tugas,
    required this.onToggle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.015),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                // Radio/Check circle toggle
                GestureDetector(
                  onTap: onToggle,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    child: Icon(
                      tugas.isCompleted
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked,
                      color: tugas.isCompleted
                          ? const Color(0xFF2563EB)
                          : const Color(0xFF64748B),
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Title & Deadline
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tugas.judul,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: tugas.isCompleted
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF1E293B),
                          decoration: tugas.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Deadline: ${tugas.deadline}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                // Person Silhouette Icon
                Tooltip(
                  message: tugas.assignedToNama ?? 'Belum ada anggota',
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    child: const Icon(
                      Icons.person,
                      color: Color(0xFF1E293B),
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
