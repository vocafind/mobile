// halaman_jobfair_detail.dart
import 'package:flutter/material.dart';
import 'package:jobfair/api/endpoints.dart';
import 'package:jobfair/models/loker_umum_detail_model.dart';
import 'package:jobfair/screens/detail_job_sheet_jobfair.dart';
import 'package:jobfair/widget/bottom_navbar.dart';
import 'package:jobfair/api/api_service.dart';
import 'package:jobfair/models/jobfair_detail_model.dart';

class HalamanJobfairDetail extends StatefulWidget {
  final int jobfairId;

  const HalamanJobfairDetail({super.key, required this.jobfairId});

  @override
  State<HalamanJobfairDetail> createState() => _HalamanJobfairDetailState();
}

class _HalamanJobfairDetailState extends State<HalamanJobfairDetail> {
  final ApiService _apiService = ApiService();
  late Future<JobfairDetail?> _jobfairDetailFuture;
  final ScrollController _scrollController =
      ScrollController(); // TAMBAHKAN INI
  final GlobalKey _jobsSectionKey = GlobalKey(); // TAMBAHKAN INI

  @override
  void initState() {
    super.initState();
    _jobfairDetailFuture = _apiService.getJobfairDetailById(widget.jobfairId);
  }

  // TAMBAHKAN METHOD INI
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

  // TAMBAHKAN METHOD INI
  void _scrollToJobsSection() {
    // Delay sedikit untuk memastikan snackbar sudah muncul
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
    return SingleChildScrollView(
      controller: _scrollController, // TAMBAHKAN INI
      child: Column(
        children: [
          // Header dengan gradient dan info job fair
          _buildHeader(context, jobfair),

          // Carousel images
          _buildImageCarousel(jobfair),

          // Tentang acara section
          _buildAboutSection(jobfair),

          // Perusahaan berpartisipasi
          _buildCompaniesSection(jobfair),

          // Lowongan tersedia - TAMBAHKAN KEY DI SINI
          _buildJobsSection(jobfair),

          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, JobfairDetail jobfair) {
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
              // Back button, Search bar dan filter
              Row(
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
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
                  const SizedBox(width: 6),
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEEEEE).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Row(
                        children: [
                          SizedBox(width: 14),
                          Icon(Icons.search, color: Colors.white, size: 25),
                          SizedBox(width: 16),
                          Text(
                            'Cari lowongan kerja...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEEEEE).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Title
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
              // Location
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
              // Date
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
              // Registration info
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
              // Badges
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
              const SizedBox(height: 20), // Reduced spacing
              // TOMBOL DAFTAR ACARA - TAMBAHAN BARU
              _buildRegisterButton(context),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Opsi 1: Langsung tampilkan snackbar dan scroll (tanpa dialog konfirmasi)
        _showRegistrationSnackbar();
        _scrollToJobsSection();

        // Opsi 2: Jika ingin tetap pakai dialog, ganti dengan:
        // _showRegistrationDialog();
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

  @override
  void dispose() {
    _scrollController.dispose(); // JANGAN LUPA DISPOSE
    super.dispose();
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

  // halaman_jobfair_detail.dart - Update bagian ini saja

  Widget _buildImageCarousel(JobfairDetail jobfair) {
    // Jika ada flyer dari API, gunakan flyer tersebut
    // Jika tidak, gunakan gambar default
    final images = jobfair.flyerAcara.isNotEmpty
        ? jobfair.flyerAcara
        : [FlyerAcara(flyerUrl: 'assets/images/image10.png')];

    // Debug info untuk memeriksa flyer
    print('📋 Total flyer: ${images.length}');
    for (var i = 0; i < images.length; i++) {
      final flyer = images[i];
      final fullUrl = ApiConfig.getFullImageUrl(flyer.flyerUrl);
      print('🖼️ Flyer $i: ${flyer.flyerUrl}');
      print('🔗 Full URL: $fullUrl');
    }

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
    // Gunakan helper untuk mendapatkan full URL
    final fullImageUrl = ApiConfig.getFullImageUrl(imageUrl);

    print('🖼️ Loading image from: $fullImageUrl');

    // Cek apakah ini asset local atau network image
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
                print('❌ Error loading image: $error');
                print('❌ StackTrace: $stackTrace');
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
                      const SizedBox(height: 4),
                      Text(
                        imageUrl,
                        style: TextStyle(color: Colors.grey[500], fontSize: 10),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            )
          : Image.asset(
              imageUrl, // Untuk asset local
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
              fontWeight: FontWeight.w400,
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
                height: 1.3,
              ),
              children: [
                TextSpan(text: _getDescriptionText(jobfair.deskripsi)),
                if (_shouldShowReadMore(jobfair.deskripsi))
                  const TextSpan(
                    text: ' Read more',
                    style: TextStyle(color: Color(0xFF2563EB)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getDescriptionText(String? deskripsi) {
    if (deskripsi == null || deskripsi.isEmpty) {
      return 'Tidak ada deskripsi tersedia untuk acara ini.';
    }

    // Potong deskripsi jika lebih dari 200 karakter
    if (deskripsi.length > 200) {
      return '${deskripsi.substring(0, 200)}...';
    }

    return deskripsi;
  }

  bool _shouldShowReadMore(String? deskripsi) {
    return deskripsi != null && deskripsi.length > 200;
  }

  Widget _buildCompaniesSection(JobfairDetail jobfair) {
    if (jobfair.perusahaan.isEmpty) {
      return Container(); // Jangan tampilkan section jika tidak ada perusahaan
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
          // Horizontal scrollable company logos
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

  Widget _buildJobsSection(JobfairDetail jobfair) {
    return Container(
      key: _jobsSectionKey, // TAMBAHKAN INI
      width: double.infinity,
      color: const Color(0xFFFAFAFA),
      margin: const EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(19, 25, 19, 16),
            child: Text(
              'Lowongan tersedia (${jobfair.lowonganAcara.length})',
              style: const TextStyle(
                color: Color(0xFF18181B),
                fontSize: 20,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: jobfair.lowonganAcara
                  .map(
                    (lowongan) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildJobCard(lowongan),
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

  // Ganti seluruh method _buildJobCard dengan kode berikut:
  Widget _buildJobCard(LowonganAcara lowongan) {
    return GestureDetector(
      onTap: () {
        // Panggil JobDetailSheetJobfair ketika card di tap
        _showJobDetail(lowongan);
      },
      child: Container(
        width: double.infinity,
        height: 220,
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
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                        child:
                            lowongan.logo != null && lowongan.logo!.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  ApiConfig.getFullImageUrl(lowongan.logo),
                                  fit: BoxFit.contain,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value:
                                                loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
                                  errorBuilder: (context, error, stackTrace) {
                                    return _buildLogoPlaceholder();
                                  },
                                ),
                              )
                            : _buildLogoPlaceholder(),
                      ),
                      const SizedBox(width: 12),

                      // Job Title and Company
                      Expanded(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 200),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lowongan.posisi,
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
                                lowongan.namaPerusahaan,
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

                      // Bookmark Icon
                      GestureDetector(
                        onTap: () {
                          _toggleBookmark(lowongan.lowonganId);
                        },
                        child: SizedBox(
                          width: 32,
                          height: 32,
                          child: Icon(
                            Icons.bookmark_border,
                            color: Colors.black.withOpacity(0.3),
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Salary
                  Text(
                    _formatSalary(lowongan.gaji),
                    style: const TextStyle(
                      color: Color(0xFF1B56FD),
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Tags
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildJobTag(lowongan.lokasi),
                      _buildJobTag(lowongan.jenisPekerjaan),
                      if (lowongan.opsiKerjaRemote) _buildJobTag('Remote'),
                      if (lowongan.minimalLulusan != null &&
                          lowongan.minimalLulusan!.isNotEmpty)
                        _buildJobTag(lowongan.minimalLulusan!),
                    ],
                  ),

                  const Spacer(),

                  // Footer info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        lowongan.timeAgo,
                        style: const TextStyle(
                          color: Color(0xFF999999),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        '${lowongan.jumlahPelamar} pelamar',
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

  void _showJobDetail(LowonganAcara lowongan) {
    // Konversi LowonganAcara ke LokerUmumDetail
    final lokerDetail = _convertToLokerUmumDetail(lowongan);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => JobDetailSheetJobfair(loker: lokerDetail),
    ).then((shouldRefresh) {
      // Handle refresh jika diperlukan setelah melamar lowongan
      if (shouldRefresh == true) {
        // Refresh data jobfair detail
        setState(() {
          _jobfairDetailFuture = _apiService.getJobfairDetailById(
            widget.jobfairId,
          );
        });
      }
    });
  }

  LokerUmumDetail _convertToLokerUmumDetail(LowonganAcara lowongan) {
    return LokerUmumDetail(
      lowonganId: lowongan.lowonganId,
      posisi: lowongan.posisi,
      deskripsiPekerjaan: lowongan.deskripsiPekerjaan,
      minimalLulusan: lowongan.minimalLulusan ?? '',
      status: lowongan.status,
      lokasi: lowongan.lokasi,
      gaji: lowongan.gaji,
      jenisPekerjaan: lowongan.jenisPekerjaan,
      tanggalPosting: lowongan.tanggalPosting,
      batasLamaran: lowongan.batasLamaran,
      batasPelamar: lowongan.batasPelamar,
      jumlahPelamar: lowongan.jumlahPelamar,
      tingkatPengalaman: lowongan.tingkatPengalaman,
      opsiKerjaRemote: lowongan.opsiKerjaRemote,
      kontrakDurasi: lowongan.kontrakDurasi,
      peluangKarir: lowongan.peluangKarir,
      namaPerusahaan: lowongan.namaPerusahaan,
      logo: lowongan.logo ?? '',
      // Field tambahan yang diperlukan oleh JobDetailSheetJobfair
      nib: '',
      npwp: '',
      bidangUsaha: '',
      alamat: '',
      provinsi: '',
      kota: '',
      email: '',
      nomorTelepon: '',
      website: '',
      deskripsiPerusahaan: '',
      jumlahKaryawan: 0,
      kebijakanKerja: '',
      budayaPerusahaan: '',
      jumlahProyekBerjalan: 0,
      jobQualifications: [],
      jobBenefits: [],
      jobAdditionalRequirements: [],
      jobAdditionalFacilities: [],
    );
  }

  Future<void> _toggleBookmark(String lowonganId) async {
    try {
      // TODO: Implement bookmark functionality
      print('Bookmark toggled for: $lowonganId');
      // Panggil API untuk save/unsave job
    } catch (e) {
      print('Error toggling bookmark: $e');
    }
  }

  // Helper methods untuk _buildJobCard
  Widget _buildLogoPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.business, color: Color(0xFFCBD5E1), size: 20),
    );
  }

  Widget _buildJobTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(
        text.length > 15 ? '${text.substring(0, 15)}...' : text,
        style: const TextStyle(
          color: Color(0xFF666666),
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
              setState(() {
                _jobfairDetailFuture = _apiService.getJobfairDetailById(
                  widget.jobfairId,
                );
              });
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
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Kembali'),
          ),
        ],
      ),
    );
  }
}
