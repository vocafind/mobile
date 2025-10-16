import 'package:flutter/material.dart';
import 'package:jobfair/widget/bottom_navbar.dart';

class HalamanJobfairDetail extends StatelessWidget {
  const HalamanJobfairDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header dengan gradient dan info job fair
            _buildHeader(context),
            
            // Carousel images
            _buildImageCarousel(),
            
            // Tentang acara section
            _buildAboutSection(),
            
            // Perusahaan berpartisipasi
            _buildCompaniesSection(),
            
            // Lowongan tersedia
            _buildJobsSection(),
            
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 2),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1B56FD), Color(0xFF0118D8)],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // Back button, Search bar dan filter
              Row(
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEEEEE).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEEEEE).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Row(
                        children: [
                          SizedBox(width: 14),
                          Icon(Icons.search, color: Colors.white, size: 25),
                          SizedBox(width: 16),
                          Text(
                            'Cari lowongan kerja...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEEEEE).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.tune,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Title
              const Text(
                'Tech Career Expo 2025',
                style: TextStyle(
                  color: Color(0xFFFFFBFB),
                  fontSize: 24,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              // Location
              const Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 12,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Politeknik Negeri Batam',
                    style: TextStyle(
                      color: Color(0xFFFFFBFB),
                      fontSize: 12,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Date
              const Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: Colors.white,
                    size: 10,
                  ),
                  SizedBox(width: 6),
                  Text(
                    '19 Sep 2025 - 20 Sep 2025',
                    style: TextStyle(
                      color: Color(0xFFFFFBFB),
                      fontSize: 12,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Registration info
              const Text(
                'Pendaftaran : 7 Sep 2025 - 19 Sep 2025',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              // Badges
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildBadge('20 Kapasitas'),
                    const SizedBox(width: 6),
                    _buildBadge('10 Lowongan'),
                    const SizedBox(width: 6),
                    _buildBadge('3 Perusahaan'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      height: 20,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(45),
        border: Border.all(
          color: const Color(0xFFF1F5F9).withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }

  Widget _buildImageCarousel() {
    return Container(
      height: 240,
      color: Colors.white,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          const SizedBox(width: 18),
          _buildCarouselImage('assets/images/image10.png'),
          const SizedBox(width: 12),
          _buildCarouselImage('assets/images/image10.png'),
          const SizedBox(width: 18),
        ],
      ),
    );
  }

  Widget _buildCarouselImage(String imagePath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(
        imagePath,
        width: 336,
        height: 202,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildAboutSection() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(19),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tentang acara',
            style: TextStyle(
              color: Color(0xFF18181B),
              fontSize: 20,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 16),
          RichText(
            textAlign: TextAlign.justify,
            text: const TextSpan(
              style: TextStyle(
                color: Color(0xFF525252),
                fontSize: 12,
                fontFamily: 'SF Pro',
                height: 1.3,
              ),
              children: [
                TextSpan(
                  text: 'Kami mencari Senior UI/UX Designer yang berpengalaman untuk memimpin inisiatif desain dalam mengembangkan pengalaman mobile generasi berikutnya. Kamu akan bekerja dengan tim product dan engineering untuk menciptakan solu... ',
                ),
                TextSpan(
                  text: 'Read more',
                  style: TextStyle(
                    color: Color(0xFF2563EB),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompaniesSection() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 19),
      margin: const EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 19),
            child: Text(
              'Perusahaan berpartisipasi',
              style: TextStyle(
                color: Color(0xFF18181B),
                fontSize: 20,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 30),
          // Horizontal scrollable company logos
          SizedBox(
            height: 80,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 19),
              children: [
                _buildCompanyLogo('assets/images/company1.png'),
                const SizedBox(width: 20),
                _buildCompanyLogo('assets/images/company2.png'),
                const SizedBox(width: 20),
                _buildCompanyLogo('assets/images/company3.png'),
                const SizedBox(width: 20),
                _buildCompanyLogo('assets/images/company4.png'),
                const SizedBox(width: 20),
                _buildCompanyLogo('assets/images/company1.png'),
                const SizedBox(width: 20),
                _buildCompanyLogo('assets/images/company2.png'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyLogo(String imagePath) {
    return Container(
      width: 76,
      height: 68,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Image.asset(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.business, color: Colors.grey, size: 40);
        },
      ),
    );
  }

  Widget _buildJobsSection() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(19),
      margin: const EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lowongan tersedia',
            style: TextStyle(
              color: Color(0xFF18181B),
              fontSize: 20,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 16),
          _buildJobCard(),
          const SizedBox(height: 15),
          _buildJobCard(),
          const SizedBox(height: 15),
          _buildJobCard(),
        ],
      ),
    );
  }

  Widget _buildJobCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Company logo
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/company_logo.png',
                      width: 38,
                      height: 34,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.business, size: 32, color: Colors.grey);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Job info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Fulltime Backend Developer',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Inforsys Indonesia',
                        style: TextStyle(
                          color: Color(0xFF525252),
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: const [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: Color(0xFF525252),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Kota Batam',
                            style: TextStyle(
                              color: Color(0xFF525252),
                              fontSize: 14,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: const [
                          Icon(
                            Icons.attach_money,
                            size: 14,
                            color: Color(0xFF525252),
                          ),
                          Text(
                            'Rp 9.000.000',
                            style: TextStyle(
                              color: Color(0xFF525252),
                              fontSize: 14,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Bookmark icon
                Icon(
                  Icons.bookmark_border,
                  color: Colors.black.withOpacity(0.5),
                  size: 20,
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE5E5E5)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bertanggung jawab mengembangkan, mengelola, dan mengoptimalkan sistem...',
                  style: TextStyle(
                    color: Color(0xFF525252),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFD4D4D4)),
                      ),
                      child: const Text(
                        'Remote',
                        style: TextStyle(
                          color: Color(0xFF525252),
                          fontSize: 12,
                          fontFamily: 'SF Pro',
                        ),
                      ),
                    ),
                    const Text(
                      '1 hari lalu',
                      style: TextStyle(
                        color: Color(0xFF525252),
                        fontSize: 12,
                        fontFamily: 'SF Pro',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}