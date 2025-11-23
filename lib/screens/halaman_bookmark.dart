import 'package:flutter/material.dart';
import 'package:jobfair/api/api_service.dart';
import 'package:jobfair/models/loker_umum_model.dart';
import 'detail_job_sheet.dart';

class HalamanBookmark extends StatefulWidget {
  const HalamanBookmark({super.key});

  @override
  State<HalamanBookmark> createState() => _HalamanBookmarkState();
}

class _HalamanBookmarkState extends State<HalamanBookmark> {
  final ApiService _apiService = ApiService();
  List<LokerUmum> _savedJobs = [];
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
      // Simulasi data lowongan tersimpan
      // Di production, ini akan mengambil dari API/bookmark service
      final allJobs = await _apiService.getAllLokerUmum();

      // Untuk demo, kita ambil 5 job pertama sebagai saved jobs
      setState(() {
        _savedJobs = allJobs.take(5).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  // ✅ Fungsi untuk membuka detail lowongan - SAMA DENGAN HALAMAN CARI LOKER
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
            _loadSavedJobs(); // Refresh data
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

  // ✅ Fungsi untuk menghitung sisa hari - SAMA DENGAN HALAMAN CARI LOKER
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
            // Header with gradient - SAMA DENGAN NOTIFIKASI
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
                          color: Colors.white.withValues(alpha: 0.1),
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
        children: _savedJobs.map((lowongan) {
          final daysLeft = _calculateDaysLeft(lowongan.batasLamaran);
          final isUrgent = daysLeft <= 10 && daysLeft >= 0;

          return Column(
            children: [
              _JobCard(
                lowongan: lowongan,
                isUrgent: isUrgent,
                daysLeft: daysLeft,
                isApplied: false, // Untuk saved jobs, biasanya belum diapply
                onTap: () => _showJobDetail(lowongan),
                showBookmark:
                    true, // Tampilkan bookmark karena ini halaman saved
                isBookmarked: true, // Selalu true karena ini halaman saved jobs
                onBookmarkTap: () {
                  // Logic untuk remove dari saved
                  setState(() {
                    _savedJobs.remove(lowongan);
                  });
                },
              ),
              const SizedBox(height: 16),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// ✅ Job Card yang SAMA PERSIS dengan halaman cari loker
class _JobCard extends StatefulWidget {
  final LokerUmum lowongan;
  final bool isUrgent;
  final int daysLeft;
  final bool isApplied;
  final VoidCallback onTap;
  final bool showBookmark;
  final bool isBookmarked;
  final VoidCallback? onBookmarkTap;

  const _JobCard({
    required this.lowongan,
    required this.isUrgent,
    required this.daysLeft,
    required this.isApplied,
    required this.onTap,
    this.showBookmark = true,
    this.isBookmarked = false,
    this.onBookmarkTap,
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
    isSaved = widget.isBookmarked;
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

    // Panggil callback jika ada
    widget.onBookmarkTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: double.infinity,
        height: 220,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            if (widget.isApplied)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 130,
                  height: 28,
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

            if (widget.isUrgent && !widget.isApplied)
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 130,
                  height: 28,
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
              padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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

                      Expanded(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 200),
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

                      if (widget.showBookmark)
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
                                        color: Colors.black.withValues(alpha:0.3),
                                        size: 24,
                                      ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Text(
                    _formatSalary(widget.lowongan.gaji),
                    style: const TextStyle(
                      //color: Color(0xFF1B56FD),
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildTag(widget.lowongan.lokasi),

                      _buildTag(widget.lowongan.jenisPekerjaan),

                      if (widget.lowongan.opsiKerjaRemote) _buildTag('Remote'),
                    ],
                  ),

                  const Spacer(),

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

  Widget _buildTag(String text, {Color? backgroundColor, Color? textColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: backgroundColor != null
              ? Colors.transparent
              : Colors.grey.shade200,
        ),
      ),
      child: Text(
        text.length > 15 ? '${text.substring(0, 15)}...' : text,
        style: TextStyle(
          color: textColor ?? Colors.grey.shade700,
          fontSize: 12,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
        ),
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

// ✅ Skeleton loading yang SAMA
class _JobCardSkeleton extends StatelessWidget {
  const _JobCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Container(
              width: 100,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 12),
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
    );
  }
}
