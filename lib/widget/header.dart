import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/screens/notification_screen.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 107,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Row(
        children: [
          // Search Bar
          Expanded(
            child: Container(
              height: 39,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: const [
                  SizedBox(width: 12),
                  Icon(
                    Icons.search,
                    color: Color(0xFF2A3038),
                    size: 20,
                  ),
                  SizedBox(width: 13),
                  Text(
                    "Cari posisi atau perusahaan...",
                    style: TextStyle(
                      fontFamily: "SF Pro",
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF747474),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 9),
          
          // Notification Button
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationScreen(),
                ),
              );
            },
            child: Stack(
              children: [
                Container(
                  width: 39,
                  height: 39,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/bel.svg',
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF2A3038),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 2,
                  top: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF0004),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}