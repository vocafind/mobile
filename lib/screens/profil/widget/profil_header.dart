import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jobfair/screens/profil/keamanan_privasi.dart';

class ProfileHeader extends StatefulWidget {
  final TabController tabController;

  const ProfileHeader({
    super.key,
    required this.tabController,
  });

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> with SingleTickerProviderStateMixin {
  final GlobalKey _settingButtonKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  AnimationController? _animationController;
  Animation<double>? _scaleAnimation;
  Animation<double>? _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeOutBack,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _showSettingMenu() {
    final RenderBox? renderBox = _settingButtonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Background overlay
          GestureDetector(
            onTap: _removeOverlay,
            child: Container(
              color: Colors.transparent,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          // Setting menu
          Positioned(
            top: offset.dy + size.height + 8,
            right: MediaQuery.of(context).size.width - offset.dx - size.width,
            child: FadeTransition(
              opacity: _fadeAnimation!,
              child: ScaleTransition(
                scale: _scaleAnimation!,
                alignment: Alignment.topRight,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildMenuItem(
                          icon: Icons.security,
                          title: 'Keamanan dan Privasi',
                          onTap: () {
                          _removeOverlay();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SecurityPrivacyPage(),
                            ),
                          );
                        },
                        ),
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.grey.withValues(alpha: 0.2),
                        ),
                        _buildMenuItem(
                          icon: Icons.logout,
                          title: 'Logout',
                          isDestructive: true,
                          onTap: () {
                            _removeOverlay();
                            // Handle logout
                            _showLogoutConfirmation(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _animationController?.forward();
  }

  void _removeOverlay() {
    _animationController?.reverse().then((_) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isDestructive ? Colors.red : const Color(0xFF1B56FD),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w500,
                  color: isDestructive ? Colors.red : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Logout',
          style: TextStyle(
            fontFamily: 'SF Pro',
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text(
          'Apakah Anda yakin ingin keluar?',
          style: TextStyle(
            fontFamily: 'SF Pro',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Batal',
              style: TextStyle(
                fontFamily: 'SF Pro',
                color: Colors.grey,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle logout action
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Berhasil logout')),
              );
            },
            child: const Text(
              'Logout',
              style: TextStyle(
                fontFamily: 'SF Pro',
                color: Colors.red,
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
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1B56FD), Color(0xFF0118D8)],
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(23, 13, 23, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Danu Yudistia',
                          style: TextStyle(
                            color: Color(0xFFFFF8F8),
                            fontSize: 36,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        const Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Color(0xFFFFF8F8),
                              size: 14,
                            ),
                            SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                'Batam , Kepulauan Riau',
                                style: TextStyle(
                                  color: Color(0xFFFFF8F8),
                                  fontSize: 14,
                                  fontFamily: 'SF Pro',
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, -10),
                    child: InkWell(
                      key: _settingButtonKey,
                      onTap: _showSettingMenu,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                            'assets/icons/setting.svg',
                            colorFilter: const ColorFilter.mode(
                              Color(0xFFFFF8F8),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TabBar(
              controller: widget.tabController,
              isScrollable: true,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: EdgeInsets.zero,
              dividerColor: Colors.transparent,
              labelColor: const Color(0xFFFFF8F8),
              unselectedLabelColor: const Color(0xFFFFF8F8).withValues(alpha: 0.7),
              labelStyle: const TextStyle(
                fontSize: 16,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 16,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w400,
              ),
              tabAlignment: TabAlignment.start,
              padding: const EdgeInsets.symmetric(horizontal: 23),
              tabs: const [
                Tab(text: 'Profil'),
                Tab(text: 'Akademik'),
                Tab(text: 'Kompetensi'),
                Tab(text: 'Pengalaman'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}