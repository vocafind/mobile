import 'package:flutter/material.dart';
import 'package:vocafind/api/api_service.dart';
import 'package:intl/intl.dart';
import 'package:vocafind/models/talent_project_model.dart';

class TabProyek extends StatefulWidget {
  const TabProyek({super.key});

  @override
  State<TabProyek> createState() => _TabProyekState();
}

class _TabProyekState extends State<TabProyek> {
  final ApiService _apiService = ApiService();
  List<ProjectModel> _projects = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    setState(() => _isLoading = true);
    try {
      final projects = await _apiService.getProject();
      setState(() {
        _projects = projects;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('Gagal memuat data proyek', isError: true);
      print("Error load projects: $e");
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

  String _formatDateRange(DateTime? start, DateTime? end) {
    if (start == null || end == null) return '-';
    final dateFormat = DateFormat('d MMM yyyy', 'id_ID');
    return '${dateFormat.format(start)} - ${dateFormat.format(end)}';
  }

  void _showAddEditModal({ProjectModel? project}) {
    final isEdit = project != null;

    // Controller form
    final TextEditingController _namaController = TextEditingController(
      text: project?.namaProyek ?? '',
    );
    final TextEditingController _klienController = TextEditingController(
      text: project?.klien ?? '',
    );
    final TextEditingController _peranController = TextEditingController(
      text: project?.peranTim ?? '',
    );
    final TextEditingController _teknologiController = TextEditingController(
      text: project?.penggunaanTeknologi ?? '',
    );

    // Variables untuk tanggal
    DateTime? _tempTanggalMulai = project?.tanggalMulai;
    DateTime? _tempTanggalSelesai = project?.tanggalSelesai;

    // Error variables - DI LUAR StatefulBuilder agar bisa diakses
    String? namaProyekError;
    String? klienError;
    String? tanggalMulaiError;
    String? tanggalSelesaiError;
    String? peranTimError;
    String? teknologiError;

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
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Text(
                          isEdit ? 'Edit Proyek' : 'Tambah Proyek',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          // Reset error messages
                          bool hasError = false;

                          // Validasi Nama Proyek
                          if (_namaController.text.trim().isEmpty) {
                            namaProyekError = 'Nama proyek harus diisi';
                            hasError = true;
                          } else {
                            namaProyekError = null;
                          }

                          // Validasi Klien
                          if (_klienController.text.trim().isEmpty) {
                            klienError = 'Nama klien/perusahaan harus diisi';
                            hasError = true;
                          } else {
                            klienError = null;
                          }

                          // Validasi Tanggal Mulai
                          if (_tempTanggalMulai == null) {
                            tanggalMulaiError = 'Tanggal mulai harus diisi';
                            hasError = true;
                          } else {
                            tanggalMulaiError = null;
                          }

                          // Validasi Tanggal Selesai
                          if (_tempTanggalSelesai == null) {
                            tanggalSelesaiError = 'Tanggal selesai harus diisi';
                            hasError = true;
                          } else if (_tempTanggalMulai != null &&
                              _tempTanggalSelesai!.isBefore(_tempTanggalMulai!)) {
                            tanggalSelesaiError =
                                'Tanggal selesai harus setelah tanggal mulai';
                            hasError = true;
                          } else if (_tempTanggalSelesai!
                              .isAfter(DateTime.now())) {
                            tanggalSelesaiError =
                                'Tanggal selesai tidak boleh lebih dari hari ini';
                            hasError = true;
                          } else {
                            tanggalSelesaiError = null;
                          }

                          // Validasi Peran Tim
                          if (_peranController.text.trim().isEmpty) {
                            peranTimError = 'Peran tim harus diisi';
                            hasError = true;
                          } else {
                            peranTimError = null;
                          }

                          // Validasi Teknologi
                          if (_teknologiController.text.trim().isEmpty) {
                            teknologiError = 'Penggunaan teknologi harus diisi';
                            hasError = true;
                          } else {
                            teknologiError = null;
                          }

                          // Update UI untuk menampilkan error
                          if (hasError) {
                            setModalState(() {});
                            return;
                          }

                          // Jika semua validasi lolos
                          final newProject = ProjectModel(
                            projectId: project?.projectId,
                            namaProyek: _namaController.text.trim(),
                            klien: _klienController.text.trim(),
                            tanggalMulai: _tempTanggalMulai!,
                            tanggalSelesai: _tempTanggalSelesai!,
                            peranTim: _peranController.text.trim(),
                            penggunaanTeknologi: _teknologiController.text.trim(),
                          );

                          try {
                            if (isEdit) {
                              await _apiService.updateProject(
                                project!.projectId!,
                                newProject,
                              );
                              _showSnackBar(
                                'Berhasil memperbarui proyek',
                              );
                            } else {
                              await _apiService.createProject(newProject);
                              _showSnackBar(
                                'Berhasil menambah proyek',
                              );
                            }

                            await _loadProjects();
                            Navigator.pop(context);
                          } catch (e) {
                            _showSnackBar(
                              'Gagal menyimpan data',
                              isError: true,
                            );
                            print("❌ Error submit project: $e");
                          }
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
                                  'Tambahkan proyek yang pernah Anda kerjakan untuk menunjukkan kemampuan dan pengalaman praktis Anda.',
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
                          label: 'Nama Proyek',
                          hint: 'Contoh: Sistem Keuangan Negara',
                          icon: Icons.folder_outlined,
                          required: true,
                          errorText: namaProyekError,
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _klienController,
                          label: 'Nama Klien / Perusahaan',
                          hint: 'Contoh: PT. Telkom Indonesia, Bank Mandiri, Kementerian Kesehatan',
                          icon: Icons.business_outlined,
                          required: true,
                          errorText: klienError,
                          helperText: 'Nama perusahaan atau institusi tempat Anda bekerja/bekerjasama',
                        ),
                        const SizedBox(height: 16),

                        // Tanggal Mulai dengan error handling
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
                                  initialDate: _tempTanggalMulai ?? DateTime.now(),
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
                                    _tempTanggalMulai = date;
                                    // Reset error jika dipilih
                                    tanggalMulaiError = null;
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
                                    color: tanggalMulaiError != null
                                        ? Colors.red
                                        : Colors.grey.shade300,
                                    width: tanggalMulaiError != null ? 2 : 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today_outlined,
                                      color: tanggalMulaiError != null
                                          ? Colors.red
                                          : Colors.grey.shade600,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      _tempTanggalMulai != null
                                          ? '${_tempTanggalMulai!.day}/${_tempTanggalMulai!.month}/${_tempTanggalMulai!.year}'
                                          : 'Pilih tanggal mulai',
                                      style: TextStyle(
                                        color: _tempTanggalMulai != null
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
                            // Tampilkan error message untuk tanggal mulai
                            if (tanggalMulaiError != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 4, left: 4),
                                child: Text(
                                  tanggalMulaiError!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Tanggal Selesai dengan error handling
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
                                      _tempTanggalSelesai ?? DateTime.now(),
                                  firstDate: _tempTanggalMulai ?? DateTime(1900),
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
                                    _tempTanggalSelesai = date;
                                    // Reset error jika dipilih
                                    tanggalSelesaiError = null;
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
                                    color: tanggalSelesaiError != null
                                        ? Colors.red
                                        : Colors.grey.shade300,
                                    width: tanggalSelesaiError != null ? 2 : 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today_outlined,
                                      color: tanggalSelesaiError != null
                                          ? Colors.red
                                          : Colors.grey.shade600,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      _tempTanggalSelesai != null
                                          ? '${_tempTanggalSelesai!.day}/${_tempTanggalSelesai!.month}/${_tempTanggalSelesai!.year}'
                                          : 'Pilih tanggal selesai',
                                      style: TextStyle(
                                        color: _tempTanggalSelesai != null
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
                            // Tampilkan error message untuk tanggal selesai
                            if (tanggalSelesaiError != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 4, left: 4),
                                child: Text(
                                  tanggalSelesaiError!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _peranController,
                          label: 'Peran Tim',
                          hint: 'Jelaskan peran Anda dalam proyek ini...',
                          icon: Icons.group_outlined,
                          maxLines: 4,
                          required: true,
                          errorText: peranTimError,
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _teknologiController,
                          label: 'Penggunaan Teknologi',
                          hint: 'Contoh: Teknologi AI, React, Node.js, MongoDB',
                          icon: Icons.settings_outlined,
                          maxLines: 3,
                          required: true,
                          errorText: teknologiError,
                        ),

                        // Tombol Hapus (hanya untuk edit)
                        if (isEdit) ...[
                          const SizedBox(height: 32),
                          Center(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                _showDeleteConfirmation(project!);
                              },
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              label: const Text(
                                'Hapus Proyek',
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    bool required = false,
    String? helperText,
    String? errorText, // Tambahkan parameter errorText
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
              borderSide: BorderSide(
                color: errorText != null ? Colors.red : Colors.grey.shade300,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: errorText != null ? Colors.red : Colors.grey.shade300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: errorText != null ? Colors.red : const Color(0xFF113CEE),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            errorText: errorText, // Tampilkan error text
            errorStyle: const TextStyle(
              fontSize: 12,
              fontFamily: 'Poppins',
              color: Colors.red,
            ),
            helperText: errorText == null ? helperText : null, // Sembunyikan helper saat ada error
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

  void _showDeleteConfirmation(ProjectModel project) {
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
            'Hapus Proyek',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Apakah Anda yakin ingin menghapus proyek ${project.namaProyek}?',
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
                        await _apiService.deleteProject(
                          project.projectId!,
                        );
                        await _loadProjects();
                        Navigator.pop(context);
                        _showSnackBar('Proyek berhasil dihapus');
                      } catch (e) {
                        setDialogState(() => isDeleting = false);
                        _showSnackBar(
                          'Gagal menghapus proyek',
                          isError: true,
                        );
                        print("Error delete project: $e");
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
      onRefresh: _loadProjects,
      color: const Color(0xFF113CEE),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
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
            else if (_projects.isEmpty)
              const Text(
                "Belum ada data proyek",
                style: TextStyle(fontFamily: 'Poppins'),
              )
            else
              Column(
                children: List.generate(_projects.length, (index) {
                  final project = _projects[index];
                  final isFirst = index == 0;
                  final isLast = index == _projects.length - 1;

                  // Truncate description untuk display
                  String displayRole = project.peranTim;
                  if (displayRole.length > 100) {
                    displayRole = '${displayRole.substring(0, 100)}...';
                  }

                  return _buildProyekItem(
                    title: project.namaProyek,
                    company: project.klien,
                    date: _formatDateRange(
                      project.tanggalMulai,
                      project.tanggalSelesai,
                    ),
                    role: displayRole,
                    technology: project.penggunaanTeknologi,
                    isFirst: isFirst,
                    isLast: isLast,
                    onEdit: () {
                      _showAddEditModal(project: project);
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

  Widget _buildProyekItem({
    required String title,
    required String company,
    required String date,
    required String role,
    required String technology,
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
                const SizedBox(height: 15),
                Text(
                  role,
                  style: const TextStyle(
                    color: Color(0xFF515151),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 1.7,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  technology,
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