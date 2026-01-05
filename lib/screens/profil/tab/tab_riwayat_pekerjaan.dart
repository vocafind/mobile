import 'package:flutter/material.dart';
import 'package:vocafind/api/api_service.dart';
import 'package:vocafind/models/talent_workhistory_model.dart';
import 'package:intl/intl.dart';

class TabRiwayatPekerjaan extends StatefulWidget {
  const TabRiwayatPekerjaan({super.key});

  @override
  State<TabRiwayatPekerjaan> createState() => _TabRiwayatPekerjaanState();
}

class _TabRiwayatPekerjaanState extends State<TabRiwayatPekerjaan> {
  final ApiService _apiService = ApiService();
  List<WorkHistoryModel> _workHistory = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWorkHistory();
  }

  Future<void> _loadWorkHistory() async {
    setState(() => _isLoading = true);
    try {
      final workHistory = await _apiService.getWorkHistory();
      setState(() {
        _workHistory = workHistory;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('Gagal memuat data riwayat pekerjaan', isError: true);
      print("Error load work history: $e");
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

  void _showAddEditModal({WorkHistoryModel? workHistory}) {
    final isEdit = workHistory != null;

    // Controller form
    final TextEditingController _posisiController = TextEditingController(
      text: workHistory?.posisi ?? '',
    );
    final TextEditingController _perusahaanController = TextEditingController(
      text: workHistory?.perusahaan ?? '',
    );
    final TextEditingController _deskripsiController = TextEditingController(
      text: workHistory?.deskripsi ?? '',
    );

    // Variables untuk tanggal
    DateTime? _tempTanggalMulai = workHistory?.tanggalMulai;
    DateTime? _tempTanggalSelesai = workHistory?.tanggalSelesai;

    // Error variables - DI LUAR StatefulBuilder agar bisa diakses
    String? posisiError;
    String? perusahaanError;
    String? tanggalMulaiError;
    String? tanggalSelesaiError;
    String? deskripsiError;

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
                // === HEADER ===
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
                          isEdit
                              ? 'Edit Riwayat Pekerjaan'
                              : 'Tambah Riwayat Pekerjaan',
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

                          // Validasi Posisi
                          if (_posisiController.text.trim().isEmpty) {
                            posisiError = 'Posisi harus diisi';
                            hasError = true;
                          } else {
                            posisiError = null;
                          }

                          // Validasi Perusahaan
                          if (_perusahaanController.text.trim().isEmpty) {
                            perusahaanError = 'Perusahaan harus diisi';
                            hasError = true;
                          } else {
                            perusahaanError = null;
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

                          // Validasi Deskripsi
                          if (_deskripsiController.text.trim().isEmpty) {
                            deskripsiError = 'Deskripsi harus diisi';
                            hasError = true;
                          } else {
                            deskripsiError = null;
                          }

                          // Update UI untuk menampilkan error
                          if (hasError) {
                            setModalState(() {});
                            return;
                          }

                          // Jika semua validasi lolos
                          final newWorkHistory = WorkHistoryModel(
                            workhistoryId: workHistory?.workhistoryId,
                            posisi: _posisiController.text.trim(),
                            perusahaan: _perusahaanController.text.trim(),
                            tanggalMulai: _tempTanggalMulai!,
                            tanggalSelesai: _tempTanggalSelesai!,
                            deskripsi: _deskripsiController.text.trim(),
                          );

                          try {
                            if (isEdit) {
                              await _apiService.updateWorkHistory(
                                workHistory!.workhistoryId!,
                                newWorkHistory,
                              );
                              _showSnackBar(
                                'Berhasil memperbarui riwayat pekerjaan',
                              );
                            } else {
                              await _apiService.createWorkHistory(newWorkHistory);
                              _showSnackBar(
                                'Berhasil menambah riwayat pekerjaan',
                              );
                            }

                            await _loadWorkHistory();
                            Navigator.pop(context);
                          } catch (e) {
                            _showSnackBar(
                              'Gagal menyimpan data',
                              isError: true,
                            );
                            print("❌ Error submit work history: $e");
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

                // === FORM ===
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
                          errorText: posisiError, // ✅ Tambahkan errorText
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _perusahaanController,
                          label: 'Perusahaan',
                          hint: 'Contoh: Google',
                          icon: Icons.business_outlined,
                          required: true,
                          errorText: perusahaanError, // ✅ Tambahkan errorText
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
                                  initialDate:
                                      _tempTanggalMulai ?? DateTime.now(),
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
                                        ? Colors.red // ✅ Border merah jika error
                                        : Colors.grey.shade300,
                                    width: tanggalMulaiError != null ? 2 : 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today_outlined,
                                      color: tanggalMulaiError != null
                                          ? Colors.red // ✅ Icon merah jika error
                                          : Colors.grey.shade600,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      _tempTanggalMulai != null
                                          ? DateFormat(
                                              'dd/MM/yyyy',
                                            ).format(_tempTanggalMulai!)
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
                            // ✅ Tampilkan error message untuk tanggal mulai
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
                                        ? Colors.red // ✅ Border merah jika error
                                        : Colors.grey.shade300,
                                    width: tanggalSelesaiError != null ? 2 : 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today_outlined,
                                      color: tanggalSelesaiError != null
                                          ? Colors.red // ✅ Icon merah jika error
                                          : Colors.grey.shade600,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      _tempTanggalSelesai != null
                                          ? DateFormat(
                                              'dd/MM/yyyy',
                                            ).format(_tempTanggalSelesai!)
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
                            // ✅ Tampilkan error message untuk tanggal selesai
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
                          controller: _deskripsiController,
                          label: 'Deskripsi',
                          hint:
                              'Jelaskan tugas dan tanggung jawab Anda di posisi ini...',
                          icon: Icons.description_outlined,
                          maxLines: 5,
                          required: true,
                          errorText: deskripsiError, // ✅ Tambahkan errorText
                        ),

                        // Tombol Hapus (hanya untuk edit)
                        if (isEdit) ...[
                          const SizedBox(height: 32),
                          Center(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                _showDeleteConfirmation(workHistory!);
                              },
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
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
      ),
    );
  }

  void _showDeleteConfirmation(WorkHistoryModel workHistory) {
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
            'Hapus Riwayat Pekerjaan',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Apakah Anda yakin ingin menghapus ${workHistory.posisi} di ${workHistory.perusahaan}?',
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
                        await _apiService.deleteWorkHistory(
                          workHistory.workhistoryId!,
                        );
                        await _loadWorkHistory();
                        Navigator.pop(context);
                        _showSnackBar('Riwayat pekerjaan berhasil dihapus');
                      } catch (e) {
                        setDialogState(() => isDeleting = false);
                        _showSnackBar(
                          'Gagal menghapus riwayat pekerjaan',
                          isError: true,
                        );
                        print("Error delete work history: $e");
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    bool required = false,
    String? errorText, // ✅ Tambahkan parameter errorText
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
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: maxLines > 1 ? 16 : 14,
            ),
            errorText: errorText, // ✅ Tampilkan error text
            errorStyle: const TextStyle(
              fontSize: 12,
              fontFamily: 'Poppins',
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadWorkHistory,
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

            // Loading Indicator
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(color: Color(0xFF113CEE)),
              )
            else if (_workHistory.isEmpty)
              const Text(
                "Belum ada data riwayat pekerjaan",
                style: TextStyle(fontFamily: 'Poppins'),
              )
            else
              Column(
                children: List.generate(_workHistory.length, (index) {
                  final work = _workHistory[index];
                  final isFirst = index == 0;
                  final isLast = index == _workHistory.length - 1;

                  // ✅ Format tanggal untuk display
                  String displayDate = '';
                  if (work.tanggalMulai != null &&
                      work.tanggalSelesai != null) {
                    displayDate =
                        '${DateFormat('dd MMM yyyy').format(work.tanggalMulai!)} - ${DateFormat('dd MMM yyyy').format(work.tanggalSelesai!)}';
                  } else {
                    displayDate = '-';
                  }

                  return _buildRiwayatPekerjaanItem(
                    position: work.posisi,
                    company: work.perusahaan,
                    date: displayDate,
                    description: work.deskripsi,
                    isFirst: isFirst,
                    isLast: isLast,
                    onEdit: () {
                      _showAddEditModal(workHistory: work);
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
                  maxLines:
                      2, // batasi misalnya 2 baris (bisa 1 kalau mau lebih pendek)
                  overflow: TextOverflow.ellipsis, // munculkan "..."
                  softWrap: true,
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