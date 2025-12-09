import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';
import 'package:jobfair/api/route.dart';

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
    
    if (widget.onTap != null) {
      widget.onTap!(index);
      return;
    }

    final routes = [
      AppRoutes.beranda,
      AppRoutes.cariLoker,
      AppRoutes.jobfair,
      AppRoutes.lamaran,
      AppRoutes.profil,
    ];
    
    if (index < routes.length) {
      goReplace(context, routes[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isVerySmall = screenWidth < 320;
    final isSmall = screenWidth < 360;
    
    // Konfigurasi responsif
    final margin = isVerySmall ? 8.0 : isSmall ? 12.0 : 20.0;
    final height = isVerySmall ? 56.0 : isSmall ? 60.0 : 68.0;
    final borderRadius = isVerySmall ? 45.0 : 60.0;
    
    return Container(
      margin: EdgeInsets.only(
        left: margin,
        right: margin,
        bottom: margin - 4, // Bottom sedikit lebih kecil
      ),
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) {
                final navItems = [
                  _NavItem('assets/icons/home.svg', 'Beranda'),
                  _NavItem('assets/icons/search.svg', 
                    isVerySmall ? 'Cari' : (isSmall ? 'Cari' : 'Cari Loker')),
                  _NavItem('assets/icons/jobfairIcon.svg', 
                    isVerySmall ? 'Fair' : 'Jobfair'),
                  _NavItem('assets/icons/lamaran.svg', 
                    isVerySmall ? 'Lamar' : 'Lamaran'),
                  _NavItem('assets/icons/profile.svg', 'Profil'),
                ];
                
                return _buildNavButton(
                  index: index,
                  svgPath: navItems[index].iconPath,
                  label: navItems[index].label,
                  isVerySmall: isVerySmall,
                  isSmall: isSmall,
                );
              }),
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
    required bool isVerySmall,
    required bool isSmall,
  }) {
    final isActive = widget.currentIndex == index;
    
    // Ukuran responsif
    final iconSize = isVerySmall ? 22.0 : isSmall ? 24.0 : 28.0;
    final horizontalPadding = isActive 
        ? (isVerySmall ? 6.0 : isSmall ? 8.0 : 12.0)
        : (isVerySmall ? 4.0 : isSmall ? 5.0 : 8.0);
    final verticalPadding = isVerySmall ? 6.0 : isSmall ? 8.0 : 10.0;
    final borderRadius = isVerySmall ? 30.0 : 45.0;
    final spacing = isVerySmall ? 4.0 : isSmall ? 5.0 : 6.0;
    final fontSize = isVerySmall ? 9.0 : isSmall ? 10.0 : 12.0;

    return GestureDetector(
      onTap: () => _handleNavigation(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              svgPath,
              width: iconSize,
              height: iconSize,
              colorFilter: ColorFilter.mode(
                isActive ? Colors.black : Colors.white,
                BlendMode.srcIn,
              ),
            ),
            if (isActive) ...[
              SizedBox(width: spacing),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: fontSize,
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

class _NavItem {
  final String iconPath;
  final String label;

  _NavItem(this.iconPath, this.label);
}