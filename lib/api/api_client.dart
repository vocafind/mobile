import 'package:dio/dio.dart';
import 'package:jobfair/api/endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late Dio dio;

  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: Duration(seconds: 30),
        receiveTimeout: Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(AuthInterceptor());

    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }
}

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // ✅ SKIP interceptor untuk login & refresh endpoint
    if (options.path.contains('/Auth/loginTalent') ||
        options.path.contains('/Auth/refresh-token')) {
      print("⏭️ Skip interceptor untuk ${options.path}");
      return handler.next(options);
    }

    final prefs = await SharedPreferences.getInstance();

    // ✅ PERIKSA: Apakah user sudah login?
    final isLoggedIn = await _checkIfUserIsLoggedIn(prefs);
    if (!isLoggedIn) {
      print("⚠️ User belum login, skip auth header");
      return handler.next(options);
    }

    // ✅ CEK: Apakah ada token sama sekali?
    final token = prefs.getString('token');
    if (token == null) {
      print("⚠️ Tidak ada token, lanjutkan request tanpa auth");
      return handler.next(options);
    }

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
          print("❌ Refresh gagal, clear session");
          await prefs.clear();

          return handler.reject(
            DioException(
              requestOptions: options,
              error: 'Token refresh failed, please login again',
              type: DioExceptionType.cancel,
            ),
          );
        }
      }
    }

    // ✅ Tambahkan token ke header
    final newToken = prefs.getString('token');
    if (newToken != null) {
      options.headers['Authorization'] = 'Bearer $newToken';
    }

    handler.next(options);
  }

  Future<bool> _checkIfUserIsLoggedIn(SharedPreferences prefs) async {
    final token = prefs.getString('token');
    final talentId = prefs.getString('talentId');

    // Minimal harus ada token DAN talentId
    if (token == null ||
        token.isEmpty ||
        talentId == null ||
        talentId.isEmpty) {
      return false;
    }

    // Cek juga expiry
    final expiryString = prefs.getString('tokenExpiry');
    if (expiryString != null) {
      final expiry = DateTime.parse(expiryString);
      if (DateTime.now().isAfter(expiry)) {
        // Token expired, coba refresh
        final refreshed = await _refreshToken();
        return refreshed;
      }
    }

    return true;
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // ✅ SKIP untuk login & refresh endpoint
    if (err.requestOptions.path.contains('/Auth/loginTalent') ||
        err.requestOptions.path.contains('/Auth/refresh-token')) {
      return handler.next(err);
    }

    // ✅ REAKTIF: Kalau dapat 401, coba refresh & retry
    if (err.response?.statusCode == 401) {
      print("⚠️ Dapat 401, mencoba refresh token...");

      final refreshed = await _refreshToken();

      if (refreshed) {
        print("✅ Token di-refresh, retry request...");

        final prefs = await SharedPreferences.getInstance();
        final newToken = prefs.getString('token');

        err.requestOptions.headers['Authorization'] = 'Bearer $newToken';

        try {
          final response = await ApiClient().dio.fetch(err.requestOptions);
          return handler.resolve(response);
        } catch (e) {
          return handler.next(err);
        }
      } else {
        print("❌ Refresh gagal, clear session");
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        // TODO: Navigate ke login screen
      }
    }

    handler.next(err);
  }

  Future<bool> _refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refreshToken');

    if (refreshToken == null) {
      print("❌ Tidak ada refresh token");
      return false;
    }

    try {
      // ✅ Dio baru tanpa interceptor untuk avoid infinite loop
      final dio = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));

      final response = await dio.post(
        '/Auth/refresh-token', // Pakai path relatif
        data: {"refreshToken": refreshToken},
      );

      if (response.statusCode == 200) {
        final data = response.data;

        await prefs.setString('token', data['accessToken']);
        await prefs.setString('refreshToken', data['refreshToken']);

        final expiresIn = data['expiresIn'] ?? 900;
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
