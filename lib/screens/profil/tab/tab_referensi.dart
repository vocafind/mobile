import 'package:flutter/material.dart';
import 'package:jobfair/models/talent_reference_model.dart';
import 'package:jobfair/api/api_service.dart';
// import 'reference_service.dart';
// import 'reference_model.dart';

class TabReferensi extends StatefulWidget {
  const TabReferensi({super.key});

  @override
  State<TabReferensi> createState() => _TabReferensiState();
}

class _TabReferensiState extends State<TabReferensi> {
  final ApiService _apiService = ApiService();
  List<ReferenceModel> _references = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReferences();
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

  void _showAddEditDialog({ReferenceModel? reference}) {
    final isEdit = reference != null;

    final nameController = TextEditingController(text: reference?.nama ?? '');
    final relationController = TextEditingController(text: reference?.relasi ?? '');
    final companyController = TextEditingController(text: reference?.perusahaan ?? '');
    final positionController = TextEditingController(text: reference?.posisi ?? '');
    final emailController = TextEditingController(text: reference?.email ?? '');
    final phoneController = TextEditingController(text: reference?.telepon ?? '');
    final descriptionController = TextEditingController(text: reference?.deskripsi ?? '');

    bool isSaving = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEdit ? 'Edit Referensi' : 'Tambah Referensi',
                  style: const TextStyle(
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF515151),
                  ),
                ),
                const SizedBox(height: 24),
                _buildDialogTextField(
                  controller: nameController,
                  label: 'Nama',
                  hint: 'Contoh: Abdul Gofar Hilman',
                ),
                const SizedBox(height: 16),
                _buildDialogTextField(
                  controller: relationController,
                  label: 'Relasi',
                  hint: 'Contoh: Atasan, Rekan Kerja',
                ),
                const SizedBox(height: 16),
                _buildDialogTextField(
                  controller: companyController,
                  label: 'Perusahaan',
                  hint: 'Contoh: PT. Inforsys Indonesia',
                ),
                const SizedBox(height: 16),
                _buildDialogTextField(
                  controller: positionController,
                  label: 'Posisi',
                  hint: 'Contoh: Manager HRD, Direktur',
                ),
                const SizedBox(height: 16),
                _buildDialogTextField(
                  controller: emailController,
                  label: 'Email',
                  hint: 'Contoh: email@example.com',
                ),
                const SizedBox(height: 16),
                _buildDialogTextField(
                  controller: phoneController,
                  label: 'Telepon',
                  hint: 'Contoh: 08123456789',
                ),
                const SizedBox(height: 16),
                _buildDialogTextField(
                  controller: descriptionController,
                  label: 'Deskripsi',
                  hint: 'Jelaskan hubungan Anda dengan referensi ini',
                  maxLines: 4,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: isSaving ? null : () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Color(0xFFE8E8E8)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Batal',
                          style: TextStyle(
                            color: Color(0xFF515151),
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isSaving
                            ? null
                            : () async {
                                if (nameController.text.isEmpty ||
                                    relationController.text.isEmpty ||
                                    companyController.text.isEmpty ||
                                    positionController.text.isEmpty ||
                                    emailController.text.isEmpty ||
                                    phoneController.text.isEmpty ||
                                    descriptionController.text.isEmpty) {
                                  _showSnackBar(
                                    'Semua field harus diisi',
                                    isError: true,
                                  );
                                  return;
                                }

                                setDialogState(() => isSaving = true);

                                try {
                                  final newReference = ReferenceModel(
                                    referenceId: reference?.referenceId,
                                    talentId: reference?.talentId,
                                    nama: nameController.text,
                                    relasi: relationController.text,
                                    perusahaan: companyController.text,
                                    posisi: positionController.text,
                                    email: emailController.text,
                                    telepon: phoneController.text,
                                    deskripsi: descriptionController.text,
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
                                  setDialogState(() => isSaving = false);
                                  _showSnackBar(
                                    'Gagal ${isEdit ? 'memperbarui' : 'menambahkan'} referensi',
                                    isError: true,
                                  );
                                  print("Error save reference: $e");
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B56FD),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: isSaving
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                isEdit ? 'Simpan' : 'Tambah',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
                if (isEdit) ...[
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton.icon(
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
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDialogTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            color: Color(0xFF515151),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: TextInputType.multiline,
          textInputAction: maxLines > 1 ? TextInputAction.newline : TextInputAction.next,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Poppins',
            color: Color(0xFF515151),
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins',
              color: Color(0xFFB8B8B8),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF98AFFF)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF98AFFF)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF1548F5), width: 2),
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
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 20),
        child: Column(
          children: [
            // Add Button
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => _showAddEditDialog(),
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

            const SizedBox(height: 16),

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
                child: Column(
                  children: const [
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
                      'Tambahkan referensi Anda',
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
    return InkWell(
      onTap: () => _showAddEditDialog(reference: reference),
      borderRadius: BorderRadius.circular(20),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    reference.posisi,
                    style: const TextStyle(
                      color: Color(0xFF515151),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  size: 24,
                  color: Color(0xFF515151),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              reference.perusahaan,
              style: const TextStyle(
                color: Color(0xFF515151),
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 12),
            Container(height: 1, color: const Color(0xFFE9E9E9)),
            const SizedBox(height: 12),
            Text(
              reference.nama,
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
    );
  }
}