import 'package:flutter/material.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSubTab('Riwayat pekerjaan', 0),
                const SizedBox(width: 8),
                _buildSubTab('Proyek', 1),
                const SizedBox(width: 8),
                _buildSubTab('Portofolio', 2),
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
        return const TabRiwayatPekerjaan();
      case 1:
        return const TabProyek();
      case 2:
        return const TabPortofolio();
      default:
        return const TabRiwayatPekerjaan();
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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