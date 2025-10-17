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
                        color: const Color(0xFFEEEEEE).withValues(alpha:0.1),
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
                        color: const Color(0xFFEEEEEE).withValues(alpha:0.1),
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
                      color: const Color(0xFFEEEEEE).withValues(alpha:0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.notifications_outlined,
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
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      height: 30,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(45),
        border: Border.all(
          color: const Color(0xFFF1F5F9).withValues(alpha:0.4),
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
                fontSize: 14,
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
      color: const Color(0xFFF1F5F9),
      margin: const EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(19, 19, 19, 16),
            child: Text(
              'Lowongan tersedia',
              style: TextStyle(
                color: Color(0xFF18181B),
                fontSize: 20,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          _buildJobCard(),
          const SizedBox(height: 1),
          _buildJobCard(),
          const SizedBox(height: 1),
          _buildJobCard(),
        ],
      ),
    );
  }

  Widget _buildJobCard() {
    return Container(
      width: double.infinity,
      height: 235,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFDADADA).withValues(alpha:0.5),
            width: 1,
          ),
        ),
      ),
      child: Stack(
        children: [
          // Logo box
          Positioned(
            left: 17,
            top: 16,
            child: Container(
              width: 55,
              height: 54,
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
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.business, color: Colors.grey, size: 32);
                  },
                ),
              ),
            ),
          ),
          // Job title
          const Positioned(
            left: 84,
            top: 20,
            right: 16,
            child: Text(
              'Fulltime Backend Developer',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
          ),
          // Company name
          const Positioned(
            left: 84,
            top: 43,
            child: Text(
              'Inforsys Indonesia',
              style: TextStyle(
                color: Color(0xFF515151),
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                height: 1.71,
              ),
            ),
          ),
          // Location icon
          const Positioned(
            left: 17,
            top: 80,
            child: Icon(
              Icons.location_on_outlined,
              size: 19,
              color: Color(0xFF515151),
            ),
          ),
          // Location text
          const Positioned(
            left: 39,
            top: 77,
            child: Text(
              'Kota Batam',
              style: TextStyle(
                color: Color(0xFF515151),
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                height: 2,
              ),
            ),
          ),
          // Salary icon
          const Positioned(
            left: 18,
            top: 103,
            child: Icon(
              Icons.payments_outlined,
              size: 18,
              color: Color(0xFF515151),
            ),
          ),
          // Salary text
          const Positioned(
            left: 39,
            top: 100,
            child: Text(
              'Rp 9.000.000',
              style: TextStyle(
                color: Color(0xFF515151),
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                height: 2,
              ),
            ),
          ),
          // Bookmark icon
          Positioned(
            right: 16,
            top: 92,
            child: Icon(
              Icons.bookmark_outline,
              size: 18,
              color: Colors.black.withValues(alpha:0.5),
            ),
          ),
          // Description
          const Positioned(
            left: 16,
            top: 136,
            right: 16,
            child: Text(
              'Bertanggung jawab mengembangkan, mengelola, dan mengoptimalkan sistem backend untuk...',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Color(0xFF515151),
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                height: 2,
              ),
            ),
          ),
          // Tags
          Positioned(
            left: 15,
            bottom: 18,
            child: Row(
              children: [
                _buildTag('S1'),
                const SizedBox(width: 6),
                _buildTag('Remote'),
                const SizedBox(width: 6),
                _buildTag('Senior'),
              ],
            ),
          ),
          // Time ago
          const Positioned(
            right: 16,
            bottom: 18,
            child: Text(
              '1 hari lalu',
              style: TextStyle(
                color: Color(0xFF464E5E),
                fontSize: 10,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w700,
                height: 2.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF464E5E),
          fontSize: 12,
          fontFamily: 'SF Pro',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}