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
  String? _errorMessage;

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
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
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
        setState(() {
          _isLoading = false;
          _errorMessage = 'Gagal memuat data: ${e.toString()}';
        });
        _showSnackBar('Gagal memuat data pendidikan', isError: true);
      }
      print("Error load education: $e");
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;

    // Gunakan GlobalKey untuk menghindari context issues
    try {
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
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      print("Error showing snackbar: $e");
    }
  }

void _showPendidikanModal({EducationModel? education}) {
  final isEdit = education != null;

  // Deklarasikan error variables
  String? jenjangError;
  String? jurusanError;
  String? institusiError;
  String? tahunMulaiError;
  String? tahunSelesaiError;
  String? nilaiAkhirError;

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
          return Container(
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
                          // Reset error messages
                          bool hasError = false;

                          // Validasi Jenjang
                          if (_selectedJenjang == null || _selectedJenjang!.isEmpty) {
                            jenjangError = 'Jenjang pendidikan harus dipilih';
                            hasError = true;
                          } else {
                            jenjangError = null;
                          }

                          // Validasi Jurusan
                          if (_jurusanController.text.trim().isEmpty) {
                            jurusanError = 'Jurusan harus diisi';
                            hasError = true;
                          } else {
                            jurusanError = null;
                          }

                          // Validasi Institusi
                          if (_institusiController.text.trim().isEmpty) {
                            institusiError = 'Nama institusi harus diisi';
                            hasError = true;
                          } else {
                            institusiError = null;
                          }

                          // Validasi Tahun Mulai
                          final tahunMulaiStr = _tahunMulaiController.text.trim();
                          if (tahunMulaiStr.isEmpty) {
                            tahunMulaiError = 'Tahun mulai harus diisi';
                            hasError = true;
                          } else {
                            final tahunMulai = int.tryParse(tahunMulaiStr);
                            if (tahunMulai == null) {
                              tahunMulaiError = 'Format tahun tidak valid';
                              hasError = true;
                            } else if (tahunMulai < 1900 || tahunMulai > DateTime.now().year) {
                              tahunMulaiError = 'Tahun mulai tidak valid';
                              hasError = true;
                            } else {
                              tahunMulaiError = null;
                            }
                          }

                          // Validasi Tahun Selesai
                          final tahunSelesaiStr = _tahunSelesaiController.text.trim();
                          if (tahunSelesaiStr.isEmpty) {
                            tahunSelesaiError = 'Tahun selesai harus diisi';
                            hasError = true;
                          } else {
                            final tahunSelesai = int.tryParse(tahunSelesaiStr);
                            final tahunMulai = int.tryParse(_tahunMulaiController.text.trim());
                            
                            if (tahunSelesai == null) {
                              tahunSelesaiError = 'Format tahun tidak valid';
                              hasError = true;
                            } else if (tahunSelesai < 1900 || tahunSelesai > DateTime.now().year + 5) {
                              tahunSelesaiError = 'Tahun selesai tidak valid';
                              hasError = true;
                            } else if (tahunMulai != null && tahunSelesai < tahunMulai) {
                              tahunSelesaiError = 'Tahun selesai harus lebih besar atau sama dengan tahun mulai';
                              hasError = true;
                            } else {
                              tahunSelesaiError = null;
                            }
                          }

                          // Validasi Nilai Akhir (opsional, tapi jika diisi harus valid)
                          final nilaiAkhirStr = _nilaiAkhirController.text.trim();
                          double? nilaiAkhirFinal;
                          
                          if (nilaiAkhirStr.isNotEmpty) {
                            final nilaiAkhir = double.tryParse(nilaiAkhirStr);
                            if (nilaiAkhir == null) {
                              nilaiAkhirError = 'Format nilai tidak valid';
                              hasError = true;
                            } else if (nilaiAkhir < 0 || nilaiAkhir > 4.0) {
                              nilaiAkhirError = 'Nilai harus antara 0.0 - 4.0';
                              hasError = true;
                            } else {
                              nilaiAkhirError = null;
                              nilaiAkhirFinal = nilaiAkhir;
                            }
                          } else {
                            // Jika kosong, tetap null (tidak error)
                            nilaiAkhirError = null;
                            nilaiAkhirFinal = null;
                          }

                          // Update UI untuk menampilkan error
                          if (hasError) {
                            setModalState(() {});
                            return;
                          }

                          // Jika semua validasi lolos
                          final tahunMulai = int.parse(_tahunMulaiController.text.trim());
                          final tahunSelesai = int.parse(_tahunSelesaiController.text.trim());

                          final newEducation = EducationModel(
                            educationId: education?.educationId,
                            jenjang: _selectedJenjang!,
                            jurusan: _jurusanController.text.trim(),
                            institusi: _institusiController.text.trim(),
                            tahunMasuk: tahunMulai,
                            tahunLulus: tahunSelesai,
                            nilaiAkhir: nilaiAkhirFinal, // Bisa null jika dikosongkan
                            gelar: '',
                          );

                          Navigator.pop(context);

                          if (isEdit) {
                            _updateEducation(newEducation);
                          } else {
                            _addEducation(newEducation);
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
                        _buildJenjangDropdown(
                          selectedValue: _selectedJenjang,
                          onChanged: (String? newValue) {
                            setModalState(() {
                              _selectedJenjang = newValue;
                            });
                          },
                          label: 'Jenjang Pendidikan',
                          required: true,
                          errorText: jenjangError,
                        ),
                        const SizedBox(height: 16),
                        
                        _buildTextField(
                          controller: _jurusanController,
                          label: 'Jurusan',
                          hint: 'Contoh: Rekayasa Perangkat Lunak',
                          icon: Icons.menu_book_outlined,
                          required: true,
                          errorText: jurusanError,
                        ),
                        const SizedBox(height: 16),
                        
                        _buildTextField(
                          controller: _institusiController,
                          label: 'Nama Institusi',
                          hint: 'Contoh: Politeknik Negeri Batam',
                          icon: Icons.apartment_outlined,
                          required: true,
                          errorText: institusiError,
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
                                errorText: tahunMulaiError,
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
                                errorText: tahunSelesaiError,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        _buildNilaiTextField(
                          controller: _nilaiAkhirController,
                          label: 'Nilai Akhir',
                          hint: 'Contoh: 3.75',
                          icon: Icons.grade_outlined,
                          required: false,
                          errorText: nilaiAkhirError,
                        ),
                        const SizedBox(height: 30),

                        // Tombol hapus (hanya jika edit)
                        if (isEdit) ...[
                          const SizedBox(height: 32),
                          Center(
                            child: OutlinedButton.icon(
                              onPressed: () {
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

  Future<void> _addEducation(EducationModel education) async {
    try {
      await _apiService.createEducation(education);
      if (mounted) {
        await _loadEducation();
        _showSnackBar('Pendidikan berhasil ditambahkan');
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Gagal menambahkan pendidikan', isError: true);
      }
    }
  }

  Future<void> _updateEducation(EducationModel education) async {
    if (education.educationId == null) {
      if (mounted) {
        _showSnackBar('ID pendidikan tidak valid', isError: true);
      }
      return;
    }

    try {
      await _apiService.updateEducation(
        education.educationId!,
        education,
      );
      if (mounted) {
        await _loadEducation();
        _showSnackBar('Pendidikan berhasil diperbarui');
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Gagal memperbarui pendidikan', isError: true);
      }
    }
  }

  Future<void> _deleteEducation(String educationId) async {
    try {
      await _apiService.deleteEducation(educationId);
      // Tidak perlu mounted check disini karena fungsi akan dipanggil
      // setelah konfirmasi dialog yang masih dalam mounted state
      if (mounted) {
        await _loadEducation();
      }
      // Tampilkan snackbar dengan delay untuk memastikan context masih ada
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _showSnackBar('Pendidikan berhasil dihapus');
        }
      });
    } catch (e) {
      // Tampilkan snackbar dengan delay untuk memastikan context masih ada
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _showSnackBar('Gagal menghapus pendidikan', isError: true);
        }
      });
    }
  }

  Widget _buildJenjangDropdown({
    required String? selectedValue,
    required ValueChanged<String?> onChanged,
    required String label,
    bool required = false,
    String? errorText,
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
            border: Border.all(
              color: errorText != null ? Colors.red : Colors.grey.shade300,
            ),
            color: Colors.grey.shade50,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue,
              isExpanded: true,
              icon: Icon(
                Icons.arrow_drop_down,
                color: Colors.grey.shade600,
              ),
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins',
                color: Color(0xFF515151),
              ),
              items: _jenjangOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins',
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
              hint: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Pilih Jenjang',
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(
              errorText,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'Poppins',
                color: Colors.red,
              ),
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
    String? errorText,
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            errorText: errorText,
            errorStyle: const TextStyle(
              fontSize: 12,
              fontFamily: 'Poppins',
              color: Colors.red,
            ),
            helperText: errorText == null ? helperText : null,
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

  Widget _buildNilaiTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    bool required = false,
    String? helperText,
    String? errorText,
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
          keyboardType: TextInputType.numberWithOptions(decimal: true),
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            errorText: errorText,
            errorStyle: const TextStyle(
              fontSize: 12,
              fontFamily: 'Poppins',
              color: Colors.red,
            ),
            helperText: errorText == null 
              ? 'Opsional (IPK 0.0 - 4.0)'
              : null,
            helperStyle: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
              fontFamily: 'Poppins',
            ),
            suffixIcon: errorText == null && controller.text.isNotEmpty
              ? ValueListenableBuilder<TextEditingValue>(
                  valueListenable: controller,
                  builder: (context, value, child) {
                    if (value.text.isEmpty) return const SizedBox();

                    final nilai = double.tryParse(value.text.trim());
                    if (nilai == null) {
                      return Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 20,
                      );
                    } else if (nilai >= 0 && nilai <= 4.0) {
                      return Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 20,
                      );
                    } else {
                      return Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 20,
                      );
                    }
                  },
                )
              : null,
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(EducationModel education) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
            onPressed: () async {
              Navigator.pop(context);
              if (education.educationId != null) {
                await _deleteEducation(education.educationId!);
              }
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
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF1B56FD)),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Color(0xFFB8B8B8)),
            const SizedBox(height: 16),
            const Text(
              'Terjadi Kesalahan',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                color: Color(0xFF515151),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  color: Color(0xFFB8B8B8),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadEducation,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B56FD),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      );
    }

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

            // Empty State atau List
            if (_education.isEmpty)
              Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.school_outlined,
                      size: 60,
                      color: Color(0xFFB8B8B8),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Belum ada data pendidikan',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF515151),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tambahkan riwayat pendidikan Anda',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        color: Color(0xFFB8B8B8),
                      ),
                    ),
                  ],
                ),
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