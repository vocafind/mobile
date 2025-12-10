import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:intl/intl.dart';
import 'package:jobfair/api/api_service.dart';
import 'package:jobfair/models/company_model.dart';
import 'package:jobfair/models/jobfair_model.dart';
import 'package:jobfair/models/loker_umum_detail_model.dart';
import 'package:jobfair/models/loker_umum_model.dart';
import 'package:jobfair/models/loker_rekomendasi_model.dart'; // Model baru untuk LokerRekomendasi
import 'package:jobfair/models/saved_job_model.dart';
import 'package:jobfair/screens/detail_job_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/widget/bottom_navbar.dart';
import 'package:jobfair/api/route.dart';

class HalamanBeranda extends StatefulWidget {
  const HalamanBeranda({super.key});

  @override
  State<HalamanBeranda> createState() => _HalamanBerandaState();
}

class _HalamanBerandaState extends State<HalamanBeranda> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<double> _scrollOffset = ValueNotifier<double>(0.0);
  final ApiService _apiService = ApiService();

  // Inisialisasi langsung dengan Future.value([]) untuk menghindari late error
  Future<List<CompanyLogo>> _companyLogosFuture = Future.value([]);
  Future<List<LokerUmum>> _urgentJobsFuture = Future.value([]);
  Future<List<LokerRekomendasi>> _recommendedJobsFuture = Future.value(
    [],
  ); // Tambahan: Future untuk Loker Rekomendasi

  // List untuk menyimpan ID job yang sudah disimpan
  List<String> _savedJobIds = [];
  bool _isLoadingUrgentJobs = true;
  bool _isLoadingSavedJobs = true;
  bool _isLoadingRecommendedJobs =
      true; // Tambahan: Loading state untuk rekomendasi

  final List<String> backgroundImages = const [
    'assets/images/kuning.png',
    'assets/images/biru.png',
    'assets/images/pink.png',
  ];

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadInitialData();
  }

  void _onScroll() {
    _scrollOffset.value = _scrollController.offset;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _scrollOffset.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  // Method untuk load data awal
  Future<void> _loadInitialData() async {
    try {
      // Inisialisasi company logos
      _companyLogosFuture = _apiService.getRandomCompanyLogos(count: 6);

      // Load semua data secara parallel
      await Future.wait([
        _loadUrgentJobs(),
        _loadRecommendedJobs(), // Tambahan: Load data rekomendasi
        _loadSavedJobs(),
      ]);
    } catch (e) {
      print("❌ Error loading initial data: $e");
      setState(() {
        _isLoadingUrgentJobs = false;
        _isLoadingSavedJobs = false;
        _isLoadingRecommendedJobs = false; // Tambahan
        _urgentJobsFuture = Future.value([]);
        _recommendedJobsFuture = Future.value([]); // Tambahan
        _savedJobIds = [];
      });
    }
  }

  Future<void> _loadUrgentJobs() async {
    try {
      setState(() {
        _isLoadingUrgentJobs = true;
      });

      final allJobs = await _apiService.getAllLokerUmum();

      // Filter jobs yang batas lamaran kurang dari 10 hari
      final urgentJobs = allJobs.where((job) {
        final daysLeft = _calculateDaysLeft(job.batasLamaran);
        return daysLeft <= 10 && daysLeft >= 0;
      }).toList();

      final result = urgentJobs.take(3).toList();

      setState(() {
        _urgentJobsFuture = Future.value(result);
        _isLoadingUrgentJobs = false;
      });
    } catch (e) {
      print("❌ Error getting urgent jobs: $e");
      setState(() {
        _urgentJobsFuture = Future.value([]);
        _isLoadingUrgentJobs = false;
      });
    }
  }

  // Method untuk load recommended jobs
  Future<void> _loadRecommendedJobs() async {
    try {
      setState(() {
        _isLoadingRecommendedJobs = true;
      });

      final allRecommendedJobs = await _apiService.getAllLokerRekomendasi();

      // Ambil maksimal 3 rekomendasi
      final recommendedJobs = allRecommendedJobs.take(3).toList();

      setState(() {
        _recommendedJobsFuture = Future.value(recommendedJobs);
        _isLoadingRecommendedJobs = false;
      });
    } catch (e) {
      print("❌ Error getting recommended jobs: $e");
      setState(() {
        _recommendedJobsFuture = Future.value([]);
        _isLoadingRecommendedJobs = false;
      });
    }
  }

  Future<void> _loadSavedJobs() async {
    try {
      setState(() {
        _isLoadingSavedJobs = true;
      });

      final savedJobs = await _apiService.getSavedJobs();

      setState(() {
        _savedJobIds = savedJobs.map((job) => job.lowonganId).toList();
        _isLoadingSavedJobs = false;
      });
    } catch (e) {
      print("❌ Error loading saved jobs: $e");
      setState(() {
        _savedJobIds = [];
        _isLoadingSavedJobs = false;
      });
    }
  }

  int _calculateDaysLeft(DateTime batasLamaran) {
    final now = DateTime.now();
    final difference = batasLamaran.difference(now);
    return difference.inDays;
  }

  // Method untuk show job detail dari LokerUmum
  Future<void> _showJobDetail(LokerUmum lowongan) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final detailLowongan = await _apiService.getLokerUmumDetailById(
        lowongan.lowonganId,
      );

      if (mounted) Navigator.of(context).pop();

      if (mounted) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => JobDetailSheet(loker: detailLowongan),
        ).then((shouldRefresh) {
          if (shouldRefresh == true) {
            _refreshSavedJobs(); // Refresh saved jobs status
          }
        });
      }
    } catch (e) {
      if (mounted) Navigator.of(context).pop();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat detail lowongan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Method untuk show job detail dari LokerRekomendasi
  Future<void> _showRecommendedJobDetail(LokerRekomendasi lowongan) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Gunakan method yang sama dengan LokerUmum karena datanya sama
      final detailLowongan = await _apiService.getLokerUmumDetailById(
        lowongan.lowonganId,
      );

      if (mounted) Navigator.of(context).pop();

      if (mounted) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => JobDetailSheet(loker: detailLowongan),
        ).then((shouldRefresh) {
          if (shouldRefresh == true) {
            _refreshSavedJobs(); // Refresh saved jobs status
          }
        });
      }
    } catch (e) {
      if (mounted) Navigator.of(context).pop();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat detail lowongan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Method untuk refresh saved jobs status
  Future<void> _refreshSavedJobs() async {
    try {
      final savedJobs = await _apiService.getSavedJobs();
      setState(() {
        _savedJobIds = savedJobs.map((job) => job.lowonganId).toList();
      });
    } catch (e) {
      print("❌ Error refreshing saved jobs: $e");
    }
  }

  Future<void> _toggleSaveJob(String lowonganId, bool currentlySaved) async {
    try {
      if (currentlySaved) {
        await _apiService.unsaveJobByLowonganId(lowonganId);
        setState(() {
          _savedJobIds.remove(lowonganId);
        });
        print("✅ Job unsaved: $lowonganId");
      } else {
        await _apiService.saveJob(lowonganId);
        setState(() {
          _savedJobIds.add(lowonganId);
        });
        print("✅ Job saved: $lowonganId");
      }
    } catch (e) {
      print("❌ Error toggling save job: $e");
      // Tidak perlu menampilkan snackbar error
    }
  }

  void _handleSearchSubmitted(String query) {
    if (query.trim().isNotEmpty) {
      print("🔍 Search query from home: ${query.trim()}");

      // Tunggu frame berikutnya untuk navigasi
      Future.delayed(Duration.zero, () {
        Navigator.pushNamed(
          context,
          AppRoutes.cariLoker,
          arguments: {'initialSearchQuery': query.trim()},
        );
      });

      _searchController.clear();
      _searchFocusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;
    final double maxHeaderHeight = topPadding + 12 + 120 + 44 + 30;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F9),
      extendBody: true,
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      body: Stack(
        children: [
          RepaintBoundary(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  SizedBox(height: maxHeaderHeight + 20),

                  // Section Cocok Untuk Kamu - akan hilang jika tidak ada data
                  _CocokUntukKamuSection(
                    recommendedJobsFuture: _recommendedJobsFuture,
                    savedJobIds: _savedJobIds,
                    isLoadingRecommendedJobs: _isLoadingRecommendedJobs,
                    onJobTap: _showRecommendedJobDetail,
                    onBookmarkToggle: _toggleSaveJob,
                  ),

                  // Hanya tampilkan divider jika ada data rekomendasi
                  FutureBuilder<List<LokerRekomendasi>>(
                    future: _recommendedJobsFuture,
                    builder: (context, snapshot) {
                      // Cek apakah ada data rekomendasi
                      final hasData =
                          snapshot.hasData &&
                          snapshot.data != null &&
                          snapshot.data!.isNotEmpty;

                      // Jika masih loading atau error, anggap ada data (tampilkan divider)
                      if (_isLoadingRecommendedJobs || snapshot.hasError) {
                        return Column(
                          children: [
                            const SizedBox(height: 40),
                            _buildDivider(),
                          ],
                        );
                      }

                      // Jika tidak ada data, jangan tampilkan divider
                      if (!hasData) {
                        return const SizedBox.shrink();
                      }

                      // Jika ada data, tampilkan divider
                      return Column(
                        children: [const SizedBox(height: 40), _buildDivider()],
                      );
                    },
                  ),

                  const SizedBox(height: 40),
                  _JelajahiKesempatanKarierSection(
                    apiService: _apiService,
                    backgroundImages: backgroundImages,
                  ),
                  const SizedBox(height: 60),
                  _TemuiMerekaDanKesempatanSegeraSection(
                    companyLogosFuture: _companyLogosFuture,
                    urgentJobsFuture: _urgentJobsFuture,
                    savedJobIds: _savedJobIds,
                    onJobTap: _showJobDetail,
                    onBookmarkToggle: _toggleSaveJob,
                    isLoadingUrgentJobs: _isLoadingUrgentJobs,
                    isLoadingSavedJobs: _isLoadingSavedJobs,
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),

          ValueListenableBuilder<double>(
            valueListenable: _scrollOffset,
            builder: (context, offset, child) {
              final bool showSearchOnly = offset > 100;
              final double headerHeight = showSearchOnly
                  ? topPadding + 25 + 50 + 16
                  : topPadding + 12 + 120 + 44 + 30;

              return Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: headerHeight,
                child: _AnimatedHeader(
                  showSearchOnly: showSearchOnly,
                  topPadding: topPadding,
                  searchController: _searchController,
                  searchFocusNode: _searchFocusNode,
                  onSearchSubmitted: _handleSearchSubmitted,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

Widget _buildDivider() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Container(
      height: 1,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0x00C7C7C7), Color(0xFFC7C7C7), Color(0x00C7C7C7)],
        ),
      ),
    ),
  );
}

class _AnimatedHeader extends StatefulWidget {
  final bool showSearchOnly;
  final double topPadding;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final Function(String) onSearchSubmitted;

  const _AnimatedHeader({
    required this.showSearchOnly,
    required this.topPadding,
    required this.searchController,
    required this.searchFocusNode,
    required this.onSearchSubmitted,
  });

  @override
  State<_AnimatedHeader> createState() => __AnimatedHeaderState();
}

class __AnimatedHeaderState extends State<_AnimatedHeader> {
  bool _isSearchFocused = false;
  String _userName = '';
  @override
  void initState() {
    super.initState();
    widget.searchFocusNode.addListener(_onFocusChange);
    _loadUserName();
  }

  @override
  void dispose() {
    widget.searchFocusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isSearchFocused = widget.searchFocusNode.hasFocus;
    });
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final userName = prefs.getString('nama') ?? 'Talent'; // Default fallback
    if (mounted) {
      setState(() {
        _userName = userName;
      });
    }
  }

  void _clearSearch() {
    widget.searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallDevice = screenWidth < 360;
    final isVerySmallDevice = screenWidth < 320;

    return Container(
      // Tambahkan height constraint agar tidak overflow
      constraints: BoxConstraints(minHeight: widget.showSearchOnly ? 80 : 180),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment(1.00, 0.30),
          end: Alignment(0.50, 1.00),
          colors: [Color(0xFF1B56FD), Color(0xFF0118D8)],
        ),
        boxShadow: widget.showSearchOnly
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: SafeArea(
        bottom: false,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.only(
            left: isVerySmallDevice ? 12 : (isSmallDevice ? 14 : 16),
            right: isVerySmallDevice ? 12 : (isSmallDevice ? 14 : 16),
            top: widget.showSearchOnly
                ? (isVerySmallDevice ? 10 : (isSmallDevice ? 12 : 14))
                : (isVerySmallDevice ? 16 : (isSmallDevice ? 18 : 24)),
            bottom: isVerySmallDevice ? 12 : (isSmallDevice ? 14 : 20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!widget.showSearchOnly) ...[
                Flexible(
                  child: Container(
                    margin: EdgeInsets.only(
                      bottom: isVerySmallDevice
                          ? 12
                          : (isSmallDevice ? 16 : 20),
                    ),
                    child: Text(
                      'Hai $_userName! Aku siap bantu cari pekerjaan terbaik buat kamu.',
                      style: TextStyle(
                        color: const Color(0xFFFFF8F8),
                        fontSize: isVerySmallDevice
                            ? 16
                            : (isSmallDevice ? 18 : 22),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],

              // Search bar dan icons
              _buildSearchRow(
                isVerySmallDevice: isVerySmallDevice,
                isSmallDevice: isSmallDevice,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchRow({
    required bool isVerySmallDevice,
    required bool isSmallDevice,
  }) {
    final iconButtonSize = isVerySmallDevice
        ? 36.0
        : (isSmallDevice ? 38.0 : 42.0);
    final iconSize = isVerySmallDevice ? 18.0 : (isSmallDevice ? 19.0 : 20.0);
    final spacing = isVerySmallDevice ? 6.0 : (isSmallDevice ? 8.0 : 10.0);

    return Row(
      children: [
        Expanded(
          child: Container(
            height: isVerySmallDevice ? 38 : (isSmallDevice ? 40 : 44),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
              border: _isSearchFocused
                  ? Border.all(color: Colors.white, width: 1.0)
                  : null,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: isVerySmallDevice ? 10 : (isSmallDevice ? 12 : 14),
                ),
                Icon(Icons.search, color: Colors.white, size: iconSize),
                SizedBox(
                  width: isVerySmallDevice ? 6 : (isSmallDevice ? 8 : 10),
                ),
                Expanded(
                  child: TextField(
                    controller: widget.searchController,
                    focusNode: widget.searchFocusNode,
                    cursorColor: Colors.white,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isVerySmallDevice
                          ? 12
                          : (isSmallDevice ? 13 : 14),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                      hintText: 'Cari lowongan kerja...',
                      hintStyle: TextStyle(
                        color: Colors.white70,
                        fontSize: isVerySmallDevice
                            ? 12
                            : (isSmallDevice ? 13 : 14),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onSubmitted: widget.onSearchSubmitted,
                  ),
                ),
                if (widget.searchController.text.isNotEmpty)
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: isVerySmallDevice ? 16 : (isSmallDevice ? 17 : 18),
                    ),
                    onPressed: _clearSearch,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                  )
                else
                  SizedBox(
                    width: isVerySmallDevice ? 6 : (isSmallDevice ? 8 : 10),
                  ),
              ],
            ),
          ),
        ),
        SizedBox(width: spacing),
        _buildIconButton(
          icon: Icons.bookmark_border,
          size: iconButtonSize,
          iconSize: iconSize,
          onTap: () => goTo(context, AppRoutes.bookmark),
        ),
        SizedBox(width: spacing),
        _buildIconButton(
          icon: Icons.notifications_outlined,
          size: iconButtonSize,
          iconSize: iconSize,
          onTap: () => goTo(context, AppRoutes.notifikasi),
        ),
      ],
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required double size,
    required double iconSize,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: iconSize),
      ),
    );
  }
}

class _CocokUntukKamuSection extends StatelessWidget {
  final Future<List<LokerRekomendasi>> recommendedJobsFuture;
  final List<String> savedJobIds;
  final bool isLoadingRecommendedJobs;
  final Function(LokerRekomendasi) onJobTap;
  final Function(String, bool) onBookmarkToggle;

  const _CocokUntukKamuSection({
    required this.recommendedJobsFuture,
    required this.savedJobIds,
    required this.isLoadingRecommendedJobs,
    required this.onJobTap,
    required this.onBookmarkToggle,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LokerRekomendasi>>(
      future: recommendedJobsFuture,
      builder: (context, snapshot) {
        // Jika masih loading, tampilkan skeleton
        if (isLoadingRecommendedJobs) {
          return _buildSectionWithSkeleton(context);
        }

        // Jika error, sembunyikan section
        if (snapshot.hasError) {
          print("❌ Error loading recommended jobs: ${snapshot.error}");
          return const SizedBox.shrink();
        }

        // Jika tidak ada data atau data kosong, sembunyikan section
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          print("ℹ️ No recommended jobs available, hiding section");
          return const SizedBox.shrink();
        }

        // Jika ada data, tampilkan section dengan data
        return _buildSectionWithData(context, snapshot.data!);
      },
    );
  }

  Widget _buildSectionWithSkeleton(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth * 0.9).clamp(300.0, 380.0);
    final cardHeight = cardWidth * 0.685;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Cocok untuk kamu',
              style: TextStyle(
                color: Color(0xFF070707),
                fontSize: 26,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                height: 1.15,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: cardHeight + 30,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(
              left: screenWidth * 0.05,
              top: 5,
              bottom: 5,
            ),
            clipBehavior: Clip.none,
            itemCount: 3,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: screenWidth * 0.04),
                child: _CocokUntukKamuCardSkeleton(
                  cardWidth: cardWidth,
                  cardHeight: cardHeight,
                  screenWidth: screenWidth,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSectionWithData(
    BuildContext context,
    List<LokerRekomendasi> recommendedJobs,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth * 0.9).clamp(300.0, 380.0);
    final cardHeight = cardWidth * 0.685;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Cocok untuk kamu',
              style: TextStyle(
                color: Color(0xFF070707),
                fontSize: 26,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                height: 1.15,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: cardHeight + 30,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(
              left: screenWidth * 0.05,
              top: 5,
              bottom: 5,
            ),
            clipBehavior: Clip.none,
            itemCount: recommendedJobs.length,
            itemBuilder: (context, index) {
              final job = recommendedJobs[index];
              final daysLeft = _calculateDaysLeft(job.batasLamaran);
              final isSaved = savedJobIds.contains(job.lowonganId);

              return Padding(
                padding: EdgeInsets.only(right: screenWidth * 0.04),
                child: _CocokUntukKamuCard(
                  lowongan: job,
                  daysLeft: daysLeft,
                  isSaved: isSaved,
                  cardWidth: cardWidth,
                  cardHeight: cardHeight,
                  screenWidth: screenWidth,
                  onTap: () => onJobTap(job),
                  onBookmarkToggle: onBookmarkToggle,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  int _calculateDaysLeft(DateTime batasLamaran) {
    final now = DateTime.now();
    final difference = batasLamaran.difference(now);
    return difference.inDays;
  }
}

class _CocokUntukKamuCard extends StatefulWidget {
  final LokerRekomendasi lowongan;
  final int daysLeft;
  final bool isSaved;
  final double cardWidth;
  final double cardHeight;
  final double screenWidth;
  final VoidCallback onTap;
  final Function(String, bool) onBookmarkToggle;

  const _CocokUntukKamuCard({
    required this.lowongan,
    required this.daysLeft,
    required this.isSaved,
    required this.cardWidth,
    required this.cardHeight,
    required this.screenWidth,
    required this.onTap,
    required this.onBookmarkToggle,
  });

  @override
  State<_CocokUntukKamuCard> createState() => _CocokUntukKamuCardState();
}

class _CocokUntukKamuCardState extends State<_CocokUntukKamuCard>
    with SingleTickerProviderStateMixin {
  late bool isSaved;
  late AnimationController _bookmarkController;
  late Animation<double> _bookmarkScale;

  @override
  void initState() {
    super.initState();
    isSaved = widget.isSaved;
    _bookmarkController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _bookmarkScale = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _bookmarkController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _bookmarkController.dispose();
    super.dispose();
  }

  void _toggleBookmark() {
    setState(() {
      isSaved = !isSaved;
    });
    _bookmarkController.forward().then((_) {
      _bookmarkController.reverse();
    });
    widget.onBookmarkToggle(widget.lowongan.lowonganId, !isSaved);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: widget.cardWidth,
        height: widget.cardHeight,
        child: Stack(
          children: [
            // Background
            Container(
              width: widget.cardWidth,
              height: widget.cardHeight,
              decoration: ShapeDecoration(
                color: const Color(0xFFF0F4F9),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color(0xFFC7C7C7)),
                  borderRadius: BorderRadius.circular(widget.cardWidth * 0.102),
                ),
              ),
            ),

            // Main card
            Container(
              width: widget.cardWidth,
              height: widget.cardHeight,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 3, color: Color(0xFF0118D8)),
                  borderRadius: BorderRadius.circular(widget.cardWidth * 0.102),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0xFF9FAAFF),
                    blurRadius: 20,
                    offset: Offset(0, 0),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Badge kecocokan
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      width: widget.cardWidth * 0.45,
                      height: widget.cardHeight * 0.119,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0E37EB),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(widget.cardWidth * 0.102),
                          bottomRight: Radius.circular(
                            widget.cardWidth * 0.058,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Color(0xFFFFCC00),
                            size: 14,
                          ),
                          SizedBox(width: widget.cardWidth * 0.012),
                          Text(
                            '${widget.lowongan.kecocokan}% cocok',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: widget.screenWidth * 0.029,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Badge hari tersisa (jika kurang dari 10 hari)
                  // if (widget.daysLeft <= 10 && widget.daysLeft >= 0)
                  //   Positioned(
                  //     right: 0,
                  //     top: 0,
                  //     child: Container(
                  //       width: widget.cardWidth * 0.35,
                  //       height: widget.cardHeight * 0.119,
                  //       decoration: BoxDecoration(
                  //         color: const Color(0xFFFF6B6B),
                  //         borderRadius: BorderRadius.only(
                  //           topRight: Radius.circular(widget.cardWidth * 0.102),
                  //           bottomLeft: Radius.circular(
                  //             widget.cardWidth * 0.058,
                  //           ),
                  //         ),
                  //       ),
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           const Icon(
                  //             Icons.bolt,
                  //             color: Colors.white,
                  //             size: 14,
                  //           ),
                  //           SizedBox(width: widget.cardWidth * 0.012),
                  //           Text(
                  //             widget.daysLeft == 0
                  //                 ? 'Hari terakhir!'
                  //                 : '${widget.daysLeft} hari',
                  //             style: TextStyle(
                  //               color: Colors.white,
                  //               fontSize: widget.screenWidth * 0.029,
                  //               fontFamily: 'Poppins',
                  //               fontWeight: FontWeight.w600,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  Padding(
                    padding: EdgeInsets.all(widget.cardWidth * 0.058),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: widget.cardHeight * 0.119),

                        // Company logo and info
                        Row(
                          children: [
                            Container(
                              width: widget.cardWidth * 0.117,
                              height: widget.cardWidth * 0.105,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: widget.lowongan.logo.isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(
                                          widget.lowongan.logo,
                                        ),
                                        fit: BoxFit.contain,
                                      )
                                    : const DecorationImage(
                                        image: AssetImage("images/poltek.png"),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            SizedBox(width: widget.cardWidth * 0.058),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.lowongan.posisi,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: widget.screenWidth * 0.042,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      height: 1.25,
                                      letterSpacing: -0.24,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    widget.lowongan.namaPerusahaan,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: const Color(0x993C3C43),
                                      fontSize: widget.screenWidth * 0.037,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      height: 1.29,
                                      letterSpacing: -0.08,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: _toggleBookmark,
                              child: ScaleTransition(
                                scale: _bookmarkScale,
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 200),
                                    child: isSaved
                                        ? const Icon(
                                            Icons.bookmark,
                                            key: ValueKey('saved'),
                                            color: Color(0xFF0118D8),
                                            size: 20,
                                          )
                                        : Icon(
                                            Icons.bookmark_border,
                                            key: const ValueKey('unsaved'),
                                            color: Colors.black.withOpacity(
                                              0.3,
                                            ),
                                            size: 20,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: widget.cardHeight * 0.085),

                        // Salary
                        Text(
                          widget.lowongan.gaji,
                          style: TextStyle(
                            color: const Color(0xFF40403F),
                            fontSize: widget.screenWidth * 0.047,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            height: 1.11,
                            letterSpacing: -0.24,
                          ),
                        ),

                        SizedBox(height: widget.cardHeight * 0.068),

                        // Tags
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: widget.cardWidth * 0.035,
                                vertical: widget.cardHeight * 0.017,
                              ),
                              decoration: ShapeDecoration(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    width: 1,
                                    color: Color(0xFFC7C7C7),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                widget.lowongan.lokasi.length > 20
                                    ? '${widget.lowongan.lokasi.substring(0, 20)}...'
                                    : widget.lowongan.lokasi,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: widget.screenWidth * 0.032,
                                  fontFamily: 'SF Pro',
                                  fontWeight: FontWeight.w400,
                                  height: 1.43,
                                  letterSpacing: -0.50,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: widget.cardWidth * 0.035,
                                vertical: widget.cardHeight * 0.017,
                              ),
                              decoration: ShapeDecoration(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    width: 1,
                                    color: Color(0xFFC7C7C7),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                widget.lowongan.jenisPekerjaan,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: widget.screenWidth * 0.032,
                                  fontFamily: 'SF Pro',
                                  fontWeight: FontWeight.w400,
                                  height: 1.43,
                                  letterSpacing: -0.50,
                                ),
                              ),
                            ),
                            if (widget.lowongan.opsiKerjaRemote)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: widget.cardWidth * 0.035,
                                  vertical: widget.cardHeight * 0.017,
                                ),
                                decoration: ShapeDecoration(
                                  color: const Color.fromARGB(255, 255, 255, 255),
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                      width: 1,
                                      color: Color(0xFFC7C7C7),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Remote',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontFamily: 'SF Pro',
                                    fontWeight: FontWeight.w400,
                                    height: 1.43,
                                    letterSpacing: -0.50,
                                  ),
                                ),
                              ),
                          ],
                        ),

                        const Spacer(),

                        // Posted time and number of applicants
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatTimeAgo(widget.lowongan.tanggalPosting),
                              style: TextStyle(
                                color: const Color(0xFF464E5E),
                                fontSize: widget.screenWidth * 0.032,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w400,
                                height: 2,
                              ),
                            ),
                            Text(
                              '${widget.lowongan.jumlahPelamar} pelamar',
                              style: TextStyle(
                                color: const Color(0xFF464E5E),
                                fontSize: widget.screenWidth * 0.032,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w400,
                                height: 2,
                              ),
                            ),
                          ],
                        ),
                      ],
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

  String _formatTimeAgo(DateTime tanggalPosting) {
    final now = DateTime.now();
    final difference = now.difference(tanggalPosting);

    if (difference.inDays == 0) {
      return 'Hari ini';
    } else if (difference.inDays == 1) {
      return '1 hari lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari lalu';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks minggu lalu';
    } else {
      final months = (difference.inDays / 30).floor();
      return '$months bulan lalu';
    }
  }
}

class _CocokUntukKamuCardSkeleton extends StatelessWidget {
  final double cardWidth;
  final double cardHeight;
  final double screenWidth;

  const _CocokUntukKamuCardSkeleton({
    required this.cardWidth,
    required this.cardHeight,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: Stack(
        children: [
          Container(
            width: cardWidth,
            height: cardHeight,
            decoration: ShapeDecoration(
              color: const Color(0xFFF0F4F9),
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: Color(0xFFC7C7C7)),
                borderRadius: BorderRadius.circular(cardWidth * 0.102),
              ),
            ),
          ),

          Container(
            width: cardWidth,
            height: cardHeight,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 3, color: Color(0xFF0118D8)),
                borderRadius: BorderRadius.circular(cardWidth * 0.102),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0xFF9FAAFF),
                  blurRadius: 20,
                  offset: Offset(0, 0),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.all(cardWidth * 0.058),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: cardHeight * 0.05),

                    // Badge skeleton
                    Container(
                      width: cardWidth * 0.4,
                      height: cardHeight * 0.08,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(cardWidth * 0.102),
                          bottomRight: Radius.circular(cardWidth * 0.058),
                        ),
                      ),
                    ),

                    SizedBox(height: cardHeight * 0.045),

                    // Company info skeleton
                    Row(
                      children: [
                        Container(
                          width: cardWidth * 0.117,
                          height: cardWidth * 0.105,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        SizedBox(width: cardWidth * 0.058),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: cardWidth * 0.45,
                                height: 13,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                width: cardWidth * 0.3,
                                height: 11,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: cardHeight * 0.045),

                    // Salary skeleton
                    Container(
                      width: cardWidth * 0.35,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),

                    SizedBox(height: cardHeight * 0.04),

                    // Tags skeleton
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        Container(
                          width: cardWidth * 0.25,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Container(
                          width: cardWidth * 0.18,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: cardHeight * 0.06),

                    // Footer skeleton
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: cardWidth * 0.23,
                          height: 11,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        Container(
                          width: cardWidth * 0.18,
                          height: 11,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ================== BAGIAN LAIN TETAP SAMA ==================

class _JelajahiKesempatanKarierSection extends StatefulWidget {
  final ApiService apiService;
  final List<String> backgroundImages;

  const _JelajahiKesempatanKarierSection({
    required this.apiService,
    required this.backgroundImages,
  });

  @override
  State<_JelajahiKesempatanKarierSection> createState() =>
      __JelajahiKesempatanKarierSectionState();
}

class __JelajahiKesempatanKarierSectionState
    extends State<_JelajahiKesempatanKarierSection> {
  late Future<List<Jobfair>> _jobfairsFuture;

  @override
  void initState() {
    super.initState();
    _jobfairsFuture = widget.apiService.getAllJobfair();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth * 0.9).clamp(300.0, 400.0);
    final cardHeight = cardWidth * 0.91;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Jelajahi Kesempatan Karier',
              style: TextStyle(
                color: Colors.black,
                fontSize: 26,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                height: 1.15,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        FutureBuilder<List<Jobfair>>(
          future: _jobfairsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: cardHeight,
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError) {
              return SizedBox(
                height: cardHeight,
                child: Center(
                  child: Text(
                    'Gagal memuat data jobfair',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return SizedBox(
                height: cardHeight,
                child: Center(
                  child: Text(
                    'Tidak ada jobfair tersedia',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              );
            } else {
              final jobfairs = snapshot.data!;
              return SizedBox(
                height: cardHeight,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(left: screenWidth * 0.05),
                  itemCount: jobfairs.length > 3 ? 3 : jobfairs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(right: screenWidth * 0.04),
                      child: _JobfairCard(
                        jobfair: jobfairs[index],
                        imagePath:
                            widget.backgroundImages[index %
                                widget.backgroundImages.length],
                        cardWidth: cardWidth,
                        cardHeight: cardHeight,
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ],
    );
  }
}

class _JobfairCard extends StatelessWidget {
  final Jobfair jobfair;
  final String imagePath;
  final double cardWidth;
  final double cardHeight;

  const _JobfairCard({
    required this.jobfair,
    required this.imagePath,
    required this.cardWidth,
    required this.cardHeight,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final headerHeight = 66.0;
    final imageHeight = cardHeight - headerHeight;
    final contentPadding = cardWidth * 0.071;

    final now = DateTime.now();
    final diff = jobfair.tanggalMulaiAcara.difference(
      DateTime(now.year, now.month, now.day),
    );
    final daysLeft = diff.inDays;
    final daysText = daysLeft > 0 ? '$daysLeft hari lagi' : 'Berlangsung';

    return GestureDetector(
      onTap: () {
        goTo<int>(context, AppRoutes.jobfairDetail, arguments: jobfair.id);
      },
      child: SizedBox(
        width: cardWidth,
        height: cardHeight,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              child: Container(
                width: cardWidth,
                height: headerHeight,
                padding: EdgeInsets.only(
                  top: headerHeight * 0.21,
                  left: contentPadding,
                  right: contentPadding,
                ),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(cardWidth * 0.1),
                      topRight: Radius.circular(cardWidth * 0.1),
                    ),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            jobfair.namaAcara,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: screenWidth * 0.042,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              height: 1.25,
                            ),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Text(
                          daysText,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth * 0.032,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: headerHeight * 0.08),
                    Text(
                      jobfair.acaraBkk ?? 'Politeknik Negeri Batam',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenWidth * 0.034,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        height: 1.38,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              top: headerHeight,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(cardWidth * 0.1),
                  bottomRight: Radius.circular(cardWidth * 0.1),
                ),
                child: Container(
                  width: cardWidth,
                  height: imageHeight,
                  color: const Color(0xFFE8F0FE),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    cacheWidth: 676,
                    cacheHeight: 472,
                  ),
                ),
              ),
            ),

            Positioned(
              top: headerHeight,
              child: Container(
                width: cardWidth,
                height: imageHeight,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(cardWidth * 0.1),
                    bottomRight: Radius.circular(cardWidth * 0.1),
                  ),
                ),
              ),
            ),

            Positioned(
              left: contentPadding,
              top: headerHeight + 34,
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                      vertical: 4,
                    ),
                    decoration: ShapeDecoration(
                      color: Colors.white.withOpacity(0.08),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1,
                          color: Color(0x66F3F6F9),
                        ),
                        borderRadius: BorderRadius.circular(45),
                      ),
                    ),
                    child: Text(
                      jobfair.jobsText,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.036,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        height: 1.71,
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                      vertical: 4,
                    ),
                    decoration: ShapeDecoration(
                      color: Colors.white.withOpacity(0.08),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1,
                          color: Color(0x66F3F6F9),
                        ),
                        borderRadius: BorderRadius.circular(45),
                      ),
                    ),
                    child: Text(
                      jobfair.companiesText,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.036,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        height: 1.71,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              left: contentPadding,
              right: contentPadding,
              top: headerHeight + 100,
              bottom: 66,
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: screenWidth * 0.04,
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            jobfair.acaraBkk ?? 'Lokasi tidak tersedia',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.036,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              height: 1.29,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                          size: screenWidth * 0.035,
                        ),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            jobfair.formattedDateRange,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.036,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              height: 1.29,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Pendaftaran : ${DateFormat('dd MMM yyyy').format(jobfair.tanggalAwalPendaftaranAcara)} - ${DateFormat('dd MMM yyyy').format(jobfair.tanggalAkhirPendaftaranAcara)}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.034,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              left: contentPadding,
              right: contentPadding,
              bottom: 14,
              child: Container(
                height: 40,
                decoration: ShapeDecoration(
                  color: Colors.white.withOpacity(0.08),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0x66F3F6F9)),
                    borderRadius: BorderRadius.circular(45),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Lihat Detail',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.034,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      height: 1.85,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TemuiMerekaDanKesempatanSegeraSection extends StatelessWidget {
  final Future<List<CompanyLogo>> companyLogosFuture;
  final Future<List<LokerUmum>> urgentJobsFuture;
  final List<String> savedJobIds;
  final Function(LokerUmum) onJobTap;
  final Function(String, bool) onBookmarkToggle;
  final bool isLoadingUrgentJobs;
  final bool isLoadingSavedJobs;

  const _TemuiMerekaDanKesempatanSegeraSection({
    required this.companyLogosFuture,
    required this.urgentJobsFuture,
    required this.savedJobIds,
    required this.onJobTap,
    required this.onBookmarkToggle,
    required this.isLoadingUrgentJobs,
    required this.isLoadingSavedJobs,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CompanyLogo>>(
      future: companyLogosFuture,
      builder: (context, snapshot) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 31, bottom: 60),
          decoration: const BoxDecoration(color: Color(0xFFFAFAFA)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 23),
                child: Text(
                  'Temui Mereka',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 26,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    height: 1.15,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Container untuk logo perusahaan
              Container(
                height: 113,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(34),
                  ),
                ),
                child: _buildCompanyLogos(snapshot),
              ),

              const SizedBox(height: 40),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 23),
                child: Text(
                  'Dibutuhkan Segera!',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    height: 1.75,
                    letterSpacing: 0.35,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // FutureBuilder untuk urgent jobs
              FutureBuilder<List<LokerUmum>>(
                future: urgentJobsFuture,
                builder: (context, snapshot) {
                  if (isLoadingUrgentJobs) {
                    return _buildUrgentJobsLoading();
                  } else if (snapshot.hasError) {
                    return _buildUrgentJobsError();
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return _buildUrgentJobsEmpty();
                  } else {
                    final urgentJobs = snapshot.data!;
                    return _buildUrgentJobsList(urgentJobs);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUrgentJobsLoading() {
    return const Column(
      children: [
        _UrgentJobCardSkeleton(),
        SizedBox(height: 15),
        _UrgentJobCardSkeleton(),
        SizedBox(height: 15),
        _UrgentJobCardSkeleton(),
      ],
    );
  }

  Widget _buildUrgentJobsError() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        border: Border.all(color: const Color(0xFFC7C7C7)),
      ),
      child: const Center(
        child: Text(
          'Gagal memuat lowongan',
          style: TextStyle(color: Colors.red, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildUrgentJobsEmpty() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        border: Border.all(color: const Color(0xFFC7C7C7)),
      ),
      child: const Center(
        child: Text(
          'Tidak ada lowongan mendesak',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildUrgentJobsList(List<LokerUmum> urgentJobs) {
    return Column(
      children: urgentJobs.map((job) {
        final daysLeft = _calculateDaysLeft(job.batasLamaran);
        final isUrgent = daysLeft <= 10 && daysLeft >= 0;
        final isSaved = savedJobIds.contains(job.lowonganId);

        return Padding(
          padding: EdgeInsets.only(bottom: urgentJobs.last == job ? 0 : 15),
          child: _UrgentJobCard(
            lowongan: job,
            daysLeft: daysLeft,
            isUrgent: isUrgent,
            isSaved: isSaved,
            onTap: () => onJobTap(job),
            onBookmarkToggle: onBookmarkToggle,
          ),
        );
      }).toList(),
    );
  }

  int _calculateDaysLeft(DateTime batasLamaran) {
    final now = DateTime.now();
    final difference = batasLamaran.difference(now);
    return difference.inDays;
  }

  Widget _buildCompanyLogos(AsyncSnapshot<List<CompanyLogo>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError) {
      return Center(
        child: Text(
          'Gagal memuat logo',
          style: TextStyle(color: Colors.red, fontSize: 14),
        ),
      );
    }

    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return Center(
        child: Text(
          'Tidak ada logo tersedia',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      );
    }

    final companyLogos = snapshot.data!;
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
      itemCount: companyLogos.length,
      itemExtent: 97,
      itemBuilder: (context, index) {
        return _CompanyLogoItem(companyLogo: companyLogos[index]);
      },
    );
  }
}

class _CompanyLogoItem extends StatelessWidget {
  final CompanyLogo companyLogo;

  const _CompanyLogoItem({required this.companyLogo});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 62,
      height: 56,
      margin: const EdgeInsets.only(right: 35),
      child: _buildLogoImage(),
    );
  }

  Widget _buildLogoImage() {
    return Image.network(
      companyLogo.logoUrl,
      fit: BoxFit.contain,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: 62,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFFF0F4F9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 62,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFFF0F4F9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              _getInitials(companyLogo.companyName),
              style: const TextStyle(
                color: Color(0xFF0118D8),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  String _getInitials(String companyName) {
    if (companyName.isEmpty) return '??';

    final parts = companyName.split(' ');
    if (parts.length >= 2) {
      return '${parts[0].substring(0, 1)}${parts[1].substring(0, 1)}'
          .toUpperCase();
    }

    return companyName.length >= 2
        ? companyName.substring(0, 2).toUpperCase()
        : companyName.toUpperCase();
  }
}

class _UrgentJobCard extends StatefulWidget {
  final LokerUmum lowongan;
  final int daysLeft;
  final bool isUrgent;
  final bool isSaved;
  final VoidCallback onTap;
  final Function(String, bool) onBookmarkToggle;

  const _UrgentJobCard({
    required this.lowongan,
    required this.daysLeft,
    required this.isUrgent,
    required this.isSaved,
    required this.onTap,
    required this.onBookmarkToggle,
  });

  @override
  State<_UrgentJobCard> createState() => _UrgentJobCardState();
}

class _UrgentJobCardState extends State<_UrgentJobCard>
    with SingleTickerProviderStateMixin {
  late bool isSaved;
  late AnimationController _bookmarkController;
  late Animation<double> _bookmarkScale;

  @override
  void initState() {
    super.initState();
    isSaved = widget.isSaved;
    _bookmarkController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _bookmarkScale = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _bookmarkController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _bookmarkController.dispose();
    super.dispose();
  }

  void _toggleBookmark() {
    setState(() {
      isSaved = !isSaved;
    });
    _bookmarkController.forward().then((_) {
      _bookmarkController.reverse();
    });
    widget.onBookmarkToggle(widget.lowongan.lowonganId, !isSaved);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Stack(
          children: [
            // Background shadow
            Container(
              width: double.infinity,
              height: 235,
              decoration: ShapeDecoration(
                color: const Color(0xFFF0F4F9),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color(0xFFC7C7C7)),
                  borderRadius: BorderRadius.circular(35),
                ),
              ),
            ),

            // Main card
            Container(
              width: double.infinity,
              height: 235,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color(0xFFC7C7C7)),
                  borderRadius: BorderRadius.circular(35),
                ),
              ),
              child: Stack(
                children: [
                  // Badge urgent (hanya jika urgent)
                  if (widget.isUrgent)
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width: 130,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: Color(0xFF0E37EB),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(35),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.bolt,
                              color: Color(0xFFFFCC00),
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.daysLeft == 0
                                  ? 'Hari terakhir!'
                                  : '${widget.daysLeft} hari lagi',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 28),

                        // Company logo and info
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(8),
                                image: widget.lowongan.logo.isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(
                                          widget.lowongan.logo,
                                        ),
                                        fit: BoxFit.contain,
                                      )
                                    : const DecorationImage(
                                        image: AssetImage("images/poltek.png"),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: SizedBox(
                                height: 48,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 0,
                                      top: 0,
                                      child: Text(
                                        widget.lowongan.posisi,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          height: 1.25,
                                          letterSpacing: -0.24,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 0,
                                      top: 24,
                                      child: Text(
                                        widget.lowongan.namaPerusahaan,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: const Color(0x993C3C43),
                                          fontSize: 14,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                          height: 1.29,
                                          letterSpacing: -0.08,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: _toggleBookmark,
                              child: ScaleTransition(
                                scale: _bookmarkScale,
                                child: SizedBox(
                                  width: 32,
                                  height: 32,
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 200),
                                    child: isSaved
                                        ? const Icon(
                                            Icons.bookmark,
                                            key: ValueKey('saved'),
                                            color: Color(0xFF0118D8),
                                            size: 24,
                                          )
                                        : Icon(
                                            Icons.bookmark_border,
                                            key: const ValueKey('unsaved'),
                                            color: Colors.black.withOpacity(
                                              0.3,
                                            ),
                                            size: 24,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Salary
                        Text(
                          widget.lowongan.gaji,
                          style: const TextStyle(
                            color: Color(0xFF40403F),
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            height: 1.11,
                            letterSpacing: -0.24,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Location and job type tags
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: ShapeDecoration(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    width: 1,
                                    color: Color(0xFFC7C7C7),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                widget.lowongan.lokasi.length > 20
                                    ? '${widget.lowongan.lokasi.substring(0, 20)}...'
                                    : widget.lowongan.lokasi,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: 'SF Pro',
                                  fontWeight: FontWeight.w400,
                                  height: 1.43,
                                  letterSpacing: -0.50,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: ShapeDecoration(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    width: 1,
                                    color: Color(0xFFC7C7C7),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                widget.lowongan.jenisPekerjaan,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: 'SF Pro',
                                  fontWeight: FontWeight.w400,
                                  height: 1.43,
                                  letterSpacing: -0.50,
                                ),
                              ),
                            ),
                            if (widget.lowongan.opsiKerjaRemote)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: ShapeDecoration(
                                  color: const Color.fromARGB(
                                    255,
                                    255,
                                    255,
                                    255,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                      width: 1,
                                      color: Color(0xFFC7C7C7),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Remote',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontFamily: 'SF Pro',
                                    fontWeight: FontWeight.w400,
                                    height: 1.43,
                                    letterSpacing: -0.50,
                                  ),
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Posted time and number of applicants
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatTimeAgo(widget.lowongan.tanggalPosting),
                              style: const TextStyle(
                                color: Color(0xFF464E5E),
                                fontSize: 12,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w400,
                                height: 2,
                              ),
                            ),
                            Text(
                              '${widget.lowongan.jumlahPelamar} pelamar',
                              style: const TextStyle(
                                color: const Color(0xFF464E5E),
                                fontSize: 12,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w400,
                                height: 2,
                              ),
                            ),
                          ],
                        ),
                      ],
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

  // Method untuk format time ago
  String _formatTimeAgo(DateTime tanggalPosting) {
    final now = DateTime.now();
    final difference = now.difference(tanggalPosting);

    if (difference.inDays == 0) {
      return 'Hari ini';
    } else if (difference.inDays == 1) {
      return '1 hari lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari lalu';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks minggu lalu';
    } else {
      final months = (difference.inDays / 30).floor();
      return '$months bulan lalu';
    }
  }
}

// Skeleton untuk urgent jobs loading
class _UrgentJobCardSkeleton extends StatelessWidget {
  const _UrgentJobCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: [
          // Background shadow
          Container(
            width: double.infinity,
            height: 235,
            decoration: ShapeDecoration(
              color: const Color(0xFFF0F4F9),
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: Color(0xFFC7C7C7)),
                borderRadius: BorderRadius.circular(35),
              ),
            ),
          ),

          // Main card skeleton
          Container(
            width: double.infinity,
            height: 235,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: Color(0xFFC7C7C7)),
                borderRadius: BorderRadius.circular(35),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 120,
                              height: 16,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              width: 80,
                              height: 14,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 100,
                    height: 18,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 50,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 60,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Container(
                        width: 50,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
