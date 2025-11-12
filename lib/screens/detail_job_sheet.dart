import 'package:flutter/material.dart';
import 'package:jobfair/models/loker_umum_model.dart';

// Fungsi untuk membuka detail lowongan
void showJobDetail(BuildContext context, LokerUmum lowongan) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => JobDetailSheet(loker: lowongan),
  );
}

class JobDetailSheet extends StatefulWidget {
  final LokerUmum loker;

  const JobDetailSheet({super.key, required this.loker});

  @override
  State<JobDetailSheet> createState() => _JobDetailSheetState();
}

class _JobDetailSheetState extends State<JobDetailSheet> {
  int _selectedTab = 0;
  bool _isBookmarked = false;

  // Helper methods untuk mengakses data
  String get _posisi => widget.loker.posisi;
  String get _perusahaan => widget.loker.namaPerusahaan;
  String get _logo => widget.loker.logo;
  String get _deskripsi => widget.loker.deskripsiPekerjaan;
  String get _gaji => widget.loker.gaji;
  String get _lokasi => widget.loker.lokasi;
  bool get _isRemote => widget.loker.opsiKerjaRemote;
  String get _jenisPekerjaan => widget.loker.jenisPekerjaan;
  String get _pengalaman => widget.loker.tingkatPengalaman;
  String? get _minimalLulusan => widget.loker.minimalLulusan;
  String get _kontrakDurasi => widget.loker.kontrakDurasi;
  String get _peluangKarir => widget.loker.peluangKarir;
  int get _jumlahDibutuhkan => widget.loker.batasPelamar;
  int get _jumlahPelamar => widget.loker.jumlahPelamar;

  // Format gaji
  String _formatGaji(String gaji) {
    if (gaji.startsWith('Rp')) {
      return gaji;
    }
    return 'Rp $gaji';
  }

  // Clean HTML dari deskripsi
  String _cleanDescription(String description) {
    return description
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .trim();
  }

  // Format tanggal
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.92, // Sedikit dikurangi
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
                  padding: const EdgeInsets.fromLTRB(18, 20, 18, 20), // Padding bottom dikurangi
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 20), // Dikurangi dari 24
                    _buildInfoCards(),
                    const SizedBox(height: 20), // Dikurangi dari 24
                    _buildTabNavigation(),
                    const SizedBox(height: 16), // Dikurangi dari 22
                    if (_selectedTab == 0) _buildDetailPekerjaanTab(),
                    if (_selectedTab == 1) _buildCompanyTab(),
                    const SizedBox(height: 10), // Tambahkan sedikit spacing sebelum button
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
        color: const Color(0xFF162781).withValues(alpha:0.9),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget _buildHeader() {
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
          child: _logo.isNotEmpty
              ? Image.network(
                  _logo,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/icons/poltek.png',
                      fit: BoxFit.contain,
                    );
                  },
                )
              : Image.asset(
                  'assets/icons/poltek.png',
                  fit: BoxFit.contain,
                ),
        ),
        const SizedBox(width: 16), // Dikurangi dari 20
        
        // Job Title & Company
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _posisi,
                style: const TextStyle(
                  color: Color(0xFF1A1A1A),
                  fontSize: 22, // Sedikit dikurangi
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w500,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 6), // Dikurangi dari 8
              Text(
                _perusahaan,
                style: const TextStyle(
                  color: Color(0xFF515151),
                  fontSize: 15, // Sedikit dikurangi
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 6), // Dikurangi dari 8
              // Remote Tag
              if (_isRemote)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3), // Dikurangi
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6), // Dikurangi
                    border: Border.all(color: const Color(0xFFE2E2E2)),
                  ),
                  child: const Text(
                    'Remote',
                    style: TextStyle(
                      color: Color(0xFF464E5E),
                      fontSize: 11, // Dikurangi
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
            ],
          ),
        ),
        
        // Bookmark Icon
        IconButton(
          icon: _isBookmarked
              ? const Icon(Icons.bookmark, color: Color(0xFF0E37EB))
              : const Icon(Icons.bookmark_border),
          iconSize: 22, // Dikurangi
          onPressed: () {
            setState(() {
              _isBookmarked = !_isBookmarked;
            });
            // TODO: Handle bookmark logic
          },
        ),
      ],
    );
  }

  Widget _buildInfoCards() {
    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            'Dibutuhkan', 
            '${_jumlahDibutuhkan - _jumlahPelamar}'
          ),
        ),
        _buildDivider(),
        Expanded(
          child: _buildInfoCard(
            'Min. Lulusan', 
            _minimalLulusan ?? '-'
          ),
        ),
        _buildDivider(),
        Expanded(
          child: _buildInfoCard(
            'Jenis Pekerjaan', 
            _jenisPekerjaan
          ),
        ),
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
            fontSize: 13, // Dikurangi
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            height: 1.4, // Dikurangi
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2), // Dikurangi
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF515151),
            fontSize: 11, // Dikurangi
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w300,
            height: 1.2, // Dikurangi
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 20, // Dikurangi
      color: const Color(0xFFE9E9E9),
    );
  }

  Widget _buildTabNavigation() {
    return Container(
      height: 40, // Dikurangi
      decoration: BoxDecoration(
        color: const Color(0xFF162781).withValues(alpha:0.9),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          _buildTab('Detail Pekerjaan', 0),
          _buildTab('Perusahaan', 1),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          margin: const EdgeInsets.all(4), // Dikurangi
          decoration: BoxDecoration(
            color: isSelected 
                ? const Color(0xFF2345F7).withValues(alpha:0.7) 
                : Colors.transparent,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13, // Dikurangi
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailPekerjaanTab() {
    final cleanDescription = _cleanDescription(_deskripsi);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSection(
          title: 'Deskripsi Pekerjaan',
          child: Text(
            cleanDescription,
            textAlign: TextAlign.justify,
            style: const TextStyle(
              color: Color(0xFF515151),
              fontSize: 13,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
        ),

        _buildSection(
          title: 'Detail Pekerjaan',
          child: Column(
            children: [
              _buildDetailItem('Tingkat Pengalaman', _pengalaman),
              _buildDetailItem('Lokasi', _lokasi),
              if (_isRemote)
                _buildDetailItem('Tipe Kerja', 'Remote'),
              _buildDetailItem('Jenis Kontrak', _kontrakDurasi),
              _buildDetailItem('Peluang Karir', _peluangKarir),
              _buildDetailItem('Kuota Tersisa', '${_jumlahDibutuhkan - _jumlahPelamar} dari $_jumlahDibutuhkan posisi'),
              _buildDetailItem('Gaji', _formatGaji(_gaji)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12), // Dikurangi dari 16
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF515151),
                fontSize: 13, // Dikurangi
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF515151),
                fontSize: 13, // Dikurangi
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w400,
                height: 1.4,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSection(
          title: 'Tentang Perusahaan',
          child: Text(
            'Informasi tentang perusahaan $_perusahaan. Perusahaan ini saat ini membuka lowongan untuk posisi $_posisi dengan kualifikasi yang telah disebutkan.',
            textAlign: TextAlign.justify,
            style: const TextStyle(
              color: Color(0xFF515151),
              fontSize: 13,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
        ),

        _buildSection(
          title: 'Informasi Lowongan',
          child: Column(
            children: [
              _buildBulletPoint('Diposting: ${_formatDate(widget.loker.tanggalPosting)}', fontSize: 12),
              _buildBulletPoint('Batas Lamar: ${_formatDate(widget.loker.batasLamaran)}', fontSize: 12),
              _buildBulletPoint('Status: ${widget.loker.status}', fontSize: 12),
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
        const SizedBox(height: 16), // Dikurangi dari 20
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF191919),
            fontSize: 18, // Dikurangi
            fontFamily: 'SF Pro',
            fontWeight: FontWeight.w500,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 10), // Dikurangi dari 12
        child,
        const SizedBox(height: 16), // Dikurangi dari 24
        Container(height: 1, color: const Color(0xFFE9E9E9)),
      ],
    );
  }

  Widget _buildBulletPoint(String text, {double fontSize = 12}) { // Default dikurangi
    return Padding(
      padding: const EdgeInsets.only(bottom: 8), // Dikurangi dari 12
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5), // Dikurangi
            width: 6, // Dikurangi
            height: 6, // Dikurangi
            decoration: const BoxDecoration(
              color: Color(0xFF2643D7),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12), // Dikurangi dari 15
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: const Color(0xFF515151),
                fontSize: fontSize,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w400,
                height: 1.4, // Dikurangi
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplyButton() {
    final isExpired = widget.loker.batasLamaran.isBefore(DateTime.now());
    final isFull = widget.loker.jumlahPelamar >= widget.loker.batasPelamar;

    return Container(
      padding: const EdgeInsets.all(16), // Dikurangi dari 18
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 6, // Dikurangi
            offset: Offset(0, -1), // Dikurangi
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: (isExpired || isFull) 
            ? null 
            : () {
                // TODO: Handle apply action
                print('Melamar lowongan: ${widget.loker.posisi}');
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: (isExpired || isFull) 
              ? Colors.grey 
              : const Color(0xFF1548F5),
          minimumSize: const Size(double.infinity, 44), // Sedikit dikurangi
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          elevation: 0,
        ),
        child: Text(
          (isExpired) 
              ? 'Lowongan Telah Berakhir'
              : (isFull)
                  ? 'Kuota Telah Penuh'
                  : 'Lamar Sekarang',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15, // Dikurangi
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}