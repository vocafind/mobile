import 'package:flutter/material.dart';
import 'package:jobfair/models/talent_reference_model.dart';
import 'package:jobfair/api/api_service.dart';

class TabReferensi extends StatefulWidget {
  const TabReferensi({super.key});

  @override
  State<TabReferensi> createState() => _TabReferensiState();
}

class _TabReferensiState extends State<TabReferensi> {
  final ApiService _apiService = ApiService();
  List<ReferenceModel> _references = [];
  bool _isLoading = true;

  // Controllers
  final _namaController = TextEditingController();
  final _relasiController = TextEditingController();
  final _perusahaanController = TextEditingController();
  final _posisiController = TextEditingController();
  final _emailController = TextEditingController();
  final _teleponController = TextEditingController();
  final _deskripsiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadReferences();
  }

  @override
  void dispose() {
    _namaController.dispose();
    _relasiController.dispose();
    _perusahaanController.dispose();
    _posisiController.dispose();
    _emailController.dispose();
    _teleponController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  void _clearControllers() {
    _namaController.clear();
    _relasiController.clear();
    _perusahaanController.clear();
    _posisiController.clear();
    _emailController.clear();
    _teleponController.clear();
    _deskripsiController.clear();
  }

  Future<void> _loadReferences() async {
    setState(() => _isLoading = true);
    try {
      final references = await _apiService.getReference();
      setState(() {
        _references = references;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('Gagal memuat data referensi', isError: true);
      print("Error load references: $e");
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

 void _showAddEditModal({ReferenceModel? reference}) {
  final isEdit = reference != null;
  bool isSaving = false;

  if (reference != null) {
    _namaController.text = reference.nama;
    _relasiController.text = reference.relasi;
    _perusahaanController.text = reference.perusahaan;
    _posisiController.text = reference.posisi;
    _emailController.text = reference.email;
    _teleponController.text = reference.telepon;
    _deskripsiController.text = reference.deskripsi ?? '';
  } else {
    _clearControllers();
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
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.9,
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
                      onPressed: isSaving ? null : () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        isEdit ? 'Edit Referensi' : 'Tambah Referensi',
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
                              if (_namaController.text.isEmpty ||
                                  _relasiController.text.isEmpty ||
                                  _perusahaanController.text.isEmpty ||
                                  _posisiController.text.isEmpty ||
                                  _emailController.text.isEmpty ||
                                  _teleponController.text.isEmpty) {
                                _showSnackBar(
                                  'Field wajib harus diisi',
                                  isError: true,
                                );
                                return;
                              }

                              setModalState(() => isSaving = true);

                              try {
                                final newReference = ReferenceModel(
                                  referenceId: reference?.referenceId,
                                  talentId: reference?.talentId,
                                  nama: _namaController.text,
                                  relasi: _relasiController.text,
                                  perusahaan: _perusahaanController.text,
                                  posisi: _posisiController.text,
                                  email: _emailController.text,
                                  telepon: _teleponController.text,
                                  deskripsi: _deskripsiController.text,
                                );

                                if (isEdit) {
                                  await _apiService.updateReference(
                                    reference!.referenceId!,
                                    newReference,
                                  );
                                  _showSnackBar('Referensi berhasil diperbarui');
                                } else {
                                  await _apiService.createReference(newReference);
                                  _showSnackBar('Referensi berhasil ditambahkan');
                                }

                                await _loadReferences();
                                Navigator.pop(context);
                              } catch (e) {
                                setModalState(() => isSaving = false);
                                _showSnackBar(
                                  'Gagal ${isEdit ? 'memperbarui' : 'menambahkan'} referensi',
                                  isError: true,
                                );
                                print("Error save reference: $e");
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
                          color: const Color(0xFFE1F5FE),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFF4FC3F7)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: Color(0xFF0277BD),
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Tambahkan kontak referensi profesional Anda. Pastikan mereka bersedia memberikan rekomendasi.',
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
                        label: 'Nama Lengkap',
                        hint: 'Contoh: Abdul Gofar Hilman',
                        icon: Icons.person_outline,
                        required: true,
                      ),
                      const SizedBox(height: 16),

                      _buildTextField(
                        controller: _relasiController,
                        label: 'Hubungan/Relasi',
                        hint: 'Contoh: Atasan Langsung, Rekan Kerja',
                        icon: Icons.people_outline,
                        required: true,
                      ),
                      const SizedBox(height: 16),

                      _buildTextField(
                        controller: _perusahaanController,
                        label: 'Perusahaan',
                        hint: 'Contoh: PT. Inforsys Indonesia',
                        icon: Icons.business_outlined,
                        required: true,
                      ),
                      const SizedBox(height: 16),

                      _buildTextField(
                        controller: _posisiController,
                        label: 'Posisi/Jabatan',
                        hint: 'Contoh: Manager HRD, Direktur',
                        icon: Icons.badge_outlined,
                        required: true,
                      ),
                      const SizedBox(height: 16),

                      _buildTextField(
                        controller: _emailController,
                        label: 'Email',
                        hint: 'Contoh: email@example.com',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        required: true,
                      ),
                      const SizedBox(height: 16),

                      _buildTextField(
                        controller: _teleponController,
                        label: 'Nomor Telepon',
                        hint: 'Contoh: 08123456789',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        required: true,
                      ),
                      const SizedBox(height: 16),

                      _buildTextField(
                        controller: _deskripsiController,
                        label: 'Deskripsi',
                        hint: 'Jelaskan hubungan kerja Anda dengan referensi ini...',
                        icon: Icons.description_outlined,
                        maxLines: 4,
                        helperText: 'Opsional - Jelaskan konteks hubungan profesional',
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
                                    _showDeleteConfirmation(reference);
                                  },
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            label: const Text(
                              'Hapus Referensi',
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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

  void _showDeleteConfirmation(ReferenceModel reference) {
    bool isDeleting = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          title: const Text(
            'Hapus Referensi',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Apakah Anda yakin ingin menghapus ${reference.nama}?',
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
                        await _apiService.deleteReference(reference.referenceId!);
                        await _loadReferences();
                        Navigator.pop(context);
                        _showSnackBar('Referensi berhasil dihapus');
                      } catch (e) {
                        setDialogState(() => isDeleting = false);
                        _showSnackBar('Gagal menghapus referensi', isError: true);
                        print("Error delete reference: $e");
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
      onRefresh: _loadReferences,
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

            // Loading State
            if (_isLoading)
              Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF1B56FD),
                  ),
                ),
              )

            // Empty State
            else if (_references.isEmpty)
              Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 60,
                      color: Color(0xFFB8B8B8),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Belum ada referensi',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF515151),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tambahkan referensi profesional Anda',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        color: Color(0xFFB8B8B8),
                      ),
                    ),
                  ],
                ),
              )

            // Reference List
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _references.length,
                itemBuilder: (context, index) {
                  final reference = _references[index];
                  return _buildReferenceItem(
                    reference: reference,
                    isFirst: index == 0,
                    isLast: index == _references.length - 1,
                  );
                },
              ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildReferenceItem({
    required ReferenceModel reference,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return GestureDetector(
      onTap: () => _showAddEditModal(reference: reference),
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
                  Text(
                    reference.nama,
                    style: const TextStyle(
                      color: Color(0xFF515151),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${reference.posisi} • ${reference.perusahaan}',
                    style: const TextStyle(
                      color: Color(0xFF515151),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          reference.relasi,
                          style: const TextStyle(
                            color: Color(0xFF515151),
                            fontSize: 11,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
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