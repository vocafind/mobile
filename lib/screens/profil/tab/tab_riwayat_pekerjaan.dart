import 'package:flutter/material.dart';

class TabRiwayatPekerjaan extends StatefulWidget {
  const TabRiwayatPekerjaan({super.key});

  @override
  State<TabRiwayatPekerjaan> createState() => _TabRiwayatPekerjaanState();
}

class _TabRiwayatPekerjaanState extends State<TabRiwayatPekerjaan> {
  // Controllers
  final _posisiController = TextEditingController();
  final _perusahaanController = TextEditingController();
  final _deskripsiController = TextEditingController();
  DateTime? _tanggalMulai;
  DateTime? _tanggalSelesai;

  @override
  void dispose() {
    _posisiController.dispose();
    _perusahaanController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  void _clearControllers() {
    _posisiController.clear();
    _perusahaanController.clear();
    _deskripsiController.clear();
    _tanggalMulai = null;
    _tanggalSelesai = null;
  }

  void _showAddEditModal({Map<String, dynamic>? data, bool isEdit = false}) {
    if (data != null) {
      _posisiController.text = data['posisi'] ?? '';
      _perusahaanController.text = data['perusahaan'] ?? '';
      _deskripsiController.text = data['deskripsi'] ?? '';
      _tanggalMulai = data['tanggalMulai'];
      _tanggalSelesai = data['tanggalSelesai'];
    } else {
      _clearControllers();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
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
                        isEdit ? 'Edit Riwayat Pekerjaan' : 'Tambah Riwayat Pekerjaan',
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
                                'Tambahkan riwayat pekerjaan Anda untuk menunjukkan pengalaman profesional kepada perekrut.',
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
                        controller: _posisiController,
                        label: 'Posisi',
                        hint: 'Contoh: Graphic Designer',
                        icon: Icons.work_outline,
                        required: true,
                      ),
                      const SizedBox(height: 16),

                      _buildTextField(
                        controller: _perusahaanController,
                        label: 'Perusahaan',
                        hint: 'Contoh: Google',
                        icon: Icons.business_outlined,
                        required: true,
                      ),
                      const SizedBox(height: 16),

                      // Tanggal Mulai
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Text(
                                'Tanggal Mulai',
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
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: _tanggalMulai ?? DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: const ColorScheme.light(
                                        primary: Color(0xFF113CEE),
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (date != null) {
                                setModalState(() {
                                  _tanggalMulai = date;
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.calendar_today_outlined, 
                                    color: Colors.grey.shade600, 
                                    size: 20
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    _tanggalMulai != null
                                        ? '${_tanggalMulai!.day}/${_tanggalMulai!.month}/${_tanggalMulai!.year}'
                                        : 'Pilih tanggal mulai',
                                    style: TextStyle(
                                      color: _tanggalMulai != null 
                                        ? const Color(0xFF515151)
                                        : Colors.grey.shade400,
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Tanggal Selesai
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Text(
                                'Tanggal Selesai',
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
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: _tanggalSelesai ?? DateTime.now(),
                                firstDate: _tanggalMulai ?? DateTime(1900),
                                lastDate: DateTime.now(),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: const ColorScheme.light(
                                        primary: Color(0xFF113CEE),
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (date != null) {
                                setModalState(() {
                                  _tanggalSelesai = date;
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.calendar_today_outlined, 
                                    color: Colors.grey.shade600, 
                                    size: 20
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    _tanggalSelesai != null
                                        ? '${_tanggalSelesai!.day}/${_tanggalSelesai!.month}/${_tanggalSelesai!.year}'
                                        : 'Pilih tanggal selesai',
                                    style: TextStyle(
                                      color: _tanggalSelesai != null 
                                        ? const Color(0xFF515151)
                                        : Colors.grey.shade400,
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      _buildTextField(
                        controller: _deskripsiController,
                        label: 'Deskripsi',
                        hint: 'Jelaskan tugas dan tanggung jawab Anda di posisi ini...',
                        icon: Icons.description_outlined,
                        maxLines: 5,
                        required: true,
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
                              'Hapus Riwayat Pekerjaan',
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
          'Hapus Riwayat Pekerjaan',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus ${data['posisi']} di ${data['perusahaan']}?',
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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

          // Riwayat Pekerjaan Items
          _buildRiwayatPekerjaanItem(
            position: 'Graphic Designer',
            company: 'Google',
            date: '1 Jan 2023 - 2 Jan 2023',
            description: 'Saya ahli dalam berbicara di depan umum, karena saya ahli berbicara.... ',
            isFirst: true,
            onEdit: () {
              _showAddEditModal(
                data: {
                  'posisi': 'Graphic Designer',
                  'perusahaan': 'Google',
                  'tanggalMulai': DateTime(2023, 1, 1),
                  'tanggalSelesai': DateTime(2023, 1, 2),
                  'deskripsi': 'Saya ahli dalam berbicara di depan umum, karena saya ahli berbicara di depan umum dengan baik dan benar.',
                },
                isEdit: true,
              );
            },
          ),
          _buildRiwayatPekerjaanItem(
            position: 'Graphic Designer',
            company: 'Google',
            date: '1 Jan 2023 - 2 Jan 2023',
            description: 'Saya ahli dalam berbicara di depan umum, karena saya ahli berbicara.... ',
            isLast: true,
            onEdit: () {
              _showAddEditModal(
                data: {
                  'posisi': 'Graphic Designer',
                  'perusahaan': 'Google',
                  'tanggalMulai': DateTime(2023, 1, 1),
                  'tanggalSelesai': DateTime(2023, 1, 2),
                  'deskripsi': 'Saya ahli dalam berbicara di depan umum, karena saya ahli berbicara di depan umum dengan baik dan benar.',
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

  Widget _buildRiwayatPekerjaanItem({
    required String position,
    required String company,
    required String date,
    required String description,
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
                  position,
                  style: const TextStyle(
                    color: Color(0xFF515151),
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  company,
                  style: const TextStyle(
                    color: Color(0xFF515151),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  date,
                  style: const TextStyle(
                    color: Color(0xFF515151),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xFF515151),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 1.7,
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