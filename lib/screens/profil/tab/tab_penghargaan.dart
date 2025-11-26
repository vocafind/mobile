import 'package:flutter/material.dart';
import 'package:jobfair/api/api_service.dart';
import 'package:jobfair/models/talent_award_model.dart';

class TabPenghargaan extends StatefulWidget {
  const TabPenghargaan({super.key});

  @override
  State<TabPenghargaan> createState() => _TabPenghargaanState();
}

class _TabPenghargaanState extends State<TabPenghargaan> {
  final ApiService _apiService = ApiService();
  List<AwardModel> _awards = [];
  bool _isLoading = true;

  // Controllers
  final _judulPenghargaanController = TextEditingController();
  final _institusiController = TextEditingController();
  final _tahunController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _urlSertifikatController = TextEditingController();
  String _selectedBadge = 'International';

  @override
  void initState() {
    super.initState();
    _loadAwards();
  }

  @override
  void dispose() {
    _judulPenghargaanController.dispose();
    _institusiController.dispose();
    _tahunController.dispose();
    _deskripsiController.dispose();
    _urlSertifikatController.dispose();
    super.dispose();
  }

  void _clearControllers() {
    _judulPenghargaanController.clear();
    _institusiController.clear();
    _tahunController.clear();
    _deskripsiController.clear();
    _urlSertifikatController.clear();
    _selectedBadge = 'International';
  }

  Future<void> _loadAwards() async {
    if (!mounted) return;

    setState(() => _isLoading = true);
    try {
      final awards = await _apiService.getAward();
      if (mounted) {
        setState(() {
          _awards = awards;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showSnackBar('Gagal memuat data penghargaan', isError: true);
      }
      print("Error load awards: $e");
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;

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
         action: SnackBarAction(
          textColor: Colors.white,
          label: 'Ok',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
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

  void _showAddEditModal({AwardModel? award}) {
    final isEdit = award != null;
    bool isSaving = false;

    // Populate controllers if editing
    final TextEditingController _judulController = TextEditingController(
      text: award?.namaPenghargaan ?? '',
    );
    final TextEditingController _institusiController = TextEditingController(
      text: award?.pemberiPenghargaan ?? '',
    );
    final TextEditingController _tahunController = TextEditingController(
      text: award?.tahun?.toString() ?? '',
    );
    final TextEditingController _deskripsiController = TextEditingController(
      text: award?.deskripsi ?? '',
    );
    final TextEditingController _urlSertifikatController =
        TextEditingController(text: award?.sertifikat ?? '');
    String _selectedBadge = award?.tingkatPenghargaan ?? 'International';

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
                        onPressed: isSaving
                            ? null
                            : () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Text(
                          isEdit ? 'Edit Penghargaan' : 'Tambah Penghargaan',
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
                                final nama = _judulController.text.trim();
                                final institusi = _institusiController.text
                                    .trim();
                                final tahun = int.tryParse(
                                  _tahunController.text.trim(),
                                );
                                final deskripsi = _deskripsiController.text
                                    .trim();
                                final sertifikat = _urlSertifikatController.text
                                    .trim();

                                // ✅ VALIDASI URL JIKA DIISI
                                if (sertifikat.isNotEmpty && !_isValidUrl(sertifikat)) {
                                  _showSnackBar(
                                    "URL sertifikat harus lengkap dengan http:// atau https://",
                                    isError: true,
                                  );
                                  return;
                                }

                                if (nama.isEmpty ||
                                    institusi.isEmpty ||
                                    tahun == null) {
                                  if (mounted) {
                                    _showSnackBar(
                                      "Lengkapi semua data wajib",
                                      isError: true,
                                    );
                                  }
                                  return;
                                }

                                setModalState(() => isSaving = true);

                                final newAward = AwardModel(
                                  awardId: award?.awardId,
                                  namaPenghargaan: nama,
                                  tingkatPenghargaan: _selectedBadge,
                                  pemberiPenghargaan: institusi,
                                  tahun: tahun,
                                  deskripsi: deskripsi,
                                  sertifikat: sertifikat,
                                );

                                try {
                                  if (isEdit) {
                                    await _apiService.updateAward(
                                      award.awardId!,
                                      newAward,
                                    );
                                    if (mounted) {
                                      _showSnackBar(
                                        'Berhasil memperbarui penghargaan',
                                      );
                                    }
                                  } else {
                                    await _apiService.createAward(newAward);
                                    if (mounted) {
                                      _showSnackBar(
                                        'Berhasil menambah penghargaan',
                                      );
                                    }
                                  }

                                  if (mounted) {
                                    await _loadAwards();
                                    Navigator.pop(context);
                                  }
                                } catch (e) {
                                  setModalState(() => isSaving = false);
                                  if (mounted) {
                                    _showSnackBar(
                                      'Gagal menyimpan data',
                                      isError: true,
                                    );
                                  }
                                  print("❌ Error submit award: $e");
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
                                  'Tambahkan penghargaan atau sertifikat yang pernah Anda raih untuk meningkatkan kredibilitas profil Anda.',
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
                          controller: _judulController,
                          label: 'Nama Penghargaan',
                          hint: 'Contoh: Google UX Design Certificate',
                          icon: Icons.workspace_premium_outlined,
                          required: true,
                        ),
                        const SizedBox(height: 16),

                        // Badge/Kategori
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Text(
                                  'Tingkat Penghargaan',
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
                              children:
                                  [
                                    'Regional',
                                    'National',
                                    'International',
                                  ].map((badge) {
                                    final isSelected = _selectedBadge == badge;
                                    return GestureDetector(
                                      onTap: () {
                                        setModalState(() {
                                          _selectedBadge = badge;
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
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          border: Border.all(
                                            color: isSelected
                                                ? const Color(0xFF113CEE)
                                                : Colors.grey.shade300,
                                          ),
                                        ),
                                        child: Text(
                                          badge,
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
                          controller: _institusiController,
                          label: 'Pemberi Penghargaan',
                          hint: 'Contoh: Google Career Certificates',
                          icon: Icons.business_outlined,
                          required: true,
                        ),

                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _tahunController,
                          label: 'Tahun',
                          hint: 'Contoh: 2024',
                          icon: Icons.calendar_today_outlined,
                          keyboardType: TextInputType.number,
                          required: true,
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _deskripsiController,
                          label: 'Deskripsi',
                          hint: 'Jelaskan tentang penghargaan ini...',
                          icon: Icons.description_outlined,
                          maxLines: 4,
                          helperText: 'Opsional - Tambahkan deskripsi singkat',
                        ),
                        const SizedBox(height: 16),

                        // ✅ FIELD URL SERTIFIKAT DENGAN VALIDASI VISUAL
                        _buildUrlTextField(
                          controller: _urlSertifikatController,
                          label: 'URL Sertifikat',
                          hint: 'https://drive.google.com/file/d/contoh-sertifikat',
                          icon: Icons.link,
                          helperText: 'Opsional - Link menuju file sertifikat',
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
                                      _showDeleteConfirmation(award);
                                    },
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              label: const Text(
                                'Hapus Penghargaan',
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
          keyboardType: TextInputType.url,
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
            helperText: helperText,
            helperStyle: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
              fontFamily: 'Poppins',
            ),
            // ✅ INDIKATOR VALIDASI URL
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
        // ✅ PESAN VALIDASI REAL-TIME
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
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

  void _showDeleteConfirmation(AwardModel award) {
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
            'Hapus Penghargaan',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Apakah Anda yakin ingin menghapus ${award.namaPenghargaan}?',
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
                        await _apiService.deleteAward(award.awardId!);
                        if (mounted) {
                          await _loadAwards();
                          Navigator.pop(context);
                          _showSnackBar('Penghargaan berhasil dihapus');
                        }
                      } catch (e) {
                        setDialogState(() => isDeleting = false);
                        if (mounted) {
                          _showSnackBar(
                            'Gagal menghapus penghargaan',
                            isError: true,
                          );
                        }
                        print("Error delete award: $e");
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
      onRefresh: _loadAwards,
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
            else if (_awards.isEmpty)
              const Text(
                "Belum ada data penghargaan",
                style: TextStyle(fontFamily: 'Poppins'),
              )
            else
              Column(
                children: List.generate(_awards.length, (index) {
                  final award = _awards[index];
                  final isFirst = index == 0;
                  final isLast = index == _awards.length - 1;

                  return _buildPenghargaanItem(
                    title: award.namaPenghargaan,
                    institution: award.pemberiPenghargaan,
                    year: award.tahun?.toString() ?? '-',
                    badge: award.tingkatPenghargaan,
                    hasCertificate: award.sertifikat.isNotEmpty,
                    isFirst: isFirst,
                    isLast: isLast,
                    onEdit: () {
                      _showAddEditModal(award: award);
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

  Widget _buildPenghargaanItem({
    required String title,
    required String institution,
    required String year,
    required String badge,
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
                const SizedBox(height: 6),
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
                    badge,
                    style: const TextStyle(
                      color: Color(0xFF464E5E),
                      fontSize: 10,
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (hasCertificate)
                      const Text(
                        'Lihat sertifikat',
                        style: TextStyle(
                          color: Color(0xFF0E38EB),
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    else
                      const SizedBox(),
                    Text(
                      year,
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