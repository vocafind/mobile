import 'package:flutter/material.dart';
import 'package:jobfair/api/api_service.dart';
import 'package:jobfair/models/loker_umum_model.dart';
import 'package:jobfair/screens/lama/job_detail_screen.dart';
import '/widget/header.dart';
import '/widget/bottom_navbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService =
      ApiService(); // Sesuaikan dengan nama service Anda
  List<LokerUmum> _lokerList = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadLokerData();
  }

  Future<void> _loadLokerData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final lokerData = await _apiService.getAllLokerUmum();
      setState(() {
        _lokerList = lokerData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat data';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            // Header dengan Search Bar
            const HeaderWidget(),

            // Scrollable Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadLokerData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      // Kategori Populer Section
                      _buildSectionTitle("Kategori Populer"),
                      const SizedBox(height: 16),
                      _buildCategoryGrid(),

                      const SizedBox(height: 32),

                      // Terbaru Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Terbaru",
                              style: TextStyle(
                                fontFamily: "SF Pro",
                                fontSize: 25,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Navigate ke halaman semua loker
                              },
                              child: const Text(
                                "Lihat semua",
                                style: TextStyle(
                                  fontFamily: "SF Pro",
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Job Cards from API
                      _buildJobList(),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: "SF Pro",
          fontSize: 25,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1A1A1A),
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    final categories = [
      {"name": "Teknologi", "count": "1.234 lowongan", "icon": Icons.computer},
      {"name": "Desain", "count": "1.234 lowongan", "icon": Icons.palette},
      {"name": "Marketing", "count": "1.234 lowongan", "icon": Icons.campaign},
      {
        "name": "Keuangan",
        "count": "1.234 lowongan",
        "icon": Icons.account_balance,
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Row(
            children: [
              _buildCategoryCard(
                categories[0]["name"] as String,
                categories[0]["count"] as String,
                categories[0]["icon"] as IconData,
              ),
              const SizedBox(width: 15),
              _buildCategoryCard(
                categories[1]["name"] as String,
                categories[1]["count"] as String,
                categories[1]["icon"] as IconData,
              ),
            ],
          ),
          const SizedBox(height: 17),
          Row(
            children: [
              _buildCategoryCard(
                categories[2]["name"] as String,
                categories[2]["count"] as String,
                categories[2]["icon"] as IconData,
              ),
              const SizedBox(width: 15),
              _buildCategoryCard(
                categories[3]["name"] as String,
                categories[3]["count"] as String,
                categories[3]["icon"] as IconData,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String name, String count, IconData icon) {
    return Expanded(
      child: Container(
        height: 128,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFDADADA),
                borderRadius: BorderRadius.circular(9),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 4,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const Spacer(),
            Text(
              name,
              style: const TextStyle(
                fontFamily: "SF Pro",
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              count,
              style: const TextStyle(
                fontFamily: "SF Pro",
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Color(0xFF7D7D7D),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobList() {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Text(
                _errorMessage,
                style: const TextStyle(
                  fontFamily: "SF Pro",
                  fontSize: 14,
                  color: Color(0xFF7D7D7D),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadLokerData,
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    if (_lokerList.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text(
            'Belum ada lowongan tersedia',
            style: TextStyle(
              fontFamily: "SF Pro",
              fontSize: 14,
              color: Color(0xFF7D7D7D),
            ),
          ),
        ),
      );
    }

    // Tampilkan maksimal 3 loker terbaru
    final displayedLoker = _lokerList.take(3).toList();

    return Column(
      children: displayedLoker.map((loker) {
        return Column(
          children: [_buildJobCard(loker), const SizedBox(height: 16)],
        );
      }).toList(),
    );
  }

  Widget _buildJobCard(LokerUmum loker) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JobDetailScreen(lowonganId: loker.lowonganId),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company Logo & Title
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0987BB),
                    borderRadius: BorderRadius.circular(9),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 4,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.business,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loker.posisi,
                        style: const TextStyle(
                          fontFamily: "SF Pro",
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        loker.companyName,
                        style: const TextStyle(
                          fontFamily: "SF Pro",
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF7D7D7D),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Description
            Text(
              loker.deskripsiPekerjaan,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: "SF Pro",
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Color(0xFF7D7D7D),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 16),

            // Tags & Time
            Row(
              children: [
                if (loker.lokasi != null) ...[
                  _buildTag(loker.lokasi),
                  const SizedBox(width: 6),
                ],
                if (loker.jenisPekerjaan != null) ...[
                  _buildTag(loker.jenisPekerjaan),
                  const SizedBox(width: 6),
                ],
                if (loker.opsiKerjaRemote != false) ...[
                  _buildTag(loker.opsiKerjaRemote ? "Remote" : ""),
                  const SizedBox(width: 6),
                ],
                const Spacer(),
                Text(
                  waktuLalu(loker.tanggalPosting),
                  style: const TextStyle(
                    fontFamily: "SF Pro",
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: "SF Pro",
          fontSize: 9,
          fontWeight: FontWeight.w500,
          color: Color(0xFF64748B),
        ),
      ),
    );
  }

  String waktuLalu(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays >= 30) {
      return "${(diff.inDays / 30).floor()} bulan lalu";
    } else if (diff.inDays >= 7) {
      return "${(diff.inDays / 7).floor()} minggu lalu";
    } else if (diff.inDays >= 1) {
      return "${diff.inDays} hari lalu";
    } else if (diff.inHours >= 1) {
      return "${diff.inHours} jam lalu";
    } else if (diff.inMinutes >= 1) {
      return "${diff.inMinutes} menit lalu";
    } else {
      return "Baru saja";
    }
  }
}
