import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:jobfair/screens/halaman_notifikasi.dart';

class HeaderWidget extends StatelessWidget {
  final bool showNotification;
  final bool showFilter;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onFilterTap;

  const HeaderWidget({
    super.key,
    this.showNotification = true,
    this.showFilter = false,
    this.onNotificationTap,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    // Set status bar style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1B56FD), Color(0xFF0118D8)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
          child: Row(
            children: [
              // Search bar
              Expanded(
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEEEEE).withValues(alpha:0.1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Row(
                    children: [
                      SizedBox(width: 14),
                      Icon(Icons.search, color: Colors.white, size: 25),
                      SizedBox(width: 16),
                      Text(
                        'Cari lowongan kerja...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 6),
              // Notification button (conditional)
              Row(
                children: [
                  const SizedBox(width: 12),
                  if (showNotification)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationPage(),
                          ),
                        );
                      },
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEEEEE).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.notifications_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                ],
              ),
              // Filter button (conditional)
              if (showFilter)
                GestureDetector(
                  onTap: onFilterTap,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEEEEE).withValues(alpha:0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.tune,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}