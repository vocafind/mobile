import 'package:flutter/material.dart';
import '/screens/halaman_beranda.dart';  
import '/screens/halaman_cari_loker.dart';
// import 'package:jobfair/screens/halaman_jobfair.dart';




class BottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int)? onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    this.onTap,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}


class _BottomNavBarState extends State<BottomNavBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void didUpdateWidget(BottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _animationController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleNavigation(int index) {
    if (index == widget.currentIndex) return;

    // Call onTap callback if provided
    if (widget.onTap != null) {
      widget.onTap!(index);
      return;
    }

    // Navigate to corresponding page
    Widget page;
    switch (index) {
      case 0:
        // Import manual di sini
        page = _getBerandaPage();
        break;
      case 1:
        page = _getCariLokerPage();
        break;
      case 2:
        page = _getJobfairPage();
        break;
      case 3:
        page = _getLamaranPage();
        break;
      case 4:
        page = _getProfilePage();
        break;
      default:
        return;
    }

    // Navigate with replacement to avoid stack buildup
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 200),
      ),
    );
  }

  // Helper methods untuk lazy loading pages
  Widget _getBerandaPage() {
    // Import manual - uncomment ketika halaman sudah siap
    // import '../screens/halaman_beranda.dart';
    return const HalamanBeranda();
    
    // Sementara gunakan placeholder, atau bisa langsung return halaman asli
    // Contoh jika sudah ada:
    // return const HalamanBeranda();
    // return _buildPlaceholder('Beranda', 0);
  }

  Widget _getCariLokerPage() {
    // Import manual - uncomment ketika halaman sudah siap
    // import '../screens/halaman_cari_loker.dart';
    return const HalamanCariLoker();
    
    // Sementara gunakan placeholder
    // return _buildPlaceholder('Cari Loker', 1);
  }

  Widget _getJobfairPage() {
    // Import manual - uncomment ketika halaman sudah siap
    // import '../screens/halaman_jobfair.dart';
    // return const HalamanJobfair();
    
    return _buildPlaceholder('Jobfair', 2);
  }

  Widget _getLamaranPage() {
    // Import manual - uncomment ketika halaman sudah siap
    // import '../screens/halaman_lamaran.dart';
    // return const HalamanLamaran();
    
    return _buildPlaceholder('Lamaran', 3);
  }

  Widget _getProfilePage() {
    // Import manual - uncomment ketika halaman sudah siap
    // import '../screens/halaman_profile.dart';
    // return const HalamanProfile();
    
    return _buildPlaceholder('Profile', 4);
  }

  Widget _buildPlaceholder(String title, int index) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F8),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.construction,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Halaman $title',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sedang dalam pengembangan',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomNavBar(currentIndex: index),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 28, right: 28, bottom: 20),
      height: 58,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(60),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavButton(
              index: 0,
              icon: Icons.home_outlined,
              label: 'Beranda',
            ),
            _buildNavButton(
              index: 1,
              icon: Icons.search,
              label: 'Cari Loker',
            ),
            _buildNavButton(
              index: 2,
              icon: Icons.favorite_border,
              label: 'Jobfair',
            ),
            _buildNavButton(
              index: 3,
              icon: Icons.description_outlined,
              label: 'Lamaran',
            ),
            _buildNavButton(
              index: 4,
              icon: Icons.person_outline,
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final bool isActive = widget.currentIndex == index;

    return GestureDetector(
      onTap: () => _handleNavigation(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 16 : 8,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(45),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.black : Colors.white,
              size: 20,
            ),
            if (isActive) ...[
              const SizedBox(width: 8),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}