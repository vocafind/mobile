// halaman_jobfair_detail.dart
import 'package:flutter/material.dart';
import 'package:jobfair/api/endpoints.dart';
import 'package:jobfair/models/lamar_jobfair_model.dart';
import 'package:jobfair/models/loker_umum_model.dart';
import 'package:jobfair/screens/detail_job_sheet_jobfair.dart';
import 'package:jobfair/widget/bottom_navbar.dart';
import 'package:jobfair/api/api_service.dart';
import 'package:jobfair/models/jobfair_detail_model.dart';
import 'package:jobfair/api/route.dart';

class HalamanJobfairDetail extends StatefulWidget {
  final int jobfairId;

  const HalamanJobfairDetail({super.key, required this.jobfairId});

  factory HalamanJobfairDetail.fromRoute(RouteSettings settings) {
    final args = settings.arguments;

    if (args is int) {
      return HalamanJobfairDetail(jobfairId: args);
    } else if (args is Map<String, dynamic>) {
      final jobfairId = args['jobfairId'] as int;
      return HalamanJobfairDetail(jobfairId: jobfairId);
    } else {
      throw ArgumentError('jobfairId harus diisi');
    }
  }

  @override
  State<HalamanJobfairDetail> createState() => _HalamanJobfairDetailState();
}

class _HalamanJobfairDetailState extends State<HalamanJobfairDetail> {
  final ApiService _apiService = ApiService();
  late Future<JobfairDetail?> _jobfairDetailFuture;
  late Future<List<LokerUmum>> _lokerJobfairFuture;
  late Future<StatusRegistrasiAcara> _statusRegistrasiFuture;
  List<String> _appliedJobIds = [];
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _jobsSectionKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    _jobfairDetailFuture = _apiService.getJobfairDetailById(widget.jobfairId);
    _lokerJobfairFuture = _apiService.getAllLokerByJobfair(widget.jobfairId);
    _statusRegistrasiFuture = _apiService.getStatusRegistrasiAcara(
      widget.jobfairId,
    );

    // Load applied job ids
    _loadAppliedJobs();
  }

  Future<void> _loadAppliedJobs() async {
    try {
      final appliedIds = await _apiService.getLowonganSudahDilamar();
      setState(() {
        _appliedJobIds = appliedIds;
      });
    } catch (e) {
      print("Error loading applied jobs: $e");
    }
  }

  void _refreshData() {
    setState(() {
      _jobfairDetailFuture = _apiService.getJobfairDetailById(widget.jobfairId);
      _lokerJobfairFuture = _apiService.getAllLokerByJobfair(widget.jobfairId);
      _statusRegistrasiFuture = _apiService.getStatusRegistrasiAcara(
        widget.jobfairId,
      );
      _loadAppliedJobs();
    });
  }

  void _showRegistrationSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Lamarlah setidaknya 1 lowongan untuk mendaftar acara',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.orange[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: SnackBarAction(
          textColor: Colors.white,
          label: 'OK',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _scrollToJobsSection() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_jobsSectionKey.currentContext != null) {
        Scrollable.ensureVisible(
          _jobsSectionKey.currentContext!,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: FutureBuilder<JobfairDetail?>(
        future: _jobfairDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingState();
          } else if (snapshot.hasError) {
            return _buildErrorState(snapshot.error.toString());
          } else if (!snapshot.hasData || snapshot.data == null) {
            return _buildEmptyState();
          } else {
            return _buildDetailContent(snapshot.data!);
          }
        },
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }

  Widget _buildDetailContent(JobfairDetail jobfair) {
    return FutureBuilder<StatusRegistrasiAcara>(
      future: _statusRegistrasiFuture,
      builder: (context, statusSnapshot) {
        final statusRegistrasi = statusSnapshot.data;

        return SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              _buildHeader(context, jobfair, statusRegistrasi),
              _buildImageCarousel(jobfair),
              _buildAboutSection(jobfair),
              _buildCompaniesSection(jobfair),
              _buildJobsSection(jobfair, statusRegistrasi),
              const SizedBox(height: 100),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(
    BuildContext context,
    JobfairDetail jobfair,
    StatusRegistrasiAcara? statusRegistrasi,
  ) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1B56FD), Color(0xFF0118D8)],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => goBack(context),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEEEEE).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                jobfair.namaAcara,
                style: const TextStyle(
                  color: Color(0xFFFFFBFB),
                  fontSize: 24,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.white, size: 12),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      jobfair.acaraBkk ?? 'Politeknik Negeri Batam',
                      style: const TextStyle(
                        color: Color(0xFFFFFBFB),
                        fontSize: 12,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    color: Colors.white,
                    size: 10,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    jobfair.formattedDateRange,
                    style: const TextStyle(
                      color: Color(0xFFFFFBFB),
                      fontSize: 12,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Pendaftaran : ${jobfair.formattedRegistrationDate}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildBadge(jobfair.capacityText),
                    const SizedBox(width: 6),
                    _buildBadge(jobfair.jobsText),
                    const SizedBox(width: 6),
                    _buildBadge(jobfair.companiesText),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (statusRegistrasi != null)
                statusRegistrasi.isRegistered
                    ? _buildRegistrationStatus(statusRegistrasi)
                    : _buildRegisterButton(context)
              else
                _buildRegisterButtonLoading(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegistrationStatus(StatusRegistrasiAcara status) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green[300], size: 20),
              const SizedBox(width: 8),
              const Text(
                'Anda sudah terdaftar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (status.registrationCode != null) ...[
            _buildRegistrationInfoRow(
              'Kode Registrasi',
              status.registrationCode!,
              Icons.confirmation_number,
            ),
            const SizedBox(height: 8),
          ],
          _buildRegistrationInfoRow(
            'Jumlah Lamaran Anda',
            '${status.applicationCount} / 3 lowongan',
            Icons.work,
          ),
        ],
      ),
    );
  }

  Widget _buildRegistrationInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.7), size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                  fontFamily: 'Poppins',
                ),
              ),
              Text(
                value,
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
      ],
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showRegistrationSnackbar();
        _scrollToJobsSection();
      },
      child: Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(45),
          border: Border.all(
            color: const Color(0xFFF1F5F9).withOpacity(0.4),
            width: 1,
          ),
        ),
        child: const Center(
          child: Text(
            'Daftar Acara',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFFFFBFB),
              fontSize: 12,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterButtonLoading() {
    return Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(45),
        border: Border.all(
          color: const Color(0xFFF1F5F9).withOpacity(0.4),
          width: 1,
        ),
      ),
      child: const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      height: 30,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(45),
        border: Border.all(
          color: const Color(0xFFF1F5F9).withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }

  Widget _buildImageCarousel(JobfairDetail jobfair) {
    final images = jobfair.flyerAcara.isNotEmpty
        ? jobfair.flyerAcara
        : [FlyerAcara(flyerUrl: 'assets/images/image10.png')];

    return Container(
      height: 240,
      color: Colors.white,
      child: images.isEmpty
          ? _buildNoImagesPlaceholder()
          : ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(vertical: 20),
              children: [
                const SizedBox(width: 18),
                ...images.asMap().entries.map((entry) {
                  final index = entry.key;
                  final flyer = entry.value;
                  return Row(
                    children: [
                      _buildCarouselImage(flyer.flyerUrl),
                      if (index < images.length - 1) const SizedBox(width: 12),
                    ],
                  );
                }),
                const SizedBox(width: 18),
              ],
            ),
    );
  }

  Widget _buildCarouselImage(String imageUrl) {
    final fullImageUrl = ApiConfig.getFullImageUrl(imageUrl);
    final isNetworkImage = fullImageUrl.startsWith('http');

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: isNetworkImage
          ? Image.network(
              fullImageUrl,
              width: 336,
              height: 202,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: 336,
                  height: 202,
                  color: Colors.grey[300],
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
                  width: 336,
                  height: 202,
                  color: Colors.grey[300],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Gagal memuat gambar',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                );
              },
            )
          : Image.asset(
              imageUrl,
              width: 336,
              height: 202,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 336,
                  height: 202,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 50, color: Colors.grey),
                );
              },
            ),
    );
  }

  Widget _buildNoImagesPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.photo_library, size: 50, color: Colors.grey),
          const SizedBox(height: 8),
          const Text(
            'Tidak ada gambar tersedia',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(JobfairDetail jobfair) {
    bool isExpanded = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.all(19),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tentang acara',
                style: TextStyle(
                  color: Color(0xFF18181B),
                  fontSize: 20,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  style: const TextStyle(
                    color: Color(0xFF525252),
                    fontSize: 14,
                    fontFamily: 'SF Pro',
                    height: 1.6,
                  ),
                  children: [
                    TextSpan(
                      text: _getDescriptionText(jobfair.deskripsi, isExpanded),
                    ),
                    if (_shouldShowReadMore(jobfair.deskripsi))
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isExpanded = !isExpanded;
                            });
                          },
                          child: Text(
                            isExpanded
                                ? ' Baca lebih sedikit'
                                : ' Baca selengkapnya',
                            style: const TextStyle(
                              color: Color(0xFF2563EB),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getDescriptionText(String? deskripsi, bool isExpanded) {
    if (deskripsi == null || deskripsi.isEmpty) {
      return 'Tidak ada deskripsi tersedia untuk acara ini.';
    }

    if (!isExpanded && deskripsi.length > 200) {
      return '${deskripsi.substring(0, 200)}...';
    }

    return deskripsi;
  }

  bool _shouldShowReadMore(String? deskripsi) {
    return deskripsi != null && deskripsi.length > 200;
  }

  Widget _buildCompaniesSection(JobfairDetail jobfair) {
    if (jobfair.perusahaan.isEmpty) {
      return Container();
    }

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 25),
      margin: const EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 19),
            child: Text(
              'Perusahaan berpartisipasi',
              style: TextStyle(
                color: Color(0xFF18181B),
                fontSize: 20,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 80,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 19),
              children: [
                ...jobfair.perusahaan.asMap().entries.map((entry) {
                  final index = entry.key;
                  final company = entry.value;
                  return Row(
                    children: [
                      _buildCompanyLogo(company),
                      if (index < jobfair.perusahaan.length - 1)
                        const SizedBox(width: 16),
                    ],
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildCompanyLogo(CompanyJobfair company) {
    final fullLogoUrl = ApiConfig.getFullImageUrl(company.logo);

    return Container(
      width: 76,
      height: 68,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: company.logo != null && company.logo!.isNotEmpty
          ? Image.network(
              fullLogoUrl,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return _buildCompanyPlaceholder(company.namaPerusahaan);
              },
            )
          : _buildCompanyPlaceholder(company.namaPerusahaan),
    );
  }

  Widget _buildCompanyPlaceholder(String companyName) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.business, color: Colors.grey, size: 24),
        const SizedBox(height: 4),
        Text(
          companyName.length > 8
              ? '${companyName.substring(0, 8)}...'
              : companyName,
          style: const TextStyle(fontSize: 10, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildJobsSection(
    JobfairDetail jobfair,
    StatusRegistrasiAcara? statusRegistrasi,
  ) {
    final canApply = statusRegistrasi?.canApplyMore ?? true;

    return FutureBuilder<List<LokerUmum>>(
      future: _lokerJobfairFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingJobs();
        } else if (snapshot.hasError) {
          return _buildErrorJobs(snapshot.error.toString());
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyJobs();
        } else {
          return _buildJobsContent(snapshot.data!, canApply);
        }
      },
    );
  }

  Widget _buildJobsContent(List<LokerUmum> lokers, bool canApply) {
    return Container(
      key: _jobsSectionKey,
      width: double.infinity,
      color: const Color(0xFFFAFAFA),
      margin: const EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(19, 25, 19, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lowongan tersedia (${lokers.length})',
                  style: const TextStyle(
                    color: Color(0xFF18181B),
                    fontSize: 20,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (!canApply) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info, color: Colors.orange[800], size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Anda sudah mencapai batas maksimal lamaran',
                            style: TextStyle(
                              color: Colors.orange[800],
                              fontSize: 12,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: lokers
                  .map(
                    (loker) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _JobCardJobfair(
                        lowongan: loker,
                        canApply: canApply,
                        isApplied: _appliedJobIds.contains(loker.lowonganId),
                        onTap: () {
                          if (canApply) {
                            _showJobDetail(loker.lowonganId);
                          }
                        },
                        onBookmarkTap: () {
                          _toggleBookmark(loker.lowonganId);
                        },
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _showJobDetail(String lowonganId) async {
    try {
      final lokerDetail = await _apiService.getLokerJobfairDetail(lowonganId);

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => JobDetailSheetJobfair(loker: lokerDetail),
      ).then((shouldRefresh) {
        if (shouldRefresh == true) {
          _refreshData();
        }
      });
    } catch (e) {
      print('Error loading job detail: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal memuat detail lowongan: $e',
            style: const TextStyle(fontFamily: 'Poppins'),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _toggleBookmark(String lowonganId) async {
    try {
      print('Bookmark toggled for: $lowonganId');
      // Tambahkan logika toggle bookmark di sini
    } catch (e) {
      print('Error toggling bookmark: $e');
    }
  }

  Widget _buildLoadingJobs() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildErrorJobs(String error) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Icon(Icons.error_outline, size: 50, color: Colors.red),
          const SizedBox(height: 10),
          Text(
            'Gagal memuat lowongan: $error',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              _refreshData();
            },
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyJobs() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Icon(Icons.work_outline, size: 50, color: Colors.grey),
          const SizedBox(height: 10),
          const Text(
            'Belum ada lowongan tersedia',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'Gagal memuat detail job fair',
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
              _refreshData();
            },
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.event_busy, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'Detail job fair tidak ditemukan',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Silakan coba lagi nanti.', textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => goBack(context),
            child: const Text('Kembali'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

// Job Card untuk halaman jobfair detail - design konsisten dengan halaman bookmark
class _JobCardJobfair extends StatefulWidget {
  final LokerUmum lowongan;
  final bool canApply;
  final bool isApplied;
  final VoidCallback onTap;
  final VoidCallback onBookmarkTap;

  const _JobCardJobfair({
    required this.lowongan,
    required this.canApply,
    required this.isApplied,
    required this.onTap,
    required this.onBookmarkTap,
  });

  @override
  State<_JobCardJobfair> createState() => __JobCardJobfairState();
}

class __JobCardJobfairState extends State<_JobCardJobfair>
    with SingleTickerProviderStateMixin {
  late AnimationController _bookmarkController;
  late Animation<double> _bookmarkScale;
  bool _isSaved = false;

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
    _bookmarkController.forward().then((_) {
      _bookmarkController.reverse();
      setState(() {
        _isSaved = !_isSaved;
      });
      widget.onBookmarkTap();
    });
  }

  int _calculateDaysLeft(DateTime batasLamaran) {
    final now = DateTime.now();
    final difference = batasLamaran.difference(now);
    return difference.inDays;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth - 32;
    final cardHeight = 235.0;
    final daysLeft = _calculateDaysLeft(widget.lowongan.batasLamaran);
    final isUrgent = daysLeft <= 10 && daysLeft >= 0;

    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: cardWidth,
        height: cardHeight,
        child: Stack(
          children: [
            // Background
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

            // Main card
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
                  // Badge urgent (kiri atas)
                  if (isUrgent && !widget.isApplied)
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
                              daysLeft == 0
                                  ? 'Hari terakhir!'
                                  : '$daysLeft hari lagi',
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

                  // Badge sudah dilamar (kanan atas)
                  if (widget.isApplied)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: cardWidth * 0.45,
                        height: cardHeight * 0.119,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50),
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

                  // Overlay jika tidak bisa apply
                  if (!widget.canApply && !widget.isApplied)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(
                            cardWidth * 0.102,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.block,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ),

                  Padding(
                    padding: EdgeInsets.all(cardWidth * 0.058),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: cardHeight * 0.119),

                        // Company logo and info
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
                            // Bookmark button
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

                        // Salary
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

                        // Tags
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

                        // Posted time and number of applicants
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
