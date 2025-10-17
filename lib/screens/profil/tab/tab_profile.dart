import 'package:flutter/material.dart';
import 'tab_media_sosial.dart';
import 'tab_minat_karir.dart';
import 'tab_referensi.dart';

class TabProfil extends StatefulWidget {
  const TabProfil({super.key});

  @override
  State<TabProfil> createState() => _TabProfilState();
}

class _TabProfilState extends State<TabProfil> {
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
            padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 8),
            child: Row(
              children: [
                _buildSubTab('Data diri', 0),
                const SizedBox(width: 8),
                _buildSubTab('Media sosial', 1),
                const SizedBox(width: 8),
                _buildSubTab('Minat karir', 2),
                const SizedBox(width: 8),
                _buildSubTab('Referensi', 3),
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
        return _buildDataDiriContent();
      case 1:
        return const TabMediaSosial();
      case 2:
        return const TabMinatKarir();
      case 3:
        return const TabReferensi();
      default:
        return _buildDataDiriContent();
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
          color: isSelected ? Colors.black : const Color(0xFFB8B8B8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: 'SF Pro',
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildDataDiriContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 20),
      child: Column(
        children: [
          // Profile Completion Card
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.person, size: 27, color: Colors.black54),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Kelengkapan Profil',
                                style: TextStyle(
                                  color: Color(0xFF515151),
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Text(
                                '24 %',
                                style: TextStyle(
                                  color: Color(0xFF515151),
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 8,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 71,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Colors.white, Color(0xFF0727E1)],
                                    ),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.info_outline, size: 15, color: Colors.black54),
                              const SizedBox(width: 4),
                              const Expanded(
                                child: Text(
                                  'Lengkapi profil Anda agar AI dapat memberikan rekomendasi yang lebih akurat dan sesuai',
                                  style: TextStyle(
                                    color: Color(0xFF515151),
                                    fontSize: 9,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w300,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Profile Fields
          _buildProfileField(Icons.photo_camera_outlined, 'Foto profil', hasAvatar: true, isFirst: true),
          _buildProfileField(Icons.person_outline, 'Nama', value: 'Nasyith Aditya'),
          _buildProfileField(Icons.badge_outlined, 'NIK', value: '21711022050689376'),
          _buildProfileField(Icons.wc, 'Jenis Kelamin', value: 'Laki-laki'),
          _buildProfileField(Icons.location_city_outlined, 'Provinsi', value: 'Kepulauan Riau'),
          _buildProfileField(Icons.location_on_outlined, 'Kabupaten / Kota', value: 'Kota Batam'),
          _buildProfileField(Icons.home_outlined, 'Alamat', value: 'Jl. Pegangsaan Timur No. 56'),
          _buildProfileField(Icons.phone_outlined, 'Nomor Whatsapp', value: '0852-6590-0099', isLast: true),

          const SizedBox(height: 18),

          _buildProfileField(Icons.location_searching, 'Lokasi kerja diinginkan', value: 'Batam', isFirst: true),
          _buildProfileField(Icons.work_outline, 'Status pekerjaan saat ini', value: 'Mencari pekerjaan'),
          _buildProfileField(Icons.attach_money, 'Preferensi gaji', value: 'Rp. 20.000.000'),
          _buildProfileField(Icons.access_time, 'Preferensi jam kerja', value: '08.00 - 17.00'),
          _buildProfileField(Icons.flight_outlined, 'Preferensi perjalanan dinas', value: 'Tidak', isLast: true),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildProfileField(
    IconData icon,
    String label, {
    String? value,
    bool hasAvatar = false,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isLast ? Colors.transparent : const Color(0xFFE8E8E8),
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
          Icon(icon, size: 24, color: Colors.black54),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF515151),
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (value != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      color: Color(0xFF515151),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (hasAvatar)
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Color(0xFFD9D9D9),
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}