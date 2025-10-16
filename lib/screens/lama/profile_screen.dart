import 'package:flutter/material.dart';
import '/widget/bottom_navbar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section with Gradient
            Container(
              height: 244,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -2),
                  radius: 2,
                  colors: [
                    Color(0xFF20249F),
                    Color(0xFF1D37A5),
                    Color(0xFF03DEDB),
                  ],
                  stops: [0.0, 0.45, 1.0],
                ),
              ),
            ),
            
            // Profile Content with Avatar
            Transform.translate(
              offset: Offset(0, -40),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Column(
                    children: [
                      // Profile Card
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 28),
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 60),
                            Text(
                              'John Doe',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF191919),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Senior UI/UX Designer',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            SizedBox(height: 2),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.location_on, size: 13, color: Color(0xFF94A3B8)),
                                SizedBox(width: 4),
                                Text(
                                  'Jakarta, Indonesia',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF94A3B8),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            // Stats
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                              decoration: BoxDecoration(
                                color: Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        '3',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF191919),
                                        ),
                                      ),
                                      Text(
                                        'Lamaran',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF64748B),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        '89%',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF191919),
                                        ),
                                      ),
                                      Text(
                                        'Profil selesai',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF64748B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Data Diri Section
                      _buildSection(
                        title: 'Data Diri',
                        child: Container(
                          padding: EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              _buildInfoRow('NIK', '1234567812345678'),
                              _buildDivider(),
                              _buildInfoRow('Tanggal Lahir', '19/01/1978'),
                              _buildDivider(),
                              _buildInfoRow('Jenis Kelamin', 'Laki-laki'),
                              _buildDivider(),
                              _buildInfoRow('Preferensi Gaji', 'Rp 20.000.000'),
                              _buildDivider(),
                              _buildInfoRow('Lokasi Kerja Diinginkan', 'Batam'),
                              _buildDivider(),
                              _buildInfoRow('Status Pekerjaan Saat Ini', 'Status Pekerjaan Saat Ini'),
                              _buildDivider(),
                              _buildInfoRow('Preferensi Jam Kerja', '09:00 - 22:00'),
                              _buildDivider(),
                              _buildInfoRow('Preferensi Perjalanan Dinas', 'Ya'),
                              _buildDivider(),
                              _buildInfoRow('Nomor Telepon', '08232099965'),
                              _buildDivider(),
                              _buildInfoRow('Provinsi', 'KEPULAUAN RIAU'),
                              _buildDivider(),
                              _buildInfoRow('Kabupaten Kota', 'KOTA B A T A M'),
                              _buildDivider(),
                              _buildInfoRow('Alamat', 'Batam Center'),
                            ],
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Sosial Media Section
                      _buildSection(
                        title: 'Sosial Media',
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _buildSocialChip('Username', 'Instagram'),
                            _buildSocialChip('Username', 'Facebook'),
                            _buildSocialChip('Username', 'X'),
                            _buildSocialChip('Username', 'YouTube'),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Riwayat Pendidikan Section
                      _buildSection(
                        title: 'Riwayat Pendidikan',
                        child: Column(
                          children: [
                            _buildEducationItem(
                              'S1 Informatika',
                              'Universitas Indonesia',
                              '2013 - 2017',
                              'IPK: 4.00',
                            ),
                            SizedBox(height: 16),
                            _buildEducationItem(
                              'S1 Informatika',
                              'Universitas Indonesia',
                              '2013 - 2017',
                              'IPK: 4.00',
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Kemahiran Berbahasa Section
                      _buildSection(
                        title: 'Kemahiran Berbahasa',
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _buildLanguageChip('Japan', 'EXPERT | Skor 99', true),
                            _buildLanguageChip('English', 'EXPERT | Skor 99', false),
                            _buildLanguageChip('Japan', 'EXPERT | Skor 99', true),
                            _buildLanguageChip('English', 'EXPERT | Skor 99', false),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Penghargaan Section
                      _buildSection(
                        title: 'Penghargaan',
                        child: Column(
                          children: [
                            _buildAwardItem(
                              'Google UX Design Certificate',
                              'Google Career Certificates',
                              '2023',
                              true,
                            ),
                            SizedBox(height: 12),
                            _buildAwardItem(
                              'Google UX Design Certificate',
                              'Google Career Certificates',
                              '2023',
                              false,
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Sertifikasi Section
                      _buildSection(
                        title: 'Sertifikasi',
                        child: Column(
                          children: [
                            _buildAwardItem(
                              'Google UX Design Certificate',
                              'Google Career Certificates',
                              '2023',
                              false,
                            ),
                            SizedBox(height: 12),
                            _buildAwardItem(
                              'Google UX Design Certificate',
                              'Google Career Certificates',
                              '2023',
                              false,
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Soft Skill Section
                      _buildSection(
                        title: 'Soft Skill',
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _buildSkillChip('Leadership', 'EXPERT', true),
                            _buildSkillChip('Komunikasi', 'ADVANCED', false),
                            _buildSkillChip('Thinking', 'ADVANCED', false),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Riwayat Pekerjaan Section
                      _buildSection(
                        title: 'Riwayat Pekerjaan',
                        child: Column(
                          children: [
                            _buildWorkItem(
                              'Senior UI/UX Designer',
                              'Gojek Indonesia',
                              'Jan 2022 - Present',
                              'Memimpin desain untuk fitur-fitur utama aplikasi Gojek yang digunakan oleh 50+ juta users. Berkolaborasi dengan product manager dan engineering team untuk mengoptimalkan user experience.',
                            ),
                            Divider(thickness: 2, color: Color(0xFFE2E8F0)),
                            _buildWorkItem(
                              'Senior UI/UX Designer',
                              'Gojek Indonesia',
                              'Jan 2022 - Present',
                              'Memimpin desain untuk fitur-fitur utama aplikasi Gojek yang digunakan oleh 50+ juta users. Berkolaborasi dengan product manager dan engineering team untuk mengoptimalkan user experience.',
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Pengalaman Pekerjaan Section
                      _buildSection(
                        title: 'Pengalaman Pekerjaan',
                        child: Column(
                          children: [
                            _buildExperienceItem(
                              'Senior UI/UX Designer',
                              'Gojek Indonesia',
                              'Jan 2022 - Present',
                              '• Mengembangkan aplikasi mobile dengan Flutter & Laravel\n• Meningkatkan user experience aplikasi internal perusahaan\n• Mendesain antarmuka aplikasi mobile dengan Figma & Adobe XD',
                            ),
                            Divider(thickness: 2, color: Color(0xFFE2E8F0)),
                            _buildExperienceItem(
                              'Senior UI/UX Designer',
                              'PT Maju Jaya',
                              'Jan 2022 - Present',
                              '• Mengembangkan aplikasi mobile dengan Flutter & Laravel\n• Meningkatkan user experience aplikasi internal perusahaan\n• Mendesain antarmuka aplikasi mobile dengan Figma & Adobe XD',
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 100),
                    ],
                  ),
                  
                  // Avatar positioned on top of the profile card
                  Positioned(
                    top: -40,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 81,
                        height: 81,
                        decoration: BoxDecoration(
                          color: Color(0xFF0987BB),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF81D5FF).withOpacity(0.25),
                              blurRadius: 10,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'D',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(
        currentIndex: 4, // Job Fair page
      ),
    );
  }
  
  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 28),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF191919),
                ),
              ),
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Color(0xFFE2E8F0)),
                ),
                child: Icon(Icons.edit, size: 10, color: Color(0xFF64748B)),
              ),
            ],
          ),
          SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w300,
                color: Color(0xFF191919),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDivider() {
    return Divider(
      color: Color(0xFFE2E8F0).withOpacity(0.7),
      thickness: 0.5,
      height: 8,
    );
  }
  
  Widget _buildSocialChip(String username, String platform) {
    return Container(
      width: 135,
      height: 26,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: Color(0xFFF1F5F9), width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            username,
            style: TextStyle(
              fontSize: 10,
              color: Color(0xFF191919),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Color(0xFF2A2F38),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              platform,
              style: TextStyle(
                fontSize: 7,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEducationItem(String degree, String university, String year, String gpa) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 17,
          height: 17,
          margin: EdgeInsets.only(top: 3, right: 16),
          decoration: BoxDecoration(
            color: Color(0xFF0987BB),
            shape: BoxShape.circle,
            border: Border.all(color: Color(0xFFDCF2FF), width: 2),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                degree,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              Text(
                university,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748B),
                ),
              ),
              Row(
                children: [
                  Text(
                    year,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  SizedBox(width: 20),
                  Text(
                    gpa,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildLanguageChip(String language, String level, bool isGreen) {
    return Container(
      width: 135,
      height: 26,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: Color(0xFFF1F5F9), width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            language,
            style: TextStyle(
              fontSize: 10,
              color: Color(0xFF191919),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isGreen ? Color(0xFFDCFCE7) : Color(0xFFDBEAFE),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              level,
              style: TextStyle(
                fontSize: 7,
                color: isGreen ? Color(0xFF166534) : Color(0xFF1E40B2),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAwardItem(String title, String issuer, String year, bool isInternational) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: Color(0xFFF1F5F9), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 58,
            decoration: BoxDecoration(
              color: Color(0xFF0987BB),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(7),
                bottomLeft: Radius.circular(7),
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF191919),
                        ),
                      ),
                    ),
                    if (isInternational)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Internasional',
                          style: TextStyle(
                            fontSize: 7,
                            color: Color(0xFF166534),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 2),
                Text(
                  issuer,
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w300,
                    color: Color(0xFF64748B),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  year,
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSkillChip(String skill, String level, bool isGreen) {
    return Container(
      height: 26,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: Color(0xFFF1F5F9), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            skill,
            style: TextStyle(
              fontSize: 10,
              color: Color(0xFF191919),
            ),
          ),
          SizedBox(width: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isGreen ? Color(0xFFDCFCE7) : Color(0xFFDBEAFE),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              level,
              style: TextStyle(
                fontSize: 7,
                color: isGreen ? Color(0xFF166534) : Color(0xFF1E40B2),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildWorkItem(String position, String company, String period, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 17,
          height: 17,
          margin: EdgeInsets.only(top: 3, right: 16),
          decoration: BoxDecoration(
            color: Color(0xFF0987BB),
            shape: BoxShape.circle,
            border: Border.all(color: Color(0xFFDCF2FF), width: 2),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                position,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              Text(
                company,
                style: TextStyle(
                  fontSize: 9,
                  color: Color(0xFF64748B),
                ),
              ),
              Text(
                period,
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF94A3B8),
                ),
              ),
              SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w300,
                  color: Color(0xFF64748B),
                  height: 1.7,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildExperienceItem(String position, String company, String period, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 17,
          height: 17,
          margin: EdgeInsets.only(top: 3, right: 16),
          decoration: BoxDecoration(
            color: Color(0xFF0987BB),
            shape: BoxShape.circle,
            border: Border.all(color: Color(0xFFDCF2FF), width: 2),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                position,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              Text(
                company,
                style: TextStyle(
                  fontSize: 9,
                  color: Color(0xFF64748B),
                ),
              ),
              Text(
                period,
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF94A3B8),
                ),
              ),
              SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w300,
                  color: Color(0xFF64748B),
                  height: 1.7,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}