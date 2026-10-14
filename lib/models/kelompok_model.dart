// lib/models/kelompok_model.dart

import 'anggota_model.dart';
import 'tugas_model.dart';

class KelompokModel {
  final String id;
  final String nama;
  final String deskripsi;
  final List<AnggotaModel> anggotaList;
  final List<TugasModel> tugasList;

  KelompokModel({
    required this.id,
    required this.nama,
    this.deskripsi = '',
    required this.anggotaList,
    required this.tugasList,
  });

  int get totalAnggota => anggotaList.length;
  int get totalTugas => tugasList.length;
}
