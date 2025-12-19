import 'package:flutter/material.dart';
import 'package:jobfair/api/api_service.dart';
import 'package:jobfair/models/talent_certification_model.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class TabSertifikasi extends StatefulWidget {
  const TabSertifikasi({super.key});

  @override
  State<TabSertifikasi> createState() => _TabSertifikasiState();
}

class _TabSertifikasiState extends State<TabSertifikasi> {
  final ApiService _apiService = ApiService();
  List<CertificationModel> _certifications = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCertifications();
  }

  Future<void> _loadCertifications() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      final certifications = await _apiService.getCertification();
      if (mounted) {
        setState(() {
          _certifications = certifications;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Gagal memuat data: ${e.toString()}';
        });
        _showSnackBar('Gagal memuat data sertifikasi', isError: true);
      }
      print("Error load certifications: $e");
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

  // Deklarasikan error variables
  String? namaSertifikasiError;
  String? lembagaError;
  String? tanggalTerbitError;
  String? tanggalHabisError;
  String? nomorSertifikatError;
  String? urlSertifikatError;

  // Controller form
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
                      onPressed: () => Navigator.pop(context),
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
                      onPressed: () {
                        // Reset error messages
                        bool hasError = false;

                        // Validasi Nama Sertifikasi
                        final namaSertifikasi = _namaController.text.trim();
                        if (namaSertifikasi.isEmpty) {
                          namaSertifikasiError = 'Nama sertifikasi harus diisi';
                          hasError = true;
                        } else {
                          namaSertifikasiError = null;
                        }

                        // Validasi Lembaga
                        final lembaga = _lembagaController.text.trim();
                        if (lembaga.isEmpty) {
                          lembagaError = 'Lembaga sertifikasi harus diisi';
                          hasError = true;
                        } else {
                          lembagaError = null;
                        }

                        // Validasi Tanggal Terbit
                        final tanggalTerbitStr = _tanggalTerbitController.text.trim();
                        if (tanggalTerbitStr.isEmpty) {
                          tanggalTerbitError = 'Tanggal terbit harus diisi';
                          hasError = true;
                        } else {
                          final tanggalTerbit = _parseDate(tanggalTerbitStr);
                          if (tanggalTerbit == null) {
                            tanggalTerbitError = 'Format tanggal tidak valid (DD/MM/YYYY)';
                            hasError = true;
                          } else {
                            tanggalTerbitError = null;
                          }
                        }

                        // Validasi Tanggal Habis
                        final tanggalHabisStr = _tanggalHabisController.text.trim();
                        if (tanggalHabisStr.isEmpty) {
                          tanggalHabisError = 'Tanggal habis masa berlaku harus diisi';
                          hasError = true;
                        } else {
                          final tanggalHabis = _parseDate(tanggalHabisStr);
                          final tanggalTerbit = _parseDate(_tanggalTerbitController.text.trim());
                          
                          if (tanggalHabis == null) {
                            tanggalHabisError = 'Format tanggal tidak valid (DD/MM/YYYY)';
                            hasError = true;
                          } else if (tanggalTerbit != null && tanggalHabis.isBefore(tanggalTerbit)) {
                            tanggalHabisError = 'Tanggal habis harus setelah tanggal terbit';
                            hasError = true;
                          } else {
                            tanggalHabisError = null;
                          }
                        }

                        // Validasi Nomor Sertifikat
                        final nomor = _nomorController.text.trim();
                        if (nomor.isEmpty) {
                          nomorSertifikatError = 'Nomor sertifikat harus diisi';
                          hasError = true;
                        } else {
                          nomorSertifikatError = null;
                        }

                        // Validasi URL Sertifikat
                        final url = _urlController.text.trim();
                        if (url.isNotEmpty && !_isValidUrl(url)) {
                          urlSertifikatError = 'URL harus lengkap dengan http:// atau https://';
                          hasError = true;
                        } else {
                          urlSertifikatError = null;
                        }

                        // Update UI untuk menampilkan error
                        if (hasError) {
                          setModalState(() {});
                          return;
                        }

                        // Jika semua validasi lolos
                        final tanggalTerbit = _parseDate(tanggalTerbitStr)!;
                        final tanggalHabis = _parseDate(tanggalHabisStr)!;

                        final newCertification = CertificationModel(
                          certificationId: certification?.certificationId,
                          namaSertifikasi: namaSertifikasi,
                          lembagaSertifikasi: lembaga,
                          tanggalTerbit: tanggalTerbit,
                          tanggalHabisMasa: tanggalHabis,
                          nomorSertifikat: nomor,
                          sertifikat: url,
                        );

                        Navigator.pop(context);

                        if (isEdit) {
                          _updateCertification(newCertification);
                        } else {
                          _addCertification(newCertification);
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
                        errorText: namaSertifikasiError,
                      ),
                      const SizedBox(height: 16),

                      _buildTextField(
                        controller: _lembagaController,
                        label: 'Lembaga Sertifikasi',
                        hint: 'Contoh: BNSP, Cisco, Microsoft',
                        icon: Icons.business_outlined,
                        required: true,
                        errorText: lembagaError,
                      ),
                      const SizedBox(height: 16),

                      _buildDateField(
                        controller: _tanggalTerbitController,
                        label: 'Tanggal Terbit',
                        hint: 'dd/mm/yyyy',
                        required: true,
                        setModalState: setModalState,
                        errorText: tanggalTerbitError,
                      ),
                      const SizedBox(height: 16),

                      _buildDateField(
                        controller: _tanggalHabisController,
                        label: 'Tanggal Habis Masa Berlaku',
                        hint: 'dd/mm/yyyy',
                        required: true,
                        setModalState: setModalState,
                        errorText: tanggalHabisError,
                      ),
                      const SizedBox(height: 16),

                      _buildTextField(
                        controller: _nomorController,
                        label: 'Nomor Sertifikat',
                        hint: 'Contoh: 12345/DS/2024',
                        icon: Icons.badge_outlined,
                        required: true,
                        errorText: nomorSertifikatError,
                      ),
                      const SizedBox(height: 16),

                      _buildUrlTextField(
                        controller: _urlController,
                        label: 'URL Sertifikat Penghargaan',
                        hint: 'https://contoh.com/sertifikat.pdf',
                        icon: Icons.link,
                        required: false,
                        errorText: urlSertifikatError,
                      ),

                      // Tombol Hapus (hanya untuk edit)
                      if (isEdit) ...[
                        const SizedBox(height: 32),
                        Center(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _showDeleteConfirmation(certification!);
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
    )
  );
}

  Future<void> _addCertification(CertificationModel certification) async {
    try {
      await _apiService.createCertification(certification);
      if (mounted) {
        await _loadCertifications();
        _showSnackBar('Sertifikasi berhasil ditambahkan');
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Gagal menambahkan sertifikasi', isError: true);
      }
    }
  }

  Future<void> _updateCertification(CertificationModel certification) async {
    if (certification.certificationId == null) {
      if (mounted) {
        _showSnackBar('ID sertifikasi tidak valid', isError: true);
      }
      return;
    }

    try {
      await _apiService.updateCertification(
        certification.certificationId!,
        certification,
      );
      if (mounted) {
        await _loadCertifications();
        _showSnackBar('Sertifikasi berhasil diperbarui');
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Gagal memperbarui sertifikasi', isError: true);
      }
    }
  }

  Future<void> _deleteCertification(String certificationId) async {
    try {
      await _apiService.deleteCertification(certificationId);
      if (mounted) {
        await _loadCertifications();
      }
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _showSnackBar('Sertifikasi berhasil dihapus');
        }
      });
    } catch (e) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _showSnackBar('Gagal menghapus sertifikasi', isError: true);
        }
      });
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int? maxLength,
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
          readOnly: true,
          onTap: () async {
            await _selectDate(context, controller);
            setModalState(() {});
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

  void _showDeleteConfirmation(CertificationModel certification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
              if (certification.certificationId != null) {
                _deleteCertification(certification.certificationId!);
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
              onPressed: _loadCertifications,
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

            // List atau Empty State
            if (_certifications.isEmpty)
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
                      'Belum ada data sertifikasi',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF515151),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tambahkan sertifikasi yang Anda miliki',
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
                    certificateUrl: cert.sertifikat,
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
                const SizedBox(height: 10),

                // Tombol lihat sertifikat (jika ada)
                if (certificateUrl.isNotEmpty)
                  GestureDetector(
                    onTap: () => _launchUrl(certificateUrl),
                    child: Row(
                      children: [
                        Text(
                          'Lihat sertifikat',
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

                // Tanggal di pojok kanan bawah
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