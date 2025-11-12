import 'package:flutter/material.dart';
import 'package:jobfair/widget/bottom_navbar.dart';
import 'package:jobfair/widget/header.dart';
import 'detail_job_sheet.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  @override
  void initState() {
    super.initState();
    _loadLowongan();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _selectedTab.dispose();
    _currentPage.dispose();
    super.dispose();
  }

  Future<void> _loadLowongan() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final lowongan = await _apiService.getAllLokerUmum();
      setState(() {
        _allLowongan = lowongan;
        _filteredLowongan = lowongan;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      print("Error loading lowongan: $e");
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

  // Fungsi untuk menghitung sisa hari hingga batas lamaran
  int _calculateDaysLeft(DateTime batasLamaran) {
    final now = DateTime.now();
    final difference = batasLamaran.difference(now);
    return difference.inDays;
  }

  // Fungsi untuk format tanggal menjadi "X hari lalu"
  String _formatTimeAgo(DateTime tanggalPosting) {
    final now = DateTime.now();
    final difference = now.difference(tanggalPosting);

    if (difference.inDays > 0) {
      return '${difference.inDays} hari lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit lalu';
    } else {
      return 'Baru saja';
    }
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
                        onRefresh: _loadLowongan,
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
                                _LowonganList(lowonganList: _filteredLowongan),
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
            onPressed: _loadLowongan,
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

  const _LowonganList({required this.lowonganList});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: lowonganList.map((lowongan) {
          final daysLeft = _calculateDaysLeft(lowongan.batasLamaran);
          final isUrgent = daysLeft <= 10 && daysLeft >= 0;

          return Column(
            children: [
              _JobCard(
                lowongan: lowongan,
                isUrgent: isUrgent,
                daysLeft: daysLeft,
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

// ✅ Job Card dengan style persis seperti di beranda
class _JobCard extends StatefulWidget {
  final LokerUmum lowongan;
  final bool isUrgent;
  final int daysLeft;

  const _JobCard({
    required this.lowongan,
    required this.isUrgent,
    required this.daysLeft,
  });

  @override
  State<_JobCard> createState() => __JobCardState();
}

class __JobCardState extends State<_JobCard> with SingleTickerProviderStateMixin {
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        height: 306, // ✅ Height sama seperti beranda
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(34),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8, // ✅ Blur radius sama seperti beranda
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // ✅ Urgent badge persis seperti beranda
            if (widget.isUrgent) ...[
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 145, // ✅ Width sama seperti beranda
                  height: 29, // ✅ Height sama seperti beranda
                  decoration: const BoxDecoration(
                    color: Color(0xFF0E37EB), // ✅ Warna sama seperti beranda
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(34),
                      bottomRight: Radius.circular(90),
                    ),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      const Icon(Icons.bolt, color: Color(0xFFFFCC00), size: 18), // ✅ Icon sama seperti beranda
                      const SizedBox(width: 4),
                      Text(
                        widget.daysLeft == 0 
                            ? 'Hari terakhir!' 
                            : 'Sisa ${widget.daysLeft} hari',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            // ✅ Company logo persis seperti beranda
            Positioned(
              left: 16,
              top: 47,
              child: Container(
                width: 40, // ✅ Width sama seperti beranda
                height: 36, // ✅ Height sama seperti beranda
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC), // ✅ Warna background sama seperti beranda
                ),
                child: widget.lowongan.logo.isNotEmpty
                    ? ClipRRect(
                        child: Image.network(
                          widget.lowongan.logo,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/icons/poltek.png', // ✅ Fallback image sama seperti beranda
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
            ),

            // ✅ Job title and company persis seperti beranda
            Positioned(
              left: 66,
              top: 47,
              right: 66,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.lowongan.posisi,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.lowongan.namaPerusahaan,
                    style: const TextStyle(
                      color: Color(0x993C3C43), // ✅ Warna sama seperti beranda
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            // ✅ Bookmark icon with animation persis seperti beranda
            Positioned(
              right: 16,
              top: 47,
              child: GestureDetector(
                onTap: _toggleBookmark,
                child: ScaleTransition(
                  scale: _bookmarkScale,
                  child: SizedBox(
                    width: 32,
                    height: 32,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(
                          scale: animation,
                          child: child,
                        );
                      },
                      child: isSaved
                          ? const Icon(
                              Icons.bookmark,
                              key: ValueKey('saved'),
                              color: Color(0xFF0E37EB), // ✅ Warna saved sama seperti beranda
                              size: 28,
                            )
                          : Icon(
                              Icons.bookmark_border,
                              key: const ValueKey('unsaved'),
                              color: Colors.black.withValues(alpha: 0.5), // ✅ Warna unsaved sama seperti beranda
                              size: 28,
                            ),
                    ),
                  ),
                ),
              ),
            ),

            // ✅ Description persis seperti beranda
            Positioned(
              left: 16,
              top: 125,
              right: 16,
              child: _buildDescription(),
            ),

            // ✅ Salary persis seperti beranda
            Positioned(
              left: 16,
              top: 172,
              child: _buildSalary(),
            ),

            // ✅ Tags persis seperti beranda
            Positioned(
              left: 16,
              top: 210,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24), // ✅ Border radius sama seperti beranda
                      border: Border.all(color: Colors.black.withValues(alpha: 0.06)), // ✅ Border color sama seperti beranda
                    ),
                    child: Text(
                      widget.lowongan.lokasi.length > 25 
                          ? '${widget.lowongan.lokasi.substring(0, 25)}...' 
                          : widget.lowongan.lokasi,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'SF Pro', // ✅ Font family sama seperti beranda
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  if (widget.lowongan.opsiKerjaRemote) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
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
            ),

            // ✅ Time ago persis seperti beranda
            Positioned(
              right: 16,
              bottom: 18,
              child: Text(
                _formatTimeAgo(widget.lowongan.tanggalPosting),
                style: const TextStyle(
                  color: Color(0xFF464E5E), // ✅ Warna sama seperti beranda
                  fontSize: 12,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription() {
    // Remove HTML tags for display
    final cleanDescription = widget.lowongan.deskripsiPekerjaan
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .trim();

    return Text(
      cleanDescription.isNotEmpty 
          ? (cleanDescription.length > 60 
              ? '${cleanDescription.substring(0, 60)}...' 
              : cleanDescription)
          : 'Tidak ada deskripsi',
      style: const TextStyle(
        color: Color(0xFF404040), // ✅ Warna sama seperti beranda
        fontSize: 14,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w300,
        height: 1.5, // ✅ Line height sama seperti beranda
      ),
    );
  }

  Widget _buildSalary() {
    return Text.rich(
      TextSpan(
        children: [
          const TextSpan(
            text: 'Rp',
            style: TextStyle(
              color: Color(0xFF40403F), // ✅ Warna sama seperti beranda
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
            text: ' ${_extractSalaryRange(widget.lowongan.gaji)}',
            style: const TextStyle(
              color: Color(0xFF40403F),
              fontSize: 18, // ✅ Font size besar sama seperti beranda
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _extractSalaryRange(String gaji) {
    // Format: "Rp 8.000.000 - Rp 9.000.000"
    // Kita ambil bagian setelah "Rp " sampai akhir
    if (gaji.startsWith('Rp')) {
      return gaji.substring(3); // Hapus "Rp "
    }
    return gaji;
  }
String _formatTimeAgo(DateTime tanggalPosting) {
  final now = DateTime.now();
  final difference = now.difference(tanggalPosting);
  
  if (difference.inDays == 0) {
    return 'Hari ini';
  } else if (difference.inDays == 1) {
    return '1 hari lalu';
  } else {
    return '${difference.inDays} hari lalu';
  }
}
}

// Skeleton loading state
class _JobCardSkeleton extends StatelessWidget {
  const _JobCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 320,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(34),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 16,
            top: 47,
            child: SizedBox(
              width: 40,
              height: 36,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          Positioned(
            left: 66,
            top: 47,
            right: 50,
            child: SizedBox(
              height: 16,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          Positioned(
            left: 66,
            top: 71,
            width: 100,
            child: SizedBox(
              height: 14,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
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
