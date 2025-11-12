import 'package:flutter/material.dart';
import 'package:jobfair/models/loker_umum_detail_model.dart';

class JobDetailSheet extends StatefulWidget {
  final LokerUmumDetail? loker;

  const JobDetailSheet({super.key, this.loker});

  @override
  State<JobDetailSheet> createState() => _JobDetailSheetState();
}

class _JobDetailSheetState extends State<JobDetailSheet> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.95,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
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
                  padding: const EdgeInsets.fromLTRB(18, 30, 18, 20), // Reduced bottom padding from 100 to 20
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 20), // Reduced from 24
                    _buildInfoCards(),
                    const SizedBox(height: 20), // Reduced from 24
                    _buildTabNavigation(),
                    const SizedBox(height: 16), // Reduced from 22
                    if (_selectedTab == 0) _buildDescriptionTab(),
                    if (_selectedTab == 1) _buildCompanyTab(),
                    const SizedBox(height: 8), // Small spacer before button
                  ],
                ),
              ),

              // Fixed Apply Button
              _buildApplyButton(),
            ],
          ),
        );
      },
    );
  }

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
              const SizedBox(height: 6), // Reduced from 8
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
              const SizedBox(height: 6), // Reduced from 8

              // Job Type & Experience Tags
              Wrap(
                spacing: 8,
                runSpacing: 6, // Reduced runSpacing
                children: [
                  if (isRemote) _buildTag('Remote'),
                  if (jenisPekerjaan.isNotEmpty) _buildTag(jenisPekerjaan),
                  if (tingkatPengalaman.isNotEmpty) _buildTag(tingkatPengalaman),
                ],
              ),
            ],
          ),
        ),

        // Bookmark Icon
        IconButton(
          icon: const Icon(Icons.bookmark_border),
          iconSize: 24,
          onPressed: () {
            // Handle bookmark
          },
        ),
      ],
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), // Reduced padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6), // Slightly smaller
        border: Border.all(color: const Color(0xFFE2E2E2)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF464E5E),
          fontSize: 11, // Slightly smaller
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
            height: 1.5, // Reduced height
          ),
        ),
        const SizedBox(height: 2), // Small spacer
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF515151),
            fontSize: 11, // Slightly smaller
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w300,
            height: 1.2, // Reduced height
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
      height: 42, // Slightly smaller
      decoration: BoxDecoration(
        color: const Color(0xFF162781).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [_buildTab('Deskripsi', 0), _buildTab('Perusahaan', 1)],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          margin: const EdgeInsets.all(4), // Reduced margin
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
                fontSize: 13, // Slightly smaller
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
    final additionalRequirements = widget.loker?.jobAdditionalRequirements ?? [];
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

        // Gaji Section - More compact
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 16), // Reduced padding
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Gaji',
                style: TextStyle(
                  color: Color(0xFF191919),
                  fontSize: 18, // Slightly smaller
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
                  fontSize: 16, // Slightly smaller
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        Container(height: 1, color: const Color(0xFFE9E9E9)),
        
        // Add small spacer at the very bottom
        const SizedBox(height: 4),
      ],
    );
  }

  Widget _buildCompanyTab() {
    final namaPerusahaan = widget.loker?.namaPerusahaan ?? 'Perusahaan';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSection(
          title: 'Tentang Perusahaan',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                namaPerusahaan,
                style: const TextStyle(
                  color: Color(0xFF1A1A1A),
                  fontSize: 18, // Slightly smaller
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8), // Reduced from 12
              const Text(
                'Informasi detail tentang perusahaan akan ditampilkan di sini. '
                'Anda dapat menambahkan field tambahan di model untuk informasi '
                'seperti deskripsi perusahaan, alamat, website, dll.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Color(0xFF515151),
                  fontSize: 13,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w400,
                  height: 1.4, // Reduced height
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16), // Reduced from 20
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF191919),
            fontSize: 18, // Slightly smaller
            fontFamily: 'SF Pro',
            fontWeight: FontWeight.w500,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8), // Reduced from 12
        child,
        const SizedBox(height: 16), // Reduced from 24
        Container(height: 1, color: const Color(0xFFE9E9E9)),
      ],
    );
  }

  Widget _buildBulletPoint(String text, {double fontSize = 12}) { // Default smaller
    return Padding(
      padding: const EdgeInsets.only(bottom: 8), // Reduced from 12
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5), // Adjusted
            width: 6, // Slightly smaller
            height: 6, // Slightly smaller
            decoration: const BoxDecoration(
              color: Color(0xFF2643D7),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12), // Reduced from 15
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: const Color(0xFF515151),
                fontSize: fontSize,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w400,
                height: 1.4, // Reduced height
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
    final isExpired = widget.loker?.batasLamaran.isBefore(DateTime.now()) ?? false;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 18), // Reduced top padding
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
        onPressed: (isKuotaPenuh || isExpired)
            ? null
            : () {
                // Handle apply action
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: (isKuotaPenuh || isExpired)
              ? Colors.grey
              : const Color(0xFF1548F5),
          minimumSize: const Size(double.infinity, 48), // Slightly taller for better touch
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          elevation: 0,
        ),
        child: Text(
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