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

  @override
  void initState() {
    super.initState();
    _loadSocialMedia();
  }

  Future<void> _loadSocialMedia() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final socialMedia = await _apiService.getSocialMedia();
      setState(() {
        _socialMediaList = socialMedia;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Gagal memuat data: ${e.toString()}';
      });
      if (mounted) {
        _showSnackBar('Gagal memuat data media sosial', isError: true);
      }
    }
  }

  Future<void> _addSocialMedia(SocialMediaModel socialMedia) async {
    try {
      await _apiService.createSocialMedia(socialMedia);
      
      // Reload data setelah berhasil tambah
      await _loadSocialMedia();

      if (mounted) {
        _showSnackBar('Media sosial berhasil ditambahkan');
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Gagal menambahkan media sosial', isError: true);
      }
    }
  }

  Future<void> _updateSocialMedia(SocialMediaModel socialMedia) async {
    if (socialMedia.socialId == null) {
      _showSnackBar('ID media sosial tidak valid', isError: true);
      return;
    }

    try {
      await _apiService.updateSocialMedia(
        socialMedia.socialId!,
        socialMedia,
      );
      
      // Reload data setelah berhasil update
      await _loadSocialMedia();

      if (mounted) {
        _showSnackBar('Media sosial berhasil diperbarui');
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Gagal memperbarui media sosial', isError: true);
      }
    }
  }

  Future<void> _deleteSocialMedia(String socialId) async {
    try {
      await _apiService.deleteSocialMedia(socialId);
      
      // Reload data setelah berhasil hapus
      await _loadSocialMedia();

      if (mounted) {
        _showSnackBar('Media sosial berhasil dihapus');
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Gagal menghapus media sosial', isError: true);
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showAddEditDialog({SocialMediaModel? socialMedia}) {
    final isEdit = socialMedia != null;
    final platformController = TextEditingController(
      text: socialMedia?.platform ?? '',
    );
    final usernameController = TextEditingController(
      text: socialMedia?.username ?? '',
    );
    final urlController = TextEditingController(
      text: socialMedia?.url ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEdit ? 'Edit Media Sosial' : 'Tambah Media Sosial',
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF515151),
                ),
              ),
              const SizedBox(height: 24),
              _buildDialogTextField(
                controller: platformController,
                label: 'Platform',
                hint: 'Contoh: Instagram, Facebook, LinkedIn',
              ),
              const SizedBox(height: 16),
              _buildDialogTextField(
                controller: usernameController,
                label: 'Username',
                hint: 'Contoh: johndoe',
              ),
              const SizedBox(height: 16),
              _buildDialogTextField(
                controller: urlController,
                label: 'URL Profil',
                hint: 'Contoh: https://instagram.com/johndoe',
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Color(0xFFE8E8E8)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Batal',
                        style: TextStyle(
                          color: Color(0xFF515151),
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (platformController.text.isEmpty ||
                            usernameController.text.isEmpty ||
                            urlController.text.isEmpty) {
                          _showSnackBar('Semua field harus diisi', isError: true);
                          return;
                        }

                        final newSocialMedia = SocialMediaModel(
                          socialId: socialMedia?.socialId,
                          platform: platformController.text,
                          username: usernameController.text,
                          url: urlController.text,
                        );

                        Navigator.pop(context);

                        if (isEdit) {
                          _updateSocialMedia(newSocialMedia);
                        } else {
                          _addSocialMedia(newSocialMedia);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B56FD),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        isEdit ? 'Simpan' : 'Tambah',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (isEdit) ...[
                const SizedBox(height: 16),
                Center(
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _showDeleteConfirmation(socialMedia);
                    },
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    label: const Text(
                      'Hapus Media Sosial',
                      style: TextStyle(
                        color: Colors.red,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDialogTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            color: Color(0xFF515151),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Poppins',
            color: Color(0xFF515151),
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins',
              color: Color(0xFFB8B8B8),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF98AFFF)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF98AFFF),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF1548F5),
                width: 2,
              ),
            ),
          ),
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
        child: CircularProgressIndicator(
          color: Color(0xFF1B56FD),
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 60,
              color: Color(0xFFB8B8B8),
            ),
            const SizedBox(height: 16),
            Text(
              'Terjadi Kesalahan',
              style: const TextStyle(
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
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => _showAddEditDialog(),
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
            const SizedBox(height: 16),
            if (_socialMediaList.isEmpty)
              Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: const [
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
    return InkWell(
      onTap: () => _showAddEditDialog(socialMedia: socialMedia),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: isLast ? Colors.transparent : const Color(0xFFE8E8E8),
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
          children: [
            _buildSocialIcon(socialMedia.platform),
            const SizedBox(width: 20),
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
                  const SizedBox(height: 4),
                  Text(
                    socialMedia.username,
                    style: const TextStyle(
                      color: Color(0xFF515151),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 24,
              color: Color(0xFF515151),
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