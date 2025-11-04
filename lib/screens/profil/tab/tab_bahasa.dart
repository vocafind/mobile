import 'package:flutter/material.dart';

class TabBahasa extends StatefulWidget {
  const TabBahasa({super.key});

  @override
  State<TabBahasa> createState() => _TabBahasaState();
}

class _TabBahasaState extends State<TabBahasa> {
  // Controllers
  final _namaBahasaController = TextEditingController();
  final _sertifikatController = TextEditingController();
  final _skorController = TextEditingController();
  final _urlSertifikatController = TextEditingController();
  String _selectedLevel = 'Beginner';

  @override
  void dispose() {
    _namaBahasaController.dispose();
    _sertifikatController.dispose();
    _skorController.dispose();
    _urlSertifikatController.dispose();
    super.dispose();
  }

  void _clearControllers() {
    _namaBahasaController.clear();
    _sertifikatController.clear();
    _skorController.clear();
    _urlSertifikatController.clear();
    _selectedLevel = 'Beginner';
  }

  void _showAddEditModal({Map<String, dynamic>? data, bool isEdit = false}) {
    if (data != null) {
      _namaBahasaController.text = data['bahasa'] ?? '';
      _selectedLevel = data['level'] ?? 'Beginner';
      _sertifikatController.text = data['sertifikat'] ?? '';
      _skorController.text = data['skor'] ?? '';
      _urlSertifikatController.text = data['urlSertifikat'] ?? '';
    } else {
      _clearControllers();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        isEdit ? 'Edit Bahasa' : 'Tambah Bahasa',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: Simpan data ke database/state management
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Simpan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Form
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Keterangan
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFF81C784)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: Color(0xFF388E3C),
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Tambahkan kemampuan bahasa yang Anda kuasai. Sertakan sertifikat jika ada untuk meningkatkan kredibilitas.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green.shade900,
                                  fontFamily: 'Poppins',
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      _buildTextField(
                        controller: _namaBahasaController,
                        label: 'Nama Bahasa',
                        hint: 'Contoh: English, Mandarin, Japanese',
                        icon: Icons.language,
                        required: true,
                      ),
                      const SizedBox(height: 16),

                      // Tingkat Kemampuan
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Text(
                                'Tingkat Kemampuan',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                  color: Color(0xFF515151),
                                ),
                              ),
                              Text(
                                ' *',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: ['Beginner', 'Intermediate', 'Advanced', 'Fluent', 'Native']
                                .map((level) {
                              final isSelected = _selectedLevel == level;
                              return GestureDetector(
                                onTap: () {
                                  setModalState(() {
                                    _selectedLevel = level;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF113CEE)
                                        : Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFF113CEE)
                                          : Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Text(
                                    level,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : const Color(0xFF515151),
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      _buildTextField(
                        controller: _sertifikatController,
                        label: 'Nama Sertifikat',
                        hint: 'Contoh: TOEFL, IELTS, JLPT N3',
                        icon: Icons.workspace_premium_outlined,
                        helperText: 'Opsional - Tambahkan jika memiliki sertifikat',
                      ),
                      const SizedBox(height: 16),

                      _buildTextField(
                        controller: _skorController,
                        label: 'Skor/Nilai',
                        hint: 'Contoh: 550, 7.5, Band 8',
                        icon: Icons.grade_outlined,
                        keyboardType: TextInputType.text,
                        helperText: 'Opsional - Skor dari sertifikat',
                      ),
                      const SizedBox(height: 16),

                      _buildTextField(
                        controller: _urlSertifikatController,
                        label: 'URL Sertifikat',
                        hint: 'Contoh: https://drive.google.com/file/xxx',
                        icon: Icons.link,
                        keyboardType: TextInputType.url,
                        helperText: 'Opsional - Link menuju file sertifikat',
                      ),

                      // Tombol Hapus (hanya untuk edit)
                      if (isEdit) ...[
                        const SizedBox(height: 32),
                        Center(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _showDeleteConfirmation(data!);
                            },
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            label: const Text(
                              'Hapus Bahasa',
                              style: TextStyle(
                                color: Colors.red,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.red),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    bool required = false,
    String? helperText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
                color: Color(0xFF515151),
              ),
            ),
            if (required)
              const Text(
                ' *',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14,
              fontFamily: 'Poppins',
            ),
            prefixIcon: Icon(icon, color: Colors.grey.shade600, size: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF113CEE), width: 2),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            helperText: helperText,
            helperStyle: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: const Text(
          'Hapus Bahasa',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus ${data['bahasa']}?',
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Poppins',
            color: Color(0xFF515151),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Batal',
              style: TextStyle(
                color: Color(0xFF515151),
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // TODO: Hapus data dari database/state management
              Navigator.pop(context);
            },
            child: const Text(
              'Hapus',
              style: TextStyle(
                color: Colors.red,
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 20),
      child: Column(
        children: [
          // Tombol Tambah
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => _showAddEditModal(),
              child: Container(
                width: 39,
                height: 39,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF113CEE), width: 1),
                ),
                child: const Center(
                  child: Text(
                    '+',
                    style: TextStyle(
                      color: Color(0xFF0C32E8),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 21),

          // Language Items
          _buildBahasaItem(
            language: 'English',
            level: 'Beginner',
            certificate: 'TOEFL',
            score: 'Skor : 550',
            isFirst: true,
            onEdit: () {
              _showAddEditModal(
                data: {
                  'bahasa': 'English',
                  'level': 'Beginner',
                  'sertifikat': 'TOEFL',
                  'skor': '550',
                  'urlSertifikat': '',
                },
                isEdit: true,
              );
            },
          ),
          _buildBahasaItem(
            language: 'Japanese',
            level: 'Native',
            certificate: 'JLPT N1',
            score: 'Skor : 180',
            isLast: true,
            onEdit: () {
              _showAddEditModal(
                data: {
                  'bahasa': 'Japanese',
                  'level': 'Native',
                  'sertifikat': 'JLPT N1',
                  'skor': '180',
                  'urlSertifikat': '',
                },
                isEdit: true,
              );
            },
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildBahasaItem({
    required String language,
    required String level,
    required String certificate,
    required String score,
    bool isFirst = false,
    bool isLast = false,
    VoidCallback? onEdit,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isLast ? Colors.transparent : const Color(0xFFE9E9E9),
            width: 1,
          ),
        ),
        borderRadius: isFirst
            ? const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              )
            : isLast
                ? const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  )
                : BorderRadius.zero,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      language,
                      style: const TextStyle(
                        color: Color(0xFF515151),
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE2E2E2)),
                      ),
                      child: Text(
                        level,
                        style: const TextStyle(
                          color: Color(0xFF464E5E),
                          fontSize: 10,
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  certificate,
                  style: const TextStyle(
                    color: Color(0xFF515151),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  score,
                  style: const TextStyle(
                    color: Color(0xFF515151),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: onEdit,
            child: Icon(
              Icons.edit_outlined,
              size: 20,
              color: Colors.black.withValues(alpha: 0.62),
            ),
          ),
        ],
      ),
    );
  }
}