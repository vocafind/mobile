import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:vocafind/api/endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FcmService {
  static final FcmService _instance = FcmService._internal();
  factory FcmService() => _instance;
  
  final Dio _dio = Dio();
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  
  FcmService._internal() {
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
  }

  // Initialize FCM terpisah
  Future<void> initialize() async {
    try {
      print('🚀 Initializing FCM Service...');
      
      try {
        await Firebase.initializeApp();
        print('✅ Firebase initialized');
      } catch (e) {
        print('ℹ️ Firebase already initialized or error: $e');
      }

      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      print('🔔 Notification permission: ${settings.authorizationStatus}');

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        String? token = await _messaging.getToken();
        print('📱 FCM Token: ${token?.substring(0, 30)}...');
        
        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('fcm_token', token);
          print('💾 Token saved to shared preferences');
        }
      }
      
      _setupListeners();
      
    } catch (e) {
      print('❌ Error initializing FCM: $e');
    }
  }

  void _setupListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📱 Foreground message received');
      print('   Title: ${message.notification?.title}');
      print('   Body: ${message.notification?.body}');
      print('   Data: ${message.data}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('📱 App opened from notification');
      print('   Data: ${message.data}');
    });
  }

  // Get device info sederhana
  Map<String, dynamic> getDeviceInfo() {
    try {
      String deviceType = 'android';
      String deviceName = 'Android Device';
      String deviceId = 'android_${DateTime.now().millisecondsSinceEpoch}';
      
      if (Platform.isIOS) deviceType = 'ios';
      else if (Platform.isWindows) deviceType = 'web';
      else if (Platform.isMacOS) deviceType = 'web';
      else if (Platform.isLinux) deviceType = 'web';
      
      return {
        'deviceId': deviceId,
        'deviceType': deviceType,
        'deviceName': deviceName,
        'appVersion': '1.0.0',
      };
    } catch (e) {
      return {
        'deviceId': 'simple_${DateTime.now().millisecondsSinceEpoch}',
        'deviceType': 'android',
        'deviceName': 'Simple Device',
        'appVersion': '1.0.0',
      };
    }
  }

  // ✅ Method utama untuk mengirim token ke server
  Future<bool> sendTokenToServer(String accessToken) async {
    try {
      print('📤 Sending FCM token to server...');
      
      // 1. Coba dapatkan token dari shared preferences
      final prefs = await SharedPreferences.getInstance();
      String? fcmToken = prefs.getString('fcm_token');
      
      // 2. Jika tidak ada, request token baru
      if (fcmToken == null || fcmToken.isEmpty) {
        print('🔄 Getting fresh FCM token...');
        fcmToken = await _messaging.getToken();
        
        if (fcmToken != null) {
          await prefs.setString('fcm_token', fcmToken);
          print('💾 New token saved to shared preferences');
        }
      }

      // 3. Cek jika masih tidak ada token
      if (fcmToken == null || fcmToken.isEmpty) {
        print('⚠️ No FCM token available');
        return false;
      }

      // 4. Siapkan device info
      final deviceInfo = getDeviceInfo();
      
      print('📱 Device Info:');
      print('   Device ID: ${deviceInfo['deviceId']}');
      print('   Device Type: ${deviceInfo['deviceType']}');
      print('   Device Name: ${deviceInfo['deviceName']}');
      print('   App Version: ${deviceInfo['appVersion']}');
      
      // 5. Kirim ke server
      print('🌐 Sending to: ${ApiConfig.saveFcmToken}');
      print('📦 Sending data:');
      print('   fcmToken: ${fcmToken.substring(0, 30)}...');
      print('   deviceId: ${deviceInfo['deviceId']}');
      print('   deviceType: ${deviceInfo['deviceType']}');
      print('   deviceName: ${deviceInfo['deviceName']}');
      print('   appVersion: ${deviceInfo['appVersion']}');
      
      final response = await _dio.post(
        ApiConfig.saveFcmToken,
        data: {
          "fcmToken": fcmToken,
          "deviceId": deviceInfo['deviceId'],
          "deviceType": deviceInfo['deviceType'],
          "deviceName": deviceInfo['deviceName'],
          "appVersion": deviceInfo['appVersion'],
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      print('✅ FCM token sent successfully - Status: ${response.statusCode}');
      print('   Response: ${response.data}');
      
      return response.statusCode == 200;
      
    } on DioException catch (e) {
      print('❌ Dio Error sending FCM token:');
      print('   Type: ${e.type}');
      print('   Message: ${e.message}');
      
      if (e.response != null) {
        print('   Status Code: ${e.response!.statusCode}');
        print('   Response Data: ${e.response!.data}');
        
        // Debug untuk 400 Bad Request
        if (e.response!.statusCode == 400) {
          print('🔍 400 BAD REQUEST DETAILS:');
          print('   Request URL: ${e.requestOptions.uri}');
          print('   Request Headers: ${e.requestOptions.headers}');
          print('   Request Data: ${e.requestOptions.data}');
        }
        
        // Debug untuk 401 Unauthorized
        if (e.response!.statusCode == 401) {
          print('🔐 401 UNAUTHORIZED:');
          print('   Token used: Bearer ${accessToken.substring(0, 50)}...');
          print('   Endpoint: ${ApiConfig.saveFcmToken}');
        }
      }
      
      return false;
    } catch (e) {
      print('❌ General Error sending FCM token: $e');
      return false;
    }
  }

  // Method untuk get token saja
  Future<String?> getCurrentFcmToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('fcm_token');
  }
}