import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:jobfair/screens/halaman_notifikasi.dart';
import 'package:jobfair/screens/halaman_bookmark.dart'; // Import halaman bookmark

class HeaderWidget extends StatelessWidget {
  final bool showNotification;
  final bool showFilter;
  final bool showBookmark; // ✅ Tambahkan parameter untuk bookmark
  final VoidCallback? onNotificationTap;
  final VoidCallback? onFilterTap;
  final VoidCallback? onBookmarkTap; // ✅ Tambahkan callback untuk bookmark

  const HeaderWidget({
    super.key,
    this.showNotification = true,
    this.showFilter = false,
    this.showBookmark = true, // ✅ Default true untuk menampilkan bookmark
    this.onNotificationTap,
    this.onFilterTap,
    this.onBookmarkTap,
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
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 12,
            bottom: 16,
          ),
          child: Row(
            children: [
              // Search bar
              Expanded(
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Row(
                    children: [
                      SizedBox(width: 20),
                      Icon(Icons.search, color: Colors.white, size: 20),
                      SizedBox(width: 12),
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
              const SizedBox(width: 12),
              
              // ✅ BOOKMARK ICON (conditional)
              if (showBookmark)
                GestureDetector(
                  onTap: onBookmarkTap ?? () {
                    // Default navigation ke halaman bookmark
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HalamanBookmark(),
                      ),
                    );
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.bookmark_border,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              
              // ✅ Spacing antara bookmark dan notification
              if (showBookmark && showNotification) const SizedBox(width: 12),
              
              // Notification button (conditional)
              if (showNotification)
                GestureDetector(
                  onTap: onNotificationTap ?? () {
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
                      color: Colors.white.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              
              // ✅ Spacing antara notification dan filter
              if (showNotification && showFilter) const SizedBox(width: 12),
              
              // Filter button (conditional)
              if (showFilter)
                GestureDetector(
                  onTap: onFilterTap,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.tune,
                      color: Colors.white,
                      size: 20,
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