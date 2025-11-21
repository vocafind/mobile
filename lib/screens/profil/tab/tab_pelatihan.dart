import 'package:flutter/material.dart';
import 'package:jobfair/api/api_service.dart';
import 'package:jobfair/models/talent_training_model.dart';
import 'package:intl/intl.dart';

class TabPelatihan extends StatefulWidget {
  const TabPelatihan({super.key});

  @override
  State<TabPelatihan> createState() => _TabPelatihanState();
}

class _TabPelatihanState extends State<TabPelatihan> {
  final ApiService _apiService = ApiService();
  List<TrainingModel> _trainings = [];
  bool _isLoading = true;

  // Controllers
  final _namaPelatihanController = TextEditingController();
  final _penyelenggaraController = TextEditingController();
  final _urlSertifikatController = TextEditingController();
  final _deskripsiController = TextEditingController();
  DateTime? _tanggalMulai;
  DateTime? _tanggalSelesai;

  @override
  void initState() {
    super.initState();
    _loadTrainings();
  }

  @override
  void dispose() {
    _namaPelatihanController.dispose();
    _penyelenggaraController.dispose();
    _urlSertifikatController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  void _clearControllers() {
    _namaPelatihanController.clear();
    _penyelenggaraController.clear();
    _urlSertifikatController.clear();
    _deskripsiController.clear();
    _tanggalMulai = null;
    _tanggalSelesai = null;
  }

  Future<void> _loadTrainings() async {
    setState(() => _isLoading = true);
    try {
      final trainings = await _apiService.getTraining();
      setState(() {
        _trainings = trainings;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('Gagal memuat data pelatihan', isError: true);
      print("Error load trainings: $e");
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: isError ? Colors.red[100] : Colors.white,
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

  String _formatDateRange(DateTime? start, DateTime? end) {
    if (start == null || end == null) return '-';
    final dateFormat = DateFormat('d MMM yyyy', 'id_ID');
    return '${dateFormat.format(start)} - ${dateFormat.format(end)}';
  }

  void _showAddEditModal({TrainingModel? training}) {
    final isEdit = training != null;
    bool isSaving = false;

    // Populate controllers if editing
    final TextEditingController _namaController = TextEditingController(
      text: training?.namaPelatihan ?? '',
    );
    final TextEditingController _penyelenggaraController =
        TextEditingController(text: training?.penyelenggara ?? '');
    final TextEditingController _urlController = TextEditingController(
      text: training?.linkSertifikat ?? '',
    );
    final TextEditingController _deskripsiController = TextEditingController(
      text: training?.deskripsi ?? '',
    );
    DateTime? _tanggalMulai = training?.tanggalMulai;
    DateTime? _tanggalSelesai = training?.tanggalSelesai;

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
                          isEdit ? 'Edit Pelatihan' : 'Tambah Pelatihan',
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
                                final penyelenggara = _penyelenggaraController
                                    .text
                                    .trim();
                                final url = _urlController.text.trim();
                                final deskripsi = _deskripsiController.text
                                    .trim();

                                // ✅ VALIDASI URL JIKA DIISI
                                if (url.isNotEmpty && !_isValidUrl(url)) {
                                  _showSnackBar(
                                    "URL sertifikat harus lengkap dengan http:// atau https://",
                                    isError: true,
                                  );
                                  return;
                                }

                                if (nama.isEmpty ||
                                    penyelenggara.isEmpty ||
                                    _tanggalMulai == null ||
                                    _tanggalSelesai == null) {
                                  _showSnackBar(
                                    "Lengkapi semua data wajib",
                                    isError: true,
                                  );
                                  return;
                                }

                                setModalState(() => isSaving = true);

                                final newTraining = TrainingModel(
                                  trainingId: training?.trainingId,
                                  namaPelatihan: nama,
                                  penyelenggara: penyelenggara,
                                  tanggalMulai: _tanggalMulai,
                                  tanggalSelesai: _tanggalSelesai,
                                  linkSertifikat: url,
                                  deskripsi: deskripsi,
                                );

                                try {
                                  if (isEdit) {
                                    await _apiService.updateTraining(
                                      training.trainingId!,
                                      newTraining,
                                    );
                                    _showSnackBar(
                                      'Berhasil memperbarui pelatihan',
                                    );
                                  } else {
                                    await _apiService.createTraining(
                                      newTraining,
                                    );
                                    _showSnackBar(
                                      'Berhasil menambah pelatihan',
                                    );
                                  }

                                  await _loadTrainings();
                                  Navigator.pop(context);
                                } catch (e) {
                                  setModalState(() => isSaving = false);
                                  _showSnackBar(
                                    'Gagal menyimpan data',
                                    isError: true,
                                  );
                                  print("❌ Error submit training: $e");
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
                                  'Tambahkan pelatihan, sertifikasi, atau kursus yang pernah Anda ikuti untuk memperkuat profil Anda.',
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
                          label: 'Nama Pelatihan',
                          hint: 'Contoh: Google UX Design Certificate',
                          icon: Icons.school_outlined,
                          required: true,
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _penyelenggaraController,
                          label: 'Penyelenggara',
                          hint: 'Contoh: Google Career Certificates',
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
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today_outlined,
                                      color: Colors.grey.shade600,
                                      size: 20,
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
                                  initialDate:
                                      _tanggalSelesai ?? DateTime.now(),
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
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today_outlined,
                                      color: Colors.grey.shade600,
                                      size: 20,
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

                        // ✅ FIELD URL SERTIFIKAT DENGAN VALIDASI VISUAL (TANPA HELPER TEXT)
                        _buildUrlTextField(
                          controller: _urlController,
                          label: 'URL Sertifikat',
                          hint: 'https://example.com/certificate',
                          icon: Icons.link_outlined,
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _deskripsiController,
                          label: 'Deskripsi',
                          hint:
                              'Jelaskan apa yang Anda pelajari dari pelatihan ini...',
                          icon: Icons.description_outlined,
                          maxLines: 5,
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
                                      _showDeleteConfirmation(training);
                                    },
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              label: const Text(
                                'Hapus Pelatihan',
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
    int maxLines = 1,
    int? maxLength,
    TextInputType? keyboardType,
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
          maxLines: maxLines,
          maxLength: maxLength,
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

  void _showDeleteConfirmation(TrainingModel training) {
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
            'Hapus Pelatihan',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Apakah Anda yakin ingin menghapus ${training.namaPelatihan}?',
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
                        await _apiService.deleteTraining(training.trainingId!);
                        await _loadTrainings();
                        Navigator.pop(context);
                        _showSnackBar('Pelatihan berhasil dihapus');
                      } catch (e) {
                        setDialogState(() => isDeleting = false);
                        _showSnackBar(
                          'Gagal menghapus pelatihan',
                          isError: true,
                        );
                        print("Error delete training: $e");
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
      onRefresh: _loadTrainings,
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
            else if (_trainings.isEmpty)
              const Text(
                "Belum ada data pelatihan",
                style: TextStyle(fontFamily: 'Poppins'),
              )
            else
              Column(
                children: List.generate(_trainings.length, (index) {
                  final training = _trainings[index];
                  final isFirst = index == 0;
                  final isLast = index == _trainings.length - 1;

                  return _buildPelatihanItem(
                    title: training.namaPelatihan,
                    institution: training.penyelenggara,
                    date: _formatDateRange(
                      training.tanggalMulai,
                      training.tanggalSelesai,
                    ),
                    hasCertificate: training.linkSertifikat.isNotEmpty,
                    isFirst: isFirst,
                    isLast: isLast,
                    onEdit: () {
                      _showAddEditModal(training: training);
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

  Widget _buildPelatihanItem({
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
                const SizedBox(height: 15),

                // 🔽 Bagian bawah: sertifikat di atas, tanggal di kiri bawah
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
                if (hasCertificate) const SizedBox(height: 4),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    date,
                    style: const TextStyle(
                      color: Color(0xFF515151),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
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