import 'package:flutter/material.dart';
import 'package:jobfair/models/talent_social_media_model.dart';
import 'package:jobfair/api/api_service.dart';

class TabMediaSosial extends StatefulWidget {
  const TabMediaSosial({super.key});

  @override
  State<TabMediaSosial> createState() => _TabMediaSosialState();
}

class _TabMediaSosialState extends State<TabMediaSosial> {
  final ApiService _apiService = ApiService();
  List<SocialMediaModel> _socialMediaList = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Controllers
  final _platformController = TextEditingController();
  final _usernameController = TextEditingController();
  final _urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSocialMedia();
  }

  @override
  void dispose() {
    _platformController.dispose();
    _usernameController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  void _clearControllers() {
    _platformController.clear();
    _usernameController.clear();
    _urlController.clear();
  }

  Future<void> _loadSocialMedia() async {
    if (!mounted) return; // TAMBAHKAN INI

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final socialMedia = await _apiService.getSocialMedia();
      if (mounted) {
        // TAMBAHKAN INI
        setState(() {
          _socialMediaList = socialMedia;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        // TAMBAHKAN INI
        setState(() {
          _isLoading = false;
          _errorMessage = 'Gagal memuat data: ${e.toString()}';
        });
        _showSnackBar('Gagal memuat data media sosial', isError: true);
      }
    }
  }

  Future<void> _addSocialMedia(SocialMediaModel socialMedia) async {
    try {
      await _apiService.createSocialMedia(socialMedia);
      if (mounted) {
        // TAMBAHKAN INI
        await _loadSocialMedia();
        _showSnackBar('Media sosial berhasil ditambahkan');
      }
    } catch (e) {
      if (mounted) {
        // TAMBAHKAN INI
        _showSnackBar('Gagal menambahkan media sosial', isError: true);
      }
    }
  }

  Future<void> _updateSocialMedia(SocialMediaModel socialMedia) async {
    if (socialMedia.socialId == null) {
      if (mounted) {
        // TAMBAHKAN INI
        _showSnackBar('ID media sosial tidak valid', isError: true);
      }
      return;
    }

    try {
      await _apiService.updateSocialMedia(socialMedia.socialId!, socialMedia);
      if (mounted) {
        // TAMBAHKAN INI
        await _loadSocialMedia();
        _showSnackBar('Media sosial berhasil diperbarui');
      }
    } catch (e) {
      if (mounted) {
        // TAMBAHKAN INI
        _showSnackBar('Gagal memperbarui media sosial', isError: true);
      }
    }
  }

  Future<void> _deleteSocialMedia(String socialId) async {
    try {
      await _apiService.deleteSocialMedia(socialId);
      if (mounted) {
        // TAMBAHKAN INI
        await _loadSocialMedia();
        _showSnackBar('Media sosial berhasil dihapus');
      }
    } catch (e) {
      if (mounted) {
        // TAMBAHKAN INI
        _showSnackBar('Gagal menghapus media sosial', isError: true);
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return; // TAMBAHKAN INI - INI YANG PALING PENTING

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: isError ? Colors.red[100] : Colors.white,
        behavior: SnackBarBehavior.floating,
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ✅ Fungsi validasi URL yang ketat - HARUS lengkap dengan http/https
  bool _isValidUrl(String url) {
    try {
      final uri = Uri.tryParse(url);
      return uri != null &&
          uri.hasScheme &&
          (uri.scheme == 'http' || uri.scheme == 'https') &&
          uri.host.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  void _showAddEditModal({SocialMediaModel? socialMedia}) {
    final isEdit = socialMedia != null;

    // Buat controller lokal untuk modal
    final TextEditingController _platformControllerLocal =
        TextEditingController();
    final TextEditingController _usernameControllerLocal =
        TextEditingController();
    final TextEditingController _urlControllerLocal = TextEditingController();

    // Inisialisasi nilai jika edit
    if (socialMedia != null) {
      _platformControllerLocal.text = socialMedia.platform;
      _usernameControllerLocal.text = socialMedia.username;
      _urlControllerLocal.text = socialMedia.url;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: StatefulBuilder(
          builder: (context, setModalState) => Container(
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Text(
                          isEdit ? 'Edit Media Sosial' : 'Tambah Media Sosial',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (_platformControllerLocal.text.isEmpty ||
                              _usernameControllerLocal.text.isEmpty ||
                              _urlControllerLocal.text.isEmpty) {
                            // ✅ TAMBAHKAN mounted check di sini
                            if (mounted) {
                              _showSnackBar(
                                'Semua field harus diisi',
                                isError: true,
                              );
                            }
                            return;
                          }

                          // ✅ Validasi URL yang ketat - HARUS lengkap
                          final url = _urlControllerLocal.text.trim();

                          if (!_isValidUrl(url)) {
                            // ✅ TAMBAHKAN mounted check di sini
                            if (mounted) {
                              _showSnackBar(
                                'URL harus lengkap dengan http:// atau https:// (contoh: https://instagram.com/johndoe)',
                                isError: true,
                              );
                            }
                            return;
                          }

                          final newSocialMedia = SocialMediaModel(
                            socialId: socialMedia?.socialId,
                            platform: _platformControllerLocal.text,
                            username: _usernameControllerLocal.text,
                            url: url,
                          );

                          Navigator.pop(context);

                          if (isEdit) {
                            _updateSocialMedia(newSocialMedia);
                          } else {
                            _addSocialMedia(newSocialMedia);
                          }
                        },
                        child: const Text(
                          'Simpan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Form
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Keterangan
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFF81C784)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.info_outline,
                                color: Color(0xFF388E3C),
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Tambahkan akun media sosial Anda untuk memudahkan perusahaan mengenal profil Anda lebih baik.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.green.shade900,
                                    fontFamily: 'Poppins',
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        _buildTextField(
                          controller: _platformControllerLocal,
                          label: 'Platform',
                          hint: 'Contoh: Instagram, LinkedIn, Facebook',
                          icon: Icons.share_outlined,
                          required: true,
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          controller: _usernameControllerLocal,
                          label: 'Username',
                          hint: 'Contoh: johndoe atau @johndoe',
                          icon: Icons.alternate_email_outlined,
                          required: true,
                        ),
                        const SizedBox(height: 16),

                        _buildUrlTextField(
                          controller: _urlControllerLocal,
                          label: 'URL Profil',
                          hint: 'https://instagram.com/johndoe',
                          icon: Icons.link_outlined,
                          required: true,
                        ),

                        // Tombol Hapus (hanya untuk edit)
                        if (isEdit) ...[
                          const SizedBox(height: 32),
                          Center(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                _showDeleteConfirmation(socialMedia!);
                              },
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              label: const Text(
                                'Hapus Media Sosial',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.red),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    bool required = false,
    String? helperText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
                color: Color(0xFF515151),
              ),
            ),
            if (required)
              const Text(
                ' *',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14,
              fontFamily: 'Poppins',
            ),
            prefixIcon: Icon(icon, color: Colors.grey.shade600, size: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF113CEE), width: 2),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            helperText: helperText,
            helperStyle: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ],
    );
  }

  // ✅ Widget khusus untuk URL TextField dengan validasi ketat
  Widget _buildUrlTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool required = false,
    String? helperText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
                color: Color(0xFF515151),
              ),
            ),
            if (required)
              const Text(
                ' *',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.url,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14,
              fontFamily: 'Poppins',
            ),
            prefixIcon: Icon(icon, color: Colors.grey.shade600, size: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF113CEE), width: 2),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            helperText: helperText,
            helperStyle: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
              fontFamily: 'Poppins',
            ),
            // ✅ Tambahkan suffix icon untuk indikator validasi
            suffixIcon: ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, child) {
                if (value.text.isEmpty) return const SizedBox();

                final isValid = _isValidUrl(value.text.trim());

                return Icon(
                  isValid ? Icons.check_circle : Icons.error_outline,
                  color: isValid ? Colors.green : Colors.red,
                  size: 20,
                );
              },
            ),
          ),
        ),
        // ✅ Tambahkan pesan validasi real-time
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, child) {
            if (value.text.isEmpty) return const SizedBox();

            final isValid = _isValidUrl(value.text.trim());

            if (!isValid) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'URL harus lengkap dengan http:// atau https://',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.red.shade700,
                    fontFamily: 'Poppins',
                  ),
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ],
    );
  }

  void _showDeleteConfirmation(SocialMediaModel socialMedia) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: const Text(
          'Hapus Media Sosial',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus ${socialMedia.platform}?',
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Poppins',
            color: Color(0xFF515151),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Batal',
              style: TextStyle(
                color: Color(0xFF515151),
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (socialMedia.socialId != null) {
                _deleteSocialMedia(socialMedia.socialId!);
              }
            },
            child: const Text(
              'Hapus',
              style: TextStyle(
                color: Colors.red,
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF1B56FD)),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Color(0xFFB8B8B8)),
            const SizedBox(height: 16),
            const Text(
              'Terjadi Kesalahan',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                color: Color(0xFF515151),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  color: Color(0xFFB8B8B8),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadSocialMedia,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B56FD),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadSocialMedia,
      color: const Color(0xFF1B56FD),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 20),
        child: Column(
          children: [
            // Tombol Tambah
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => _showAddEditModal(),
                child: Container(
                  width: 39,
                  height: 39,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF113CEE)),
                  ),
                  child: const Center(
                    child: Text(
                      '+',
                      style: TextStyle(
                        color: Color(0xFF0C32E8),
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 21),

            // List atau Empty State
            if (_socialMediaList.isEmpty)
              Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.share_outlined,
                      size: 60,
                      color: Color(0xFFB8B8B8),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Belum ada media sosial',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF515151),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tambahkan media sosial Anda',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        color: Color(0xFFB8B8B8),
                      ),
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _socialMediaList.length,
                itemBuilder: (context, index) {
                  final socialMedia = _socialMediaList[index];
                  return _buildSocialMediaItem(
                    socialMedia: socialMedia,
                    isFirst: index == 0,
                    isLast: index == _socialMediaList.length - 1,
                  );
                },
              ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialMediaItem({
    required SocialMediaModel socialMedia,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return GestureDetector(
      onTap: () => _showAddEditModal(socialMedia: socialMedia),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: isLast ? Colors.transparent : const Color(0xFFE9E9E9),
              width: 1,
            ),
          ),
          borderRadius: isFirst
              ? const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                )
              : isLast
              ? const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                )
              : BorderRadius.zero,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSocialIcon(socialMedia.platform),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    socialMedia.platform,
                    style: const TextStyle(
                      color: Color(0xFF515151),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    socialMedia.username,
                    style: const TextStyle(
                      color: Color(0xFF515151),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    socialMedia.url,
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Icon(
              Icons.edit_outlined,
              size: 20,
              color: Colors.black.withValues(alpha: 0.62),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon(String platform) {
    final lowerPlatform = platform.toLowerCase();

    if (lowerPlatform.contains('instagram')) {
      return Container(
        width: 31,
        height: 31,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFDDD55), Color(0xFFFF543E), Color(0xFFC837AB)],
          ),
        ),
        child: Center(
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.camera_alt_outlined,
              size: 16,
              color: Color(0xFFC837AB),
            ),
          ),
        ),
      );
    } else if (lowerPlatform.contains('facebook')) {
      return Container(
        width: 31,
        height: 31,
        decoration: BoxDecoration(
          color: const Color(0xFF1877F2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            'f',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    } else if (lowerPlatform.contains('linkedin')) {
      return Container(
        width: 31,
        height: 31,
        decoration: BoxDecoration(
          color: const Color(0xFF0A66C2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            'in',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    } else if (lowerPlatform.contains('twitter') ||
        lowerPlatform.contains('x')) {
      return Container(
        width: 31,
        height: 31,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            'X',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    } else if (lowerPlatform.contains('tiktok')) {
      return Container(
        width: 31,
        height: 31,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Icon(Icons.music_note, size: 20, color: Colors.white),
        ),
      );
    } else if (lowerPlatform.contains('youtube')) {
      return Container(
        width: 31,
        height: 31,
        decoration: BoxDecoration(
          color: const Color(0xFFFF0000),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Icon(Icons.play_arrow, size: 20, color: Colors.white),
        ),
      );
    } else {
      return Container(
        width: 31,
        height: 31,
        decoration: BoxDecoration(
          color: const Color(0xFFB8B8B8),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Icon(Icons.share, size: 18, color: Colors.white),
        ),
      );
    }
  }
}
