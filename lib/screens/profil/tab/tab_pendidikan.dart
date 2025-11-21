import 'package:flutter/material.dart';
import 'package:jobfair/api/api_service.dart';
import 'package:jobfair/models/talent_education_model.dart';

class TabPendidikan extends StatefulWidget {
  const TabPendidikan({super.key});

  @override
  State<TabPendidikan> createState() => _TabPendidikanState();
}

class _TabPendidikanState extends State<TabPendidikan> {
  final ApiService _apiService = ApiService();
  List<EducationModel> _education = [];
  bool _isLoading = true;

  // Daftar pilihan jenjang yang valid
  final List<String> _jenjangOptions = [
    'SD',
    'SMP',
    'SMA',
    'SMK',
    'D1',
    'D2',
    'D3',
    'D4',
    'S1',
    'S2',
    'S3',
  ];

  @override
  void initState() {
    super.initState();
    _loadEducation();
  }

  Future<void> _loadEducation() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final education = await _apiService.getEducation();
      if (mounted) {
        setState(() {
          _education = education;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showSnackBar('Gagal memuat data pendidikan', isError: true);
      }
      print("Error load education: $e");
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return; // ✅ CEK MOUNTED SEBELUM MENAMPILKAN SNACKBAR

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

  void _showPendidikanModal({EducationModel? education}) {
    final isEdit = education != null;
    bool isSaving = false;

    // Controller form
    final TextEditingController _jurusanController = TextEditingController(
      text: education?.jurusan ?? '',
    );
    final TextEditingController _institusiController = TextEditingController(
      text: education?.institusi ?? '',
    );
    final TextEditingController _tahunMulaiController = TextEditingController(
      text: education?.tahunMasuk?.toString() ?? '',
    );
    final TextEditingController _tahunSelesaiController = TextEditingController(
      text: education?.tahunLulus?.toString() ?? '',
    );
    final TextEditingController _nilaiAkhirController = TextEditingController(
      text: education?.nilaiAkhir?.toString() ?? '',
    );

    // Variabel untuk dropdown jenjang
    String? _selectedJenjang = education?.jenjang;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: StatefulBuilder(
          builder: (context, setModalState) {
            // ✅ FUNCTION UNTUK HANDLE SAVE DENGAN ERROR HANDLING
            Future<void> _handleSave() async {
              final jurusan = _jurusanController.text.trim();
              final institusi = _institusiController.text.trim();
              final tahunMasuk = int.tryParse(
                _tahunMulaiController.text.trim(),
              );
              final tahunLulus = int.tryParse(
                _tahunSelesaiController.text.trim(),
              );
              final nilaiAkhir = double.tryParse(
                _nilaiAkhirController.text.trim(),
              );

              // Validasi form
              if (_selectedJenjang == null ||
                  jurusan.isEmpty ||
                  institusi.isEmpty ||
                  tahunMasuk == null ||
                  tahunLulus == null) {
                // ✅ GUNAKAN ScaffoldMessenger DARI MODAL CONTEXT
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Lengkapi semua data yang wajib",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    backgroundColor: Colors.red[100],
                    behavior: SnackBarBehavior.floating,
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
                return;
              }

              setModalState(() => isSaving = true);

              final edu = EducationModel(
                educationId: education?.educationId,
                jenjang: _selectedJenjang!,
                jurusan: jurusan,
                institusi: institusi,
                tahunMasuk: tahunMasuk,
                tahunLulus: tahunLulus,
                nilaiAkhir: nilaiAkhir,
                gelar: '',
              );

              try {
                if (isEdit) {
                  await _apiService.updateEducation(
                    education!.educationId!,
                    edu,
                  );
                } else {
                  await _apiService.createEducation(edu);
                }

                // ✅ TUTUP MODAL DULU, BARU TAMPILKAN SNACKBAR DI PARENT
                if (mounted) {
                  Navigator.pop(context);
                  // Tampilkan snackbar di parent context setelah modal tertutup
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      _showSnackBar(
                        isEdit
                            ? 'Berhasil memperbarui pendidikan'
                            : 'Berhasil menambah pendidikan',
                      );
                      _loadEducation();
                    }
                  });
                }
              } catch (e) {
                setModalState(() => isSaving = false);
                // ✅ TAMPILKAN ERROR DI DALAM MODAL JIKA GAGAL
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Gagal menyimpan data: ${e.toString()}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    backgroundColor: Colors.red[100],
                    behavior: SnackBarBehavior.floating,
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    duration: const Duration(seconds: 3),
                  ),
                );
                print("❌ Error submit education: $e");
              }
            }

            return Container(
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
                          onPressed: isSaving
                              ? null
                              : () => Navigator.pop(context),
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
                          onPressed: isSaving ? null : _handleSave,
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

                  // === FORM ===
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Dropdown Jenjang (Menggantikan TextField)
                          _buildJenjangDropdown(
                            selectedValue: _selectedJenjang,
                            onChanged: (String? newValue) {
                              setModalState(() {
                                _selectedJenjang = newValue;
                              });
                            },
                            label: 'Jenjang Pendidikan',
                            required: true,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _jurusanController,
                            label: 'Jurusan',
                            hint: 'Contoh: Rekayasa Perangkat Lunak',
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
                            hint: 'Contoh: 3.75',
                            icon: Icons.grade_outlined,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Tombol hapus (hanya jika edit)
                          if (isEdit) ...[
                            const SizedBox(height: 32),
                            Center(
                              child: OutlinedButton.icon(
                                onPressed: isSaving
                                    ? null
                                    : () {
                                        Navigator.pop(context);
                                        _showDeleteConfirmation(education!);
                                      },
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                                label: const Text(
                                  'Hapus Pendidikan',
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
            );
          },
        ),
      ),
    );
  }

  void _showDeleteConfirmation(EducationModel education) {
    bool isDeleting = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          Future<void> _handleDelete() async {
            setDialogState(() => isDeleting = true);
            try {
              await _apiService.deleteEducation(education.educationId!);
              if (mounted) {
                Navigator.pop(context); // Tutup dialog
                // Refresh data dan tampilkan snackbar
                _loadEducation();
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    _showSnackBar('Pendidikan berhasil dihapus');
                  }
                });
              }
            } catch (e) {
              if (mounted) {
                setDialogState(() => isDeleting = false);
                // Tampilkan error di dalam dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Gagal menghapus pendidikan: ${e.toString()}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    backgroundColor: Colors.red[100],
                    behavior: SnackBarBehavior.floating,
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
              print("Error delete education: $e");
            }
          }

          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.white,
            title: const Text(
              'Hapus Pendidikan',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
            content: Text(
              'Apakah Anda yakin ingin menghapus pendidikan di ${education.institusi}?',
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
                onPressed: isDeleting ? null : _handleDelete,
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
          );
        },
      ),
    );
  }

  // METHOD-METHOD BUILD WIDGET TIDAK BERUBAH
  Widget _buildJenjangDropdown({
    required String? selectedValue,
    required ValueChanged<String?> onChanged,
    required String label,
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
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
            color: Colors.grey.shade50,
          ),
          child: DropdownButtonFormField<String>(
            value: selectedValue,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              prefixIcon: Icon(
                Icons.school_outlined,
                color: Colors.grey.shade600,
                size: 20,
              ),
            ),
            items: _jenjangOptions.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 14, fontFamily: 'Poppins'),
                ),
              );
            }).toList(),
            onChanged: onChanged,
            hint: Text(
              'Pilih Jenjang',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 14,
                fontFamily: 'Poppins',
              ),
            ),
            validator: required
                ? (value) {
                    if (value == null || value.isEmpty) {
                      return 'Jenjang harus dipilih';
                    }
                    return null;
                  }
                : null,
          ),
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

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadEducation,
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
                onTap: () => _showPendidikanModal(),
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
            else if (_education.isEmpty)
              const Text(
                "Belum ada data pendidikan",
                style: TextStyle(fontFamily: 'Poppins'),
              )
            else
              Column(
                children: List.generate(_education.length, (index) {
                  final edu = _education[index];
                  final isFirst = index == 0;
                  final isLast = index == _education.length - 1;

                  return _buildPendidikanItem(
                    title: '${edu.jenjang} ${edu.jurusan}',
                    institution: edu.institusi,
                    year: '${edu.tahunMasuk ?? "-"} - ${edu.tahunLulus ?? "-"}',
                    grade:
                        'Nilai akhir: ${edu.nilaiAkhir?.toStringAsFixed(2) ?? "-"}',
                    isFirst: isFirst,
                    isLast: isLast,
                    onEdit: () {
                      _showPendidikanModal(education: edu);
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
