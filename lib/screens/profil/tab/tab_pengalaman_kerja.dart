import 'package:flutter/material.dart';

class TabPengalamanKerja extends StatelessWidget {
  const TabPengalamanKerja({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          // Add Button
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 39,
              height: 39,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF113CEE), width: 1),
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
          const SizedBox(height: 21),

          // Pengalaman Kerja Items
          _buildPengalamanKerjaItem(
            description: 'Saya ahli dalam berbicara di depan umum, karena saya ahli berbicara.... ',
            isFirst: true,
          ),
          _buildPengalamanKerjaItem(
            description: 'Saya ahli dalam berbicara di depan umum, karena saya ahli berbicara.... ',
            isLast: true,
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildPengalamanKerjaItem({
    required String description,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: Colors.white,
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
            child: Text(
              description,
              style: const TextStyle(
                color: Color(0xFF515151),
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w300,
                height: 1.7,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Icon(
            Icons.edit_outlined,
            size: 20,
            color: Colors.black.withValues(alpha:0.62),
          ),
        ],
      ),
    );
  }
}