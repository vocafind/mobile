import 'package:flutter/material.dart';
import 'package:jobfair/api/api_service.dart';
import 'package:jobfair/models/loker_umum_detail_model.dart';

class JobDetailSheetJobfair extends StatefulWidget {
  final LokerUmumDetail? loker;

  const JobDetailSheetJobfair({super.key, this.loker});

  @override
  State<JobDetailSheetJobfair> createState() => _JobDetailSheetJobfairState();
}

class _JobDetailSheetJobfairState extends State<JobDetailSheetJobfair>
    with SingleTickerProviderStateMixin {
  int _selectedTab = 0;
  bool _isLoading = false;
  bool _isSaved = false;
  bool _checkingSavedStatus = true;
  final ApiService _apiService = ApiService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Tambahkan GlobalKey untuk ScaffoldMessenger
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  // Animation controller untuk bookmark
  late AnimationController _bookmarkController;
  late Animation<double> _bookmarkScale;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _bookmarkController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _bookmarkScale = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _bookmarkController, curve: Curves.easeInOut),
    );

    // Check saved status ketika detail dibuka
    _checkSavedStatus();
  }

  @override
  void dispose() {
    _bookmarkController.dispose();
    super.dispose();
  }

  // Fungsi untuk mengecek status saved job
  Future<void> _checkSavedStatus() async {
    if (widget.loker?.lowonganId == null) {
      setState(() {
        _checkingSavedStatus = false;
      });
      return;
    }

    try {
      final isSaved = await _apiService.checkIfJobIsSaved(
        widget.loker!.lowonganId,
      );
      setState(() {
        _isSaved = isSaved;
        _checkingSavedStatus = false;
      });
    } catch (e) {
      print("❌ Error checking saved status: $e");
      setState(() {
        _checkingSavedStatus = false;
      });
    }
  }

  // Fungsi untuk toggle save/unsave job
  Future<void> _toggleSaveJob() async {
    if (widget.loker?.lowonganId == null) return;

    // Update UI immediately for better UX
    setState(() {
      _isSaved = !_isSaved;
    });

    // Play animation
    _bookmarkController.forward().then((_) {
      _bookmarkController.reverse();
    });

    try {
      if (_isSaved) {
        // Save job
        await _apiService.saveJob(widget.loker!.lowonganId);
        print("✅ Job saved: ${widget.loker!.lowonganId}");
      } else {
        // Unsave job
        await _apiService.unsaveJobByLowonganId(widget.loker!.lowonganId);
        print("✅ Job unsaved: ${widget.loker!.lowonganId}");
      }
    } catch (e) {
      // Rollback UI state if API call fails
      setState(() {
        _isSaved = !_isSaved;
      });
      print("❌ Error toggling save job: $e");
    }
  }

  // ✅ PERBAIKAN: Fungsi snackbar dengan style yang sama seperti JobDetailSheet
  void _showSnackBar(String message, {bool isError = false}) {
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: isError ? Colors.red[700] : Colors.green,
        behavior: SnackBarBehavior.floating,
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(
          textColor: Colors.white,
          label: 'Ok', 
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          }
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  // Di fungsi _lamarLoker di JobDetailSheetJobfair
  Future<void> _lamarJobfair() async {
    if (widget.loker?.lowonganId == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _apiService.lamarJobfair(widget.loker!.lowonganId);

      if (mounted) {
        _showSnackBar(response.message);

        // Return true untuk trigger refresh di halaman jobfair detail
        Future.delayed(const Duration(seconds: 5), () {
          if (mounted) {
            Navigator.of(context).pop(true); // Return true untuk trigger refresh
          }
        });
      }
    } catch (e) {
      if (mounted) {
        final cleanError = e.toString().replaceAll('Exception:', '').trim();
        _showSnackBar(cleanError, isError: true);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.95,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return ScaffoldMessenger(
          key: _scaffoldMessengerKey,
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.transparent,
            body: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x40000000),
                    blurRadius: 4,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Drag Handle
                  _buildDragHandle(),

                  // Scrollable Content
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(18, 30, 18, 100),
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 24),
                        _buildInfoCards(),
                        const SizedBox(height: 24),
                        _buildTabNavigation(),
                        const SizedBox(height: 22),
                        if (_selectedTab == 0) _buildDescriptionTab(),
                        if (_selectedTab == 1) _buildCompanyTab(),
                      ],
                    ),
                  ),

                  // Fixed Apply Button
                  _buildApplyButton(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ... (method-method lainnya tetap sama)
  Widget _buildDragHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      width: 143,
      height: 5,
      decoration: BoxDecoration(
        color: const Color(0xFF162781).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget _buildHeader() {
    final namaPerusahaan = widget.loker?.namaPerusahaan ?? 'Perusahaan';
    final logo = widget.loker?.logo ?? 'assets/icons/icon.png';
    final jobTitle = widget.loker?.posisi ?? 'Posisi';
    final isRemote = widget.loker?.opsiKerjaRemote ?? false;
    final jenisPekerjaan = widget.loker?.jenisPekerjaan ?? '';
    final tingkatPengalaman = widget.loker?.tingkatPengalaman ?? '';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Company Logo
        Container(
          width: 60,
          height: 53,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFF1F5F9)),
          ),
          padding: const EdgeInsets.all(8),
          child: logo.startsWith('http')
              ? Image.network(
                  logo,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/icons/icon.png',
                      fit: BoxFit.contain,
                    );
                  },
                )
              : Image.asset(logo, fit: BoxFit.contain),
        ),
        const SizedBox(width: 20),

        // Job Title & Company
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                jobTitle,
                style: const TextStyle(
                  color: Color(0xFF1A1A1A),
                  fontSize: 24,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w500,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                namaPerusahaan,
                style: const TextStyle(
                  color: Color(0xFF515151),
                  fontSize: 16,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 8),

              // Job Type & Experience Tags
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (isRemote) _buildTag('Remote'),
                  if (jenisPekerjaan.isNotEmpty) _buildTag(jenisPekerjaan),
                  if (tingkatPengalaman.isNotEmpty)
                    _buildTag(tingkatPengalaman),
                ],
              ),
            ],
          ),
        ),

        // Bookmark Icon dengan animation
        ScaleTransition(
          scale: _bookmarkScale,
          child: IconButton(
            icon: _checkingSavedStatus
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.grey.shade400,
                      ),
                    ),
                  )
                : AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _isSaved
                        ? Icon(
                            Icons.bookmark,
                            key: const ValueKey('saved'),
                            color: const Color(0xFF0E37EB),
                            size: 24,
                          )
                        : Icon(
                            Icons.bookmark_border,
                            key: const ValueKey('unsaved'),
                            color: Colors.black.withValues(alpha: 0.3),
                            size: 24,
                          ),
                  ),
            onPressed: _checkingSavedStatus ? null : _toggleSaveJob,
          ),
        ),
      ],
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E2E2)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF464E5E),
          fontSize: 12,
          fontFamily: 'SF Pro',
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildInfoCards() {
    final batasPelamar = widget.loker?.batasPelamar ?? 0;
    final minimalLulusan = widget.loker?.minimalLulusan ?? '-';
    final jenisPekerjaan = widget.loker?.jenisPekerjaan ?? '-';

    return Row(
      children: [
        Expanded(child: _buildInfoCard('Dibutuhkan', '$batasPelamar')),
        _buildDivider(),
        Expanded(child: _buildInfoCard('Min Lulusan', minimalLulusan)),
        _buildDivider(),
        Expanded(child: _buildInfoCard('Jenis Pekerjaan', jenisPekerjaan)),
      ],
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF515151),
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            height: 1.71,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF515151),
            fontSize: 12,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w300,
            height: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(width: 1.4, height: 26, color: const Color(0xFFE9E9E9));
  }

  Widget _buildTabNavigation() {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: const Color(0xFF162781).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [_buildTab('Detail', 0), _buildTab('Perusahaan', 1)],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF2345F7).withValues(alpha: 0.7)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Center(
            child: Text(
              title,
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
    );
  }

  Widget _buildDescriptionTab() {
    final qualifications = widget.loker?.jobQualifications ?? [];
    final benefits = widget.loker?.jobBenefits ?? [];
    final additionalRequirements =
        widget.loker?.jobAdditionalRequirements ?? [];
    final additionalFacilities = widget.loker?.jobAdditionalFacilities ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Kualifikasi & Persyaratan
        if (qualifications.isNotEmpty)
          _buildSection(
            title: 'Kualifikasi & Persyaratan',
            child: Column(
              children: qualifications
                  .map(
                    (qualification) =>
                        _buildBulletPoint(qualification.kualifikasi),
                  )
                  .toList(),
            ),
          ),

        // Benefit
        if (benefits.isNotEmpty)
          _buildSection(
            title: 'Benefit',
            child: Column(
              children: benefits
                  .map(
                    (benefit) =>
                        _buildBulletPoint(benefit.benefit, fontSize: 12),
                  )
                  .toList(),
            ),
          ),

        // Persyaratan Tambahan
        if (additionalRequirements.isNotEmpty)
          _buildSection(
            title: 'Persyaratan Tambahan',
            child: Column(
              children: additionalRequirements
                  .map(
                    (requirement) => _buildBulletPoint(
                      requirement.persyaratan,
                      fontSize: 12,
                    ),
                  )
                  .toList(),
            ),
          ),

        // Fasilitas
        if (additionalFacilities.isNotEmpty)
          _buildSection(
            title: 'Fasilitas',
            child: Column(
              children: additionalFacilities
                  .map(
                    (facility) =>
                        _buildBulletPoint(facility.fasilitas, fontSize: 12),
                  )
                  .toList(),
            ),
          ),

        // Gaji
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment:
                CrossAxisAlignment.center, // penting biar sejajar
            children: [
              const Text(
                'Gaji',
                style: TextStyle(
                  color: Color(0xFF191919),
                  fontSize: 20,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                ),
              ),
              Text(
                widget.loker?.gaji != null && widget.loker!.gaji.isNotEmpty
                    ? '${widget.loker!.gaji}'
                    : '-',
                style: const TextStyle(
                  fontSize: 17, // sedikit lebih besar biar menonjol
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        Container(height: 1, color: const Color(0xFFE9E9E9)),
      ],
    );
  }

  String removeHtmlTags(String htmlText) {
    final regex = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false);
    return htmlText.replaceAll(regex, '').trim();
  }

  Widget _buildCompanyTab() {
    final loker = widget.loker;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tentang Perusahaan
        if (loker?.deskripsiPerusahaan != null &&
            loker!.deskripsiPerusahaan!.isNotEmpty)
          _buildSection(
            title: 'Tentang Perusahaan',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loker.namaPerusahaan,
                  style: const TextStyle(
                    color: Color(0xFF1A1A1A),
                    fontSize: 14,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  removeHtmlTags(loker.deskripsiPerusahaan!),
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    color: Color(0xFF515151),
                    fontSize: 13,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

        // Informasi Perusahaan
        _buildSection(
          title: 'Informasi Perusahaan',
          child: Column(
            children: [
              if (loker?.bidangUsaha != null && loker!.bidangUsaha.isNotEmpty)
                _buildCompanyInfoRow('Bidang Usaha', loker.bidangUsaha),

              if (loker?.alamat != null && loker!.alamat.isNotEmpty)
                _buildCompanyInfoRow(
                  'Alamat',
                  '${loker.alamat}${loker.kota.isNotEmpty ? ', ${loker.kota}' : ''}${loker.provinsi.isNotEmpty ? ', ${loker.provinsi}' : ''}',
                ),

              if (loker?.email != null && loker!.email.isNotEmpty)
                _buildCompanyInfoRow('Email', loker.email),

              if (loker?.nomorTelepon != null && loker!.nomorTelepon.isNotEmpty)
                _buildCompanyInfoRow('Telepon', loker.nomorTelepon),

              if (loker?.website != null && loker!.website!.isNotEmpty)
                _buildCompanyInfoRow('Website', loker.website!),

              if (loker?.jumlahKaryawan != null)
                _buildCompanyInfoRow(
                  'Jumlah Karyawan',
                  '${loker?.jumlahKaryawan ?? '-'} orang',
                ),

              if (loker?.jumlahProyekBerjalan != null)
                _buildCompanyInfoRow(
                  'Proyek Berjalan',
                  '${loker?.jumlahProyekBerjalan ?? '-'} proyek',
                ),
            ],
          ),
        ),

        // Kebijakan Kerja
        if (loker?.kebijakanKerja != null && loker!.kebijakanKerja!.isNotEmpty)
          _buildSection(
            title: 'Kebijakan Kerja',
            child: Text(
              removeHtmlTags(loker.kebijakanKerja!),
              textAlign: TextAlign.justify,
              style: const TextStyle(
                color: Color(0xFF515151),
                fontSize: 13,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w400,
                height: 1.4,
              ),
            ),
          ),

        // Budaya Perusahaan
        if (loker?.budayaPerusahaan != null &&
            loker!.budayaPerusahaan!.isNotEmpty)
          _buildSection(
            title: 'Budaya Perusahaan',
            child: Text(
              removeHtmlTags(loker.budayaPerusahaan!),
              textAlign: TextAlign.justify,
              style: const TextStyle(
                color: Color(0xFF515151),
                fontSize: 13,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w400,
                height: 1.4,
              ),
            ),
          ),
      ],
    );
  }

  // Widget untuk baris informasi perusahaan
  Widget _buildCompanyInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF515151),
                fontSize: 13,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF515151),
                fontSize: 13,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //non perusahaan
  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF191919),
            fontSize: 20,
            fontFamily: 'SF Pro',
            fontWeight: FontWeight.w500,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        child,
        const SizedBox(height: 24),
        Container(height: 1, color: const Color(0xFFE9E9E9)),
      ],
    );
  }

  Widget _buildBulletPoint(String text, {double fontSize = 13}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: Color(0xFF2643D7),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: const Color(0xFF515151),
                fontSize: fontSize,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w400,
                height: 1.54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF515151),
                fontSize: 13,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF515151),
                fontSize: 13,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplyButton() {
    final jumlahPelamar = widget.loker?.jumlahPelamar ?? 0;
    final batasPelamar = widget.loker?.batasPelamar ?? 0;
    final isKuotaPenuh = jumlahPelamar >= batasPelamar;
    final isExpired =
        widget.loker?.batasLamaran.isBefore(DateTime.now()) ?? false;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: (isKuotaPenuh || isExpired || _isLoading)
            ? null
            : _lamarJobfair, // Ganti dengan _lamarJobfair
        style: ElevatedButton.styleFrom(
          backgroundColor: (isKuotaPenuh || isExpired)
              ? Colors.grey
              : const Color(0xFF1548F5),
          minimumSize: const Size(double.infinity, 45),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                isKuotaPenuh
                    ? 'Kuota Penuh'
                    : isExpired
                    ? 'Lowongan Ditutup'
                    : 'Lamar Sekarang',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return '${date.day}/${date.month}/${date.year}';
  }
}