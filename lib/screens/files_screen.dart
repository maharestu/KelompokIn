// lib/screens/files_screen.dart

import 'package:flutter/material.dart';
import '../data/mock_database.dart';

class FilesScreen extends StatefulWidget {
  final ValueChanged<int>? onSwitchTab;

  const FilesScreen({super.key, this.onSwitchTab});

  @override
  State<FilesScreen> createState() => _FilesScreenState();
}

class _FilesScreenState extends State<FilesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showUploadDialog() {
    final fileNameController = TextEditingController();
    String selectedExt = '.pdf';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              'Upload File',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: fileNameController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'Nama File',
                    hintText: 'Misal: Dokumen_Revisi',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: selectedExt,
                  decoration: InputDecoration(
                    labelText: 'Format File',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: '.pdf', child: Text('PDF Document (.pdf)')),
                    DropdownMenuItem(value: '.fig', child: Text('Figma File (.fig)')),
                    DropdownMenuItem(value: '.zip', child: Text('ZIP Archive (.zip)')),
                    DropdownMenuItem(value: '.png', child: Text('Image (.png)')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setDialogState(() {
                        selectedExt = val;
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
                  final name = fileNameController.text.trim();
                  if (name.isNotEmpty) {
                    final cleanExt = selectedExt.replaceAll('.', '');
                    final newFile = {
                      'title': '$name$selectedExt',
                      'date': 'Hari ini',
                      'size': '2.0 MB',
                      'type': cleanExt,
                    };
                    MockDatabase.addFile(newFile);
                    Navigator.pop(context);
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('File $name$selectedExt berhasil diupload!')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Upload', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showFileOptions(Map<String, String> file) {
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
                  leading: const Icon(Icons.download_rounded, color: Color(0xFF2563EB)),
                  title: Text('Unduh ${file['title']}'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Mengunduh ${file['title']}...')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.share_outlined, color: Color(0xFF1E293B)),
                  title: const Text('Bagikan File'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tautan file disalin ke papan klip!')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  title: const Text('Hapus File', style: TextStyle(color: Colors.redAccent)),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      MockDatabase.removeFile(file['title']!);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${file['title']} telah dihapus')),
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

  IconData _getFileIcon(String? type, String? title) {
    final t = type?.toLowerCase() ?? '';
    final name = title?.toLowerCase() ?? '';
    if (t == 'pdf' || name.endsWith('.pdf')) {
      return Icons.article_outlined;
    } else if (t == 'fig' || name.endsWith('.fig')) {
      return Icons.insert_drive_file_outlined;
    } else if (t == 'zip' || name.endsWith('.zip')) {
      return Icons.folder_zip_outlined;
    } else if (t == 'png' || t == 'jpg' || name.endsWith('.png') || name.endsWith('.jpg')) {
      return Icons.image_outlined;
    }
    return Icons.insert_drive_file_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final allFiles = MockDatabase.getFiles();
    final filteredFiles = _searchQuery.isEmpty
        ? allFiles
        : allFiles.where((f) {
            return f['title']!.toLowerCase().contains(_searchQuery.toLowerCase());
          }).toList();

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
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else if (widget.onSwitchTab != null) {
              widget.onSwitchTab!(0); // kembali ke beranda
            }
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title: File
              const Text(
                'File',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 18),

              // Search Bar: Cari file...
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFF1E293B),
                    width: 1.1,
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
                    hintText: 'Cari file...',
                    hintStyle: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 15,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Color(0xFF1E293B),
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

              const SizedBox(height: 24),

              // Files List
              Expanded(
                child: filteredFiles.isEmpty
                    ? Center(
                        child: Text(
                          _searchQuery.isEmpty ? 'Belum ada file' : 'File tidak ditemukan',
                          style: const TextStyle(color: Color(0xFF64748B), fontSize: 15),
                        ),
                      )
                    : ListView.separated(
                        itemCount: filteredFiles.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final file = filteredFiles[index];
                          final iconData = _getFileIcon(file['type'], file['title']);

                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFF1E293B),
                                width: 1.1,
                              ),
                            ),
                            child: Row(
                              children: [
                                // Rounded square file icon outline
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFF1E293B),
                                      width: 1.1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      iconData,
                                      color: const Color(0xFF1E293B),
                                      size: 26,
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 14),

                                // File title and date/size
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        file['title']!,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1E293B),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${file['date']} · ${file['size']}',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF64748B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Three dots ⋮
                                IconButton(
                                  icon: const Icon(
                                    Icons.more_vert,
                                    color: Color(0xFF64748B),
                                    size: 22,
                                  ),
                                  onPressed: () => _showFileOptions(file),
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
      ),

      // Floating button: + Upload
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 12.0, right: 8.0),
        child: SizedBox(
          height: 48,
          child: ElevatedButton(
            onPressed: _showUploadDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              elevation: 4,
              shadowColor: const Color(0x4D2563EB),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 22),
            ),
            child: const Text(
              '+ Upload',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
