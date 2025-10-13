import 'package:flutter/material.dart';
import '/widget/bottom_navbar.dart';

class JobFairDetailScreen extends StatelessWidget {
  const JobFairDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    _buildHeader(context),
                    
                    // Main Content
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          const Text(
                            "Tech Career Expo 2025",
                            style: TextStyle(
                              fontSize: 25,
                              fontFamily: "SF Pro",
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1A1A1A),
                              height: 1.12,
                            ),
                          ),
                          const SizedBox(height: 13),
                          
                          // Organizer
                          const Text(
                            "Politeknik Negeri Batam",
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: "SF Pro",
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF64748B),
                              height: 1.56,
                            ),
                          ),
                          const SizedBox(height: 0),
                          
                          // Location
                          const Text(
                            "Politeknik Negeri Batam",
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: "SF Pro",
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF94A3B8),
                              height: 1.87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          
                          // Date Tag
                          Container(
                            height: 23,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFFF1F5F9),
                                width: 1.5,
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                "19 Sep 2025 - 20 Sep 2025",
                                style: TextStyle(
                                  fontSize: 9,
                                  fontFamily: "SF Pro",
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF64748B),
                                  height: 2.67,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          
                          // Registration Period
                          const Text(
                            "Pendaftaran : 7 Sep 2025 - 19 Sep 2025",
                            style: TextStyle(
                              fontSize: 9,
                              fontFamily: "SF Pro",
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0987BB),
                              height: 2.67,
                            ),
                          ),
                          const SizedBox(height: 25),
                          
                          // Stats Box
                          _buildStatsBox(),
                          const SizedBox(height: 25),
                          
                          // Participating Companies Section
                          _buildParticipatingCompanies(),
                          const SizedBox(height: 25),
                          
                          // Job Listings Section
                          _buildJobListings(),
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Register Button (Fixed at bottom)
            _buildRegisterButton(),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 36),
      child: Row(
        children: [
          // Back Button
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
          const SizedBox(width: 13),
          
          // Title
          const Text(
            "Detail Acara",
            style: TextStyle(
              fontSize: 14,
              fontFamily: "SF Pro",
              fontWeight: FontWeight.w700,
              color: Colors.black,
              height: 1.71,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsBox() {
    return Container(
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
                  "10",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: "SF Pro",
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF191919),
                    height: 1.5,
                  ),
                ),
                Text(
                  "Lowongan",
                  style: TextStyle(
                    fontSize: 11,
                    fontFamily: "SF Pro",
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF64748B),
                    height: 2.18,
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
                  "3",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: "SF Pro",
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF191919),
                    height: 1.5,
                  ),
                ),
                Text(
                  "Perusahaan",
                  style: TextStyle(
                    fontSize: 11,
                    fontFamily: "SF Pro",
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF64748B),
                    height: 2.18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipatingCompanies() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(
                Icons.business_outlined,
                size: 20,
                color: Color(0xFF0987BB),
              ),
              SizedBox(width: 8),
              Text(
                "Perusahaan Berpartisipasi",
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: "SF Pro",
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF191919),
                  height: 1.6,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          
          // Company Logos
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCompanyLogo(),
              _buildCompanyLogo(),
              _buildCompanyLogo(),
              _buildCompanyLogo(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyLogo() {
    return Container(
      width: 50,
      height: 50,
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
    );
  }

  Widget _buildJobListings() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(
                Icons.work_outline,
                size: 20,
                color: Color(0xFF0987BB),
              ),
              SizedBox(width: 8),
              Text(
                "Lowongan Kerja",
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: "SF Pro",
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF191919),
                  height: 1.6,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          
          // Job Cards
          _buildJobCard(),
          const SizedBox(height: 16),
          _buildJobCard(),
          const SizedBox(height: 16),
          _buildJobCard(),
        ],
      ),
    );
  }

  Widget _buildJobCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Company Logo
              Container(
                width: 43.45,
                height: 45.51,
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
              const SizedBox(width: 10),
              
              // Job Title and Company
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Senior UI/UX Designer",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "SF Pro",
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        height: 1.71,
                      ),
                    ),
                    Text(
                      "Gojek Indonesia",
                      style: TextStyle(
                        fontSize: 11,
                        fontFamily: "SF Pro",
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF7D7D7D),
                        height: 1.9,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          
          // Job Description
          const Text(
            "Lead design initiatives for next-gen mobile experiences",
            style: TextStyle(
              fontSize: 11,
              fontFamily: "SF Pro",
              fontWeight: FontWeight.w500,
              color: Color(0xFF7D7D7D),
              height: 1.64,
            ),
          ),
          const SizedBox(height: 15),
          
          // Tags and Time
          Row(
            children: [
              _buildJobTag("Batam"),
              const SizedBox(width: 6),
              _buildJobTag("Remote"),
              const SizedBox(width: 6),
              _buildJobTag("Senior"),
              const Spacer(),
              const Text(
                "1 hari lalu",
                style: TextStyle(
                  fontSize: 9,
                  fontFamily: "SF Pro",
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF94A3B8),
                  height: 2.67,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJobTag(String text) {
    return Container(
      height: 20.89,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 9,
            fontFamily: "SF Pro",
            fontWeight: FontWeight.w500,
            color: Color(0xFF64748B),
            height: 2.67,
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
      color: Colors.transparent,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF20249F),
              Color(0xFF03DEDB),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            "Daftar Sekarang",
            style: TextStyle(
              fontSize: 18,
              fontFamily: "SF Pro",
              fontWeight: FontWeight.w900,
              color: Colors.white.withOpacity(0.95),
              height: 1.33,
            ),
          ),
        ),
      ),
    );
  }
}