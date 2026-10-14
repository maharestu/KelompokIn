import 'anggota_model.dart';

class TugasModel {
  final String id;
  final String kelompokId;
  final String judul;
  final String deskripsi;
  final String deadline;
  final String status;
  final String? assignedToNama;
  final List<AnggotaModel> assignedAnggotaList;
  final double progress; // 0.0 to 1.0
  bool isCompleted;

  TugasModel({
    required this.id,
    required this.kelompokId,
    required this.judul,
    this.deskripsi = '',
    required this.deadline,
    this.status = 'Belum Dimulai',
    this.assignedToNama,
    this.assignedAnggotaList = const [],
    this.progress = 0.0,
    this.isCompleted = false,
  });

  TugasModel copyWith({
    String? id,
    String? kelompokId,
    String? judul,
    String? deskripsi,
    String? deadline,
    String? status,
    String? assignedToNama,
    List<AnggotaModel>? assignedAnggotaList,
    double? progress,
    bool? isCompleted,
  }) {
    return TugasModel(
      id: id ?? this.id,
      kelompokId: kelompokId ?? this.kelompokId,
      judul: judul ?? this.judul,
      deskripsi: deskripsi ?? this.deskripsi,
      deadline: deadline ?? this.deadline,
      status: status ?? this.status,
      assignedToNama: assignedToNama ?? this.assignedToNama,
      assignedAnggotaList: assignedAnggotaList ?? this.assignedAnggotaList,
      progress: progress ?? this.progress,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
