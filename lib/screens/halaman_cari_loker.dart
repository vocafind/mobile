import 'package:flutter/material.dart';
import 'package:jobfair/widget/bottom_navbar.dart';
import 'package:jobfair/widget/header.dart';
import 'detail_job_sheet.dart';
import 'package:jobfair/api/api_service.dart';
import 'package:jobfair/models/loker_umum_model.dart';

class HalamanCariLoker extends StatefulWidget {
  const HalamanCariLoker({super.key});

  @override
  State<HalamanCariLoker> createState() => _HalamanCariLokerState();
}

class _HalamanCariLokerState extends State<HalamanCariLoker> {
  final ScrollController _scrollController = ScrollController();
  final ApiService _apiService = ApiService();

  // ✅ ValueNotifier untuk state management efisien
  final ValueNotifier<int> _selectedTab = ValueNotifier<int>(0);
  final ValueNotifier<int> _currentPage = ValueNotifier<int>(0);

  // Data lowongan
  List<LokerUmum> _allLowongan = [];
  List<LokerUmum> _filteredLowongan = [];
  bool _isLoading = true;
  bool _hasError = false;
  List<String> _appliedJobIds = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _selectedTab.dispose();
    _currentPage.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // Load lowongan dan data lamaran secara bersamaan dengan type annotation
      final results = await Future.wait<dynamic>([
        _apiService.getAllLokerUmum(),
        _apiService.getLowonganSudahDilamar(),
      ]);

      // Cast ke tipe yang benar
      final lowongan = results[0] as List<LokerUmum>;
      final appliedIds = results[1] as List<String>;

      setState(() {
        _allLowongan = lowongan;
        _filteredLowongan = lowongan;
        _appliedJobIds = appliedIds;
        _isLoading = false;
      });

      print(
        "✅ Data loaded: ${lowongan.length} lowongan, ${appliedIds.length} sudah dilamar",
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      print("❌ Error loading data: $e");
    }
  }

  void _onTabChanged(int index) {
    _selectedTab.value = index;
    _currentPage.value = 0;

    // Filter data berdasarkan tab
    if (index == 0) {
      // Semua lowongan
      setState(() {
        _filteredLowongan = _allLowongan;
      });
    } else {
      // Rekomendasi AI - untuk sekarang tampilkan semua juga
      setState(() {
        _filteredLowongan = _allLowongan;
      });
    }
  }

  // ✅ Fungsi untuk membuka detail lowongan
  Future<void> _showJobDetail(LokerUmum lowongan) async {
    try {
      // Tampilkan loading terlebih dahulu
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Ambil data detail dari API
      final detailLowongan = await _apiService.getLokerUmumDetailById(
        lowongan.lowonganId,
      );

      // Tutup loading
      if (mounted) Navigator.of(context).pop();

      // Tampilkan bottom sheet dengan data detail
      if (mounted) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => JobDetailSheet(loker: detailLowongan),
        ).then((shouldRefresh) {
          // Handle refresh setelah melamar
          if (shouldRefresh == true) {
            _loadData(); // Refresh data
          }
        });
      }
    } catch (e) {
      // Tutup loading jika error
      if (mounted) Navigator.of(context).pop();

      // Tampilkan error
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

  // Fungsi untuk menghitung sisa hari hingga batas lamaran
  int _calculateDaysLeft(DateTime batasLamaran) {
    final now = DateTime.now();
    final difference = batasLamaran.difference(now);
    return difference.inDays;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fullip.jpg'),
            fit: BoxFit.cover,
            alignment: Alignment(0, -0.9),
          ),
        ),
        child: Column(
          children: [
            // Fixed Header
            const HeaderWidget(showNotification: true, showFilter: false),

            // ✅ Fixed Filter Tabs dengan ValueListenableBuilder
            ValueListenableBuilder<int>(
              valueListenable: _selectedTab,
              builder: (context, selectedTab, child) {
                return _FilterTabs(
                  selectedTab: selectedTab,
                  onTabChanged: _onTabChanged,
                );
              },
            ),

            // ✅ Main content dengan ValueListenableBuilder
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFAFA).withValues(alpha: 0.95),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(37),
                    topRight: Radius.circular(37),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(37),
                    topRight: Radius.circular(37),
                  ),
                  child: ValueListenableBuilder<int>(
                    valueListenable: _selectedTab,
                    builder: (context, selectedTab, child) {
                      return RefreshIndicator(
                        onRefresh: _loadData,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            children: [
                              const SizedBox(height: 17),
                              if (_isLoading)
                                _buildLoadingState()
                              else if (_hasError)
                                _buildErrorState()
                              else if (_filteredLowongan.isEmpty)
                                _buildEmptyState()
                              else
                                _LowonganList(
                                  lowonganList: _filteredLowongan,
                                  appliedJobIds: _appliedJobIds,
                                  onItemTap: _showJobDetail,
                                ),
                              const SizedBox(height: 24),
                              ValueListenableBuilder<int>(
                                valueListenable: _currentPage,
                                builder: (context, currentPage, child) {
                                  return EnhancedPagination(
                                    currentPage: currentPage,
                                    totalPages: 4,
                                    onPageChanged: (page) {
                                      _currentPage.value = page;
                                      _scrollController.animateTo(
                                        0,
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        curve: Curves.easeOut,
                                      );
                                    },
                                  );
                                },
                              ),
                              const SizedBox(height: 100),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }

  Widget _buildLoadingState() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _JobCardSkeleton(),
          SizedBox(height: 16),
          _JobCardSkeleton(),
          SizedBox(height: 16),
          _JobCardSkeleton(),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      padding: const EdgeInsets.all(40),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline, size: 60, color: Color(0xFFDC2626)),
          const SizedBox(height: 16),
          const Text(
            'Gagal memuat data',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              color: Color(0xFF515151),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _loadData,
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
    return Container(
      padding: const EdgeInsets.all(40),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        children: [
          Icon(Icons.work_outline, size: 60, color: Color(0xFFB8B8B8)),
          SizedBox(height: 16),
          Text(
            'Belum ada lowongan',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              color: Color(0xFF515151),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Coba lagi nanti',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins',
              color: Color(0xFFB8B8B8),
            ),
          ),
        ],
      ),
    );
  }
}

// ✅ Extract Filter Tabs sebagai StatelessWidget
class _FilterTabs extends StatelessWidget {
  final int selectedTab;
  final Function(int) onTabChanged;

  const _FilterTabs({required this.selectedTab, required this.onTabChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xFF162781).withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 6),
                  // ✅ Semua tab
                  _TabButton(
                    label: 'Semua',
                    isSelected: selectedTab == 0,
                    onTap: () => onTabChanged(0),
                    width: 136,
                  ),
                  const SizedBox(width: 10),
                  // ✅ Rekomendasi AI tab
                  _TabButton(
                    label: 'Rekomendasi AI',
                    isSelected: selectedTab == 1,
                    onTap: () => onTabChanged(1),
                    isFlexible: true,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 5),
          // Filter button
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: const Color(0xFF162781).withValues(alpha: 0.9),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.tune, color: Colors.white, size: 18),
          ),
        ],
      ),
    );
  }
}

// ✅ Extract Tab Button untuk reusability
class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final double? width;
  final bool isFlexible;

  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.width,
    this.isFlexible = false,
  });

  @override
  Widget build(BuildContext context) {
    final widget = GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: width,
        height: 35,
        padding: isFlexible ? const EdgeInsets.symmetric(horizontal: 16) : null,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF2345F7).withValues(alpha: 0.7)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );

    return isFlexible ? Expanded(child: widget) : widget;
  }
}

// ✅ Extract Lowongan List dengan data real
class _LowonganList extends StatelessWidget {
  final List<LokerUmum> lowonganList;
  final List<String> appliedJobIds;
  final Function(LokerUmum) onItemTap;

  const _LowonganList({
    required this.lowonganList,
    required this.appliedJobIds,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: lowonganList.map((lowongan) {
          final daysLeft = _calculateDaysLeft(lowongan.batasLamaran);
          final isUrgent = daysLeft <= 10 && daysLeft >= 0;
          final isApplied = appliedJobIds.contains(lowongan.lowonganId);

          return Column(
            children: [
              _JobCard(
                lowongan: lowongan,
                isUrgent: isUrgent,
                daysLeft: daysLeft,
                isApplied: isApplied,
                onTap: () => onItemTap(lowongan),
              ),
              const SizedBox(height: 16),
            ],
          );
        }).toList(),
      ),
    );
  }

  static int _calculateDaysLeft(DateTime batasLamaran) {
    final now = DateTime.now();
    final difference = batasLamaran.difference(now);
    return difference.inDays;
  }
}

// ✅ Job Card yang SIMPLE - TANPA DESKRIPSI dengan layout fixed
class _JobCard extends StatefulWidget {
  final LokerUmum lowongan;
  final bool isUrgent;
  final int daysLeft;
  final bool isApplied;
  final VoidCallback onTap;

  const _JobCard({
    required this.lowongan,
    required this.isUrgent,
    required this.daysLeft,
    required this.isApplied,
    required this.onTap,
  });

  @override
  State<_JobCard> createState() => __JobCardState();
}

class __JobCardState extends State<_JobCard>
    with SingleTickerProviderStateMixin {
  bool isSaved = false;
  late AnimationController _bookmarkController;
  late Animation<double> _bookmarkScale;

  @override
  void initState() {
    super.initState();
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
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: double.infinity,
        height: 220, // ✅ Sedikit lebih tinggi untuk menghindari overlap
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // ✅ Sudah dilamar badge - DI ATAS SEMUA
            if (widget.isApplied)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 130,
                  height: 28, // ✅ Sedikit lebih tinggi
                  decoration: const BoxDecoration(
                    color: Color(0xFF4CAF50),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'Sudah dilamar',
                        style: TextStyle(
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

            // ✅ Urgent badge (hanya tampil jika belum dilamar) - DI ATAS SEMUA
            if (widget.isUrgent && !widget.isApplied)
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 130,
                  height: 28, // ✅ Sedikit lebih tinggi
                  decoration: const BoxDecoration(
                    color: Color(0xFF0E37EB),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.bolt, color: Color(0xFFFFCC00), size: 14),
                      const SizedBox(width: 4),
                      Text(
                        widget.daysLeft == 0
                            ? 'Hari terakhir!'
                            : '${widget.daysLeft}h',
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

            // ✅ Main Content dengan padding yang disesuaikan
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 40, 16, 16), // ✅ Top padding lebih besar untuk badge
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ Header Row (Company logo, title, bookmark)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Company Logo
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: widget.lowongan.logo.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  widget.lowongan.logo,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/icons/poltek.png',
                                      fit: BoxFit.contain,
                                    );
                                  },
                                ),
                              )
                            : Image.asset(
                                'assets/icons/poltek.png',
                                fit: BoxFit.contain,
                              ),
                      ),
                      const SizedBox(width: 12),
                      
                      // Job Title & Company - DIBERI BATAS MAX WIDTH
                      Expanded(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 200, // ✅ Batas maksimal width
                          ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.lowongan.posisi,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.lowongan.namaPerusahaan,
                              style: const TextStyle(
                                color: Color(0xFF666666),
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        ),
                      ),
                      
                      // Bookmark
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
                                      color: Color(0xFF0E37EB),
                                      size: 24,
                                    )
                                  : Icon(
                                      Icons.bookmark_border,
                                      key: const ValueKey('unsaved'),
                                      color: Colors.black.withOpacity(0.3),
                                      size: 24,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // ✅ Salary
                  Text(
                    _formatSalary(widget.lowongan.gaji),
                    style: const TextStyle(
                      color: Color(0xFF1B56FD),
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ✅ Tags Row - DIBAWAH SALARY
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      // Location
                      _buildTag(
                        icon: Icons.location_on,
                        text: widget.lowongan.lokasi,
                      ),
                      
                      // Job Type
                      _buildTag(
                        icon: Icons.work_outline,
                        text: widget.lowongan.jenisPekerjaan,
                      ),
                      
                      // Remote badge jika ada
                      if (widget.lowongan.opsiKerjaRemote)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Remote',
                            style: TextStyle(
                              color: Color(0xFF2E7D32),
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // // ✅ Experience & Contract - DIBAWAH TAGS
                  // Wrap(
                  //   spacing: 8,
                  //   runSpacing: 8,
                  //   children: [
                  //     Container(
                  //       padding: const EdgeInsets.symmetric(
                  //         horizontal: 8,
                  //         vertical: 4,
                  //       ),
                  //       decoration: BoxDecoration(
                  //         color: const Color(0xFFFFF8E1),
                  //         borderRadius: BorderRadius.circular(12),
                  //       ),
                  //       child: Text(
                  //         widget.lowongan.tingkatPengalaman,
                  //         style: const TextStyle(
                  //           color: Color(0xFFF57C00),
                  //           fontSize: 10,
                  //           fontFamily: 'Poppins',
                  //           fontWeight: FontWeight.w500,
                  //         ),
                  //       ),
                  //     ),
                  //     Container(
                  //       padding: const EdgeInsets.symmetric(
                  //         horizontal: 8,
                  //         vertical: 4,
                  //       ),
                  //       decoration: BoxDecoration(
                  //         color: const Color(0xFFE8F0FE),
                  //         borderRadius: BorderRadius.circular(12),
                  //       ),
                  //       child: Text(
                  //         widget.lowongan.kontrakDurasi,
                  //         style: const TextStyle(
                  //           color: Color(0xFF1B56FD),
                  //           fontSize: 10,
                  //           fontFamily: 'Poppins',
                  //           fontWeight: FontWeight.w500,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  const Spacer(),

                  // ✅ Footer (Posted time) - DI BAWAH
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatTimeAgo(widget.lowongan.tanggalPosting),
                        style: const TextStyle(
                          color: Color(0xFF999999),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      
                      // Applicants count
                      Text(
                        '${widget.lowongan.jumlahPelamar} pelamar',
                        style: const TextStyle(
                          color: Color(0xFF999999),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
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
    );
  }

  Widget _buildTag({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.grey.shade600),
          const SizedBox(width: 4),
          Text(
            text.length > 12 ? '${text.substring(0, 12)}...' : text, // ✅ Lebih pendek
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  String _formatSalary(String gaji) {
    if (gaji.startsWith('Rp')) {
      return gaji;
    }
    return 'Rp $gaji';
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

// ✅ Skeleton loading yang disesuaikan
class _JobCardSkeleton extends StatelessWidget {
  const _JobCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 220, // ✅ Disesuaikan dengan tinggi baru
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 40, 16, 16), // ✅ Padding sama dengan card asli
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header skeleton
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 12),
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
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Salary skeleton
            Container(
              width: 100,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 12),
            // Tags skeleton
            Row(
              children: [
                Container(
                  width: 60,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 50,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Experience skeleton
            Row(
              children: [
                Container(
                  width: 70,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 60,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
            const Spacer(),
            // Footer skeleton
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
    );
  }
}

// ✅ Optimized Pagination
class EnhancedPagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;

  const EnhancedPagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(totalPages, (index) {
          final isActive = currentPage == index;
          double size = 8;

          if (isActive) {
            size = 10;
          } else if (index == currentPage - 1 || index == currentPage + 1) {
            size = 8;
          } else {
            size = 6;
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () => onPageChanged(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFF1E40AF)
                      : const Color(0xFFD1D5DB),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}