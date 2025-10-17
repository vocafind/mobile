import 'package:flutter/material.dart';
import 'package:jobfair/screens/profil/widget/profil_header.dart';
import 'package:jobfair/screens/profil/tab/tab_profile.dart';
import 'package:jobfair/screens/profil/tab/tab_akademik.dart';
import 'package:jobfair/widget/bottom_navbar.dart'; 
import 'package:jobfair/screens/profil/tab/tab_kompetensi.dart';
import 'package:jobfair/screens/profil/tab/tab_pengalaman.dart';

class HalamanProfil extends StatefulWidget {
  const HalamanProfil({super.key});

  @override
  State<HalamanProfil> createState() => _HalamanProfilState();
}

class _HalamanProfilState extends State<HalamanProfil>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F9),
      body: Column(
        children: [
          ProfileHeader(tabController: _tabController),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                TabProfil(),
                TabAkademik(),
                TabKompetensi(),
                TabPengalaman(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 4),
    );
  }
}
