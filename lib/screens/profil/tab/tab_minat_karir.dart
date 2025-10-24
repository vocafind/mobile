import 'package:flutter/material.dart';

class TabMinatKarir extends StatefulWidget {
  const TabMinatKarir({super.key});

  @override
  State<TabMinatKarir> createState() => _TabMinatKarirState();
}

class _TabMinatKarirState extends State<TabMinatKarir> {
  // Contoh data minat karir
  List<CareerInterest> _careerInterests = [
    CareerInterest(
      id: '1',
      title: 'Teknologi',
      level: 'Tinggi',
      description:
          'Alasan saya berminat di bidang ini karena saya suka teknologi, di era digital ini teknologi sangat berkembang pesat.',
    ),
    CareerInterest(
      id: '2',
      title: 'Teknologi',
      level: 'Sedang',
      description:
          'Alasan saya berminat di bidang ini karena saya suka teknologi, di era digital ini teknologi sangat berkembang pesat.',
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

  void _showAddEditDialog({CareerInterest? careerInterest}) {
    final isEdit = careerInterest != null;
    final titleController = TextEditingController(
      text: careerInterest?.title ?? '',
    );
    final levelController = TextEditingController(
      text: careerInterest?.level ?? '',
    );
    final descriptionController = TextEditingController(
      text: careerInterest?.description ?? '',
    );

    String selectedLevel = careerInterest?.level ?? 'Tinggi';

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
                  isEdit ? 'Edit Minat Karir' : 'Tambah Minat Karir',
                  style: const TextStyle(
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF515151),
                  ),
                ),
                const SizedBox(height: 24),
                _buildDialogTextField(
                  controller: titleController,
                  label: 'Bidang Minat',
                  hint: 'Contoh: Teknologi, Kesehatan, Bisnis',
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tingkat Minat',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF515151),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF98AFFF)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedLevel,
                          isExpanded: true,
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            color: Color(0xFF515151),
                          ),
                          items: ['Tinggi', 'Sedang', 'Rendah']
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setDialogState(() {
                                selectedLevel = newValue;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildDialogTextField(
                  controller: descriptionController,
                  label: 'Alasan Minat',
                  hint: 'Jelaskan alasan Anda berminat di bidang ini',
                  maxLines: 4,
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
                          if (titleController.text.isEmpty ||
                              descriptionController.text.isEmpty) {
                            _showSnackBar('Semua field harus diisi', isError: true);
                            return;
                          }

                          final newCareerInterest = CareerInterest(
                            id: careerInterest?.id ?? DateTime.now().toString(),
                            title: titleController.text,
                            level: selectedLevel,
                            description: descriptionController.text,
                          );

                          setState(() {
                            if (isEdit) {
                              final index = _careerInterests.indexWhere(
                                (item) => item.id == careerInterest.id,
                              );
                              if (index != -1) {
                                _careerInterests[index] = newCareerInterest;
                              }
                              _showSnackBar('Minat karir berhasil diperbarui');
                            } else {
                              _careerInterests.add(newCareerInterest);
                              _showSnackBar('Minat karir berhasil ditambahkan');
                            }
                          });

                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B56FD),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
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
                        _showDeleteConfirmation(careerInterest);
                      },
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      label: const Text(
                        'Hapus Minat Karir',
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

  void _showDeleteConfirmation(CareerInterest careerInterest) {
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
          'Apakah Anda yakin ingin menghapus ${careerInterest.title}?',
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
                _careerInterests.removeWhere((item) => item.id == careerInterest.id);
              });
              Navigator.pop(context);
              _showSnackBar('Minat karir berhasil dihapus');
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
          const SizedBox(height: 0),

          // Career Interest Items
          if (_careerInterests.isEmpty)
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: const [
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
    );
  }

  Widget _buildCareerInterestItem({
    required CareerInterest careerInterest,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: () => _showAddEditDialog(careerInterest: careerInterest),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        careerInterest.title,
                        style: const TextStyle(
                          color: Color(0xFF515151),
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE2E2E2)),
                        ),
                        child: Text(
                          careerInterest.level,
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
                    careerInterest.description.length > 80
                        ? '${careerInterest.description.substring(0, 80)}....'
                        : careerInterest.description,
                    style: const TextStyle(
                      color: Color(0xFF515151),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Icon(
              Icons.chevron_right,
              size: 24,
              color: Color(0xFF515151),
            ),
          ],
        ),
      ),
    );
  }
}

// Model class untuk Minat Karir
class CareerInterest {
  final String id;
  final String title;
  final String level;
  final String description;

  CareerInterest({
    required this.id,
    required this.title,
    required this.level,
    required this.description,
  });
}