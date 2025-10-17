import 'package:flutter/material.dart';
import 'tab_pengalaman_kerja.dart';
import 'tab_riwayat_pekerjaan.dart';
import 'tab_proyek.dart';
import 'tab_portofolio.dart';

class TabPengalaman extends StatefulWidget {
  const TabPengalaman({super.key});

  @override
  State<TabPengalaman> createState() => _TabPengalamanState();
}

class _TabPengalamanState extends State<TabPengalaman> {
  int _selectedSubTab = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Sub Tabs
        Container(
          height: 50,
          color: const Color(0xFFF0F4F9),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                _buildSubTab('Pengalaman kerja', 0),
                const SizedBox(width: 8),
                _buildSubTab('Riwayat pekerjaan', 1),
                const SizedBox(width: 8),
                _buildSubTab('Proyek', 2),
                const SizedBox(width: 8),
                _buildSubTab('Portofolio', 3),
              ],
            ),
          ),
        ),

        // Content based on selected sub-tab
        Expanded(
          child: _buildContent(),
        ),
      ],
    );
  }

  Widget _buildContent() {
    switch (_selectedSubTab) {
      case 0:
        return const TabPengalamanKerja();
      case 1:
        return const TabRiwayatPekerjaan();
      case 2:
        return const TabProyek();
      case 3:
        return const TabPortofolio();
      default:
        return const TabPengalamanKerja();
    }
  }

  Widget _buildSubTab(String text, int index) {
    final isSelected = _selectedSubTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSubTab = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : const Color(0x80475664),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}