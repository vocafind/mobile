import 'package:dio/dio.dart';
import 'package:jobfair/api/endpoints.dart';
import 'package:jobfair/screens/halaman_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'endpoints.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late Dio dio;

  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal() {
    dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl, // Set base URL kamu
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    // ✅ Tambahkan interceptor
    dio.interceptors.add(AuthInterceptor());
    
    // Optional: Logger untuk debugging
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }
}

// ✅ Interceptor untuk handle token otomatis
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final prefs = await SharedPreferences.getInstance();
    
    // ✅ CEK PROAKTIF: Apakah token akan expired?
    final expiryString = prefs.getString('tokenExpiry');
    if (expiryString != null) {
      final expiry = DateTime.parse(expiryString);
      final now = DateTime.now();
      
      // Kalau token akan expired dalam 2 menit, refresh dulu
      if (now.isAfter(expiry.subtract(Duration(minutes: 2)))) {
        print("🔄 Token akan expired, refresh dulu sebelum request...");
        
        final refreshed = await _refreshToken();
        if (!refreshed) {
          print("❌ Refresh gagal, batalkan request");
          return handler.reject(
            DioException(
              requestOptions: options,
              error: 'Token refresh failed',
              type: DioExceptionType.cancel,
            ),
          );
        }
      }
    }
    
    // ✅ Tambahkan token ke header
    final token = prefs.getString('token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // ✅ REAKTIF: Kalau dapat 401, coba refresh & retry
    if (err.response?.statusCode == 401) {
      print("⚠️ Dapat 401, mencoba refresh token...");
      
      final refreshed = await _refreshToken();
      
      if (refreshed) {
        print("✅ Token di-refresh, retry request...");
        
        // Ambil token baru
        final prefs = await SharedPreferences.getInstance();
        final newToken = prefs.getString('token');
        
        // Update header dengan token baru
        err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
        
        // ✅ RETRY request dengan token baru
        try {
          final response = await ApiClient().dio.fetch(err.requestOptions);
          return handler.resolve(response);
        } catch (e) {
          return handler.next(err);
        }
      } else {
        print("❌ Refresh gagal, user harus login ulang");
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        HalamanLogin();
      }
    }
    
    handler.next(err);
  }

  // ✅ Function refresh token (dipanggil otomatis oleh interceptor)
  Future<bool> _refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refreshToken');

    if (refreshToken == null) {
      print("❌ Tidak ada refresh token");
      return false;
    }

    try {
      final dio = Dio(); // Dio baru tanpa interceptor (avoid infinite loop)
      final response = await dio.post(
        ApiConfig.refreshToken,
        data: {"refreshToken": refreshToken},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        
        // Simpan token baru
        await prefs.setString('token', data['accessToken']);
        await prefs.setString('refreshToken', data['refreshToken']);
        
        // Hitung expiry baru
        final expiresIn = data['expiresIn'] ?? 900; // Default 15 menit
        final expiryTime = DateTime.now().add(Duration(seconds: expiresIn));
        await prefs.setString('tokenExpiry', expiryTime.toIso8601String());
        
        print("✅ Token berhasil di-refresh");
        return true;
      }
    } catch (e) {
      print("❌ Error refresh token: $e");
    }
    
    return false;
  }
}