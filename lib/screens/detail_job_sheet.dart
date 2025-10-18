import 'package:flutter/material.dart';

void showJobDetail(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const JobDetailSheet(),
  );
}

class JobDetailSheet extends StatelessWidget {
  const JobDetailSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.95,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFFFFFF),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x40000000),
                blurRadius: 4,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Scrollable Content
              Column(
                children: [
                  // Drag Handle
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 143,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFF162781).withValues(alpha:0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: EdgeInsets.zero,
                      children: [
                        const SizedBox(height: 30),
                        
                        // Header Section
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Column(
                            children: [
                              Row(
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
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Image.asset(
                                        'assets/icons/icon.png',
                                        fit: BoxFit.contain,
                                      ),
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
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 15,
                                            vertical: 4,
                                          ),
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
                                  Container(
                                    width: 16,
                                    height: 23,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black.withValues(alpha:0.5),
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 24),
                              
                              // Info Cards
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildInfoCard('Dibutuhkan', '5'),
                                  ),
                                  Container(
                                    width: 1.4,
                                    height: 26,
                                    color: const Color(0xFFE9E9E9),
                                  ),
                                  Expanded(
                                    child: _buildInfoCard('Lokasi', 'Kota Batam'),
                                  ),
                                  Container(
                                    width: 1.4,
                                    height: 26,
                                    color: const Color(0xFFE9E9E9),
                                  ),
                                  Expanded(
                                    child: _buildInfoCard('Gaji', 'Rp 9.000.000'),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 24),
                              
                              // Tab Navigation
                              Container(
                                height: 45,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF162781).withValues(alpha:0.9),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF2345F7).withValues(alpha:0.7),
                                          borderRadius: BorderRadius.circular(100),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'Deskripsi',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.all(5),
                                        child: const Center(
                                          child: Text(
                                            'Perusahaan',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 22),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 2),
                        
                        // Deskripsi Pekerjaan Section
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              const Text(
                                'Deskripsi Pekerjaan',
                          style: TextStyle(
                            color: Color(0xFF191919),
                            fontSize: 20,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        RichText(
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
                        
                        const SizedBox(height: 24),
                        
                        // Divider
                        Container(
                          height: 1,
                          color: const Color(0xFFE9E9E9),
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // Kualifikasi & Persyaratan Section
                        const Text(
                          'Kualifikasi & Persyaratan',
                          style: TextStyle(
                            color: Color(0xFF191919),
                            fontSize: 20,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildBulletPoint('Minimal S1 Desain Komunikasi Visual, HCI, atau bidang terkait'),
                        _buildBulletPoint('5+ tahun pengalaman sebagai UI/UX Designer di perusahaan teknologi'),
                        _buildBulletPoint('Mahir menggunakan Figma, Sketch, dan Adobe Creative Suite'),
                        _buildBulletPoint('Pengalaman dalam mengembangkan dan mengelola design system'),
                        
                        const SizedBox(height: 24),
                        
                        // Divider
                        Container(
                          height: 1,
                          color: const Color(0xFFE9E9E9),
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // Benefit Section
                        const Text(
                          'Benefit',
                          style: TextStyle(
                            color: Color(0xFF191919),
                            fontSize: 20,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildBulletPoint('Gaji kompetitif & bonus tahunan', fontSize: 12),
                        _buildBulletPoint('BPJS Kesehatan & Ketenagakerjaan', fontSize: 12),
                        _buildBulletPoint('Tunjangan makan & transport', fontSize: 12),
                        _buildBulletPoint('Cuti tahunan dan cuti sakit', fontSize: 12),
                        
                        const SizedBox(height: 24),
                        
                        // Divider
                        Container(
                          height: 1,
                          color: const Color(0xFFE9E9E9),
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // Persyaratan Tambahan Section
                        const Text(
                          'Persyaratan Tambahan',
                          style: TextStyle(
                            color: Color(0xFF191919),
                            fontSize: 20,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildBulletPoint('Bersedia ditempatkan di luar kota jika diperlukan', fontSize: 12),
                        _buildBulletPoint('Memiliki laptop pribadi (untuk posisi remote)', fontSize: 12),
                        _buildBulletPoint('Siap bekerja dengan target dan deadline', fontSize: 12),
                        _buildBulletPoint('Tidak sedang terikat kontrak dengan perusahaan lain', fontSize: 12),
                        
                        const SizedBox(height: 24),
                        
                        // Divider
                        Container(
                          height: 1,
                          color: const Color(0xFFE9E9E9),
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // Fasilitas Section
                        const Text(
                          'Fasilitas',
                          style: TextStyle(
                            color: Color(0xFF191919),
                            fontSize: 20,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildBulletPoint('Ruang kerja nyaman (Coworking / Open Space)', fontSize: 12),
                        _buildBulletPoint('Pantry & Snack gratis', fontSize: 12),
                        _buildBulletPoint('Ruang istirahat / Games room (PS, billiard, dll)', fontSize: 12),
                        _buildBulletPoint('Parkir gratis (motor & mobil)', fontSize: 12),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 100), // Extra space for fixed button
                      ],
                    ),
                  ),
                ],
              ),
              
              // Fixed Apply Button
              Positioned(
                left: 0,
                right: 0,
                bottom: 10,
                child: Container(
                  padding: const EdgeInsets.all(18),
                  child: GestureDetector(
                    onTap: () {
                      // Handle apply action
                    },
                    child: Container(
                      width: double.infinity,
                      height: 45,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1548F5),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Center(
                        child: Text(
                          'Lamar Sekarang',
                          style: TextStyle(
                            color: Color(0xF2FFFFFF),
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
}