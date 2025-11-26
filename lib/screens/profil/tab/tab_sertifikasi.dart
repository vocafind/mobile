import 'package:flutter/material.dart';
import 'package:jobfair/api/api_service.dart';
import 'package:jobfair/models/talent_certification_model.dart';
import 'package:intl/intl.dart';

class TabSertifikasi extends StatefulWidget {
  const TabSertifikasi({super.key});

  @override
  State<TabSertifikasi> createState() => _TabSertifikasiState();
}

class _TabSertifikasiState extends State<TabSertifikasi> {
  final ApiService _apiService = ApiService();
  List<CertificationModel> _certifications = [];
  bool _isLoading = true;

  // Controllers
  final _namaSertifikasiController = TextEditingController();
  final _lembagaController = TextEditingController();
  final _tanggalTerbitController = TextEditingController();
  final _tanggalHabisController = TextEditingController();
  final _nomorSertifikatController = TextEditingController();
  final _urlSertifikatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCertifications();
  }

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

  Future<void> _loadCertifications() async {
    setState(() => _isLoading = true);
    try {
      final certifications = await _apiService.getCertification();
      setState(() {
        _certifications = certifications;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('Gagal memuat data sertifikasi', isError: true);
      print("Error load certifications: $e");
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: isError ? Colors.red[700] : Colors.green,
        behavior: SnackBarBehavior.floating,
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(
          textColor: Colors.white,
          label: 'Ok',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  // ✅ FUNGSI VALIDASI URL
  bool _isValidUrl(String url) {
    if (url.isEmpty) return true; // Opsional, jadi empty diizinkan
    try {
      final uri = Uri.tryParse(url);
      return uri != null &&
          uri.hasScheme &&
          (uri.scheme == 'http' || uri.scheme == 'https') &&
          uri.host.isNotEmpty;
    } catch (e) {
      return false;
    }
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

  DateTime? _parseDate(String dateStr) {
    try {
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        return DateTime(
          int.parse(parts[2]), // year
          int.parse(parts[1]), // month
          int.parse(parts[0]), // day
        );
      }
    } catch (e) {
      print("Error parsing date: $e");
    }
    return null;
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  String _formatDateRange(DateTime? start, DateTime? end) {
    if (start == null || end == null) return '-';
    final dateFormat = DateFormat('d MMM yyyy', 'id_ID');
    return '${dateFormat.format(start)} - ${dateFormat.format(end)}';
  }

  void _showAddEditModal({CertificationModel? certification}) {
    final isEdit = certification != null;
    bool isSaving = false;

    // Populate controllers if editing
    final TextEditingController _namaController = TextEditingController(
      text: certification?.namaSertifikasi ?? '',
    );
    final TextEditingController _lembagaController = TextEditingController(
      text: certification?.lembagaSertifikasi ?? '',
    );
    final TextEditingController _tanggalTerbitController =
        TextEditingController(text: _formatDate(certification?.tanggalTerbit));
    final TextEditingController _tanggalHabisController = TextEditingController(
      text: _formatDate(certification?.tanggalHabisMasa),
    );
    final TextEditingController _nomorController = TextEditingController(
      text: certification?.nomorSertifikat ?? '',
    );
    final TextEditingController _urlController = TextEditingController(
      text: certification?.sertifikat ?? '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: StatefulBuilder(
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
                        onPressed: isSaving
                            ? null
                            : () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Text(
                          isEdit
                              ? 'Edit Data Sertifikasi'
                              : 'Tambah Data Sertifikasi',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: isSaving
                            ? null
                            : () async {
                                final nama = _namaController.text.trim();
                                final lembaga = _lembagaController.text.trim();
                                final nomor = _nomorController.text.trim();
                                final url = _urlController.text.trim();

                                final tanggalTerbit = _parseDate(
                                  _tanggalTerbitController.text.trim(),
                                );
                                final tanggalHabis = _parseDate(
                                  _tanggalHabisController.text.trim(),
                                );

                                // ✅ VALIDASI URL JIKA DIISI
                                if (url.isNotEmpty && !_isValidUrl(url)) {
                                  _showSnackBar(
                                    "URL sertifikat harus lengkap dengan http:// atau https://",
                                    isError: true,
                                  );
                                  return;
                                }

                                if (nama.isEmpty ||
                                    lembaga.isEmpty ||
                                    nomor.isEmpty ||
                                    tanggalTerbit == null ||
                                    tanggalHabis == null) {
                                  _showSnackBar(
                                    "Lengkapi semua data wajib",
                                    isError: true,
                                  );
                                  return;
                                }

                                setModalState(() => isSaving = true);

                                final newCertification = CertificationModel(
                                  certificationId:
                                      certification?.certificationId,
                                  namaSertifikasi: nama,
                                  lembagaSertifikasi: lembaga,
                                  tanggalTerbit: tanggalTerbit,
                                  tanggalHabisMasa: tanggalHabis,
                                  nomorSertifikat: nomor,
                                  sertifikat: url,
                                );

                                try {
                                  if (isEdit) {
                                    await _apiService.updateCertification(
                                      certification.certificationId!,
                                      newCertification,
                                    );
                                    _showSnackBar(
                                      'Berhasil memperbarui sertifikasi',
                                    );
                                  } else {
                                    await _apiService.createCertification(
                                      newCertification,
                                    );
                                    _showSnackBar(
                                      'Berhasil menambah sertifikasi',
                                    );
                                  }

                                  await _loadCertifications();
                                  Navigator.pop(context);
                                } catch (e) {
                                  setModalState(() => isSaving = false);
                                  _showSnackBar(
                                    'Gagal menyimpan data',
                                    isError: true,
                                  );
                                  print("❌ Error submit certification: $e");
                                }
                              },
                        child: isSaving
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
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
                          controller: _namaController,
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
                          setModalState: setModalState,
                        ),
                        const SizedBox(height: 16),

                        _buildDateField(
                          controller: _tanggalHabisController,
                          label: 'Tanggal Habis Masa Berlaku',
                          hint: 'dd/mm/yyyy',
                          required: true,
                          setModalState: setModalState,
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _nomorController,
                          label: 'Nomor Sertifikat',
                          hint: 'Contoh: 12345/DS/2024',
                          icon: Icons.badge_outlined,
                          required: true,
                        ),
                        const SizedBox(height: 16),

                        // ✅ FIELD URL SERTIFIKAT DENGAN VALIDASI VISUAL (TANPA HELPER TEXT)
                        _buildUrlTextField(
                          controller: _urlController,
                          label: 'URL Sertifikat Penghargaan',
                          hint: 'https://contoh.com/sertifikat.pdf',
                          icon: Icons.link,
                        ),

                        // Tombol Hapus (hanya untuk edit)
                        if (isEdit) ...[
                          const SizedBox(height: 32),
                          Center(
                            child: OutlinedButton.icon(
                              onPressed: isSaving
                                  ? null
                                  : () {
                                      Navigator.pop(context);
                                      _showDeleteConfirmation(certification);
                                    },
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
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
        ),
      ),
    );
  }

  // ✅ WIDGET KHUSUS UNTUK URL TEXTFIELD DENGAN INDIKATOR VISUAL
  Widget _buildUrlTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.url,
          maxLength: 255,
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            counterText: '${controller.text.length} / 255 karakter',
            counterStyle: const TextStyle(
              fontSize: 12,
              color: Color(0xFF515151),
              fontFamily: 'Poppins',
            ),
            // ✅ INDIKATOR VALIDASI URL (SAMA SEPERTI HALAMAN SEBELUMNYA)
            suffixIcon: ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, child) {
                if (value.text.isEmpty) return const SizedBox();
                final isValid = _isValidUrl(value.text.trim());
                return Icon(
                  isValid ? Icons.check_circle : Icons.error_outline,
                  color: isValid ? Colors.green : Colors.red,
                  size: 20,
                );
              },
            ),
          ),
        ),
        // ✅ PESAN VALIDASI HANYA UNTUK FORMAT URL (SAMA SEPERTI HALAMAN SEBELUMNYA)
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, child) {
            if (value.text.isEmpty) return const SizedBox();
            final isValid = _isValidUrl(value.text.trim());
            if (!isValid) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'URL harus lengkap dengan http:// atau https://',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.red.shade700,
                    fontFamily: 'Poppins',
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ],
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            counterText: maxLength != null
                ? '${controller.text.length} / $maxLength karakter'
                : null,
            counterStyle: const TextStyle(
              fontSize: 12,
              color: Color(0xFF515151),
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
    required StateSetter setModalState,
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
          onTap: () async {
            await _selectDate(context, controller);
            setModalState(() {}); // Refresh modal state after date selection
          },
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(CertificationModel certification) {
    bool isDeleting = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
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
            'Apakah Anda yakin ingin menghapus ${certification.namaSertifikasi}?',
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins',
              color: Color(0xFF515151),
            ),
          ),
          actions: [
            TextButton(
              onPressed: isDeleting ? null : () => Navigator.pop(context),
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
              onPressed: isDeleting
                  ? null
                  : () async {
                      setDialogState(() => isDeleting = true);
                      try {
                        await _apiService.deleteCertification(
                          certification.certificationId!,
                        );
                        await _loadCertifications();
                        Navigator.pop(context);
                        _showSnackBar('Sertifikasi berhasil dihapus');
                      } catch (e) {
                        setDialogState(() => isDeleting = false);
                        _showSnackBar(
                          'Gagal menghapus sertifikasi',
                          isError: true,
                        );
                        print("Error delete certification: $e");
                      }
                    },
              child: isDeleting
                  ? const SizedBox(
                      height: 14,
                      width: 14,
                      child: CircularProgressIndicator(
                        color: Colors.red,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadCertifications,
      color: const Color(0xFF113CEE),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
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
                    border: Border.all(
                      color: const Color(0xFF113CEE),
                      width: 1,
                    ),
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

            // Loading atau Data
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(color: Color(0xFF113CEE)),
              )
            else if (_certifications.isEmpty)
              const Text(
                "Belum ada data sertifikasi",
                style: TextStyle(fontFamily: 'Poppins'),
              )
            else
              Column(
                children: List.generate(_certifications.length, (index) {
                  final cert = _certifications[index];
                  final isFirst = index == 0;
                  final isLast = index == _certifications.length - 1;

                  return _buildSertifikasiItem(
                    title: cert.namaSertifikasi,
                    institution: cert.lembagaSertifikasi,
                    date: _formatDateRange(
                      cert.tanggalTerbit,
                      cert.tanggalHabisMasa,
                    ),
                    hasCertificate: cert.sertifikat.isNotEmpty,
                    isFirst: isFirst,
                    isLast: isLast,
                    onEdit: () {
                      _showAddEditModal(certification: cert);
                    },
                  );
                }),
              ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildSertifikasiItem({
    required String title,
    required String institution,
    required String date,
    bool hasCertificate = false,
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
                const SizedBox(height: 10),

                // Tombol lihat sertifikat (jika ada)
                if (hasCertificate)
                  const Text(
                    'Lihat sertifikat',
                    style: TextStyle(
                      color: Color(0xFF0E38EB),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                // 🔹 Tanggal di pojok kanan bawah
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      date,
                      style: const TextStyle(
                        color: Color(0xFF515151),
                        fontSize: 13,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
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