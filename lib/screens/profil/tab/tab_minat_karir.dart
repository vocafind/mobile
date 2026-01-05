import 'package:flutter/material.dart';
import 'package:vocafind/api/api_service.dart';
import 'package:vocafind/models/talent_career_interest_model.dart';

class TabMinatKarir extends StatefulWidget {
  const TabMinatKarir({super.key});

  @override
  State<TabMinatKarir> createState() => _TabMinatKarirState();
}

class _TabMinatKarirState extends State<TabMinatKarir> {
  final ApiService _apiService = ApiService();
  List<CareerInterestModel> _careerInterests = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCareerInterests();
  }

  Future<void> _loadCareerInterests() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final careerInterests = await _apiService.getCareerInterest();
      if (mounted) {
        setState(() {
          _careerInterests = careerInterests;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Gagal memuat data: ${e.toString()}';
        });
        _showSnackBar('Gagal memuat data minat karir', isError: true);
      }
    }
  }

  Future<void> _addCareerInterest(CareerInterestModel careerInterest) async {
    try {
      await _apiService.createCareerInterest(careerInterest);
      if (mounted) {
        await _loadCareerInterests();
        _showSnackBar('Minat karir berhasil ditambahkan');
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Gagal menambahkan minat karir', isError: true);
      }
    }
  }

  Future<void> _updateCareerInterest(CareerInterestModel careerInterest) async {
    if (careerInterest.careerinterestId == null) {
      if (mounted) {
        _showSnackBar('ID minat karir tidak valid', isError: true);
      }
      return;
    }

    try {
      await _apiService.updateCareerInterest(
        careerInterest.careerinterestId!,
        careerInterest,
      );
      if (mounted) {
        await _loadCareerInterests();
        _showSnackBar('Minat karir berhasil diperbarui');
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Gagal memperbarui minat karir', isError: true);
      }
    }
  }

  Future<void> _deleteCareerInterest(String careerInterestId) async {
    try {
      await _apiService.deleteCareerInterest(careerInterestId);
      if (mounted) {
        await _loadCareerInterests();
        _showSnackBar('Minat karir berhasil dihapus');
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Gagal menghapus minat karir', isError: true);
      }
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

void _showAddEditModal({CareerInterestModel? careerInterest}) {
  final isEdit = careerInterest != null;

  final TextEditingController _bidangControllerLocal =
      TextEditingController();
  final TextEditingController _alasanControllerLocal =
      TextEditingController();
  String _selectedLevelLocal = 'Tinggi';

  // Deklarasikan error variables di sini
  String? bidangError;
  String? alasanError;

  // Inisialisasi nilai jika edit
  if (careerInterest != null) {
    _bidangControllerLocal.text = careerInterest.bidangKetertarikan;
    _alasanControllerLocal.text = careerInterest.alasan;
    _selectedLevelLocal = careerInterest.tingkatKetertarikan;
  }

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
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Text(
                          isEdit ? 'Edit Minat Karir' : 'Tambah Minat Karir',
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

                          // Validasi Bidang Minat
                          if (_bidangControllerLocal.text.trim().isEmpty) {
                            bidangError = 'Bidang minat harus diisi';
                            hasError = true;
                          } else {
                            bidangError = null;
                          }

                          // Validasi Alasan Minat
                            final alasan = _alasanControllerLocal.text.trim();

                            if (alasan.isEmpty) {
                              alasanError = 'Alasan minat harus diisi';
                              hasError = true;
                            } else {
                              alasanError = null;
                            }


                          // Update UI untuk menampilkan error
                          if (hasError) {
                            setModalState(() {});
                            return;
                          }

                          // Jika semua validasi lolos
                          final newCareerInterest = CareerInterestModel(
                            careerinterestId: careerInterest?.careerinterestId,
                            tingkatKetertarikan: _selectedLevelLocal,
                            alasan: alasan,
                            bidangKetertarikan: _bidangControllerLocal.text.trim(),
                          );

                          Navigator.pop(context);

                          if (isEdit) {
                            _updateCareerInterest(newCareerInterest);
                          } else {
                            _addCareerInterest(newCareerInterest);
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
                            color: const Color(0xFFFFF3E0),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFFFB74D)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.info_outline,
                                color: Color(0xFFE65100),
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Tambahkan bidang karir yang Anda minati. Informasi ini membantu perusahaan menemukan kandidat yang sesuai.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.orange.shade900,
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
                          controller: _bidangControllerLocal,
                          label: 'Bidang Minat',
                          hint: 'Contoh: Teknologi Informasi, Marketing',
                          icon: Icons.work_outline,
                          required: true,
                          errorText: bidangError,
                        ),
                        const SizedBox(height: 16),

                        // Tingkat Minat Dropdown
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Text(
                                  'Tingkat Ketertarikan',
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
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedLevelLocal,
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
                                  items: ['Tinggi', 'Sedang', 'Rendah'].map((
                                    String value,
                                  ) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Row(
                                        children: [
                                          Icon(
                                            _getInterestIcon(value),
                                            size: 18,
                                            color: _getInterestColor(value),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(value),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      setModalState(() {
                                        _selectedLevelLocal = newValue;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _alasanControllerLocal,
                          label: 'Alasan Minat',
                          hint:
                              'Jelaskan mengapa Anda tertarik dengan bidang ini...',
                          icon: Icons.description_outlined,
                          maxLines: 5,
                          required: true,
                          errorText: alasanError,
                        ),

                        // Tombol Hapus (hanya untuk edit)
                        if (isEdit) ...[
                          const SizedBox(height: 32),
                          Center(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                _showDeleteConfirmation(careerInterest!);
                              },
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              label: const Text(
                                'Hapus Minat Karir',
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

  IconData _getInterestIcon(String level) {
    switch (level) {
      case 'Tinggi':
        return Icons.trending_up;
      case 'Sedang':
        return Icons.trending_flat;
      case 'Rendah':
        return Icons.trending_down;
      default:
        return Icons.circle;
    }
  }

  Color _getInterestColor(String level) {
    switch (level) {
      case 'Tinggi':
        return Colors.green;
      case 'Sedang':
        return Colors.orange;
      case 'Rendah':
        return Colors.grey;
      default:
        return Colors.grey;
    }
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

  void _showDeleteConfirmation(CareerInterestModel careerInterest) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: const Text(
          'Hapus Minat Karir',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus ${careerInterest.bidangKetertarikan}?',
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
              Navigator.pop(context);
              if (careerInterest.careerinterestId != null) {
                _deleteCareerInterest(careerInterest.careerinterestId!);
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
              onPressed: _loadCareerInterests,
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
      onRefresh: _loadCareerInterests,
      color: const Color(0xFF1B56FD),
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
                    border: Border.all(color: const Color(0xFF113CEE)),
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

            // List atau Empty State
            if (_careerInterests.isEmpty)
              Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.work_outline,
                      size: 60,
                      color: Color(0xFFB8B8B8),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Belum ada minat karir',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF515151),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tambahkan minat karir Anda',
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
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _careerInterests.length,
                itemBuilder: (context, index) {
                  final careerInterest = _careerInterests[index];
                  return _buildCareerInterestItem(
                    careerInterest: careerInterest,
                    isFirst: index == 0,
                    isLast: index == _careerInterests.length - 1,
                  );
                },
              ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildCareerInterestItem({
    required CareerInterestModel careerInterest,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return GestureDetector(
      onTap: () => _showAddEditModal(careerInterest: careerInterest),
      child: Container(
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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          careerInterest.bidangKetertarikan,
                          style: const TextStyle(
                            color: Color(0xFF515151),
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE2E2E2)),
                        ),
                        child: Text(
                          careerInterest.tingkatKetertarikan,
                          style: const TextStyle(
                            color: Color(0xFF464E5E),
                            fontSize: 10,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    careerInterest.alasan.length > 80
                        ? '${careerInterest.alasan.substring(0, 80)}...'
                        : careerInterest.alasan,
                    style: const TextStyle(
                      color: Color(0xFF515151),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w300,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Icon(
              Icons.edit_outlined,
              size: 20,
              color: Colors.black.withValues(alpha: 0.62),
            ),
          ],
        ),
      ),
    );
  }
}