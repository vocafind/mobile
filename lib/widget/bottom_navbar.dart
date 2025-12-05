import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';
import 'package:jobfair/api/route.dart'; // ✅ Import route.dart

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

  // ✅ UPDATED: Gunakan route.dart untuk navigasi
  void _handleNavigation(int index) {
    if (index == widget.currentIndex) return;

    // Jika ada custom onTap handler
    if (widget.onTap != null) {
      widget.onTap!(index);
      return;
    }

    // ✅ Gunakan route name dari AppRoutes
    String routeName;
    switch (index) {
      case 0:
        routeName = AppRoutes.beranda;
        break;
      case 1:
        routeName = AppRoutes.cariLoker;
        break;
      case 2:
        routeName = AppRoutes.jobfair;
        break;
      case 3:
        routeName = AppRoutes.lamaran;
        break;
      case 4:
        routeName = AppRoutes.profil;
        break;
      default:
        return;
    }

    
    goReplace(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    
    final isSmallDevice = screenWidth < 360;
    
    return Container(
      margin: EdgeInsets.only(
        left: isSmallDevice ? 16 : 28,
        right: isSmallDevice ? 16 : 28,
        bottom: isSmallDevice ? 12 : 20,
      ),
      height: isSmallDevice ? 60 : 68,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(60),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(60),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isSmallDevice ? 4 : 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavButton(
                    index: 0,
                    svgPath: 'assets/icons/home.svg',
                    label: 'Beranda',
                    isSmallDevice: isSmallDevice,
                  ),
                  _buildNavButton(
                    index: 1,
                    svgPath: 'assets/icons/search.svg',
                    label: isSmallDevice ? 'Cari' : 'Cari Loker',
                    isSmallDevice: isSmallDevice,
                  ),
                  _buildNavButton(
                    index: 2,
                    svgPath: 'assets/icons/jobfairIcon.svg',
                    label: 'Jobfair',
                    isSmallDevice: isSmallDevice,
                  ),
                  _buildNavButton(
                    index: 3,
                    svgPath: 'assets/icons/lamaran.svg',
                    label: 'Lamaran',
                    isSmallDevice: isSmallDevice,
                  ),
                  _buildNavButton(
                    index: 4,
                    svgPath: 'assets/icons/profile.svg',
                    label: 'Profil',
                    isSmallDevice: isSmallDevice,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton({
    required int index,
    required String svgPath,
    required String label,
    required bool isSmallDevice,
  }) {
    final bool isActive = widget.currentIndex == index;

    return GestureDetector(
      onTap: () => _handleNavigation(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isActive 
              ? (isSmallDevice ? 12 : 16) 
              : (isSmallDevice ? 6 : 8),
          vertical: isSmallDevice ? 8 : 10,
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
              width: isSmallDevice ? 26 : 30,
              height: isSmallDevice ? 26 : 30,
              colorFilter: ColorFilter.mode(
                isActive ? Colors.black : Colors.white,
                BlendMode.srcIn,
              ),
            ),
            if (isActive) ...[
              SizedBox(width: isSmallDevice ? 6 : 8),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: isSmallDevice ? 10 : 12,
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