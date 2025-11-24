import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobfair/api/api_service.dart';
import '/widget/header.dart';
import 'package:jobfair/widget/bottom_navbar.dart';
import 'package:jobfair/models/jobfair_model.dart';
import 'halaman_jobfair_detail.dart';

class HalamanJobfair extends StatefulWidget {
  const HalamanJobfair({super.key});

  @override
  State<HalamanJobfair> createState() => _HalamanJobfairState();
}

class _HalamanJobfairState extends State<HalamanJobfair> {
  final ApiService _apiService = ApiService();
  late Future<List<Jobfair>> _jobfairsFuture;
  
  // Daftar background colors yang akan digunakan secara berurutan
  final List<String> backgroundImages = const [
    'assets/images/kuning.png',
    'assets/images/biru.png',
    'assets/images/pink.png',
  ];

  @override
  void initState() {
    super.initState();
    _jobfairsFuture = _apiService.getAllJobfair();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Stack(
        children: [
          Column(
            children: [
              // Fixed Header
              const HeaderWidget(
                showNotification: true,
                showFilter: false,
              ),
              // Content area dengan scroll
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                  child: FutureBuilder<List<Jobfair>>(
                    future: _jobfairsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return _buildLoadingState();
                      } else if (snapshot.hasError) {
                        return _buildErrorState(snapshot.error.toString());
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return _buildEmptyState();
                      } else {
                        return _buildJobfairList(snapshot.data!);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          // Bottom Navigation Bar positioned at bottom
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomNavBar(currentIndex: 2),
          ),
        ],
      ),
    );
  }

  Widget _buildJobfairList(List<Jobfair> jobfairs) {
    return Column(
      children: [
        ...jobfairs.asMap().entries.map((entry) {
          final index = entry.key;
          final jobfair = entry.value;
          return Column(
            children: [
              _buildJobFairCard(
                context: context,
                jobfair: jobfair,
                imagePath: backgroundImages[index % backgroundImages.length],
              ),
              if (index < jobfairs.length - 1) const SizedBox(height: 15),
            ],
          );
        }),
        const SizedBox(height: 100), // Extra space untuk bottom navbar
      ],
    );
  }

  Widget _buildJobFairCard({
    required BuildContext context,
    required Jobfair jobfair,
    required String imagePath,
  }) {
    return GestureDetector(
      // onTap: () {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => HalamanJobfairDetail(jobfair: jobfair),
      //     ),
      //   );
      // },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            // Background image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                imagePath,
                width: double.infinity,
                height: 240,
                fit: BoxFit.cover,
              ),
            ),
            // Dark overlay
            Container(
              height: 240,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            // Content
            Container(
              height: 240,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badges row
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildBadge(jobfair.capacityText),
                        const SizedBox(width: 6),
                        _buildBadge(jobfair.jobsText),
                        const SizedBox(width: 6),
                        _buildBadge(jobfair.companiesText),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  // Title
                  Text(
                    jobfair.namaAcara,
                    style: const TextStyle(
                      color: Color(0xFFFFFBFB),
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Location
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Color(0xFFFFFBFB),
                        size: 12,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          jobfair.acaraBkk ?? 'Politeknik Negeri Batam',
                          style: const TextStyle(
                            color: Color(0xFFFFFBFB),
                            fontSize: 12,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Date
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: Color(0xFFFFFBFB),
                        size: 10,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        jobfair.formattedDateRange,
                        style: const TextStyle(
                          color: Color(0xFFFFFBFB),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Registration info
                  Text(
                    'Pendaftaran : ${DateFormat('dd MMM yyyy').format(jobfair.tanggalAwalPendaftaranAcara)} - ${DateFormat('dd MMM yyyy').format(jobfair.tanggalAkhirPendaftaranAcara)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  // Register button
                  Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(45),
                      border: Border.all(
                        color: const Color(0xFFF1F5F9).withOpacity(0.4),
                        width: 1,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Daftar Sekarang',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFFFFBFB),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
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
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      height: 22,
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
            fontSize: 10,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      children: [
        for (int i = 0; i < 2; i++)
          Column(
            children: [
              Container(
                width: double.infinity,
                height: 240,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              if (i < 1) const SizedBox(height: 15),
            ],
          ),
      ],
    );
  }

  Widget _buildErrorState(String error) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'Gagal memuat data job fair',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _jobfairsFuture = _apiService.getAllJobfair();
              });
            },
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: const Column(
        children: [
          Icon(Icons.event_busy, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Tidak ada job fair tersedia',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Silakan cek kembali nanti untuk informasi job fair terbaru.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}