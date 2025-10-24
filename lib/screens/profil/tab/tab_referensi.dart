import 'package:flutter/material.dart';

class TabReferensi extends StatefulWidget {
  const TabReferensi({super.key});

  @override
  State<TabReferensi> createState() => _TabReferensiState();
}

class _TabReferensiState extends State<TabReferensi> {
  // Contoh data referensi
  final List<ReferenceItem> _references = [
    ReferenceItem(
      id: '1',
      position: 'Manager HRD',
      company: 'Inforsys Indonesia',
      name: 'Abdul Gofar Hilman',
    ),
    ReferenceItem(
      id: '2',
      position: 'Manager HRD',
      company: 'Inforsys Indonesia',
      name: 'Abdul Gofar Hilman',
    ),
  ];

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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showAddEditDialog({ReferenceItem? reference}) {
    final isEdit = reference != null;
    final positionController = TextEditingController(
      text: reference?.position ?? '',
    );
    final companyController = TextEditingController(
      text: reference?.company ?? '',
    );
    final nameController = TextEditingController(
      text: reference?.name ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => Dialog(
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
                controller: positionController,
                label: 'Posisi',
                hint: 'Contoh: Manager HRD, Direktur',
              ),
              const SizedBox(height: 16),
              _buildDialogTextField(
                controller: companyController,
                label: 'Perusahaan',
                hint: 'Contoh: PT. Inforsys Indonesia',
              ),
              const SizedBox(height: 16),
              _buildDialogTextField(
                controller: nameController,
                label: 'Nama Lengkap',
                hint: 'Contoh: Abdul Gofar Hilman',
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
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
                      onPressed: () {
                        if (positionController.text.isEmpty ||
                            companyController.text.isEmpty ||
                            nameController.text.isEmpty) {
                          _showSnackBar('Semua field harus diisi', isError: true);
                          return;
                        }

                        final newReference = ReferenceItem(
                          id: reference?.id ?? DateTime.now().toString(),
                          position: positionController.text,
                          company: companyController.text,
                          name: nameController.text,
                        );

                        setState(() {
                          if (isEdit) {
                            final index = _references.indexWhere(
                              (item) => item.id == reference.id,
                            );
                            if (index != -1) {
                              _references[index] = newReference;
                            }
                            _showSnackBar('Referensi berhasil diperbarui');
                          } else {
                            _references.add(newReference);
                            _showSnackBar('Referensi berhasil ditambahkan');
                          }
                        });

                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B56FD),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
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
                    onPressed: () {
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
    );
  }

  Widget _buildDialogTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
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
              borderSide: const BorderSide(
                color: Color(0xFF98AFFF),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF1548F5),
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(ReferenceItem reference) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
          'Apakah Anda yakin ingin menghapus ${reference.name}?',
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
              setState(() {
                _references.removeWhere((item) => item.id == reference.id);
              });
              Navigator.pop(context);
              _showSnackBar('Referensi berhasil dihapus');
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
    return SingleChildScrollView(
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

          // Reference Items
          if (_references.isEmpty)
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
    );
  }

  Widget _buildReferenceItem({
    required ReferenceItem reference,
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
                    reference.position,
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
              reference.company,
              style: const TextStyle(
                color: Color(0xFF515151),
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 1,
              color: const Color(0xFFE9E9E9),
            ),
            const SizedBox(height: 12),
            Text(
              reference.name,
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

// Model class untuk Referensi
class ReferenceItem {
  final String id;
  final String position;
  final String company;
  final String name;

  ReferenceItem({
    required this.id,
    required this.position,
    required this.company,
    required this.name,
  });
}