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
              const HeaderWidget(showNotification: true, showFilter: false),
              // Content area dengan scroll
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 18,
                  ),
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
    // Convert days until event start
    final now = DateTime.now();
    final diff = jobfair.tanggalMulaiAcara.difference(
      DateTime(now.year, now.month, now.day),
    );
    final daysLeft = diff.inDays;
    final daysText = daysLeft > 0 ? '$daysLeft hari lagi' : 'Berlangsung';

    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HalamanJobfairDetail(jobfairId: jobfair.id),
            ),
          );
        },
        child: Container(
          width: 338,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(34),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            jobfair.namaAcara,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          daysText,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      jobfair.acaraBkk ?? 'Politeknik Negeri Batam',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(34),
                      bottomRight: Radius.circular(34),
                    ),
                    child: Container(
                      width: 338,
                      height: 236,
                      color: const Color(0xFFE8F0FE),
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        cacheWidth: 676,
                        cacheHeight: 472,
                      ),
                    ),
                  ),
                  Container(
                    width: 338,
                    height: 236,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.1),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(34),
                        bottomRight: Radius.circular(34),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 24,
                    top: 24,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(45),
                            border: Border.all(
                              color: const Color(0xFFF3F6F9).withOpacity(0.4),
                            ),
                          ),
                          child: Text(
                            jobfair.jobsText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(45),
                            border: Border.all(
                              color: const Color(0xFFF3F6F9).withOpacity(0.4),
                            ),
                          ),
                          child: Text(
                            jobfair.companiesText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // HAPUS SizedBox yang di sini karena tidak efektif
                  Positioned(
                    left: 24,
                    top:
                        70, // UBAH dari bottom: 110 MENJADI top: 70 (atau nilai lain)
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Baris Lokasi
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              jobfair.acaraBkk ?? 'Lokasi tidak tersedia',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Baris Tanggal Acara
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              color: Colors.white,
                              size: 12,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              jobfair.formattedDateRange,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Baris Periode Pendaftaran
                        Text(
                          'Pendaftaran : ${DateFormat('dd MMM yyyy').format(jobfair.tanggalAwalPendaftaranAcara)} - ${DateFormat('dd MMM yyyy').format(jobfair.tanggalAkhirPendaftaranAcara)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    left: 24,
                    right: 24,
                    bottom: 14,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(45),
                        border: Border.all(
                          color: const Color(0xFFF3F6F9).withOpacity(0.4),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Lihat Detail',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
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
                child: const Center(child: CircularProgressIndicator()),
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
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
      padding: const EdgeInsets.all(30),
      child: const Column(
        children: [
          Icon(Icons.event_busy, size: 64, color: Colors.grey),
          SizedBox(height: 40),
          Text(
            'Tidak ada job fair tersedia',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
