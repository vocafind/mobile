import 'package:flutter/material.dart';
import 'package:vocafind/api/api_service.dart';
import 'package:vocafind/models/talent_softskill_model.dart';

class TabSoftSkill extends StatefulWidget {
  const TabSoftSkill({super.key});

  @override
  State<TabSoftSkill> createState() => _TabSoftSkillState();
}

class _TabSoftSkillState extends State<TabSoftSkill> {
  final ApiService _apiService = ApiService();
  List<SoftskillModel> _softskills = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSoftskills();
  }

  Future<void> _loadSoftskills() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      final softskills = await _apiService.getSoftskill();
      if (mounted) {
        setState(() {
          _softskills = softskills;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Gagal memuat data: ${e.toString()}';
        });
        _showSnackBar('Gagal memuat data soft skill', isError: true);
      }
      print("Error load softskills: $e");
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

void _showAddEditModal({SoftskillModel? softskill}) {
  final isEdit = softskill != null;

  // Deklarasikan error variables
  String? namaSkillError;
  String? deskripsiError;

  // Populate controllers if editing
  final TextEditingController _namaController = TextEditingController(
    text: softskill?.namaSkill ?? '',
  );
  final TextEditingController _deskripsiController = TextEditingController(
    text: softskill?.deskripsi ?? '',
  );
  String _selectedLevel = softskill?.profisiensi ?? 'Beginner';

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
                        isEdit ? 'Edit Soft Skill' : 'Tambah Soft Skill',
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

                        // Validasi Nama Skill
                        final namaSkill = _namaController.text.trim();
                        if (namaSkill.isEmpty) {
                          namaSkillError = 'Nama soft skill harus diisi';
                          hasError = true;
                        } else {
                          namaSkillError = null;
                        }

                        // Validasi Deskripsi
                        final deskripsi = _deskripsiController.text.trim();
                        if (deskripsi.isEmpty) {
                          deskripsiError = 'Deskripsi harus diisi';
                          hasError = true;
                        } else if (deskripsi.length < 30) {
                          deskripsiError = 'Minimal 30 karakter untuk deskripsi yang baik';
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
                        final newSoftskill = SoftskillModel(
                          softskillsId: softskill?.softskillsId,
                          namaSkill: namaSkill,
                          profisiensi: _selectedLevel,
                          deskripsi: deskripsi,
                        );

                        Navigator.pop(context);

                        if (isEdit) {
                          _updateSoftskill(newSoftskill);
                        } else {
                          _addSoftskill(newSoftskill);
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
                                'Tambahkan soft skill yang Anda kuasai. Jelaskan pengalaman atau pencapaian terkait skill tersebut.',
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
                        label: 'Nama Soft Skill',
                        hint: 'Contoh: Public Speaking, Leadership',
                        icon: Icons.lightbulb_outline,
                        required: true,
                        errorText: namaSkillError,
                      ),
                      const SizedBox(height: 16),

                      // Tingkat Kemampuan
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Text(
                                'Tingkat Kemampuan',
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
                            children: [
                              'Beginner',
                              'Intermediate',
                              'Advanced',
                              'Fluent',
                              'Native'
                            ].map((level) {
                              final isSelected = _selectedLevel == level;
                              return GestureDetector(
                                onTap: () {
                                  setModalState(() {
                                    _selectedLevel = level;
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
                                    level,
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
                        controller: _deskripsiController,
                        label: 'Deskripsi',
                        hint: 'Jelaskan pengalaman atau pencapaian terkait soft skill ini...',
                        icon: Icons.description_outlined,
                        maxLines: 5,
                        required: true,
                        helperText: 'Minimal 30 karakter untuk deskripsi yang baik',
                        errorText: deskripsiError,
                      ),

                      // Tombol Hapus (hanya untuk edit)
                      if (isEdit) ...[
                        const SizedBox(height: 32),
                        Center(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _showDeleteConfirmation(softskill!);
                            },
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                            label: const Text(
                              'Hapus Soft Skill',
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

  Future<void> _addSoftskill(SoftskillModel softskill) async {
    try {
      await _apiService.createSoftskill(softskill);
      if (mounted) {
        await _loadSoftskills();
        _showSnackBar('Soft skill berhasil ditambahkan');
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Gagal menambahkan soft skill', isError: true);
      }
    }
  }

  Future<void> _updateSoftskill(SoftskillModel softskill) async {
    if (softskill.softskillsId == null) {
      if (mounted) {
        _showSnackBar('ID soft skill tidak valid', isError: true);
      }
      return;
    }

    try {
      await _apiService.updateSoftskill(
        softskill.softskillsId!,
        softskill,
      );
      if (mounted) {
        await _loadSoftskills();
        _showSnackBar('Soft skill berhasil diperbarui');
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Gagal memperbarui soft skill', isError: true);
      }
    }
  }

  Future<void> _deleteSoftskill(String softskillId) async {
    try {
      await _apiService.deleteSoftskill(softskillId);
      if (mounted) {
        await _loadSoftskills();
      }
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _showSnackBar('Soft skill berhasil dihapus');
        }
      });
    } catch (e) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _showSnackBar('Gagal menghapus soft skill', isError: true);
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

  void _showDeleteConfirmation(SoftskillModel softskill) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: const Text(
          'Hapus Soft Skill',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus ${softskill.namaSkill}?',
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
              if (softskill.softskillsId != null) {
                _deleteSoftskill(softskill.softskillsId!);
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
              onPressed: _loadSoftskills,
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
      onRefresh: _loadSoftskills,
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
            if (_softskills.isEmpty)
              Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      size: 60,
                      color: Color(0xFFB8B8B8),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Belum ada data soft skill',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF515151),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tambahkan soft skill yang Anda kuasai',
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
                children: List.generate(_softskills.length, (index) {
                  final softskill = _softskills[index];
                  final isFirst = index == 0;
                  final isLast = index == _softskills.length - 1;

                  // Truncate description untuk display
                  String displayDescription = softskill.deskripsi;
                  if (displayDescription.length > 70) {
                    displayDescription = '${displayDescription.substring(0, 70)}....';
                  }

                  return _buildSoftSkillItem(
                    title: softskill.namaSkill,
                    level: softskill.profisiensi,
                    description: displayDescription,
                    isFirst: isFirst,
                    isLast: isLast,
                    onEdit: () {
                      _showAddEditModal(softskill: softskill);
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

  Widget _buildSoftSkillItem({
    required String title,
    required String level,
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
                Row(
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
                    const SizedBox(width: 8),
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
                        level,
                        style: const TextStyle(
                          color: Color(0xFF464E5E),
                          fontSize: 10,
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  description,
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