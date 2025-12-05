import 'package:flutter/material.dart';
import 'package:jobfair/api/api_service.dart';
import 'package:jobfair/models/loker_umum_model.dart';
import 'package:jobfair/models/saved_job_model.dart';
import 'detail_job_sheet.dart';

class HalamanBookmark extends StatefulWidget {
  const HalamanBookmark({super.key});

  @override
  State<HalamanBookmark> createState() => _HalamanBookmarkState();
}

class _HalamanBookmarkState extends State<HalamanBookmark> {
  final ApiService _apiService = ApiService();
  List<SavedJob> _savedJobs = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadSavedJobs();
  }

  Future<void> _loadSavedJobs() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final savedJobs = await _apiService.getSavedJobs();
      
      setState(() {
        _savedJobs = savedJobs;
        _isLoading = false;
      });
      
      print("✅ Loaded ${savedJobs.length} saved jobs");
    } catch (e) {
      print("❌ Error loading saved jobs: $e");
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  Future<void> _unsaveJob(String savedJobId) async {
    try {
      await _apiService.unsaveJob(savedJobId);
      
      // Hapus dari list lokal
      setState(() {
        _savedJobs.removeWhere((job) => job.savedJobId == savedJobId);
      });
      
      print("✅ Job unsaved: $savedJobId");
      
      // Tampilkan snackbar feedback
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lowongan dihapus dari bookmark'),
          duration: Duration(seconds: 1),
          backgroundColor: Color(0xFF0118D8),
        ),
      );
    } catch (e) {
      print("❌ Error unsaving job: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus bookmark: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
            _loadSavedJobs();
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

  int _calculateDaysLeft(DateTime batasLamaran) {
    final now = DateTime.now();
    final difference = batasLamaran.difference(now);
    return difference.inDays;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFF0F4F9),
        child: Column(
          children: [
            // Header with gradient
            Container(
              height: 108,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF1B56FD), Color(0xFF0118D8)],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 21),
                  child: Row(
                    children: [
                      // Back button
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: 18),
                      const Text(
                        'Lowongan Tersimpan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Main Content
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(37),
                    topRight: Radius.circular(37),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(37),
                    topRight: Radius.circular(37),
                  ),
                  child: RefreshIndicator(
                    onRefresh: _loadSavedJobs,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          const SizedBox(height: 17),
                          if (_isLoading)
                            _buildLoadingState()
                          else if (_hasError)
                            _buildErrorState()
                          else if (_savedJobs.isEmpty)
                            _buildEmptyState()
                          else
                            _buildJobList(),
                          const SizedBox(height: 24),
                        ],
                      ),
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

  Widget _buildLoadingState() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _JobCardSkeleton(),
          SizedBox(height: 15),
          _JobCardSkeleton(),
          SizedBox(height: 15),
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
            onPressed: _loadSavedJobs,
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
          Icon(Icons.bookmark_border, size: 60, color: Color(0xFFB8B8B8)),
          SizedBox(height: 16),
          Text(
            'Belum ada lowongan tersimpan',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              color: Color(0xFF515151),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Simpan lowongan yang menarik untuk dilihat nanti',
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

  Widget _buildJobList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: _savedJobs.map((savedJob) {
          final lokerUmum = savedJob.toLokerUmum();
          final daysLeft = _calculateDaysLeft(lokerUmum.batasLamaran);
          final isUrgent = daysLeft <= 10 && daysLeft >= 0;

          return Column(
            children: [
              _JobCard(
                lowongan: lokerUmum,
                savedJobId: savedJob.savedJobId,
                isUrgent: isUrgent,
                daysLeft: daysLeft,
                isApplied: false,
                onTap: () => _showJobDetail(lokerUmum),
                onBookmarkTap: () => _unsaveJob(savedJob.savedJobId),
              ),
              const SizedBox(height: 15),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _JobCard extends StatefulWidget {
  final LokerUmum lowongan;
  final String savedJobId;
  final bool isUrgent;
  final int daysLeft;
  final bool isApplied;
  final VoidCallback onTap;
  final VoidCallback onBookmarkTap;

  const _JobCard({
    required this.lowongan,
    required this.savedJobId,
    required this.isUrgent,
    required this.daysLeft,
    required this.isApplied,
    required this.onTap,
    required this.onBookmarkTap,
  });

  @override
  State<_JobCard> createState() => __JobCardState();
}

class __JobCardState extends State<_JobCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _bookmarkController;
  late Animation<double> _bookmarkScale;
  late bool _isSaved;

  @override
  void initState() {
    super.initState();
    _isSaved = true;
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
    // Animasi scale
    _bookmarkController.forward().then((_) {
      _bookmarkController.reverse();
      
      // Ubah state untuk animasi icon
      setState(() {
        _isSaved = false;
      });
      
      // Tunggu sebelum menghapus dari UI (sama seperti di beranda)
      Future.delayed(const Duration(milliseconds: 300), () {
        widget.onBookmarkTap();
      });
    });
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
                  // Badge urgent
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
                            // Bookmark button dengan animasi yang sama seperti di beranda
                            GestureDetector(
                              onTap: _toggleBookmark,
                              child: ScaleTransition(
                                scale: _bookmarkScale,
                                child: SizedBox(
                                  width: 32,
                                  height: 32,
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 200),
                                    child: _isSaved
                                        ? const Icon(
                                            Icons.bookmark,
                                            key: ValueKey('saved'),
                                            color: Color(0xFF0118D8),
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
                                color: Color(0xFF464E5E),
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

class _JobCardSkeleton extends StatelessWidget {
  const _JobCardSkeleton();

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