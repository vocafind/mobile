import 'package:flutter/material.dart';
import 'package:jobfair/api/api_service.dart';
import 'package:jobfair/models/talent_portofolio_model.dart';

class TabPortofolio extends StatefulWidget {
  const TabPortofolio({super.key});

  @override
  State<TabPortofolio> createState() => _TabPortofolioState();
}

class _TabPortofolioState extends State<TabPortofolio> {
  final ApiService _apiService = ApiService();
  List<PortofolioModel> _portofolio = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPortofolio();
  }

  Future<void> _loadPortofolio() async {
    setState(() => _isLoading = true);
    try {
      final portofolio = await _apiService.getPortofolio();
      setState(() {
        _portofolio = portofolio;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('Gagal memuat data portofolio', isError: true);
      print("Error load portofolio: $e");
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

  void _showAddEditModal({PortofolioModel? portofolio}) {
    final isEdit = portofolio != null;
    bool isSaving = false;

    // Controller form
    final _judulController = TextEditingController(
      text: portofolio?.judul ?? '',
    );
    final _deskripsiController = TextEditingController(
      text: portofolio?.deskripsi ?? '',
    );
    final _linkPortofolioController = TextEditingController(
      text: portofolio?.linkPorotofolio ?? '',
    );
    final _galeriPortofolioController = TextEditingController(
      text: portofolio?.galeriPortofolio ?? '',
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
                          isEdit ? 'Edit Portofolio' : 'Tambah Portofolio',
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
                                final judul = _judulController.text.trim();
                                final deskripsi = _deskripsiController.text.trim();
                                final linkPortofolio = _linkPortofolioController.text.trim();
                                final galeriPortofolio = _galeriPortofolioController.text.trim();

                                if (judul.isEmpty || deskripsi.isEmpty) {
                                  _showSnackBar(
                                    "Judul dan deskripsi wajib diisi",
                                    isError: true,
                                  );
                                  return;
                                }

                                setModalState(() => isSaving = true);

                                final portfolio = PortofolioModel(
                                  portfolioId: portofolio?.portfolioId,
                                  talentId: portofolio?.talentId,
                                  judul: judul,
                                  deskripsi: deskripsi,
                                  linkPorotofolio: linkPortofolio,
                                  galeriPortofolio: galeriPortofolio,
                                );

                                try {
                                  if (isEdit) {
                                    await _apiService.updatePortofolio(
                                      portofolio!.portfolioId!,
                                      portfolio,
                                    );
                                    _showSnackBar('Berhasil memperbarui portofolio');
                                  } else {
                                    await _apiService.createPortofolio(portfolio);
                                    _showSnackBar('Berhasil menambah portofolio');
                                  }

                                  await _loadPortofolio();
                                  Navigator.pop(context);
                                } catch (e) {
                                  setModalState(() => isSaving = false);
                                  _showSnackBar(
                                    'Gagal menyimpan data',
                                    isError: true,
                                  );
                                  print("❌ Error submit portofolio: $e");
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
                                  'Tambahkan portofolio karya Anda untuk menunjukkan hasil kerja dan kreativitas kepada perekrut.',
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
                          controller: _judulController,
                          label: 'Judul',
                          hint: 'Contoh: Sistem Keuangan Negara',
                          icon: Icons.title_outlined,
                          required: true,
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _deskripsiController,
                          label: 'Deskripsi',
                          hint: 'Jelaskan detail tentang portofolio ini...',
                          icon: Icons.description_outlined,
                          maxLines: 5,
                          required: true,
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _linkPortofolioController,
                          label: 'Link Portofolio',
                          hint: 'https://example.com/portfolio',
                          icon: Icons.link_outlined,
                          keyboardType: TextInputType.url,
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _galeriPortofolioController,
                          label: 'Link Galeri Portofolio',
                          hint: 'https://example.com/gallery',
                          icon: Icons.image_outlined,
                          keyboardType: TextInputType.url,
                        ),

                        // Tombol Hapus (hanya jika edit)
                        if (isEdit) ...[
                          const SizedBox(height: 32),
                          Center(
                            child: OutlinedButton.icon(
                              onPressed: isSaving
                                  ? null
                                  : () {
                                      Navigator.pop(context);
                                      _showDeleteConfirmation(portofolio!);
                                    },
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              label: const Text(
                                'Hapus Portofolio',
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

  void _showDeleteConfirmation(PortofolioModel portofolio) {
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
            'Hapus Portofolio',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Apakah Anda yakin ingin menghapus portofolio "${portofolio.judul}"?',
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
                        await _apiService.deletePortofolio(
                          portofolio.portfolioId!,
                        );
                        await _loadPortofolio();
                        Navigator.pop(context);
                        _showSnackBar('Portofolio berhasil dihapus');
                      } catch (e) {
                        setDialogState(() => isDeleting = false);
                        _showSnackBar(
                          'Gagal menghapus portofolio',
                          isError: true,
                        );
                        print("Error delete portofolio: $e");
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
      onRefresh: _loadPortofolio,
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
            else if (_portofolio.isEmpty)
              const Text(
                "Belum ada data portofolio",
                style: TextStyle(fontFamily: 'Poppins'),
              )
            else
              Column(
                children: List.generate(_portofolio.length, (index) {
                  final portfolio = _portofolio[index];
                  final isFirst = index == 0;
                  final isLast = index == _portofolio.length - 1;

                  return _buildPortofolioItem(
                    title: portfolio.judul,
                    description: portfolio.deskripsi,
                    link: portfolio.linkPorotofolio,
                    isFirst: isFirst,
                    isLast: isLast,
                    onEdit: () {
                      _showAddEditModal(portofolio: portfolio);
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

  Widget _buildPortofolioItem({
    required String title,
    required String description,
    required String link,
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
                const SizedBox(height: 3),
                if (link.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      // TODO: Buka link portofolio
                    },
                    child: const Text(
                      'Lihat portofolio',
                      style: TextStyle(
                        color: Color(0xFF0E38EB),
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                const SizedBox(height: 15),
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