// route.dart
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

  // ==================== ARGUMENT KEYS ====================
  static const String argJobfairId = 'jobfairId';

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
        // PENTING: Validasi argument jobfairId
        if (args != null) {
          int jobfairId;
          
          // Handle berbagai tipe argument
          if (args is int) {
            jobfairId = args;
          } else if (args is Map<String, dynamic>) {
            jobfairId = args[argJobfairId] as int;
          } else {
            // Fallback jika argument tidak valid
            return _errorRoute(
              'Parameter jobfairId tidak valid',
              settings.name,
            );
          }
          
          return MaterialPageRoute(
            builder: (_) => HalamanJobfairDetail(jobfairId: jobfairId),
            settings: settings,
          );
        }
        
        // Jika tidak ada argument, tampilkan error
        return _errorRoute(
          'Parameter jobfairId wajib diisi',
          settings.name,
        );
      
      case lamaran:
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
        return _errorRoute('Halaman tidak ditemukan', settings.name);
    }
  }

  // ==================== ERROR ROUTE ====================
  static Route<dynamic> _errorRoute(String message, String? routeName) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
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
                  onPressed: () {},
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