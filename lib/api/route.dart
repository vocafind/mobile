// route.dart - SIMPLIFIED VERSION
import 'package:flutter/material.dart';

import 'package:jobfair/screens/halaman_1.dart';
import 'package:jobfair/screens/halaman_beranda.dart';
import 'package:jobfair/screens/halaman_bookmark.dart';
import 'package:jobfair/screens/halaman_cari_loker.dart';
import 'package:jobfair/screens/halaman_jobfair_detail.dart';
import 'package:jobfair/screens/halaman_jobfair.dart';
import 'package:jobfair/screens/halaman_lamaran.dart';
import 'package:jobfair/screens/halaman_login.dart';
import 'package:jobfair/screens/halaman_notifikasi.dart';
import 'package:jobfair/screens/halaman_register.dart';
import 'package:jobfair/screens/profil/halaman_profil.dart';
// Import untuk bottom sheet (optional, hanya untuk reference)
import 'package:jobfair/screens/detail_lamaran.dart';
import 'package:jobfair/screens/detail_lamaran_jobfair.dart';

class AppRoutes {
  // ==================== ROUTE NAMES CONSTANTS ====================
  static const String beranda = '/beranda';
  static const String halaman1 = '/halaman1';
  static const String bookmark = '/bookmark';
  static const String cariLoker = '/cari-loker';
  static const String jobfair = '/jobfair';
  static const String jobfairDetail = '/jobfair-detail';
  static const String lamaran = '/lamaran';
  static const String login = '/login';
  static const String notifikasi = '/notifikasi';
  static const String register = '/register';
  static const String profil = '/profil';
  // HAPUS: detailLamaran dan detailLamaranJobfair dari route constants

  // ==================== ARGUMENT KEYS ====================
  static const String argJobfairId = 'jobfairId';
  static const String argApplyId = 'applyId';
  // HAPUS: argLamaran dan argIsJobfair karena tidak butuh route khusus

  // ==================== GENERATE ROUTE ====================
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
      case beranda:
        return MaterialPageRoute(
          builder: (_) => const HalamanBeranda(),
          settings: settings,
        );
      
      case halaman1:
        return MaterialPageRoute(
          builder: (_) => const Halaman1(),
          settings: settings,
        );
      
      case bookmark:
        return MaterialPageRoute(
          builder: (_) => const HalamanBookmark(),
          settings: settings,
        );
      
      case cariLoker:
        return MaterialPageRoute(
          builder: (_) => const HalamanCariLoker(),
          settings: settings,
        );
      
      case jobfair:
        return MaterialPageRoute(
          builder: (_) => const HalamanJobfair(),
          settings: settings,
        );
      
      case jobfairDetail:
        if (args != null) {
          int jobfairId;
          
          if (args is int) {
            jobfairId = args;
          } else if (args is Map<String, dynamic>) {
            jobfairId = args[argJobfairId] as int;
          } else {
            return _buildErrorRoute(
              'Parameter jobfairId tidak valid',
              settings.name,
            );
          }
          
          return MaterialPageRoute(
            builder: (_) => HalamanJobfairDetail(jobfairId: jobfairId),
            settings: settings,
          );
        }
        
        return _buildErrorRoute(
          'Parameter jobfairId wajib diisi',
          settings.name,
        );
      
      case lamaran:
        // Handle parameter untuk auto-open lamaran
        if (args != null) {
          if (args is String) {
            // Jika args langsung applyId
            return MaterialPageRoute(
              builder: (_) => HalamanLamaran(applyIdToOpen: args),
              settings: settings,
            );
          } else if (args is Map<String, dynamic>) {
            final applyId = args[argApplyId] as String?;
            if (applyId != null) {
              return MaterialPageRoute(
                builder: (_) => HalamanLamaran(applyIdToOpen: applyId),
                settings: settings,
              );
            }
          }
        }
        return MaterialPageRoute(
          builder: (_) => const HalamanLamaran(),
          settings: settings,
        );
      
      case login:
        return MaterialPageRoute(
          builder: (_) => const HalamanLogin(),
          settings: settings,
        );
      
      case notifikasi:
        return MaterialPageRoute(
          builder: (_) => const NotificationPage(),
          settings: settings,
        );
      
      case register:
        return MaterialPageRoute(
          builder: (_) => const RegisterPage(),
          settings: settings,
        );
      
      case profil: 
        return MaterialPageRoute(
          builder: (_) => const HalamanProfil(),
          settings: settings,
        );
      
      default:
        return _buildErrorRoute('Halaman tidak ditemukan', settings.name);
    }
  }

  // ==================== ERROR ROUTE ====================
  static Route<dynamic> _buildErrorRoute(String message, String? routeName) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
          backgroundColor: Colors.red,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 80,
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Route: ${routeName ?? "Unknown"}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context, 
                      AppRoutes.beranda, 
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.home),
                  label: const Text('Kembali ke Beranda'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B56FD),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==================== NAVIGATION HELPER METHODS ====================
  
  /// Navigate to a new route
  static Future<T?> navigateTo<T>(
    BuildContext context, 
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamed<T>(
      context, 
      routeName, 
      arguments: arguments,
    );
  }

  /// Replace current route with a new one
  static Future<T?> replaceWith<T, TO>(
    BuildContext context, 
    String routeName, {
    Object? arguments,
    TO? result,
  }) {
    return Navigator.pushReplacementNamed<T, TO>(
      context, 
      routeName, 
      arguments: arguments,
      result: result,
    );
  }

  /// Pop current route and push a new one
  static Future<T?> popAndPush<T, TO>(
    BuildContext context, 
    String routeName, {
    Object? arguments,
    TO? result,
  }) {
    return Navigator.popAndPushNamed<T, TO>(
      context, 
      routeName, 
      arguments: arguments,
      result: result,
    );
  }

  /// Push and remove all previous routes
  static Future<T?> pushAndRemoveUntil<T>(
    BuildContext context, 
    String routeName, {
    Object? arguments,
    bool Function(Route<dynamic>)? predicate,
  }) {
    return Navigator.pushNamedAndRemoveUntil<T>(
      context, 
      routeName, 
      predicate ?? (route) => false,
      arguments: arguments,
    );
  }

  /// Go back to previous route
  static void goBack(BuildContext context, [Object? result]) {
    Navigator.pop(context, result);
  }

  /// Go back to specific route
  static void popUntil(BuildContext context, String routeName) {
    Navigator.popUntil(context, ModalRoute.withName(routeName));
  }

  /// Check if can pop
  static bool canPop(BuildContext context) {
    return Navigator.canPop(context);
  }

  /// Pop until root (beranda)
  static void popToRoot(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }
}

// ==================== GLOBAL SHORTHAND FUNCTIONS ====================

/// Navigate to a new route (shorthand)
Future<T?> goTo<T>(
  BuildContext context, 
  String routeName, {
  Object? arguments,
}) {
  return AppRoutes.navigateTo<T>(context, routeName, arguments: arguments);
}

/// Replace current route (shorthand)
Future<T?> goReplace<T, TO>(
  BuildContext context, 
  String routeName, {
  Object? arguments,
  TO? result,
}) {
  return AppRoutes.replaceWith<T, TO>(
    context, 
    routeName, 
    arguments: arguments,
    result: result,
  );
}

/// Pop and push (shorthand)
Future<T?> goPopAndPush<T, TO>(
  BuildContext context, 
  String routeName, {
  Object? arguments,
  TO? result,
}) {
  return AppRoutes.popAndPush<T, TO>(
    context, 
    routeName, 
    arguments: arguments,
    result: result,
  );
}

/// Push and remove all (shorthand)
Future<T?> goResetTo<T>(
  BuildContext context, 
  String routeName, {
  Object? arguments,
}) {
  return AppRoutes.pushAndRemoveUntil<T>(
    context, 
    routeName, 
    arguments: arguments,
  );
}

/// Go back (shorthand)
void goBack(BuildContext context, [Object? result]) {
  AppRoutes.goBack(context, result);
}

/// Pop to root (shorthand)
void goHome(BuildContext context) {
  AppRoutes.popToRoot(context);
}

// ==================== BOTTOM SHEET HELPER ====================
/// Helper untuk menampilkan bottom sheet (TIDAK ADA NAVIGASI DI SINI)
void showDetailLamaranBottomSheet(
  BuildContext context,
  dynamic lamaran, {
  bool isJobfair = false,
}) {
  if (isJobfair) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DetailLamaranJobfair(lamaran: lamaran),
    );
  } else {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DetailLamaran(lamaran: lamaran),
    );
  }
}