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
  List<String> _appliedJobIds = []; // ✅ TAMBAHKAN INI
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
      // ✅ LOAD DATA SAVED JOBS DAN APPLIED JOIDS SECARA BERSAMAAN
      final results = await Future.wait<dynamic>([
        _apiService.getSavedJobs(),
        _apiService.getLowonganSudahDilamar(), // ✅ LOAD DATA SUDAH DILAMAR
      ]);

      final savedJobs = results[0] as List<SavedJob>;
      final appliedIds = results[1] as List<String>;

      setState(() {
        _savedJobs = savedJobs;
        _appliedJobIds = appliedIds; // ✅ SIMPAN DATA SUDAH DILAMAR
        _isLoading = false;
      });

      print("✅ Loaded ${savedJobs.length} saved jobs, ${appliedIds.length} already applied");
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
        // ✅ CEK APAKAH SUDAH DILAMAR
        final isAlreadyApplied = _appliedJobIds.contains(lowongan.lowonganId);
        
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => JobDetailSheet(
            loker: detailLowongan,
            isAlreadyApplied: isAlreadyApplied, // ✅ KIRIM STATUS DI SINI
          ),
        ).then((shouldRefresh) {
          if (shouldRefresh == true) {
            _loadSavedJobs(); // Refresh data untuk update status
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
          
          // ✅ CEK APAKAH SUDAH DILAMAR
          final isApplied = _appliedJobIds.contains(lokerUmum.lowonganId);

          return Column(
            children: [
              _JobCard(
                lowongan: lokerUmum,
                savedJobId: savedJob.savedJobId,
                isUrgent: isUrgent,
                daysLeft: daysLeft,
                isApplied: isApplied, // ✅ KIRIM STATUS INI
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

// Job Card untuk halaman bookmark - design konsisten dengan halaman cari loker
class _JobCard extends StatefulWidget {
  final LokerUmum lowongan;
  final String savedJobId;
  final bool isUrgent;
  final int daysLeft;
  final bool isApplied; // ✅ TAMBAHKAN INI
  final VoidCallback onTap;
  final VoidCallback onBookmarkTap;

  const _JobCard({
    required this.lowongan,
    required this.savedJobId,
    required this.isUrgent,
    required this.daysLeft,
    required this.isApplied, // ✅ TAMBAHKAN INI
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
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth - 32; // 16 padding kiri + 16 padding kanan
    final cardHeight = 235.0; // Tinggi sama dengan card di halaman cari loker

    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: cardWidth,
        height: cardHeight,
        child: Stack(
          children: [
            // Background - sama dengan halaman cari loker
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

            // Main card - tanpa border biru dan shadow khusus
            Container(
              width: cardWidth,
              height: cardHeight,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color(0xFFC7C7C7)),
                  borderRadius: BorderRadius.circular(cardWidth * 0.102),
                ),
              ),
              child: Stack(
                children: [
                  // Badge urgent (kiri atas) - hanya jika urgent
                  if (widget.isUrgent && !widget.isApplied)
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width: cardWidth * 0.45,
                        height: cardHeight * 0.119,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0E37EB),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(cardWidth * 0.102),
                            bottomRight: Radius.circular(cardWidth * 0.058),
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
                            SizedBox(width: cardWidth * 0.012),
                            Text(
                              widget.daysLeft == 0
                                  ? 'Hari terakhir!'
                                  : '${widget.daysLeft} hari lagi',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth * 0.029,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // ✅ BADGE SUDAH DILAMAR (KANAN ATAS) - JIKA SUDAH DILAMAR
                  if (widget.isApplied)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: cardWidth * 0.45,
                        height: cardHeight * 0.119,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50), // HIJAU
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(cardWidth * 0.102),
                            bottomLeft: Radius.circular(cardWidth * 0.058),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 14,
                            ),
                            SizedBox(width: cardWidth * 0.012),
                            const Text(
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

                  Padding(
                    padding: EdgeInsets.all(cardWidth * 0.058),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: cardHeight * 0.119),

                        // Company logo and info - ukuran font sama dengan halaman cari loker
                        Row(
                          children: [
                            Container(
                              width: cardWidth * 0.117,
                              height: cardWidth * 0.105,
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
                            SizedBox(width: cardWidth * 0.058),
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
                                      fontSize: screenWidth * 0.042,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      height: 1.25,
                                      letterSpacing: -0.24,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.lowongan.namaPerusahaan,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: const Color(0x993C3C43),
                                      fontSize: screenWidth * 0.037,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      height: 1.29,
                                      letterSpacing: -0.08,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Bookmark button dengan animasi yang sama seperti di halaman cari loker
                            GestureDetector(
                              onTap: _toggleBookmark,
                              child: ScaleTransition(
                                scale: _bookmarkScale,
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 200),
                                    child: _isSaved
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

                        SizedBox(height: cardHeight * 0.085),

                        // Salary - ukuran font sama dengan halaman cari loker
                        RichText(
                          text: TextSpan(
                            children: [
                              // Teks "Rp" dari fungsi format
                              TextSpan(
                                text: _formatSalaryValue(widget.lowongan.gaji),
                                style: TextStyle(
                                  color: const Color(0xFF40403F),
                                  fontSize:
                                      screenWidth *
                                      0.047, // Gunakan screenWidth yang sudah didefinisikan
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  height: 1.11,
                                  letterSpacing: -0.24,
                                ),
                              ),
                              // Icon mata silang hanya jika gaji tidak ditampilkan
                              if (widget.lowongan.gaji.toLowerCase().contains(
                                    'gaji tidak ditampilkan',
                                  ) ||
                                  widget.lowongan.gaji.toLowerCase().contains(
                                    'tidak diumumkan',
                                  ) ||
                                  widget.lowongan.gaji.isEmpty)
                                WidgetSpan(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: screenWidth * 0.015,
                                    ), // Gunakan screenWidth yang sudah didefinisikan
                                    child: Icon(
                                      Icons.visibility_off,
                                      color: const Color(0xFF40403F),
                                      size:
                                          screenWidth *
                                          0.04, // Gunakan screenWidth yang sudah didefinisikan
                                    ),
                                  ),
                                  alignment: PlaceholderAlignment.middle,
                                ),
                            ],
                          ),
                        ),

                        SizedBox(height: cardHeight * 0.068),

                        // Tags - ukuran font sama dengan halaman cari loker
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: cardWidth * 0.035,
                                vertical: cardHeight * 0.017,
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
                                  fontSize: screenWidth * 0.032,
                                  fontFamily: 'SF Pro',
                                  fontWeight: FontWeight.w400,
                                  height: 1.43,
                                  letterSpacing: -0.50,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: cardWidth * 0.035,
                                vertical: cardHeight * 0.017,
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
                                  fontSize: screenWidth * 0.032,
                                  fontFamily: 'SF Pro',
                                  fontWeight: FontWeight.w400,
                                  height: 1.43,
                                  letterSpacing: -0.50,
                                ),
                              ),
                            ),

                             // Hanya tampilkan jika minimalLulusan bukan "Tidak Ada"
                            if (widget.lowongan.minimalLulusan.toLowerCase() !=
                                'tidak ada')
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: cardWidth * 0.035,
                                  vertical: cardHeight * 0.017,
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
                                child: Text(
                                  widget.lowongan.minimalLulusan,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: screenWidth * 0.032,
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
                                  horizontal: cardWidth * 0.035,
                                  vertical: cardHeight * 0.017,
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

                        const Spacer(),

                        // Posted time and number of applicants - ukuran font sama dengan halaman cari loker
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatTimeAgo(widget.lowongan.tanggalPosting),
                              style: TextStyle(
                                color: const Color(0xFF464E5E),
                                fontSize: screenWidth * 0.032,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w400,
                                height: 2,
                              ),
                            ),
                            Text(
                              '${widget.lowongan.jumlahPelamar} pelamar',
                              style: TextStyle(
                                color: const Color(0xFF464E5E),
                                fontSize: screenWidth * 0.032,
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

  String _formatSalaryValue(String gaji) {
    if (gaji.toLowerCase().contains('gaji tidak ditampilkan') ||
        gaji.toLowerCase().contains('tidak diumumkan') ||
        gaji.isEmpty) {
      return 'Rp '; // Hanya return 'Rp ' untuk digabung dengan icon
    }
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