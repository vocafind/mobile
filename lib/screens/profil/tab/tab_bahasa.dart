import 'package:flutter/material.dart';
import 'package:jobfair/api/api_service.dart';
import 'package:jobfair/models/talent_language_model.dart';

class TabBahasa extends StatefulWidget {
  const TabBahasa({super.key});

  @override
  State<TabBahasa> createState() => _TabBahasaState();
}

class _TabBahasaState extends State<TabBahasa> {
  final ApiService _apiService = ApiService();
  List<LanguageModel> _languages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLanguages();
  }

  Future<void> _loadLanguages() async {
    setState(() => _isLoading = true);
    try {
      final languages = await _apiService.getLanguages();
      setState(() {
        _languages = languages;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('Gagal memuat data bahasa', isError: true);
      print("Error load languages: $e");
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

  void _showAddEditModal({LanguageModel? language}) {
    final isEdit = language != null;
    bool isSaving = false;

    // Controller form
    final TextEditingController namaBahasaController = TextEditingController(
      text: language?.namaBahasa ?? '',
    );
    final TextEditingController sertifikatController = TextEditingController(
      text: language?.sertifikat ?? '',
    );
    final TextEditingController skorController = TextEditingController(
      text: language?.skor ?? '',
    );
    String selectedProfisiensi = language?.profisiensi ?? 'Beginner';

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
                        onPressed: isSaving
                            ? null
                            : () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Text(
                          isEdit ? 'Edit Bahasa' : 'Tambah Bahasa',
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
                                final namaBahasa = namaBahasaController.text
                                    .trim();
                                final sertifikat = sertifikatController.text
                                    .trim();
                                final skor = skorController.text.trim();

                                if (namaBahasa.isEmpty) {
                                  _showSnackBar(
                                    "Nama bahasa wajib diisi",
                                    isError: true,
                                  );
                                  return;
                                }

                                setModalState(() => isSaving = true);

                                final lang = LanguageModel(
                                  languageId: language?.languageId,
                                  talentId: language?.talentId,
                                  namaBahasa: namaBahasa,
                                  profisiensi: selectedProfisiensi,
                                  sertifikat: sertifikat,
                                  skor: skor,
                                );

                                try {
                                  if (isEdit) {
                                    await _apiService.updateLanguage(
                                      language.languageId!,
                                      lang,
                                    );
                                    _showSnackBar(
                                      'Berhasil memperbarui bahasa',
                                    );
                                  } else {
                                    await _apiService.createLanguage(lang);
                                    _showSnackBar('Berhasil menambah bahasa');
                                  }

                                  await _loadLanguages();
                                  Navigator.pop(context);
                                } catch (e) {
                                  setModalState(() => isSaving = false);
                                  _showSnackBar(
                                    'Gagal menyimpan data',
                                    isError: true,
                                  );
                                  print("❌ Error submit language: $e");
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
                                  'Tambahkan kemampuan bahasa yang Anda kuasai. Sertakan sertifikat jika ada untuk meningkatkan kredibilitas.',
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
                          controller: namaBahasaController,
                          label: 'Nama Bahasa',
                          hint: 'Contoh: English, Mandarin, Japanese',
                          icon: Icons.language,
                          required: true,
                        ),
                        const SizedBox(height: 16),

                        // Tingkat Kemampuan (Profisiensi)
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
                              children:
                                  [
                                    'Beginner',
                                    'Intermediate',
                                    'Advanced',
                                    'Fluent',
                                    'Native',
                                  ].map((level) {
                                    final isSelected =
                                        selectedProfisiensi == level;
                                    return GestureDetector(
                                      onTap: () {
                                        setModalState(() {
                                          selectedProfisiensi = level;
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
                          controller: sertifikatController,
                          label: 'Url Sertifikat',
                          hint: 'Contoh: TOEFL, IELTS, JLPT N1',
                          icon: Icons.link,
                          helperText: 'Opsional - Nama sertifikat bahasa',
                        ),

                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: skorController,
                          label: 'Skor/Nilai',
                          hint: 'Contoh: 550, 7.5, Band 8',
                          icon: Icons.grade_outlined,
                          keyboardType: TextInputType.text,
                          helperText: 'Opsional - Skor dari sertifikat',
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
                                      _showDeleteConfirmation(language);
                                    },
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              label: const Text(
                                'Hapus Bahasa',
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

  void _showDeleteConfirmation(LanguageModel language) {
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
            'Hapus Bahasa',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Apakah Anda yakin ingin menghapus ${language.namaBahasa}?',
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
                        await _apiService.deleteLanguage(language.languageId!);
                        await _loadLanguages();
                        Navigator.pop(context);
                        _showSnackBar('Bahasa berhasil dihapus');
                      } catch (e) {
                        setDialogState(() => isDeleting = false);
                        _showSnackBar('Gagal menghapus bahasa', isError: true);
                        print("Error delete language: $e");
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
      onRefresh: _loadLanguages,
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
            else if (_languages.isEmpty)
              const Text(
                "Belum ada data bahasa",
                style: TextStyle(fontFamily: 'Poppins'),
              )
            else
              Column(
                children: List.generate(_languages.length, (index) {
                  final lang = _languages[index];
                  final isFirst = index == 0;
                  final isLast = index == _languages.length - 1;

                  return _buildBahasaItem(
                    language: lang.namaBahasa,
                    level: lang.profisiensi,
                    certificate: lang.sertifikat.isNotEmpty
                        ? lang.sertifikat
                        : '-',
                    score: lang.skor.isNotEmpty ? 'Skor : ${lang.skor}' : '-',
                    isFirst: isFirst,
                    isLast: isLast,
                    onEdit: () {
                      _showAddEditModal(language: lang);
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

  Widget _buildBahasaItem({
    required String language,
    required String level,
    required String certificate,
    required String score,
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
                      language,
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
                const SizedBox(height: 8),
                Text(
                  'Lihat sertifikat',
                  style: TextStyle(
                    color: Color(0xFF0E38EB),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  score,
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
