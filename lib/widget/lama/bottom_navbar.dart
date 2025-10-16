import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../screens/lama/home_screen.dart';
import '../../screens/lama/search_screen.dart';
import '../../screens/lama/jobfair_screen.dart';
import '../../screens/lama/profile_screen.dart';
import '../../screens/lama/lamaran_screen.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({
    super.key,
    this.currentIndex = 0,
  });

  void _onNavTap(BuildContext context, int index) {
    // Jangan navigasi jika sudah di halaman yang sama
    if (index == currentIndex) return;

    // Navigasi ke halaman yang sesuai
    Widget screen;
    switch (index) {
      case 0:
        screen = const HomeScreen();
        break;
      case 1:
        screen = const SearchScreen();
        break;
      case 2:
        screen = const JobFairScreen();
        break;
      case 3:
        // Lamaran Screen (placeholder)
        screen = const ApplicationScreen();
        break;
      case 4:
        screen = const ProfileScreen(); 
        break;
      default:
        screen = const HomeScreen();
    }

    // Push replacement agar tidak menumpuk history
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionDuration: Duration.zero, // No animation
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.black.withValues(alpha: 0.05),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            context,
            'assets/icons/home.svg',
            "Home",
            0,
            currentIndex == 0,
          ),
          _buildNavItem(
            context,
            'assets/icons/search.svg',
            "Cari Loker",
            1,
            currentIndex == 1,
          ),
          _buildNavItem(
            context,
            'assets/icons/jobfair.svg',
            "Job Fair",
            2,
            currentIndex == 2,
          ),
          _buildNavItem(
            context,
            'assets/icons/lamaran.svg',
            "Lamaran",
            3,
            currentIndex == 3,
          ),
          _buildNavItem(
            context,
            'assets/icons/profile.svg',
            "Profile",
            4,
            currentIndex == 4,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    String iconPath,
    String label,
    int index,
    bool isActive,
  ) {
    final color = isActive ? const Color(0xFF0987BB) : const Color(0xFF909090);

    return GestureDetector(
      onTap: () => _onNavTap(context, index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(
                color,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: "SF Pro",
                fontSize: 8,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}