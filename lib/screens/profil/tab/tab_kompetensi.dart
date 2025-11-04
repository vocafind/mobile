import 'package:flutter/material.dart';
import 'tab_sertifikasi.dart';
import 'tab_pelatihan.dart';
import 'tab_soft_skill.dart';

class TabKompetensi extends StatefulWidget {
  const TabKompetensi({super.key});

  @override
  State<TabKompetensi> createState() => _TabKompetensiState();
}

class _TabKompetensiState extends State<TabKompetensi> {
  int _selectedSubTab = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Sub Tabs
        Container(
          height: 50,
          color: const Color(0xFFF0F4F9),
          padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSubTab('Sertifikasi', 0),
                const SizedBox(width: 8),
                _buildSubTab('Pelatihan', 1),
                const SizedBox(width: 8),
                _buildSubTab('Soft skill', 2),
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
        return const TabSertifikasi();
      case 1:
        return const TabPelatihan();
      case 2:
        return const TabSoftSkill();
      default:
        return const TabSertifikasi();
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