import 'package:flutter/material.dart';

void showJobDetail(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const JobDetailSheet(),
  );
}

class JobDetailSheet extends StatefulWidget {
  const JobDetailSheet({super.key});

  @override
  State<JobDetailSheet> createState() => _JobDetailSheetState();
}

class _JobDetailSheetState extends State<JobDetailSheet> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.95,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Color(0x40000000),
                blurRadius: 4,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Drag Handle
              _buildDragHandle(),
              
              // Scrollable Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(18, 30, 18, 100),
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildInfoCards(),
                    const SizedBox(height: 24),
                    _buildTabNavigation(),
                    const SizedBox(height: 22),
                    if (_selectedTab == 0) _buildDescriptionTab(),
                    if (_selectedTab == 1) _buildCompanyTab(),
                  ],
                ),
              ),
              
              // Fixed Apply Button
              _buildApplyButton(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDragHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      width: 143,
      height: 5,
      decoration: BoxDecoration(
        color: const Color(0xFF162781).withValues(alpha:0.9),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Company Logo
        Container(
          width: 60,
          height: 53,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFF1F5F9)),
          ),
          padding: const EdgeInsets.all(8),
          child: Image.asset(
            'assets/icons/icon.png',
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(width: 20),
        
        // Job Title & Company
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Fulltime Backend Developer',
                style: TextStyle(
                  color: Color(0xFF1A1A1A),
                  fontSize: 24,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w500,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Inforsys Indonesia',
                style: TextStyle(
                  color: Color(0xFF515151),
                  fontSize: 16,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              // Remote Tag
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE2E2E2)),
                ),
                child: const Text(
                  'Remote',
                  style: TextStyle(
                    color: Color(0xFF464E5E),
                    fontSize: 12,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Bookmark Icon
        IconButton(
          icon: const Icon(Icons.bookmark_border),
          iconSize: 24,
          onPressed: () {
            // Handle bookmark
          },
        ),
      ],
    );
  }

  Widget _buildInfoCards() {
    return Row(
      children: [
        Expanded(child: _buildInfoCard('Dibutuhkan', '5')),
        _buildDivider(),
        Expanded(child: _buildInfoCard('Lokasi', 'Kota Batam')),
        _buildDivider(),
        Expanded(child: _buildInfoCard('Gaji', 'Rp 9.000.000')),
      ],
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF515151),
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            height: 1.71,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF515151),
            fontSize: 12,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w300,
            height: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1.4,
      height: 26,
      color: const Color(0xFFE9E9E9),
    );
  }

  Widget _buildTabNavigation() {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: const Color(0xFF162781).withValues(alpha:0.9),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          _buildTab('Deskripsi', 0),
          _buildTab('Perusahaan', 1),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: isSelected 
                ? const Color(0xFF2345F7).withValues(alpha:0.7) 
                : Colors.transparent,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDescriptionTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSection(
          title: 'Deskripsi Pekerjaan',
          child: RichText(
            textAlign: TextAlign.justify,
            text: const TextSpan(
              style: TextStyle(
                color: Color(0xFF515151),
                fontSize: 13,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w400,
                height: 1.54,
              ),
              children: [
                TextSpan(
                  text: 'Kami mencari Senior UI/UX Designer yang berpengalaman untuk memimpin inisiatif desain dalam mengembangkan pengalaman mobile generasi berikutnya. Kamu akan bekerja dengan tim product dan engineering untuk menciptakan solusi desain yang inovatif... ',
                ),
                TextSpan(
                  text: 'Read more',
                  style: TextStyle(color: Color(0xFF2345F7)),
                ),
              ],
            ),
          ),
        ),
        _buildSection(
          title: 'Kualifikasi & Persyaratan',
          child: Column(
            children: [
              _buildBulletPoint('Minimal S1 Desain Komunikasi Visual, HCI, atau bidang terkait'),
              _buildBulletPoint('5+ tahun pengalaman sebagai UI/UX Designer di perusahaan teknologi'),
              _buildBulletPoint('Mahir menggunakan Figma, Sketch, dan Adobe Creative Suite'),
              _buildBulletPoint('Pengalaman dalam mengembangkan dan mengelola design system'),
            ],
          ),
        ),
        _buildSection(
          title: 'Benefit',
          child: Column(
            children: [
              _buildBulletPoint('Gaji kompetitif & bonus tahunan', fontSize: 12),
              _buildBulletPoint('BPJS Kesehatan & Ketenagakerjaan', fontSize: 12),
              _buildBulletPoint('Tunjangan makan & transport', fontSize: 12),
              _buildBulletPoint('Cuti tahunan dan cuti sakit', fontSize: 12),
            ],
          ),
        ),
        _buildSection(
          title: 'Persyaratan Tambahan',
          child: Column(
            children: [
              _buildBulletPoint('Bersedia ditempatkan di luar kota jika diperlukan', fontSize: 12),
              _buildBulletPoint('Memiliki laptop pribadi (untuk posisi remote)', fontSize: 12),
              _buildBulletPoint('Siap bekerja dengan target dan deadline', fontSize: 12),
              _buildBulletPoint('Tidak sedang terikat kontrak dengan perusahaan lain', fontSize: 12),
            ],
          ),
        ),
        _buildSection(
          title: 'Fasilitas',
          child: Column(
            children: [
              _buildBulletPoint('Ruang kerja nyaman (Coworking / Open Space)', fontSize: 12),
              _buildBulletPoint('Pantry & Snack gratis', fontSize: 12),
              _buildBulletPoint('Ruang istirahat / Games room (PS, billiard, dll)', fontSize: 12),
              _buildBulletPoint('Parkir gratis (motor & mobil)', fontSize: 12),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompanyTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSection(
          title: 'Tentang Perusahaan',
          child: const Text(
            'Informasi tentang perusahaan akan ditampilkan di sini.',
            textAlign: TextAlign.justify,
            style: TextStyle(
              color: Color(0xFF515151),
              fontSize: 13,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w400,
              height: 1.54,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF191919),
            fontSize: 20,
            fontFamily: 'SF Pro',
            fontWeight: FontWeight.w500,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        child,
        const SizedBox(height: 24),
        Container(height: 1, color: const Color(0xFFE9E9E9)),
      ],
    );
  }

  Widget _buildBulletPoint(String text, {double fontSize = 13}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: Color(0xFF2643D7),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: const Color(0xFF515151),
                fontSize: fontSize,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w400,
                height: 1.54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplyButton() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          // Handle apply action
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1548F5),
          minimumSize: const Size(double.infinity, 45),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Lamar Sekarang',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}