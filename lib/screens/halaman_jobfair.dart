import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobfair/api/api_service.dart';
import '/widget/header.dart';
import 'package:jobfair/widget/bottom_navbar.dart';
import 'package:jobfair/models/jobfair_model.dart';
import 'package:jobfair/api/route.dart';

class HalamanJobfair extends StatefulWidget {
  const HalamanJobfair({super.key});

  @override
  State<HalamanJobfair> createState() => _HalamanJobfairState();
}

class _HalamanJobfairState extends State<HalamanJobfair> {
  final ApiService _apiService = ApiService();
  late Future<List<Jobfair>> _jobfairsFuture;

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
              // PERBAIKI: Tambahkan enableNavigation = true
              HeaderWidget(
                showNotification: true,
                showFilter: false,
                enableNavigation: true, // INI YANG PERLU DITAMBAHKAN!
                searchRoute: AppRoutes.cariLoker,
                onSearch: (query) {
                  // Real-time search di jobfair jika diperlukan
                  print("Search di jobfair: $query");
                },
              ),
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
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          children: [
            ...jobfairs.asMap().entries.map((entry) {
              final index = entry.key;
              final jobfair = entry.value;
              return Column(
                children: [
                  _buildJobFairCard(
                    context: context,
                    jobfair: jobfair,
                    imagePath:
                        backgroundImages[index % backgroundImages.length],
                  ),
                  if (index < jobfairs.length - 1) const SizedBox(height: 15),
                ],
              );
            }),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildJobFairCard({
    required BuildContext context,
    required Jobfair jobfair,
    required String imagePath,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallDevice = screenWidth < 360;
    // Maksimal width 500px, atau full width - padding jika layar kecil
    final maxCardWidth = screenWidth > 536 ? 500.0 : screenWidth - 36;
    final cardWidth = maxCardWidth;
    final cardHeight = isSmallDevice ? 280.0 : 300.0;

    final now = DateTime.now();
    final diff = jobfair.tanggalMulaiAcara.difference(
      DateTime(now.year, now.month, now.day),
    );
    final daysLeft = diff.inDays;
    final daysText = daysLeft > 0 ? '$daysLeft hari lagi' : 'Berlangsung';

    return GestureDetector(
      onTap: () {
        goTo(context, AppRoutes.jobfairDetail, arguments: jobfair.id);
      },
      child: Container(
        width: cardWidth,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(isSmallDevice ? 28 : 34),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(isSmallDevice ? 18 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          jobfair.namaAcara,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: isSmallDevice ? 14 : 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        daysText,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: isSmallDevice ? 11 : 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    jobfair.acaraBkk ?? 'Politeknik Negeri Batam',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: isSmallDevice ? 12 : 13,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(isSmallDevice ? 28 : 34),
                    bottomRight: Radius.circular(isSmallDevice ? 28 : 34),
                  ),
                  child: Container(
                    width: cardWidth,
                    height: isSmallDevice ? 200 : 236,
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
                  width: cardWidth,
                  height: isSmallDevice ? 200 : 236,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(isSmallDevice ? 28 : 34),
                      bottomRight: Radius.circular(isSmallDevice ? 28 : 34),
                    ),
                  ),
                ),
                Positioned(
                  left: isSmallDevice ? 16 : 24,
                  top: isSmallDevice ? 16 : 24,
                  right: isSmallDevice ? 16 : 24,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallDevice ? 12 : 16,
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
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isSmallDevice ? 12 : 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallDevice ? 12 : 16,
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
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isSmallDevice ? 12 : 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: isSmallDevice ? 16 : 24,
                  top: isSmallDevice ? 58 : 70,
                  right: isSmallDevice ? 16 : 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: isSmallDevice ? 12 : 14,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              jobfair.acaraBkk ?? 'Lokasi tidak tersedia',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isSmallDevice ? 12 : 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isSmallDevice ? 6 : 8),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Colors.white,
                            size: isSmallDevice ? 10 : 12,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              jobfair.formattedDateRange,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isSmallDevice ? 12 : 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isSmallDevice ? 6 : 8),
                      Text(
                        'Pendaftaran : ${DateFormat('dd MMM yyyy').format(jobfair.tanggalAwalPendaftaranAcara)} - ${DateFormat('dd MMM yyyy').format(jobfair.tanggalAkhirPendaftaranAcara)}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallDevice ? 11 : 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: isSmallDevice ? 16 : 24,
                  right: isSmallDevice ? 16 : 24,
                  bottom: 14,
                  child: Container(
                    height: isSmallDevice ? 36 : 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(45),
                      border: Border.all(
                        color: const Color(0xFFF3F6F9).withOpacity(0.4),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Lihat Detail',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallDevice ? 12 : 13,
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
