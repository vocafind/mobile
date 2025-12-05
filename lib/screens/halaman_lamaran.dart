import 'package:flutter/material.dart';
import 'package:jobfair/models/lamar_loker.dart';
import 'package:jobfair/widget/bottom_navbar.dart';
import 'package:jobfair/widget/header.dart';
import 'package:jobfair/screens/detail_lamaran.dart';
import 'package:jobfair/screens/detail_lamaran_jobfair.dart';
import 'package:jobfair/api/api_service.dart';

class HalamanLamaran extends StatefulWidget {
  final String? applyIdToOpen; // Parameter untuk auto open lamaran

  const HalamanLamaran({super.key, this.applyIdToOpen});

  @override
  State<HalamanLamaran> createState() => _HalamanLamaranState();
}

class _HalamanLamaranState extends State<HalamanLamaran> {
  int _selectedMainTab = 0;
  int _selectedFilterTab = 0;

  final ApiService _apiService = ApiService();
  List<LamaranSaya> _allLamaranUmum = [];
  List<LamaranSaya> _allLamaranJobfair = [];
  List<LamaranSaya> _filteredLamaran = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadAllLamaran();

    // Jika ada applyIdToOpen, tunggu data dimuat lalu buka detail
    if (widget.applyIdToOpen != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _openLamaranDetailById(widget.applyIdToOpen!);
      });
    }
  }

  Future<void> _openLamaranDetailById(String applyId) async {
    // Tunggu loading selesai
    await Future.delayed(const Duration(milliseconds: 500));

    // Cari lamaran di semua data
    final allLamaran = [..._allLamaranUmum, ..._allLamaranJobfair];
    final lamaran = allLamaran
      .where((lamaran) => lamaran.applyId == applyId)
      .cast<LamaranSaya?>()
      .firstOrNull;

    if (lamaran != null && mounted) {
      final isJobfair = lamaran.acara != null;
      if (isJobfair) {
        DetailLamaranJobfair.show(context, lamaran: lamaran);
      } else {
        DetailLamaran.show(context, lamaran: lamaran);
      }
    }
  }

  Future<void> _loadAllLamaran() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final results = await Future.wait([
        _apiService.getLamaranSaya(),
        _apiService.getLamaranJobfairSaya(),
      ]);

      setState(() {
        _allLamaranUmum = results[0];
        _allLamaranJobfair = results[1];
        _filteredLamaran = _selectedMainTab == 0 ? results[0] : results[1];
        _isLoading = false;
      });

      print("""
      📊 DATA LAMARAN:
      - Umum: ${_allLamaranUmum.length} lamaran
      - Jobfair: ${_allLamaranJobfair.length} lamaran
      - Tab aktif: ${_selectedMainTab == 0 ? 'Umum' : 'Jobfair'}
      - Tampil: ${_filteredLamaran.length} lamaran
      """);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      print("❌ Error loading lamaran: $e");
    }
  }

  void _filterLamaran() {
    final baseList = _selectedMainTab == 0
        ? _allLamaranUmum
        : _allLamaranJobfair;

    if (_selectedFilterTab == 0) {
      setState(() {
        _filteredLamaran = baseList;
      });
    } else {
      final statusMap = {
        1: 'pending',
        2: 'reviewed',
        3: 'interview',
        4: 'accepted',
        5: 'reject_interview',
      };

      final status = statusMap[_selectedFilterTab];
      if (status != null) {
        setState(() {
          _filteredLamaran = baseList
              .where((lamaran) => lamaran.status.toLowerCase() == status)
              .toList();
        });
      }
    }
  }

  void _onMainTabChanged(int tabIndex) {
    setState(() {
      _selectedMainTab = tabIndex;
      _selectedFilterTab = 0;
      _filteredLamaran = tabIndex == 0 ? _allLamaranUmum : _allLamaranJobfair;
    });
  }

  // Method untuk handle tap card - BEDAKAN ANTARA UMUM DAN JOBFAIR
  void _handleCardTap(LamaranSaya lamaran) {
    if (_selectedMainTab == 1) {
      // Untuk tab Jobfair, buka DetailLamaranJobfair
      DetailLamaranJobfair.show(context, lamaran: lamaran);
    } else {
      // Untuk tab Umum, buka DetailLamaran biasa
      DetailLamaran.show(context, lamaran: lamaran);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F9),
      extendBody: true,
      body: Column(
        children: [
          const HeaderWidget(showNotification: true, showFilter: false),

          // Main Tabs (Umum & Job fair)
          Container(
            height: 45,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            decoration: BoxDecoration(
              color: const Color(0xFF162781).withOpacity(0.9),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              children: [
                const SizedBox(width: 6),
                // Umum Tab
                Expanded(
                  child: GestureDetector(
                    onTap: () => _onMainTabChanged(0),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 35,
                      decoration: BoxDecoration(
                        color: _selectedMainTab == 0
                            ? const Color(0xFF2345F7).withOpacity(0.7)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: Text(
                          'Umum ${_allLamaranUmum.isNotEmpty ? '(${_allLamaranUmum.length})' : ''}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Job fair Tab
                Expanded(
                  child: GestureDetector(
                    onTap: () => _onMainTabChanged(1),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 35,
                      decoration: BoxDecoration(
                        color: _selectedMainTab == 1
                            ? const Color(0xFF2345F7).withOpacity(0.7)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: Text(
                          'Job Fair ${_allLamaranJobfair.isNotEmpty ? '(${_allLamaranJobfair.length})' : ''}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
              ],
            ),
          ),

          // Filter Tabs
          Container(
            height: 42,
            padding: const EdgeInsets.only(left: 15, bottom: 8),
            color: const Color(0xFFF0F4F9),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterTab('Semua', 0),
                  const SizedBox(width: 9),
                  _buildFilterTab('Menunggu', 1),
                  const SizedBox(width: 9),
                  _buildFilterTab('Ditinjau', 2),
                  const SizedBox(width: 9),
                  _buildFilterTab('Interview', 3),
                  const SizedBox(width: 9),
                  _buildFilterTab('Diterima', 4),
                  const SizedBox(width: 9),
                  _buildFilterTab('Ditolak', 5),
                ],
              ),
            ),
          ),

          // Application List
          Expanded(child: _buildContent()),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_hasError) {
      return _buildErrorState();
    }

    if (_filteredLamaran.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadAllLamaran,
      child: ListView.separated(
        padding: const EdgeInsets.only(bottom: 100),
        itemCount: _filteredLamaran.length,
        separatorBuilder: (context, index) => const SizedBox(height: 0),
        itemBuilder: (context, index) {
          return _buildApplicationCard(_filteredLamaran[index]);
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: 3,
      separatorBuilder: (context, index) => const SizedBox(height: 0),
      itemBuilder: (context, index) {
        return _buildApplicationCardSkeleton();
      },
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Color(0xFFDC2626)),
          const SizedBox(height: 16),
          const Text(
            'Gagal memuat data lamaran',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              color: Color(0xFF515151),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _loadAllLamaran,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E40AF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Coba Lagi',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final isJobfairTab = _selectedMainTab == 1;
    final totalInTab = isJobfairTab
        ? _allLamaranJobfair.length
        : _allLamaranUmum.length;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isJobfairTab ? Icons.event_busy : Icons.work_outline,
            size: 60,
            color: const Color(0xFFB8B8B8),
          ),
          const SizedBox(height: 16),
          Text(
            isJobfairTab ? 'Belum ada lamaran jobfair' : 'Belum ada lamaran',
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              color: Color(0xFF515151),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isJobfairTab
                ? 'Ayo ikuti jobfair dan lamar lowongan yang sesuai'
                : 'Ayo lamar lowongan yang sesuai dengan minat kamu',
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins',
              color: Color(0xFFB8B8B8),
            ),
            textAlign: TextAlign.center,
          ),
          if (totalInTab > 0 && _filteredLamaran.isEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Coba ubah filter status untuk melihat lamaran',
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Poppins',
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterTab(String text, int index) {
    final isSelected = _selectedFilterTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilterTab = index;
          _filterLamaran();
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 26,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.black
              : const Color(0xFF475664).withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              height: 1.7,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildApplicationCard(LamaranSaya lamaran) {
    final lowongan = lamaran.lowongan;
    final company = lowongan.company;

    // Tentukan apakah ini jobfair dan ada acara
    final isJobfairWithEvent = _selectedMainTab == 1 && lamaran.acara != null;

    return GestureDetector(
      onTap: () => _handleCardTap(lamaran),
      child: Container(
        height: 181,
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 17),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(34),
        ),
        child: Stack(
          children: [
            // Label Nama Acara untuk Jobfair - POSISI LEBIH TINGGI
            if (isJobfairWithEvent)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 130,
                  height: 28,
                  decoration: BoxDecoration(
                    // <-- HAPUS const
                    color: const Color.fromARGB(255, 245, 245, 245),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(34),
                      bottomLeft: Radius.circular(20),
                    ),
                    border: Border.all(
                      color: Colors.black.withOpacity(0.06), // <-- OUTLINE
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          _getShortEventName(lamaran.acara!.namaAcara),
                          style: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 11,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
                ),
              ),

            // Content Area - TAMBAH JARAK LEBIH BANYAK UNTUK JOBFAIR
            Column(
              children: [
                // Content Area
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      16,
                      isJobfairWithEvent
                          ? 35
                          : 17, // ⬅️ TAMBAH JARAK DARI 25 KE 35
                      16,
                      0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with Logo and Title
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Company Logo
                            Container(
                              width: 40,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: company.logo.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        company.logo,
                                        fit: BoxFit.contain,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Image.asset(
                                                'assets/icons/icon.png',
                                                fit: BoxFit.contain,
                                              );
                                            },
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Image.asset(
                                        'assets/icons/icon.png',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                            ),
                            const SizedBox(width: 10),

                            // Job Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    lowongan.posisi,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      height: 1.25,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    company.namaPerusahaan,
                                    style: TextStyle(
                                      color: const Color(
                                        0xFF3C3C43,
                                      ).withOpacity(0.6),
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      height: 1.3,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 13),

                        // Location and Remote Tags
                        Row(
                          children: [
                            // Location Tag
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: Colors.black.withOpacity(0.06),
                                ),
                              ),
                              child: Text(
                                lowongan.lokasi.length > 25
                                    ? '${lowongan.lokasi.substring(0, 25)}...'
                                    : lowongan.lokasi,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'SF Pro',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),

                            // Remote Tag jika tersedia
                            if (lowongan.opsiKerjaRemote) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: Colors.black.withOpacity(0.06),
                                  ),
                                ),
                                child: const Text(
                                  'Remote',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontFamily: 'SF Pro',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Divider
                Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  color: const Color(0xFFE9E9E9),
                ),

                // Footer with Date and Status
                Container(
                  height: 54,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Dilamar ${_formatDate(lamaran.appliedAt)}',
                        style: const TextStyle(
                          color: Color(0xFF464E5E),
                          fontSize: 12,
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w400,
                          height: 2.0,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: lamaran.statusColor,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(
                          lamaran.statusText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w600,
                            height: 1.43,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper method untuk memendekkan nama acara jika terlalu panjang
  String _getShortEventName(String fullName) {
    if (fullName.length <= 15) return fullName;

    final words = fullName.split(' ');
    if (words.length > 1) {
      final shortName = words.take(2).join(' ');
      return shortName.length <= 15
          ? shortName
          : '${shortName.substring(0, 12)}...';
    }

    return '${fullName.substring(0, 12)}...';
  }

  Widget _buildApplicationCardSkeleton() {
    return Container(
      height: 181,
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(34),
      ),
      child: Column(
        children: [
          // Content Area Skeleton
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 17, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Skeleton
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo Skeleton
                      Container(
                        width: 40,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Title Skeleton
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 16,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: 120,
                              height: 14,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 13),
                  // Tags Skeleton
                  Row(
                    children: [
                      Container(
                        width: 100,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 60,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Divider
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            color: const Color(0xFFE9E9E9),
          ),
          // Footer Skeleton
          Container(
            height: 54,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 100,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  width: 60,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day;
    final month = _getMonthName(date.month);
    final year = date.year;
    return '$day $month $year';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return months[month - 1];
  }
}
