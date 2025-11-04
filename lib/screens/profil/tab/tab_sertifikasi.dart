import 'package:flutter/material.dart';

class TabSertifikasi extends StatefulWidget {
  const TabSertifikasi({super.key});

  @override
  State<TabSertifikasi> createState() => _TabSertifikasiState();
}

class _TabSertifikasiState extends State<TabSertifikasi> {
  // Controllers
  final _namaSertifikasiController = TextEditingController();
  final _lembagaController = TextEditingController();
  final _tanggalTerbitController = TextEditingController();
  final _tanggalHabisController = TextEditingController();
  final _nomorSertifikatController = TextEditingController();
  final _urlSertifikatController = TextEditingController();

  @override
  void dispose() {
    _namaSertifikasiController.dispose();
    _lembagaController.dispose();
    _tanggalTerbitController.dispose();
    _tanggalHabisController.dispose();
    _nomorSertifikatController.dispose();
    _urlSertifikatController.dispose();
    super.dispose();
  }

  void _clearControllers() {
    _namaSertifikasiController.clear();
    _lembagaController.clear();
    _tanggalTerbitController.clear();
    _tanggalHabisController.clear();
    _nomorSertifikatController.clear();
    _urlSertifikatController.clear();
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF113CEE),
              onPrimary: Colors.white,
              onSurface: Color(0xFF515151),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      controller.text =
          "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
    }
  }

  void _showAddEditModal({Map<String, dynamic>? data, bool isEdit = false}) {
    if (data != null) {
      _namaSertifikasiController.text = data['nama'] ?? '';
      _lembagaController.text = data['lembaga'] ?? '';
      _tanggalTerbitController.text = data['tanggalTerbit'] ?? '';
      _tanggalHabisController.text = data['tanggalHabis'] ?? '';
      _nomorSertifikatController.text = data['nomor'] ?? '';
      _urlSertifikatController.text = data['url'] ?? '';
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
                      isEdit ? 'Edit Data Sertifikasi' : 'Tambah Data Sertifikasi',
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
                              'Isi semua informasi sertifikasi Anda dengan lengkap dan akurat. Data ini akan ditampilkan pada profil Anda.',
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
                      controller: _namaSertifikasiController,
                      label: 'Nama Sertifikasi',
                      hint: 'Contoh: Sertifikasi Data Analyst',
                      icon: Icons.workspace_premium_outlined,
                      required: true,
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _lembagaController,
                      label: 'Lembaga Sertifikasi',
                      hint: 'Contoh: BNSP, Cisco, Microsoft',
                      icon: Icons.business_outlined,
                      required: true,
                    ),
                    const SizedBox(height: 16),

                    _buildDateField(
                      controller: _tanggalTerbitController,
                      label: 'Tanggal Terbit',
                      hint: 'dd/mm/yyyy',
                      required: true,
                    ),
                    const SizedBox(height: 16),

                    _buildDateField(
                      controller: _tanggalHabisController,
                      label: 'Tanggal Habis Masa Berlaku',
                      hint: 'dd/mm/yyyy',
                      required: true,
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _nomorSertifikatController,
                      label: 'Nomor Sertifikat',
                      hint: 'Contoh: 12345/DS/2024',
                      icon: Icons.badge_outlined,
                      required: true,
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _urlSertifikatController,
                      label: 'URL Sertifikat Penghargaan',
                      hint: 'https://contoh.com/sertifikat.pdf',
                      icon: Icons.link,
                      keyboardType: TextInputType.url,
                      maxLength: 255,
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
                            'Hapus Sertifikasi',
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
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int? maxLength,
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
          keyboardType: keyboardType,
          maxLength: maxLength,
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
            counterText: maxLength != null ? '0 / $maxLength karakter' : null,
            counterStyle: const TextStyle(
              fontSize: 12,
              color: Color(0xFF515151),
              fontFamily: 'Poppins',
            ),
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

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool required = false,
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
          readOnly: true,
          onTap: () => _selectDate(context, controller),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14,
              fontFamily: 'Poppins',
            ),
            prefixIcon: Icon(
              Icons.calendar_today_outlined,
              color: Colors.grey.shade600,
              size: 20,
            ),
            suffixIcon: Icon(
              Icons.calendar_today,
              color: Colors.grey.shade600,
              size: 20,
            ),
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
          'Hapus Sertifikasi',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus ${data['nama']}?',
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

          // Sertifikasi Items
          _buildSertifikasiItem(
            title: 'Google UX Design Certificate',
            institution: 'Google Career Certificates',
            date: '1 Jan 2023 - 2 Jan 2023',
            isFirst: true,
            onEdit: () {
              _showAddEditModal(
                data: {
                  'nama': 'Google UX Design Certificate',
                  'lembaga': 'Google Career Certificates',
                  'tanggalTerbit': '01/01/2023',
                  'tanggalHabis': '02/01/2023',
                  'nomor': '12345/DS/2024',
                  'url': '',
                },
                isEdit: true,
              );
            },
          ),
          _buildSertifikasiItem(
            title: 'Google UX Design Certificate',
            institution: 'Google Career Certificates',
            date: '1 Jan 2023 - 2 Jan 2023',
            isLast: true,
            onEdit: () {
              _showAddEditModal(
                data: {
                  'nama': 'Google UX Design Certificate',
                  'lembaga': 'Google Career Certificates',
                  'tanggalTerbit': '01/01/2023',
                  'tanggalHabis': '02/01/2023',
                  'nomor': '12345/DS/2024',
                  'url': '',
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

  Widget _buildSertifikasiItem({
    required String title,
    required String institution,
    required String date,
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
                    const Text(
                      'Lihat sertifikat',
                      style: TextStyle(
                        color: Color(0xFF0E38EB),
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      date,
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