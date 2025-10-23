import 'package:flutter/material.dart';

class SocialMedia {
  final String? id;
  final String platform;
  final String username;
  final String profileUrl;

  SocialMedia({
    this.id,
    required this.platform,
    required this.username,
    required this.profileUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'platform': platform,
      'username': username,
      'profileUrl': profileUrl,
    };
  }

  factory SocialMedia.fromJson(Map<String, dynamic> json) {
    return SocialMedia(
      id: json['id'],
      platform: json['platform'] ?? '',
      username: json['username'] ?? '',
      profileUrl: json['profileUrl'] ?? '',
    );
  }

  SocialMedia copyWith({
    String? id,
    String? platform,
    String? username,
    String? profileUrl,
  }) {
    return SocialMedia(
      id: id ?? this.id,
      platform: platform ?? this.platform,
      username: username ?? this.username,
      profileUrl: profileUrl ?? this.profileUrl,
    );
  }
}

class TabMediaSosial extends StatefulWidget {
  const TabMediaSosial({super.key});

  @override
  State<TabMediaSosial> createState() => _TabMediaSosialState();
}

class _TabMediaSosialState extends State<TabMediaSosial> {
  List<SocialMedia> _socialMediaList = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSocialMedia();
  }

  Future<void> _loadSocialMedia() async {
    setState(() {
      _isLoading = true;
    });

    // TODO: Ganti dengan API call
    await Future.delayed(const Duration(milliseconds: 500));

    // Dummy data untuk testing
    setState(() {
      _socialMediaList = [
        SocialMedia(
          id: '1',
          platform: 'Instagram',
          username: 'pergijauh',
          profileUrl: 'https://instagram.com/pergijauh',
        ),
        SocialMedia(
          id: '2',
          platform: 'Facebook',
          username: 'pergijauh',
          profileUrl: 'https://facebook.com/pergijauh',
        ),
        SocialMedia(
          id: '3',
          platform: 'LinkedIn',
          username: 'pergijauh',
          profileUrl: 'https://linkedin.com/in/pergijauh',
        ),
      ];
      _isLoading = false;
    });
  }

  Future<void> _addSocialMedia(SocialMedia socialMedia) async {
    // TODO: Ganti dengan API call untuk create
    await Future.delayed(const Duration(milliseconds: 300));

    setState(() {
      _socialMediaList.add(
        socialMedia.copyWith(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
        ),
      );
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Media sosial berhasil ditambahkan',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
          backgroundColor: Colors.white,
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
  }

  Future<void> _updateSocialMedia(SocialMedia socialMedia) async {
    // TODO: Ganti dengan API call untuk update
    await Future.delayed(const Duration(milliseconds: 300));

    setState(() {
      final index = _socialMediaList.indexWhere(
        (item) => item.id == socialMedia.id,
      );
      if (index != -1) {
        _socialMediaList[index] = socialMedia;
      }
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Media sosial berhasil diperbarui',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
          backgroundColor: Colors.white,
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
  }

  Future<void> _deleteSocialMedia(String id) async {
    // TODO: Ganti dengan API call untuk delete
    await Future.delayed(const Duration(milliseconds: 300));

    setState(() {
      _socialMediaList.removeWhere((item) => item.id == id);
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Media sosial berhasil dihapus',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
          backgroundColor: Colors.white,
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
  }

  void _showAddEditDialog({SocialMedia? socialMedia}) {
    final isEdit = socialMedia != null;
    final platformController = TextEditingController(
      text: socialMedia?.platform ?? '',
    );
    final usernameController = TextEditingController(
      text: socialMedia?.username ?? '',
    );
    final urlController = TextEditingController(
      text: socialMedia?.profileUrl ?? '',
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
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Semua field harus diisi'),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          return;
                        }

                        final newSocialMedia = SocialMedia(
                          id: socialMedia?.id,
                          platform: platformController.text,
                          username: usernameController.text,
                          profileUrl: urlController.text,
                        );

                        if (isEdit) {
                          _updateSocialMedia(newSocialMedia);
                        } else {
                          _addSocialMedia(newSocialMedia);
                        }

                        Navigator.pop(context);
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

  void _showDeleteConfirmation(SocialMedia socialMedia) {
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
              _deleteSocialMedia(socialMedia.id!);
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
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
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
    );
  }

  Widget _buildSocialMediaItem({
    required SocialMedia socialMedia,
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