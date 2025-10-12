import 'package:flutter/material.dart';

class JobDetailScreen extends StatelessWidget {
  const JobDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button
            Container(
              height: 75,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 18),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 39,
                        height: 39,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 16,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Detail Lowongan",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: "SF Pro",
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Job Header Section
                    Container(
                      width: double.infinity,
                      color: Colors.white,
                      padding: const EdgeInsets.fromLTRB(23, 30, 23, 25),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Company Logo
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0987BB),
                              borderRadius: BorderRadius.circular(9),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  blurRadius: 4,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 21),
                          // Job Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Senior UI/UX \nDesigner",
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontFamily: "SF Pro",
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF1A1A1A),
                                    height: 1.12,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Gojek Indonesia",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: "SF Pro",
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Jakarta, Indonesia",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: "SF Pro",
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF94A3B8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Tags Section
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.fromLTRB(104, 0, 23, 20),
                      child: Row(
                        children: [
                          _buildTag("Remote"),
                          const SizedBox(width: 15),
                          _buildTag("Senior Level"),
                          const SizedBox(width: 15),
                          _buildTag("Full Time"),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Experience & Education Box
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 23),
                      child: Container(
                        height: 59,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "5-7 Thn",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: "SF Pro",
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF191919),
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    "Experience",
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontFamily: "SF Pro",
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 40,
                              color: const Color(0xFFE2E8F0),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "S1",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: "SF Pro",
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF191919),
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    "Pendidikan",
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontFamily: "SF Pro",
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Job Description Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 31),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(19),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.description,
                                  size: 21,
                                  color: Color(0xFF0987BB),
                                ),
                                SizedBox(width: 14),
                                Text(
                                  "Deskripsi Pekerjaan",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: "SF Pro",
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF191919),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 13),
                            const Text(
                              "Kami mencari Senior UI/UX Designer yang berpengalaman untuk memimpin inisiatif desain dalam mengembangkan pengalaman mobile generasi berikutnya. Kamu akan bekerja dengan tim product dan engineering untuk menciptakan solusi desain yang inovatif dan user-centric.\n\nSebagai Senior Designer, kamu akan bertanggung jawab untuk mengembangkan design system, melakukan user research, dan memastikan konsistensi pengalaman pengguna di seluruh platform Gojek yang digunakan oleh jutaan orang setiap harinya.",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 11,
                                fontFamily: "SF Pro",
                                fontWeight: FontWeight.w300,
                                color: Color(0xFF64748B),
                                height: 1.36,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Qualifications Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 31),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(19),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.check_circle_outline,
                                  size: 19,
                                  color: Color(0xFF0987BB),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  "Kualifikasi & Persyaratan",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: "SF Pro",
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF191919),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildBulletPoint("Minimal S1 Desain Komunikasi Visual, HCI, atau bidang terkait"),
                            const SizedBox(height: 18),
                            _buildBulletPoint("5+ tahun pengalaman sebagai UI/UX Designer di perusahaan teknologi"),
                            const SizedBox(height: 18),
                            _buildBulletPoint("Mahir menggunakan Figma, Sketch, dan Adobe Creative Suite"),
                            const SizedBox(height: 18),
                            _buildBulletPoint("Pengalaman dalam mengembangkan dan mengelola design system"),
                            const SizedBox(height: 18),
                            _buildBulletPoint("Pemahaman yang mendalam tentang user research dan usability testing"),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Apply Button - Fixed at bottom
      bottomNavigationBar: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.fromLTRB(31, 0, 31, 26),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFF2A3038).withOpacity(0.95),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // Handle apply button
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fitur Lamar Pekerjaan akan segera hadir!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Center(
                child: Text(
                  "Lamar Sekarang",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: "SF Pro",
                    fontWeight: FontWeight.w900,
                    color: Colors.white.withOpacity(0.95),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      height: 23,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 9,
            fontFamily: "SF Pro",
            fontWeight: FontWeight.w500,
            color: Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 7,
          height: 7,
          margin: const EdgeInsets.only(top: 4),
          decoration: const BoxDecoration(
            color: Color(0xFF0987BB),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            text,
            textAlign: TextAlign.justify,
            style: const TextStyle(
              fontSize: 11,
              fontFamily: "SF Pro",
              fontWeight: FontWeight.w300,
              color: Color(0xFF64748B),
              height: 1.36,
            ),
          ),
        ),
      ],
    );
  }
}