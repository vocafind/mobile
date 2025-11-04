import 'package:flutter/material.dart';

class TabPendidikan extends StatefulWidget {
  const TabPendidikan({super.key});

  @override
  State<TabPendidikan> createState() => _TabPendidikanState();
}

class _TabPendidikanState extends State<TabPendidikan> {
  // Controllers
  final _jenjangController = TextEditingController();
  final _jurusanController = TextEditingController();
  final _institusiController = TextEditingController();
  final _tahunMulaiController = TextEditingController();
  final _tahunSelesaiController = TextEditingController();
  final _nilaiAkhirController = TextEditingController();

  @override
  void dispose() {
    _jenjangController.dispose();
    _jurusanController.dispose();
    _institusiController.dispose();
    _tahunMulaiController.dispose();
    _tahunSelesaiController.dispose();
    _nilaiAkhirController.dispose();
    super.dispose();
  }

  void _clearControllers() {
    _jenjangController.clear();
    _jurusanController.clear();
    _institusiController.clear();
    _tahunMulaiController.clear();
    _tahunSelesaiController.clear();
    _nilaiAkhirController.clear();
  }

  void _showPendidikanModal({Map<String, dynamic>? data, bool isEdit = false}) {
    if (data != null) {
      _jenjangController.text = data['jenjang'] ?? '';
      _jurusanController.text = data['jurusan'] ?? '';
      _institusiController.text = data['institusi'] ?? '';
      _tahunMulaiController.text = data['tahunMulai'] ?? '';
      _tahunSelesaiController.text = data['tahunSelesai'] ?? '';
      _nilaiAkhirController.text = data['nilaiAkhir'] ?? '';
    } else {
      _clearControllers();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
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
                      isEdit ? 'Edit Pendidikan' : 'Tambah Pendidikan',
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
                        color: const Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF90CAF9)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: Color(0xFF1976D2),
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Isi semua informasi pendidikan Anda dengan lengkap dan akurat. Data ini akan ditampilkan pada profil Anda.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue.shade900,
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
                      controller: _jenjangController,
                      label: 'Jenjang Pendidikan',
                      hint: 'Contoh: D4, S1, S2, S3',
                      icon: Icons.school_outlined,
                      required: true,
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _jurusanController,
                      label: 'Jurusan/Program Studi',
                      hint: 'Contoh: Teknologi Rekayasa Perangkat Lunak',
                      icon: Icons.menu_book_outlined,
                      required: true,
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _institusiController,
                      label: 'Nama Institusi',
                      hint: 'Contoh: Politeknik Negeri Batam',
                      icon: Icons.apartment_outlined,
                      required: true,
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _tahunMulaiController,
                            label: 'Tahun Mulai',
                            hint: 'YYYY',
                            icon: Icons.calendar_today_outlined,
                            keyboardType: TextInputType.number,
                            required: true,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            controller: _tahunSelesaiController,
                            label: 'Tahun Selesai',
                            hint: 'YYYY',
                            icon: Icons.event_outlined,
                            keyboardType: TextInputType.number,
                            required: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _nilaiAkhirController,
                      label: 'Nilai Akhir',
                      hint: 'Contoh: 3.75 atau 4.00',
                      icon: Icons.grade_outlined,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      required: true,
                      helperText: 'Isi dengan IPK atau rata-rata nilai akhir',
                    ),
                  ],
                ),
              ),
            ),
          ],
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 20),
      child: Column(
        children: [
          // Add Button
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => _showPendidikanModal(),
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

          // Education Items
          _buildPendidikanItem(
            title: 'D4 Teknologi Rekayasa Peran...',
            institution: 'Politeknik Negeri Batam',
            year: '2019 - 2023',
            grade: 'Nilai akhir : 4.00',
            isFirst: true,
            onEdit: () {
              _showPendidikanModal(
                data: {
                  'jenjang': 'D4',
                  'jurusan': 'Teknologi Rekayasa Perangkat Lunak',
                  'institusi': 'Politeknik Negeri Batam',
                  'tahunMulai': '2019',
                  'tahunSelesai': '2023',
                  'nilaiAkhir': '4.00',
                },
                isEdit: true,
              );
            },
          ),
          _buildPendidikanItem(
            title: 'D3 Informatika',
            institution: 'Politeknik Negeri Batam',
            year: '2019 - 2023',
            grade: 'Nilai akhir : 4.00',
            isLast: true,
            onEdit: () {
              _showPendidikanModal(
                data: {
                  'jenjang': 'D3',
                  'jurusan': 'Informatika',
                  'institusi': 'Politeknik Negeri Batam',
                  'tahunMulai': '2019',
                  'tahunSelesai': '2023',
                  'nilaiAkhir': '4.00',
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

  Widget _buildPendidikanItem({
    required String title,
    required String institution,
    required String year,
    required String grade,
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
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF515151),
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  institution,
                  style: const TextStyle(
                    color: Color(0xFF515151),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      year,
                      style: const TextStyle(
                        color: Color(0xFF515151),
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      grade,
                      style: const TextStyle(
                        color: Color(0xFF515151),
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
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