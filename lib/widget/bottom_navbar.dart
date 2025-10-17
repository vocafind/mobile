import 'package:flutter/material.dart';
import 'package:jobfair/screens/halaman_beranda.dart';  
import 'package:jobfair/screens/halaman_cari_loker.dart';
import 'package:jobfair/screens/halaman_jobfair.dart';
import 'package:jobfair/screens/profil/halaman_profil.dart';
import 'package:jobfair/screens/halaman_lamaran.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
        page = const HalamanBeranda();
        break;
      case 1:
        page = const HalamanCariLoker();
        break;
      case 2:
        page = const HalamanJobfair();
        break;
      case 3:
        page = const HalamanLamaran();
        break;
      case 4:
        page = const HalamanProfil();
        break;
      default:
        return;
    }

    // Navigate with replacement without transition
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 28, right: 28, bottom: 20),
      height: 68,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(60),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavButton(
              index: 0,
              svgPath: 'assets/icons/home.svg',
              label: 'Beranda',
            ),
            _buildNavButton(
              index: 1,
              svgPath: 'assets/icons/search.svg',
              label: 'Cari Loker',
            ),
            _buildNavButton(
              index: 2,
              svgPath: 'assets/icons/jobfairIcon.svg',
              label: 'Jobfair',
            ),
            _buildNavButton(
              index: 3,
              svgPath: 'assets/icons/lamaran.svg',
              label: 'Lamaran',
            ),
            _buildNavButton(
              index: 4,
              svgPath: 'assets/icons/profile.svg',
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton({
    required int index,
    required String svgPath,
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
            SvgPicture.asset(
              svgPath,
              width: 30,
              height: 30,
              colorFilter: ColorFilter.mode(
                isActive ? Colors.black : Colors.white,
                BlendMode.srcIn,
              ),
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