import 'package:flutter/material.dart';
import 'tab_pendidikan.dart';
import 'tab_bahasa.dart';
import 'tab_penghargaan.dart';

class TabAkademik extends StatefulWidget {
  const TabAkademik({super.key});

  @override
  State<TabAkademik> createState() => _TabAkademikState();
}

class _TabAkademikState extends State<TabAkademik> {
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
            padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 8),
            child: Row(
              children: [
                _buildSubTab('Pendidikan', 0),
                const SizedBox(width: 8),
                _buildSubTab('Bahasa', 1),
                const SizedBox(width: 8),
                _buildSubTab('Penghargaan', 2),
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
        return const TabPendidikan();
      case 1:
        return const TabBahasa();
      case 2:
        return const TabPenghargaan();
      default:
        return const TabPendidikan();
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