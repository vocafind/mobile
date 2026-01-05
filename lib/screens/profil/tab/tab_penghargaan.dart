import 'package:flutter/material.dart';
import 'package:vocafind/api/api_service.dart';
import 'package:vocafind/models/talent_award_model.dart';
import 'package:url_launcher/url_launcher.dart';

class TabPenghargaan extends StatefulWidget {
  const TabPenghargaan({super.key});

  @override
  State<TabPenghargaan> createState() => _TabPenghargaanState();
}

class _TabPenghargaanState extends State<TabPenghargaan> {
  final ApiService _apiService = ApiService();
  List<AwardModel> _awards = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAwards();
  }

  Future<void> _loadAwards() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
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
        setState(() {
          _isLoading = false;
          _errorMessage = 'Gagal memuat data: ${e.toString()}';
        });
        _showSnackBar('Gagal memuat data penghargaan', isError: true);
      }
      print("Error load awards: $e");
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;

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

  Future<void> _launchUrl(String urlString) async {
    try {
      final Uri url = Uri.parse(urlString);
      
      if (!await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      )) {
        _showSnackBar('Tidak dapat membuka link', isError: true);
      }
    } catch (e) {
      _showSnackBar('URL tidak valid', isError: true);
    }
  }

  // ✅ FUNGSI VALIDASI URL
  bool _isValidUrl(String url) {
    if (url.isEmpty) return true;
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

  // Deklarasikan error variables
  String? namaPenghargaanError;
  String? pemberiPenghargaanError;
  String? tahunError;
  String? sertifikatError;

  // Controller form
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
                      onPressed: () => Navigator.pop(context),
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
                      onPressed: () {
                        // Reset error messages
                        bool hasError = false;

                        // Validasi Nama Penghargaan
                        final namaPenghargaan = _judulController.text.trim();
                        if (namaPenghargaan.isEmpty) {
                          namaPenghargaanError = 'Nama penghargaan harus diisi';
                          hasError = true;
                        } else {
                          namaPenghargaanError = null;
                        }

                        // Validasi Pemberi Penghargaan
                        final pemberiPenghargaan = _institusiController.text.trim();
                        if (pemberiPenghargaan.isEmpty) {
                          pemberiPenghargaanError = 'Pemberi penghargaan harus diisi';
                          hasError = true;
                        } else {
                          pemberiPenghargaanError = null;
                        }

                        // Validasi Tahun
                        final tahunStr = _tahunController.text.trim();
                        if (tahunStr.isEmpty) {
                          tahunError = 'Tahun harus diisi';
                          hasError = true;
                        } else {
                          final tahun = int.tryParse(tahunStr);
                          if (tahun == null) {
                            tahunError = 'Format tahun tidak valid';
                            hasError = true;
                          } else if (tahun < 1900 || tahun > DateTime.now().year) {
                            tahunError = 'Tahun tidak valid';
                            hasError = true;
                          } else {
                            tahunError = null;
                          }
                        }

                        // Validasi URL Sertifikat
                        final sertifikat = _urlSertifikatController.text.trim();
                        if (sertifikat.isNotEmpty && !_isValidUrl(sertifikat)) {
                          sertifikatError = 'URL harus lengkap dengan http:// atau https://';
                          hasError = true;
                        } else {
                          sertifikatError = null;
                        }

                        // Update UI untuk menampilkan error
                        if (hasError) {
                          setModalState(() {});
                          return;
                        }

                        // Jika semua validasi lolos
                        final tahun = int.parse(tahunStr);
                        final deskripsi = _deskripsiController.text.trim();

                        final newAward = AwardModel(
                          awardId: award?.awardId,
                          namaPenghargaan: namaPenghargaan,
                          tingkatPenghargaan: _selectedBadge,
                          pemberiPenghargaan: pemberiPenghargaan,
                          tahun: tahun,
                          deskripsi: deskripsi,
                          sertifikat: sertifikat,
                        );

                        Navigator.pop(context);

                        if (isEdit) {
                          _updateAward(newAward);
                        } else {
                          _addAward(newAward);
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
                        errorText: namaPenghargaanError,
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
                            children: ['Regional', 'National', 'International']
                                .map((badge) {
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
                                    borderRadius: BorderRadius.circular(10),
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
                        errorText: pemberiPenghargaanError,
                      ),

                      const SizedBox(height: 16),

                      _buildTahunTextField(
                        controller: _tahunController,
                        label: 'Tahun',
                        hint: 'Contoh: 2024',
                        icon: Icons.calendar_today_outlined,
                        required: true,
                        errorText: tahunError,
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

                      _buildUrlTextField(
                        controller: _urlSertifikatController,
                        label: 'URL Penghargaan',
                        hint: 'https://drive.google.com/file/d/contoh-sertifikat',
                        icon: Icons.link,
                        helperText: 'Opsional - Link menuju file Penghargaan',
                        errorText: sertifikatError,
                      ),

                      // Tombol Hapus (hanya untuk edit)
                      if (isEdit) ...[
                        const SizedBox(height: 32),
                        Center(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _showDeleteConfirmation(award!);
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

  Future<void> _addAward(AwardModel award) async {
    try {
      await _apiService.createAward(award);
      if (mounted) {
        await _loadAwards();
        _showSnackBar('Penghargaan berhasil ditambahkan');
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Gagal menambahkan penghargaan', isError: true);
      }
    }
  }

  Future<void> _updateAward(AwardModel award) async {
    if (award.awardId == null) {
      if (mounted) {
        _showSnackBar('ID penghargaan tidak valid', isError: true);
      }
      return;
    }

    try {
      await _apiService.updateAward(
        award.awardId!,
        award,
      );
      if (mounted) {
        await _loadAwards();
        _showSnackBar('Penghargaan berhasil diperbarui');
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Gagal memperbarui penghargaan', isError: true);
      }
    }
  }

  Future<void> _deleteAward(String awardId) async {
    try {
      await _apiService.deleteAward(awardId);
      if (mounted) {
        await _loadAwards();
      }
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _showSnackBar('Penghargaan berhasil dihapus');
        }
      });
    } catch (e) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _showSnackBar('Gagal menghapus penghargaan', isError: true);
        }
      });
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

  Widget _buildTahunTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
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
          keyboardType: TextInputType.number,
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
            suffixIcon: errorText == null
                ? ValueListenableBuilder<TextEditingValue>(
                    valueListenable: controller,
                    builder: (context, value, child) {
                      if (value.text.isEmpty) return const SizedBox();

                      final tahun = int.tryParse(value.text.trim());
                      if (tahun == null) {
                        return Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 20,
                        );
                      } else if (tahun >= 1900 && tahun <= DateTime.now().year) {
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

  Widget _buildUrlTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
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
            suffixIcon: errorText == null
                ? ValueListenableBuilder<TextEditingValue>(
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
                  )
                : null,
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(AwardModel award) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
              if (award.awardId != null) {
                _deleteAward(award.awardId!);
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
              onPressed: _loadAwards,
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

            // List atau Empty State
            if (_awards.isEmpty)
              Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.workspace_premium_outlined,
                      size: 60,
                      color: Color(0xFFB8B8B8),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Belum ada data penghargaan',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF515151),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tambahkan penghargaan yang pernah Anda raih',
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
                children: List.generate(_awards.length, (index) {
                  final award = _awards[index];
                  final isFirst = index == 0;
                  final isLast = index == _awards.length - 1;

                  return _buildPenghargaanItem(
                    title: award.namaPenghargaan,
                    institution: award.pemberiPenghargaan,
                    year: award.tahun?.toString() ?? '-',
                    badge: award.tingkatPenghargaan,
                    certificateUrl: award.sertifikat,
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
    required String certificateUrl,
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
                    if (certificateUrl.isNotEmpty)
                      GestureDetector(
                        onTap: () => _launchUrl(certificateUrl),
                        child: Row(
                          children: [
                            Text(
                              'Lihat Penghargaan',
                              style: TextStyle(
                                color: const Color(0xFF0E38EB),
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.open_in_new,
                              size: 14,
                              color: const Color(0xFF0E38EB),
                            ),
                          ],
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