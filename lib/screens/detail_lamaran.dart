import 'package:flutter/material.dart';

class DetailLamaran extends StatefulWidget {
  final String jobTitle;
  final String companyName;
  final String location;
  final String date;
  final String qrCode;
  final String status;

  const DetailLamaran({
    super.key,
    required this.jobTitle,
    required this.companyName,
    required this.location,
    required this.date,
    required this.qrCode,
    required this.status,
  });

  static void show(
    BuildContext context, {
    required String jobTitle,
    required String companyName,
    required String location,
    required String date,
    required String qrCode,
    required String status,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DetailLamaran(
        jobTitle: jobTitle,
        companyName: companyName,
        location: location,
        date: date,
        qrCode: qrCode,
        status: status,
      ),
    );
  }

  @override
  State<DetailLamaran> createState() => _DetailLamaranState();
}

class _DetailLamaranState extends State<DetailLamaran> {
  int _selectedTab = 0; // 0 = Status Lamaran, 1 = Deskripsi

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.only(top: 12, bottom: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),

          // Header Section with Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF162781).withValues(alpha:0.05),
                  const Color(0xFF2345F7).withValues(alpha:0.02),
                ],
              ),
            ),
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Column(
              children: [
                // Company Logo and Title
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo with Shadow
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha:0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/icons/icon.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.business, size: 36, color: Color(0xFF162781));
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Title and Company
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.jobTitle,
                            style: const TextStyle(
                              color: Color(0xFF1A1A1A),
                              fontSize: 22,
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.companyName,
                            style: TextStyle(
                              color: const Color(0xFF515151).withValues(alpha:0.9),
                              fontSize: 16,
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w400,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF162781).withValues(alpha:0.08),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFF162781).withValues(alpha:0.2),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 14,
                                  color: const Color(0xFF162781).withValues(alpha:0.7),
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'Remote',
                                  style: TextStyle(
                                    color: Color(0xFF162781),
                                    fontSize: 13,
                                    fontFamily: 'SF Pro',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Tab Buttons with Enhanced Design
                Container(
                  height: 50,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F7FA),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFFE5E8EB),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Status Lamaran Tab
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedTab = 0;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            decoration: BoxDecoration(
                              gradient: _selectedTab == 0
                                  ? LinearGradient(
                                      colors: [
                                        const Color(0xFF162781),
                                        const Color(0xFF2345F7),
                                      ],
                                    )
                                  : null,
                              color: _selectedTab == 0 ? null : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: _selectedTab == 0
                                  ? [
                                      BoxShadow(
                                        color: const Color(0xFF162781).withValues(alpha:0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                'Status Lamaran',
                                style: TextStyle(
                                  color: _selectedTab == 0 ? Colors.white : const Color(0xFF6B7280),
                                  fontSize: 15,
                                  fontFamily: 'Poppins',
                                  fontWeight: _selectedTab == 0 ? FontWeight.w600 : FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Deskripsi Tab
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedTab = 1;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            decoration: BoxDecoration(
                              gradient: _selectedTab == 1
                                  ? LinearGradient(
                                      colors: [
                                        const Color(0xFF162781),
                                        const Color(0xFF2345F7),
                                      ],
                                    )
                                  : null,
                              color: _selectedTab == 1 ? null : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: _selectedTab == 1
                                  ? [
                                      BoxShadow(
                                        color: const Color(0xFF162781).withValues(alpha:0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                'Deskripsi',
                                style: TextStyle(
                                  color: _selectedTab == 1 ? Colors.white : const Color(0xFF6B7280),
                                  fontSize: 15,
                                  fontFamily: 'Poppins',
                                  fontWeight: _selectedTab == 1 ? FontWeight.w600 : FontWeight.w500,
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

          // Divider
          Container(
            height: 1,
            color: const Color(0xFFE5E8EB),
          ),

          const SizedBox(height: 8),

          // Content Area
          Expanded(
            child: _selectedTab == 0
                ? _buildStatusLamaranContent()
                : _buildDeskripsiContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusLamaranContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusItem(
            title: 'Pending',
            description: 'Lamaran Anda sedang dalam antrian',
            icon: Icons.access_time_rounded,
            isCompleted: true,
            showLine: true,
          ),
          _buildStatusItem(
            title: 'Ditinjau',
            description: 'Tim HR sedang meninjau lamaran Anda',
            icon: Icons.remove_red_eye_rounded,
            isCompleted: true,
            showLine: true,
          ),
          _buildStatusItem(
            title: 'Interview',
            description: 'Anda dijadwalkan untuk wawancara',
            icon: Icons.people_rounded,
            isCompleted: widget.status == 'Interview' || widget.status == 'Diterima',
            showLine: true,
            actionText: 'Lihat Jadwal',
            actionColor: const Color(0xFF2345F7),
          ),
          _buildStatusItem(
            title: 'Diterima',
            description: 'Selamat! Lamaran Anda diterima',
            icon: Icons.check_circle_rounded,
            isCompleted: widget.status == 'Diterima',
            isSuccess: true,
            showLine: false,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem({
    required String title,
    required String description,
    required IconData icon,
    required bool isCompleted,
    required bool showLine,
    bool isSuccess = false,
    String? actionText,
    Color? actionColor,
  }) {
    final iconColor = isSuccess 
        ? const Color(0xFF34C759) 
        : (isCompleted ? const Color(0xFF0088FF) : const Color(0xFFBDBDBD));
    
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon Circle with Animation
            Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: iconColor,
                    shape: BoxShape.circle,
                    boxShadow: isCompleted
                        ? [
                            BoxShadow(
                              color: iconColor.withValues(alpha:0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                if (showLine)
                  Container(
                    width: 2,
                    height: 70,
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF2643D7).withValues(alpha:0.5),
                          const Color(0xFF2643D7).withValues(alpha:0.2),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),

            // Content
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: isCompleted ? const Color(0xFF191919) : const Color(0xFF9CA3AF),
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                          ),
                        ),
                        if (isCompleted)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF34C759).withValues(alpha:0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_circle_rounded,
                                  color: const Color(0xFF34C759),
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'Selesai',
                                  style: TextStyle(
                                    color: Color(0xFF34C759),
                                    fontSize: 12,
                                    fontFamily: 'SF Pro',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: TextStyle(
                        color: isCompleted ? const Color(0xFF6B7280) : const Color(0xFFBDBDBD),
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                    if (actionText != null) ...[
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          // Handle action
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: actionColor?.withValues(alpha:0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                actionText,
                                style: TextStyle(
                                  color: actionColor ?? const Color(0xFF2345F7),
                                  fontSize: 13,
                                  fontFamily: 'SF Pro',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 12,
                                color: actionColor ?? const Color(0xFF2345F7),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
        if (showLine) const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildDeskripsiContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Company Info Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF162781).withValues(alpha:0.05),
                  const Color(0xFF2345F7).withValues(alpha:0.02),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF162781).withValues(alpha:0.1),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.business_rounded,
                      size: 20,
                      color: const Color(0xFF162781).withValues(alpha:0.7),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.companyName,
                      style: const TextStyle(
                        color: Color(0xFF1A1A1A),
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: 18,
                      color: const Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.location,
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 18,
                      color: const Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.date,
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Instructions Section
          const Text(
            'Instruksi QR Code',
            style: TextStyle(
              color: Color(0xFF1A1A1A),
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildInstructionItem(
            icon: Icons.save_alt_rounded,
            text: 'Simpan QR code ini',
          ),
          const SizedBox(height: 12),
          _buildInstructionItem(
            icon: Icons.qr_code_scanner_rounded,
            text: 'Tunjukkan kepada petugas',
          ),
          const SizedBox(height: 12),
          _buildInstructionItem(
            icon: Icons.verified_rounded,
            text: 'Pastikan QR code terlihat jelas',
          ),
          const SizedBox(height: 32),

          // QR Code Section
          Center(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF2643D7).withValues(alpha:0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2643D7).withValues(alpha:0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 240,
                        height: 240,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F7FA),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.qr_code_2_rounded,
                          size: 160,
                          color: Colors.grey[300],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF162781).withValues(alpha:0.05),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          widget.qrCode,
                          style: const TextStyle(
                            color: Color(0xFF162781),
                            fontSize: 15,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Download Button
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.white),
                            SizedBox(width: 12),
                            Text('QR Code berhasil diunduh'),
                          ],
                        ),
                        backgroundColor: const Color(0xFF34C759),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF162781),
                          Color(0xFF2345F7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF162781).withValues(alpha:0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.download_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Unduh QR Code',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionItem({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE5E8EB),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF2643D7).withValues(alpha:0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 20,
              color: const Color(0xFF2643D7),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF1A1A1A),
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}