import 'package:flutter/material.dart';
import 'package:jobfair/screens/halaman_beranda.dart';  
import 'package:jobfair/screens/halaman_cari_loker.dart';
import 'package:jobfair/screens/halaman_jobfair.dart';
import 'package:jobfair/screens/profil/halaman_profil.dart';
import 'package:jobfair/screens/halaman_lamaran.dart';




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

    // Navigate with replacement without transition
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: Duration.zero, // No transition
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  // Helper methods untuk lazy loading pages
  Widget _getBerandaPage() {
    return const HalamanBeranda();
  }

  Widget _getCariLokerPage() {
    return const HalamanCariLoker();
  }

  Widget _getJobfairPage() {
    return const HalamanJobfair();
  }

  Widget _getLamaranPage() {
    return const HalamanLamaran();
  }

  Widget _getProfilePage() {
    return const HalamanProfil();

  }

  // Widget _buildPlaceholder(String title, int index) {
  //   return Scaffold(
  //     backgroundColor: const Color(0xFFFFF8F8),
  //     body: Stack(
  //       children: [
  //         Center(
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Icon(
  //                 Icons.construction,
  //                 size: 100,
  //                 color: Colors.grey[400],
  //               ),
  //               const SizedBox(height: 16),
  //               Text(
  //                 'Halaman $title',
  //                 style: const TextStyle(
  //                   fontSize: 24,
  //                   fontWeight: FontWeight.w600,
  //                   fontFamily: 'Poppins',
  //                 ),
  //               ),
  //               const SizedBox(height: 8),
  //               Text(
  //                 'Sedang dalam pengembangan',
  //                 style: TextStyle(
  //                   fontSize: 14,
  //                   color: Colors.grey[600],
  //                   fontFamily: 'Poppins',
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Positioned(
  //           left: 0,
  //           right: 0,
  //           bottom: 0,
  //           child: BottomNavBar(currentIndex: index),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 28, right: 28, bottom: 20),
      height: 68,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha:0.5),
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
              size: 30,
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