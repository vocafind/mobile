import 'dart:io';

import 'package:dio/dio.dart';
import 'package:jobfair/api/api_client.dart';
import 'package:jobfair/models/lamar_loker.dart';
import 'package:jobfair/models/talent_award_model.dart';
import 'package:jobfair/models/talent_certification_model.dart';
import 'package:jobfair/models/talent_education_model.dart';
import 'package:jobfair/models/talent_language_model.dart';
import 'package:jobfair/models/talent_portofolio_model.dart';
import 'package:jobfair/models/talent_project_model.dart';
import 'package:jobfair/models/talent_softskill_model.dart';
import 'package:jobfair/models/talent_training_model.dart';
import 'package:jobfair/models/talent_workhistory_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:jobfair/models/loker_umum_detail_model.dart';
import 'package:jobfair/models/loker_umum_model.dart';
import 'package:jobfair/models/talent_profile_model.dart';
import 'endpoints.dart';
import 'dart:convert';
import 'package:jobfair/models/talent_social_media_model.dart';
import 'package:jobfair/models/talent_career_interest_model.dart';
import 'package:jobfair/models/talent_reference_model.dart';

class ApiService {
  final Dio _dio = ApiClient().dio;

  Future<void> _saveTokens(
    String accessToken,
    String refreshToken,
    int expiresIn,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', accessToken);
    await prefs.setString('refreshToken', refreshToken);

    final expiryTime = DateTime.now().add(Duration(seconds: expiresIn));
    await prefs.setString('tokenExpiry', expiryTime.toIso8601String());
  }

  //------------------------------------------------TALENTS--------------------------TALENTS-----------------TALENTS------------------------------------------

  // -----------------------------------------------------------------------AUTH

  // ================== REGISTER ==================
  Future<http.StreamedResponse> registerTalent(
    Map<String, String> fields,
    String? filePath,
  ) async {
    var url = Uri.parse(ApiConfig.registerTalent);
    var request = http.MultipartRequest('POST', url);

    request.fields.addAll(fields);

    if (filePath != null) {
      request.files.add(await http.MultipartFile.fromPath('Ktp', filePath));
    }

    return await request.send();
  }

  // ================== LOGIN - VERSI SIMPLIFIED ==================
  Future<Map<String, dynamic>> loginTalent(
    String email,
    String password,
  ) async {
    try {
      final response = await _dio.post(
        ApiConfig.loginTalent,
        data: {"Email": email, "Password": password},
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      print("STATUS: ${response.statusCode}");
      print("RESPONSE: ${response.data}");

      // ✅ Simpan token + expiry
      if (response.statusCode == 200 && response.data['accessToken'] != null) {
        await _saveTokens(
          response.data['accessToken'],
          response.data['refreshToken'],
          response.data['expiresIn'] ?? 900,
        );
      }

      return response.data;
    } on DioException catch (e) {
      print("❌ Login error: ${e.message}");
      print("❌ Error type: ${e.type}");
      print("❌ Response: ${e.response?.data}");
      print("❌ Status code: ${e.response?.statusCode}");

      // ✅ Handle network errors
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        return {"message": "Periksa koneksi internet Anda"};
      }

      // ✅ Handle no internet connection
      if (e.type == DioExceptionType.unknown && 
          e.error?.toString().contains("SocketException") == true) {
        return {"message": "Tidak ada koneksi internet"};
      }

      // ✅ Handle server response errors
      if (e.response != null) {
        final statusCode = e.response!.statusCode;
        final responseData = e.response!.data;

        switch (statusCode) {
          case 400:
          case 401:
            // Try to get specific error message from server
            final serverMessage = responseData?['message'] ?? 
                                responseData?['error'] ??
                                "Email atau password salah";
            return {"message": serverMessage};
          
          case 500:
          case 502:
          case 503:
            return {"message": "Server sedang gangguan. Coba lagi nanti"};
          
          default:
            final serverMessage = responseData?['message'] ?? 
                                responseData?['error'] ??
                                "Terjadi kesalahan";
            return {"message": serverMessage};
        }
      }

      // ✅ Default error message
      return {"message": "Gagal terhubung ke server"};
    } catch (e) {
      print("❌ Non-Dio error: $e");
      return {"message": "Terjadi kesalahan sistem"};
    }
  }

  // ================== REFRESH TOKEN ==================
  Future<bool> refreshAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refreshToken');

    if (refreshToken == null) {
      print("❌ Tidak ada refresh token tersimpan");
      return false;
    }

    final url = Uri.parse(ApiConfig.refreshToken);

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"refreshToken": refreshToken}),
      );

      print("REFRESH STATUS: ${response.statusCode}");
      print("REFRESH RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final newAccessToken = data['accessToken'];
        final newRefreshToken = data['refreshToken'];

        if (newAccessToken == null || newRefreshToken == null) {
          print("❌ Response tidak mengandung token baru!");
          return false;
        }

        await prefs.setString('token', newAccessToken);
        await prefs.setString('refreshToken', newRefreshToken);

        print("✅ Token baru berhasil disimpan ke SharedPreferences");
        return true;
      } else if (response.statusCode == 401) {
        print("⚠️ Refresh token invalid atau expired");
        await prefs.clear();
        return false;
      } else {
        print("⚠️ Refresh token gagal: ${response.body}");
        return false;
      }
    } catch (e) {
      print("❌ Error saat refresh token: $e");
      return false;
    }
  }





  //  -----------------------------------------------------------------------Data Diri
  // ================== GET PROFIL / DATA DIRI ==================
  Future<TalentProfileModel?> getProfilDataDiri() async {
    final prefs = await SharedPreferences.getInstance();
    final talentId = prefs.getString('talentId');

    if (talentId == null) {
      print("❌ TalentId tidak ditemukan");
      return null;
    }

    try {
      final response = await _dio.get(ApiConfig.profilDataDiri(talentId));

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.data}");

      if (response.statusCode == 200) {
        prefs.setString('cachedProfile', jsonEncode(response.data));
        return TalentProfileModel.fromJson(response.data);
      }
    } on DioException catch (e) {
      print("❌ Error ambil profil: ${e.message}");
    }

    return null;
  }

  // ================== UPDATE PROFIL / DATA DIRI (PATCH) ==================
  Future<Map<String, dynamic>> updateProfilTalent({
    required String talentId,
    File? fotoProfil,
    String? nama,
    String? alamat,
    String? nomorTelepon,
    String? lokasiKerjaDiinginkan,
    String? statusPekerjaanSaatIni,
    int? preferensiGaji,
    String? preferensiJamKerjaMulai,
    String? preferensiJamKerjaSelesai,
    String? preferensiPerjalananDinas,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      return {"success": false, "message": "Token tidak ditemukan"};
    }

    final url = Uri.parse(ApiConfig.updateTalent(talentId));
    var request = http.MultipartRequest('PATCH', url);

    // Add authorization header
    request.headers['Authorization'] = 'Bearer $token';

    // Add fields yang tidak null
    if (nama != null) request.fields['Nama'] = nama;
    if (alamat != null) request.fields['Alamat'] = alamat;
    if (nomorTelepon != null) {
      // Hapus format dash dari nomor telepon sebelum dikirim
      final cleanNumber = nomorTelepon.replaceAll('-', '');
      request.fields['NomorTelepon'] = cleanNumber;
    }
    if (lokasiKerjaDiinginkan != null) {
      request.fields['LokasiKerjaDiinginkan'] = lokasiKerjaDiinginkan;
    }
    if (statusPekerjaanSaatIni != null) {
      request.fields['StatusPekerjaanSaatIni'] = statusPekerjaanSaatIni;
    }
    if (preferensiGaji != null) {
      request.fields['PreferensiGaji'] = preferensiGaji.toString();
    }
    if (preferensiJamKerjaMulai != null && preferensiJamKerjaMulai.isNotEmpty) {
      request.fields['PreferensiJamKerjaMulai'] = preferensiJamKerjaMulai;
    }
    if (preferensiJamKerjaSelesai != null &&
        preferensiJamKerjaSelesai.isNotEmpty) {
      request.fields['PreferensiJamKerjaSelesai'] = preferensiJamKerjaSelesai;
    }
    if (preferensiPerjalananDinas != null) {
      request.fields['PreferensiPerjalananDinas'] = preferensiPerjalananDinas;
    }

    // Add foto profil jika ada
    if (fotoProfil != null) {
      request.files.add(
        await http.MultipartFile.fromPath('FotoProfil', fotoProfil.path),
      );
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("STATUS UPDATE: ${response.statusCode}");
      print("RESPONSE UPDATE: ${response.body}");

      if (response.statusCode == 200) {
        return {"success": true, "message": "Profil berhasil diperbarui"};
      } else {
        return {"success": false, "message": "Gagal memperbarui profil"};
      }
    } catch (e) {
      print("ERROR UPDATE: $e");
      return {"success": false, "message": "Gagal terhubung ke server"};
    }
  }




  //-----------------------------------------------------------------------SOSMED
  // ================== GET SOCIAL MEDIA ==================
  Future<List<SocialMediaModel>> getSocialMedia() async {
    final prefs = await SharedPreferences.getInstance();
    final talentId = prefs.getString('talentId');

    if (talentId == null) throw Exception('Unauthorized');

    try {
      final response = await _dio.get(
        ApiConfig.getSocialMediaByTalent(talentId),
      );

      print("GET Social Media - STATUS: ${response.statusCode}");
      print("GET Social Media - BODY: ${response.data}");

      final List<dynamic> data = response.data;
      return data.map((json) => SocialMediaModel.fromJson(json)).toList();
    } on DioException catch (e) {
      print("❌ Error ambil social media: ${e.message}");
      rethrow;
    }
  }

  // ================== CREATE SOCIAL MEDIA ==================
  Future<Map<String, dynamic>> createSocialMedia(
    SocialMediaModel socialMedia,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final talentId = prefs.getString('talentId');

    if (talentId == null) throw Exception('Unauthorized');

    try {
      final response = await _dio.post(
        ApiConfig.createSocialMedia(),
        data: socialMedia.toJsonPost(talentId),
      );

      print("POST Social Media - STATUS: ${response.statusCode}");
      print("POST Social Media - BODY: ${response.data}");

      return response.data;
    } on DioException catch (e) {
      print("❌ Error tambah social media: ${e.message}");
      rethrow;
    }
  }

  // ================== UPDATE SOCIAL MEDIA ==================
  Future<Map<String, dynamic>> updateSocialMedia(
    String socialId,
    SocialMediaModel socialMedia,
  ) async {
    try {
      final response = await _dio.put(
        ApiConfig.updateSocialMedia(socialId),
        data: socialMedia.toJsonPut(),
      );

      print("PUT Social Media - STATUS: ${response.statusCode}");
      print("PUT Social Media - BODY: ${response.data}");

      return response.data;
    } on DioException catch (e) {
      print("❌ Error update social media: ${e.message}");
      rethrow;
    }
  }

  // ================== DELETE SOCIAL MEDIA ==================
  Future<Map<String, dynamic>> deleteSocialMedia(String socialId) async {
    try {
      final response = await _dio.delete(ApiConfig.deleteSocialMedia(socialId));

      print("DELETE Social Media - STATUS: ${response.statusCode}");
      print("DELETE Social Media - BODY: ${response.data}");

      return response.data;
    } on DioException catch (e) {
      print("❌ Error hapus social media: ${e.message}");
      rethrow;
    }
  }

  //  -----------------------------------------------------------------------MINAT KARIR

  // ================== GET MINAT KARIR ==================
  Future<List<CareerInterestModel>> getCareerInterest() async {
    final prefs = await SharedPreferences.getInstance();
    final talentId = prefs.getString('talentId');

    if (talentId == null) throw Exception('Unauthorized');

    try {
      final response = await _dio.get(
        ApiConfig.getCareerInterestByTalent(talentId),
      );

      print("GET Career Interest - STATUS: ${response.statusCode}");
      print("GET Career Interest - BODY: ${response.data}");

      final List<dynamic> data = response.data;
      return data.map((json) => CareerInterestModel.fromJson(json)).toList();
    } on DioException catch (e) {
      print("❌ Error ambil minat karir: ${e.message}");
      rethrow;
    }
  }

  //================== CREATE MINAT KARIR ==================
  Future<Map<String, dynamic>> createCareerInterest(
    CareerInterestModel careerInterest,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final talentId = prefs.getString('talentId');

    if (talentId == null) throw Exception('Unauthorized');

    try {
      final response = await _dio.post(
        ApiConfig.createCareerInterest(),
        data: careerInterest.toJsonPost(talentId),
      );

      print("POST Career Interest - STATUS: ${response.statusCode}");
      print("POST Career Interest - BODY: ${response.data}");

      return response.data;
    } on DioException catch (e) {
      print("❌ Error tambah minat karir: ${e.message}");
      rethrow;
    }
  }

  // ================== UPDATE MINAT KARIR ==================
  Future<Map<String, dynamic>> updateCareerInterest(
    String careerInterestId,
    CareerInterestModel careerInterest,
  ) async {
    try {
      final response = await _dio.put(
        ApiConfig.updateCareerInterest(careerInterestId),
        data: careerInterest.toJsonPut(),
      );

      print("PUT Career Interest - STATUS: ${response.statusCode}");
      print("PUT Career Interest - BODY: ${response.data}");

      return response.data;
    } on DioException catch (e) {
      print("❌ Error update minat karir: ${e.message}");
      rethrow;
    }
  }

  // ================== DELETE MINAT KARIR ==================
  Future<Map<String, dynamic>> deleteCareerInterest(
    String careerInterestId,
  ) async {
    try {
      final response = await _dio.delete(
        ApiConfig.deleteCareerInterest(careerInterestId),
      );

      print("DELETE Career Interest - STATUS: ${response.statusCode}");
      print("DELETE Career Interest - BODY: ${response.data}");

      return response.data;
    } on DioException catch (e) {
      print("❌ Error hapus minat karir: ${e.message}");
      rethrow;
    }
  }






  //  -----------------------------------------------------------------------REFERENSI

  // ================== GET REFERENCE ==================
  Future<List<ReferenceModel>> getReference() async {
    final prefs = await SharedPreferences.getInstance();
    final talentId = prefs.getString('talentId');

    if (talentId == null) {
      print("❌ TalentId tidak ditemukan");
      throw Exception('Unauthorized');
    }

    try {
      final response = await _dio.get(ApiConfig.getReferenceByTalent(talentId));

      print("GET Reference - STATUS: ${response.statusCode}");
      print("GET Reference - BODY: ${response.data}");

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => ReferenceModel.fromJson(json)).toList();
      } else {
        print("⚠️ Gagal ambil referensi: ${response.data}");
        throw Exception('Failed to load reference');
      }
    } on DioException catch (e) {
      print("❌ Error ambil referensi: ${e.message}");
      rethrow;
    }
  }

  // ================== CREATE REFERENSI ==================
  Future<Map<String, dynamic>> createReference(ReferenceModel reference) async {
    final prefs = await SharedPreferences.getInstance();
    final talentId = prefs.getString('talentId');

    if (talentId == null) {
      print("❌ TalentId tidak ditemukan");
      throw Exception('Unauthorized');
    }

    try {
      final response = await _dio.post(
        ApiConfig.createReference(),
        data: reference.toJsonPost(talentId),
      );

      print("POST Reference - STATUS: ${response.statusCode}");
      print("POST Reference - BODY: ${response.data}");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        print("⚠️ Gagal tambah referensi: ${response.data}");
        throw Exception('Failed to create reference');
      }
    } on DioException catch (e) {
      print("❌ Error tambah referensi: ${e.message}");
      rethrow;
    }
  }

  // ================== UPDATE REFERENSI ==================
  Future<Map<String, dynamic>> updateReference(
    String referenceId,
    ReferenceModel reference,
  ) async {
    try {
      final response = await _dio.put(
        ApiConfig.updateReference(referenceId),
        data: reference.toJsonPut(),
      );

      print("PUT Reference - STATUS: ${response.statusCode}");
      print("PUT Reference - BODY: ${response.data}");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        print("⚠️ Gagal update referensi: ${response.data}");
        throw Exception('Failed to update reference');
      }
    } on DioException catch (e) {
      print("❌ Error update referensi: ${e.message}");
      rethrow;
    }
  }

  // ================== DELETE REFERENSI ==================
  Future<Map<String, dynamic>> deleteReference(String referenceId) async {
    try {
      final response = await _dio.delete(
        ApiConfig.deleteReference(referenceId),
      );

      print("DELETE Reference - STATUS: ${response.statusCode}");
      print("DELETE Reference - BODY: ${response.data}");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        print("⚠️ Gagal hapus referensi: ${response.data}");
        throw Exception('Failed to delete reference');
      }
    } on DioException catch (e) {
      print("❌ Error hapus referensi: ${e.message}");
      rethrow;
    }
  }






  //  -----------------------------------------------------------------------PENDIDIKAN

  // ================== GET PENDIDIKAN ==================
  Future<List<EducationModel>> getEducation() async {
    final prefs = await SharedPreferences.getInstance();
    final talentId = prefs.getString('talentId');

    if (talentId == null) {
      print("❌ TalentId tidak ditemukan");
      throw Exception('Unauthorized');
    }

    try {
      final response = await _dio.get(ApiConfig.getEducationByTalent(talentId));

      print("GET Education - STATUS: ${response.statusCode}");
      print("GET Education - BODY: ${response.data}");

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => EducationModel.fromJson(json)).toList();
      } else {
        print("⚠️ Gagal ambil data pendidikan: ${response.data}");
        throw Exception('Failed to load education');
      }
    } on DioException catch (e) {
      print("❌ Error ambil pendidikan: ${e.message}");
      rethrow;
    }
  }

  // ================== CREATE PENDIDIKAN ==================
  Future<Map<String, dynamic>> createEducation(EducationModel education) async {
    final prefs = await SharedPreferences.getInstance();
    final talentId = prefs.getString('talentId');

    if (talentId == null) {
      print("❌ TalentId tidak ditemukan");
      throw Exception('Unauthorized');
    }

    try {
      final response = await _dio.post(
        ApiConfig.createEducation(),
        data: education.toJsonPost(talentId),
      );

      print("POST Education - STATUS: ${response.statusCode}");
      print("POST Education - BODY: ${response.data}");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        print("⚠️ Gagal tambah pendidikan: ${response.data}");
        throw Exception('Failed to create education');
      }
    } on DioException catch (e) {
      print("❌ Error tambah pendidikan: ${e.message}");
      rethrow;
    }
  }

  // ================== UPDATE PENDIDIKAN ==================
  Future<Map<String, dynamic>> updateEducation(
    String educationId,
    EducationModel education,
  ) async {
    try {
      final response = await _dio.put(
        ApiConfig.updateEducation(educationId),
        data: education.toJsonPut(),
      );

      print("PUT Education - STATUS: ${response.statusCode}");
      print("PUT Education - BODY: ${response.data}");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        print("⚠️ Gagal update pendidikan: ${response.data}");
        throw Exception('Failed to update education');
      }
    } on DioException catch (e) {
      print("❌ Error update pendidikan: ${e.message}");
      rethrow;
    }
  }

  // ================== DELETE PENDIDIKAN ==================
  Future<Map<String, dynamic>> deleteEducation(String educationId) async {
    try {
      final response = await _dio.delete(
        ApiConfig.deleteEducation(educationId),
      );

      print("DELETE Education - STATUS: ${response.statusCode}");
      print("DELETE Education - BODY: ${response.data}");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        print("⚠️ Gagal hapus pendidikan: ${response.data}");
        throw Exception('Failed to delete education');
      }
    } on DioException catch (e) {
      print("❌ Error hapus pendidikan: ${e.message}");
      rethrow;
    }
  }







  //  -----------------------------------------------------------------------BAHASA

  // ================== GET BAHASA ==================
  Future<List<LanguageModel>> getLanguages() async {
    final prefs = await SharedPreferences.getInstance();
    final talentId = prefs.getString('talentId');

    if (talentId == null) {
      print("❌ TalentId tidak ditemukan");
      throw Exception('Unauthorized');
    }

    try {
      final response = await _dio.get(ApiConfig.getLanguageByTalent(talentId));

      print("GET Language - STATUS: ${response.statusCode}");
      print("GET Language - BODY: ${response.data}");

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => LanguageModel.fromJson(json)).toList();
      } else {
        print("⚠️ Gagal ambil data bahasa: ${response.data}");
        throw Exception('Failed to load language');
      }
    } on DioException catch (e) {
      print("❌ Error ambil bahasa: ${e.message}");
      rethrow;
    }
  }

  // ================== CREATE BAHASA ==================
  Future<Map<String, dynamic>> createLanguage(LanguageModel language) async {
    final prefs = await SharedPreferences.getInstance();
    final talentId = prefs.getString('talentId');

    if (talentId == null) {
      print("❌ TalentId tidak ditemukan");
      throw Exception('Unauthorized');
    }

    try {
      final response = await _dio.post(
        ApiConfig.createLanguage(),
        data: language.toJsonPost(talentId),
      );

      print("POST Language - STATUS: ${response.statusCode}");
      print("POST Language - BODY: ${response.data}");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        print("⚠️ Gagal tambah bahasa: ${response.data}");
        throw Exception('Failed to create language');
      }
    } on DioException catch (e) {
      print("❌ Error tambah bahasa: ${e.message}");
      rethrow;
    }
  }

  // ================== UPDATE BAHASA ==================
  Future<Map<String, dynamic>> updateLanguage(
    String languageId,
    LanguageModel language,
  ) async {
    try {
      final response = await _dio.put(
        ApiConfig.updateLanguage(languageId),
        data: language.toJsonPut(),
      );

      print("PUT Language - STATUS: ${response.statusCode}");
      print("PUT Language - BODY: ${response.data}");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        print("⚠️ Gagal update bahasa: ${response.data}");
        throw Exception('Failed to update language');
      }
    } on DioException catch (e) {
      print("❌ Error update bahasa: ${e.message}");
      rethrow;
    }
  }

  // ================== DELETE BAHASA ==================
  Future<Map<String, dynamic>> deleteLanguage(String languageId) async {
    try {
      final response = await _dio.delete(ApiConfig.deleteLanguage(languageId));

      print("DELETE Language - STATUS: ${response.statusCode}");
      print("DELETE Language - BODY: ${response.data}");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        print("⚠️ Gagal hapus bahasa: ${response.data}");
        throw Exception('Failed to delete language');
      }
    } on DioException catch (e) {
      print("❌ Error hapus bahasa: ${e.message}");
      rethrow;
    }
  }





  //  -----------------------------------------------------------------------PENGHARGAAN

  // ================== GET PENGHARGAAN ==================
  Future<List<AwardModel>> getAward() async {
    final prefs = await SharedPreferences.getInstance();
    final talentId = prefs.getString('talentId');

    if (talentId == null) {
      print("❌ TalentId tidak ditemukan");
      throw Exception('Unauthorized');
    }

    try {
      final response = await _dio.get(ApiConfig.getAwardByTalent(talentId));

      print("GET Award - STATUS: ${response.statusCode}");
      print("GET Award - BODY: ${response.data}");

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => AwardModel.fromJson(json)).toList();
      } else {
        print("⚠️ Gagal ambil data penghargaan: ${response.data}");
        throw Exception('Failed to load language');
      }
    } on DioException catch (e) {
      print("❌ Error ambil penghargaan: ${e.message}");
      rethrow;
    }
  }

  // ================== CREATE PENGHARGAAN ==================
  Future<Map<String, dynamic>> createAward(AwardModel award) async {
    final prefs = await SharedPreferences.getInstance();
    final talentId = prefs.getString('talentId');

    if (talentId == null) {
      print("❌ TalentId tidak ditemukan");
      throw Exception('Unauthorized');
    }

    try {
      final response = await _dio.post(
        ApiConfig.createAward(),
        data: award.toJsonPost(talentId),
      );

      print("POST Award - STATUS: ${response.statusCode}");
      print("POST Award - BODY: ${response.data}");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        print("⚠️ Gagal tambah penghargaan: ${response.data}");
        throw Exception('Failed to create language');
      }
    } on DioException catch (e) {
      print("❌ Error tambah penghargaan: ${e.message}");
      rethrow;
    }
  }

  // ================== UPDATE PENGHARGAAN ==================
  Future<Map<String, dynamic>> updateAward(
    String awardId,
    AwardModel award,
  ) async {
    try {
      final response = await _dio.put(
        ApiConfig.updateAward(awardId),
        data: award.toJsonPut(),
      );

      print("PUT Award - STATUS: ${response.statusCode}");
      print("PUT Award - BODY: ${response.data}");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        print("⚠️ Gagal update penghargaan: ${response.data}");
        throw Exception('Failed to update language');
      }
    } on DioException catch (e) {
      print("❌ Error update penghargaan: ${e.message}");
      rethrow;
    }
  }

  // ================== DELETE PENGHARGAAN ==================
  Future<Map<String, dynamic>> deleteAward(String awardId) async {
    try {
      final response = await _dio.delete(ApiConfig.deleteAward(awardId));

      print("DELETE Award - STATUS: ${response.statusCode}");
      print("DELETE Award - BODY: ${response.data}");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        print("⚠️ Gagal hapus penghargaan: ${response.data}");
        throw Exception('Failed to delete award');
      }
    } on DioException catch (e) {
      print("❌ Error hapus penghargaan: ${e.message}");
      rethrow;
    }
  }






  //  -----------------------------------------------------------------------SERTIFIKASI

  // ================== GET SERTIFIKASI ==================
  Future<List<CertificationModel>> getCertification() async {
    final prefs = await SharedPreferences.getInstance();
    final talentId = prefs.getString('talentId');

    if (talentId == null) {
      print("❌ TalentId tidak ditemukan");
      throw Exception('Unauthorized');
    }

    try {
      final response = await _dio.get(
        ApiConfig.getCertificationByTalent(talentId),
      );

      print("GET Certification - STATUS: ${response.statusCode}");
      print("GET Certification - BODY: ${response.data}");

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => CertificationModel.fromJson(json)).toList();
      } else {
        print("⚠️ Gagal ambil data sertifikasi: ${response.data}");
        throw Exception('Failed to load language');
      }
    } on DioException catch (e) {
      print("❌ Error ambil sertifikasi: ${e.message}");
      rethrow;
    }
  }

  // ================== CREATE SERTIFIKASI ==================
  Future<Map<String, dynamic>> createCertification(
    CertificationModel certification,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final talentId = prefs.getString('talentId');

    if (talentId == null) {
      print("❌ TalentId tidak ditemukan");
      throw Exception('Unauthorized');
    }

    try {
      final response = await _dio.post(
        ApiConfig.createCertification(),
        data: certification.toJsonPost(talentId),
      );

      print("POST Certification - STATUS: ${response.statusCode}");
      print("POST Certification - BODY: ${response.data}");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        print("⚠️ Gagal tambah sertifikasi: ${response.data}");
        throw Exception('Failed to create language');
      }
    } on DioException catch (e) {
      print("❌ Error tambah sertifikasi: ${e.message}");
      rethrow;
    }
  }

  // ================== UPDATE SERTIFIKASI ==================
  Future<Map<String, dynamic>> updateCertification(
    String certificationId,
    CertificationModel certification,
  ) async {
    try {
      final response = await _dio.put(
        ApiConfig.updateCertification(certificationId),
        data: certification.toJsonPut(),
      );

      print("PUT Certification - STATUS: ${response.statusCode}");
      print("PUT Certification - BODY: ${response.data}");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        print("⚠️ Gagal update sertifikasi: ${response.data}");
        throw Exception('Failed to update certification');
      }
    } on DioException catch (e) {
      print("❌ Error update sertifikasi: ${e.message}");
      rethrow;
    }
  }

  // ================== DELETE SERTIFIKASI ==================
  Future<Map<String, dynamic>> deleteCertification(
    String certificationId,
  ) async {
    try {
      final response = await _dio.delete(
        ApiConfig.deleteCertification(certificationId),
      );

      print("DELETE Certification - STATUS: ${response.statusCode}");
      print("DELETE Certification - BODY: ${response.data}");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        print("⚠️ Gagal hapus sertifikasi: ${response.data}");
        throw Exception('Failed to delete certification');
      }
    } on DioException catch (e) {
      print("❌ Error hapus sertifikasi: ${e.message}");
      rethrow;
    }
  }






  //  -----------------------------------------------------------------------PELATIHAN

  // ================== GET TRAINING ==================
  Future<List<TrainingModel>> getTraining() async {
    final prefs = await SharedPreferences.getInstance();
    final talentId = prefs.getString('talentId');

    if (talentId == null) {
      print("❌ TalentId tidak ditemukan");
      throw Exception('Unauthorized');
    }

    try {
      final response = await _dio.get(ApiConfig.getTrainingByTalent(talentId));

      print("GET Training - STATUS: ${response.statusCode}");
      print("GET Training - BODY: ${response.data}");

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => TrainingModel.fromJson(json)).toList();
      } else {
        print("⚠️ Gagal ambil data pelatihan: ${response.data}");
        throw Exception('Failed to load language');
      }
    } on DioException catch (e) {
      print("❌ Error ambil pelatihan: ${e.message}");
      rethrow;
    }
  }

  // ================== CREATE TRAINING ==================
  Future<Map<String, dynamic>> createTraining(TrainingModel training) async {
    final prefs = await SharedPreferences.getInstance();
    final talentId = prefs.getString('talentId');

    if (talentId == null) {
      print("❌ TalentId tidak ditemukan");
      throw Exception('Unauthorized');
    }

    try {
      final response = await _dio.post(
        ApiConfig.createTraining(),
        data: training.toJsonPost(talentId),
      );

      print("POST Training - STATUS: ${response.statusCode}");
      print("POST Training - BODY: ${response.data}");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        print("⚠️ Gagal tambah pelatihan: ${response.data}");
        throw Exception('Failed to create language');
      }
    } on DioException catch (e) {
      print("❌ Error tambah pelatihan: ${e.message}");
      rethrow;
    }
  }

  // ================== UPDATE TRAINING ==================
  Future<Map<String, dynamic>> updateTraining(
    String trainingId,
    TrainingModel training,
  ) async {
    try {
      final response = await _dio.put(
        ApiConfig.updateTraining(trainingId),
        data: training.toJsonPut(),
      );

      print("PUT training - STATUS: ${response.statusCode}");
      print("PUT training - BODY: ${response.data}");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        print("⚠️ Gagal update pelatihan: ${response.data}");
        throw Exception('Failed to update training');
      }
    } on DioException catch (e) {
      print("❌ Error update pelatihan: ${e.message}");
      rethrow;
    }
  }

  // ================== DELETE TRAINING ==================
  Future<Map<String, dynamic>> deleteTraining(String trainingId) async {
    try {
      final response = await _dio.delete(ApiConfig.deleteTraining(trainingId));

      print("DELETE training - STATUS: ${response.statusCode}");
      print("DELETE training - BODY: ${response.data}");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        print("⚠️ Gagal hapus pelatihan: ${response.data}");
        throw Exception('Failed to delete training');
      }
    } on DioException catch (e) {
      print("❌ Error hapus pelatihan: ${e.message}");
      rethrow;
    }
  }







  //  -----------------------------------------------------------------------SOFT SKILL

  // ================== GET SOFT SKILL ==================
  Future<List<SoftskillModel>> getSoftskill() async {
    final prefs = await SharedPreferences.getInstance();
    final talentId = prefs.getString('talentId');

    if (talentId == null) {
      print("❌ TalentId tidak ditemukan");
      throw Exception('Unauthorized');
    }

    try {
      final response = await _dio.get(ApiConfig.getSoftskillByTalent(talentId));

      print("GET Softskill - STATUS: ${response.statusCode}");
      print("GET Softskill - BODY: ${response.data}");

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => SoftskillModel.fromJson(json)).toList();
      } else {
        print("⚠️ Gagal ambil data softskill: ${response.data}");
        throw Exception('Failed to load language');
      }
    } on DioException catch (e) {
      print("❌ Error ambil softskill: ${e.message}");
      rethrow;
    }
  }

  // ================== CREATE SOFT SKILL ==================
  Future<Map<String, dynamic>> createSoftskill(SoftskillModel softskill) async {
    final prefs = await SharedPreferences.getInstance();
    final talentId = prefs.getString('talentId');

    if (talentId == null) {
      print("❌ TalentId tidak ditemukan");
      throw Exception('Unauthorized');
    }

    try {
      final response = await _dio.post(
        ApiConfig.createSoftskill(),
        data: softskill.toJsonPost(talentId),
      );

      print("POST softskill - STATUS: ${response.statusCode}");
      print("POST softskill - BODY: ${response.data}");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        print("⚠️ Gagal tambah softskill: ${response.data}");
        throw Exception('Failed to create softskill');
      }
    } on DioException catch (e) {
      print("❌ Error tambah softskill: ${e.message}");
      rethrow;
    }
  }

  // ================== UPDATE SOFT SKILL ==================
  Future<Map<String, dynamic>> updateSoftskill(
    String softskillId,
    SoftskillModel softskill,
  ) async {
    try {
      final response = await _dio.put(
        ApiConfig.updateSoftskill(softskillId),
        data: softskill.toJsonPut(),
      );

      print("PUT softskill - STATUS: ${response.statusCode}");
      print("PUT softskill - BODY: ${response.data}");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        print("⚠️ Gagal update softskill: ${response.data}");
        throw Exception('Failed to update softskill');
      }
    } on DioException catch (e) {
      print("❌ Error update softskill: ${e.message}");
      rethrow;
    }
  }

  // ================== DELETE SOFT SKILL ==================
  Future<Map<String, dynamic>> deleteSoftskill(String softskillId) async {
    try {
      final response = await _dio.delete(
        ApiConfig.deleteSoftskill(softskillId),
      );

      print("DELETE softskill - STATUS: ${response.statusCode}");
      print("DELETE softskill - BODY: ${response.data}");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        print("⚠️ Gagal hapus softskill: ${response.data}");
        throw Exception('Failed to delete softskill');
      }
    } on DioException catch (e) {
      print("❌ Error hapus softskill: ${e.message}");
      rethrow;
    }
  }







  //  -----------------------------------------------------------------------RIWAYAT PEKERJAAN

  // ================== GET RIWAYAT PEKERJAAN ==================
  Future<List<WorkHistoryModel>> getWorkHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final talentId = prefs.getString('talentId');

    if (talentId == null) {
      print("❌ TalentId tidak ditemukan");
      throw Exception('Unauthorized');
    }

    try {
      final response = await _dio.get(
        ApiConfig.getWorkHistoryByTalent(talentId),
      );

      print("GET WorkHistory - STATUS: ${response.statusCode}");
      print("GET WorkHistory - BODY: ${response.data}");

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => WorkHistoryModel.fromJson(json)).toList();
      } else {
        print("⚠️ Gagal ambil data WorkHistory: ${response.data}");
        throw Exception('Failed to load work history');
      }
    } on DioException catch (e) {
      print("❌ Error ambil WorkHistory: ${e.message}");
      rethrow;
    }
  }

  // ================== CREATE RIWAYAT PEKERJAAN ==================
  Future<Map<String, dynamic>> createWorkHistory(
    WorkHistoryModel workHistory,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final talentId = prefs.getString('talentId');

    if (talentId == null) {
      print("❌ TalentId tidak ditemukan");
      throw Exception('Unauthorized');
    }

    try {
      final response = await _dio.post(
        ApiConfig.createWorkHistory(),
        data: workHistory.toJsonPost(talentId),
      );

      print("POST WorkHistory - STATUS: ${response.statusCode}");
      print("POST WorkHistory - BODY: ${response.data}");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        print("⚠️ Gagal tambah WorkHistory: ${response.data}");
        throw Exception('Failed to create work history');
      }
    } on DioException catch (e) {
      print("❌ Error tambah WorkHistory: ${e.message}");
      rethrow;
    }
  }

  // ================== UPDATE RIWAYAT PEKERJAAN ==================
  Future<Map<String, dynamic>> updateWorkHistory(
    String workHistoryId,
    WorkHistoryModel workHistory,
  ) async {
    try {
      final response = await _dio.put(
        ApiConfig.updateWorkHistory(workHistoryId),
        data: workHistory.toJsonPut(),
      );

      print("PUT WorkHistory - STATUS: ${response.statusCode}");
      print("PUT WorkHistory - BODY: ${response.data}");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        print("⚠️ Gagal update WorkHistory: ${response.data}");
        throw Exception('Failed to update work history');
      }
    } on DioException catch (e) {
      print("❌ Error update WorkHistory: ${e.message}");
      rethrow;
    }
  }

  // ================== DELETE RIWAYAT PEKERJAAN ==================
  Future<Map<String, dynamic>> deleteWorkHistory(String workHistoryId) async {
    try {
      final response = await _dio.delete(
        ApiConfig.deleteWorkHistory(workHistoryId),
      );

      print("DELETE WorkHistory - STATUS: ${response.statusCode}");
      print("DELETE WorkHistory - BODY: ${response.data}");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        print("⚠️ Gagal hapus WorkHistory: ${response.data}");
        throw Exception('Failed to delete work history');
      }
    } on DioException catch (e) {
      print("❌ Error hapus WorkHistory: ${e.message}");
      rethrow;
    }
  }








  //  -----------------------------------------------------------------------PROYEK

  // ================== GET PROYEK ==================
  Future<List<ProjectModel>> getProject() async {
    final prefs = await SharedPreferences.getInstance();
    final talentId = prefs.getString('talentId');

    if (talentId == null) {
      print("❌ TalentId tidak ditemukan");
      throw Exception('Unauthorized');
    }

    try {
      final response = await _dio.get(ApiConfig.getProjectByTalent(talentId));

      print("GET project - STATUS: ${response.statusCode}");
      print("GET project - BODY: ${response.data}");

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => ProjectModel.fromJson(json)).toList();
      } else {
        print("⚠️ Gagal ambil data project: ${response.data}");
        throw Exception('Failed to load language');
      }
    } on DioException catch (e) {
      print("❌ Error ambil project: ${e.message}");
      rethrow;
    }
  }

  // ================== CREATE PROYEK ==================
  Future<Map<String, dynamic>> createProject(ProjectModel project) async {
    final prefs = await SharedPreferences.getInstance();
    final talentId = prefs.getString('talentId');

    if (talentId == null) {
      print("❌ TalentId tidak ditemukan");
      throw Exception('Unauthorized');
    }

    try {
      final response = await _dio.post(
        ApiConfig.createProject(),
        data: project.toJsonPost(talentId),
      );

      print("POST project - STATUS: ${response.statusCode}");
      print("POST project - BODY: ${response.data}");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        print("⚠️ Gagal tambah project: ${response.data}");
        throw Exception('Failed to create project');
      }
    } on DioException catch (e) {
      print("❌ Error tambah project: ${e.message}");
      rethrow;
    }
  }

  // ================== UPDATE PROYEK ==================
  Future<Map<String, dynamic>> updateProject(
    String projectId,
    ProjectModel project,
  ) async {
    try {
      final response = await _dio.put(
        ApiConfig.updateProject(projectId),
        data: project.toJsonPut(),
      );

      print("PUT project - STATUS: ${response.statusCode}");
      print("PUT project - BODY: ${response.data}");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        print("⚠️ Gagal update project: ${response.data}");
        throw Exception('Failed to update project');
      }
    } on DioException catch (e) {
      print("❌ Error update project: ${e.message}");
      rethrow;
    }
  }

  // ================== DELETE PROYEK ==================
  Future<Map<String, dynamic>> deleteProject(String projectId) async {
    try {
      final response = await _dio.delete(ApiConfig.deleteProject(projectId));

      print("DELETE project - STATUS: ${response.statusCode}");
      print("DELETE project - BODY: ${response.data}");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        print("⚠️ Gagal hapus project: ${response.data}");
        throw Exception('Failed to delete project');
      }
    } on DioException catch (e) {
      print("❌ Error hapus project: ${e.message}");
      rethrow;
    }
  }










  //  -----------------------------------------------------------------------PORTOFOLIO

  // ================== GET PORTOFOLIO ==================
  Future<List<PortofolioModel>> getPortofolio() async {
    final prefs = await SharedPreferences.getInstance();
    final talentId = prefs.getString('talentId');

    if (talentId == null) {
      print("❌ TalentId tidak ditemukan");
      throw Exception('Unauthorized');
    }

    try {
      final response = await _dio.get(ApiConfig.getPortofolioByTalent(talentId));

      print("GET Portofolio - STATUS: ${response.statusCode}");
      print("GET Portofolio - BODY: ${response.data}");

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => PortofolioModel.fromJson(json)).toList();
      } else {
        print("⚠️ Gagal ambil data Portofolio: ${response.data}");
        throw Exception('Failed to load Portofolio');
      }
    } on DioException catch (e) {
      print("❌ Error ambil Portofolio: ${e.message}");
      rethrow;
    }
  }

  // ================== CREATE PORTOFOLIO ==================
  Future<Map<String, dynamic>> createPortofolio(PortofolioModel portofolio) async {
    final prefs = await SharedPreferences.getInstance();
    final talentId = prefs.getString('talentId');

    if (talentId == null) {
      print("❌ TalentId tidak ditemukan");
      throw Exception('Unauthorized');
    }

    try {
      final response = await _dio.post(
        ApiConfig.createPortofolio(),
        data: portofolio.toJsonPost(talentId),
      );

      print("POST portofolio - STATUS: ${response.statusCode}");
      print("POST portofolio - BODY: ${response.data}");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        print("⚠️ Gagal tambah Portofolio: ${response.data}");
        throw Exception('Failed to create Portofolio');
      }
    } on DioException catch (e) {
      print("❌ Error tambah Portofolio: ${e.message}");
      rethrow;
    }
  }

  // ================== UPDATE PORTOFOLIO ==================
  Future<Map<String, dynamic>> updatePortofolio(
    String portofolioId,
    PortofolioModel portofolio,
  ) async {
    try {
      final response = await _dio.put(
        ApiConfig.updatePortofolio(portofolioId),
        data: portofolio.toJsonPut(),
      );

      print("PUT portofolio - STATUS: ${response.statusCode}");
      print("PUT portofolio - BODY: ${response.data}");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        print("⚠️ Gagal update portofolio: ${response.data}");
        throw Exception('Failed to update portofolio');
      }
    } on DioException catch (e) {
      print("❌ Error update portofolio: ${e.message}");
      rethrow;
    }
  }

  // ================== DELETE PORTOFOLIO ==================
  Future<Map<String, dynamic>> deletePortofolio(String portofolioId) async {
    try {
      final response = await _dio.delete(ApiConfig.deletePortofolio(portofolioId));

      print("DELETE portofolio - STATUS: ${response.statusCode}");
      print("DELETE portofolio - BODY: ${response.data}");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        print("⚠️ Gagal hapus portofolio: ${response.data}");
        throw Exception('Failed to delete portofolio');
      }
    } on DioException catch (e) {
      print("❌ Error hapus portofolio: ${e.message}");
      rethrow;
    }
  }








  // --------------------------------------------------------------------------LOKER UMUM-----------------------------------------------------------

  // ================== GET ALL LOKER UMUM ==================
  Future<List<LokerUmum>> getAllLokerUmum() async {
    var url = Uri.parse(ApiConfig.allLokerUmum);
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => LokerUmum.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // ================== GET LOKER DETAIL BY ID ==================
  Future<LokerUmumDetail?> getLokerUmumDetailById(String id) async {
    final url = Uri.parse(ApiConfig.lokerById(id));

    try {
      final response = await http.get(url);

      print("STATUS BY ID: ${response.statusCode}");
      print("RESPONSE BY ID: ${response.body}");

      if (response.statusCode == 200) {
        // Parse ke model LokerUmumDetail
        return LokerUmumDetail.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      print("ERROR: $e");
      return null;
    }
  }










  // --------------------------------------------------------------------------LAMAR LOKER-----------------------------------------------------------
  // ================== LAMAR LOKER UMUM ==================
    Future<LamarLokerResponse> lamarLokerUmum(String lowonganId) async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final talentId = prefs.getString('talentId');

      if (token == null || talentId == null) {
        print("❌ Token atau TalentId tidak ditemukan");
        throw Exception('Unauthorized');
      }

      try {
        // Set headers dengan token
        _dio.options.headers = {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        };

        final response = await _dio.post(
          ApiConfig.Lamarloker(lowonganId),
        );

        print("POST Lamar Loker - STATUS: ${response.statusCode}");
        print("POST Lamar Loker - BODY: ${response.data}");

        if (response.statusCode == 200) {
          return LamarLokerResponse.fromJson(response.data);
        } else {
          print("⚠️ Gagal melamar loker: ${response.data}");
          throw Exception(response.data['message'] ?? 'Failed to apply job');
        }
      } on DioException catch (e) {
        print("❌ Error melamar loker: ${e.message}");
        
        // Handle specific error responses
        if (e.response != null) {
          final errorData = e.response!.data;
          final errorMessage = errorData['message'] ?? 'Terjadi kesalahan saat melamar';
          throw Exception(errorMessage);
        }
        
        throw Exception('Terjadi kesalahan jaringan');
      }
    }



  // ================== GET LAMARAN SAYA ==================
    Future<List<LamaranSaya>> getLamaranSaya() async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final talentId = prefs.getString('talentId');

      if (token == null || talentId == null) {
        print("❌ Token atau TalentId tidak ditemukan");
        throw Exception('Unauthorized');
      }

      try {
        // Set headers dengan token
        _dio.options.headers = {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        };

        final response = await _dio.get(
          ApiConfig.getLamaranSaya(),
        );

        print("GET Lamaran Saya - STATUS: ${response.statusCode}");
        print("GET Lamaran Saya - BODY: ${response.data}");

        if (response.statusCode == 200) {
          final List<dynamic> data = response.data;
          return data.map((json) => LamaranSaya.fromJson(json)).toList();
        } else {
          print("⚠️ Gagal ambil data lamaran: ${response.data}");
          throw Exception('Failed to load job applications');
        }
      } on DioException catch (e) {
        print("❌ Error ambil lamaran: ${e.message}");
        
        if (e.response != null) {
          final errorData = e.response!.data;
          final errorMessage = errorData['message'] ?? 'Terjadi kesalahan saat mengambil data lamaran';
          throw Exception(errorMessage);
        }
        
        throw Exception('Terjadi kesalahan jaringan');
      }
    }

  // ================== GET LOWONGAN YANG SUDAH DILAMAR ==================
  Future<List<String>> getLowonganSudahDilamar() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final talentId = prefs.getString('talentId');

    if (token == null || talentId == null) {
      print("❌ Token atau TalentId tidak ditemukan");
      throw Exception('Unauthorized');
    }

    try {
      // Set headers dengan token
      _dio.options.headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final response = await _dio.get(
        ApiConfig.getLamaranSaya(),
      );

      print("GET Lowongan Sudah Dilamar - STATUS: ${response.statusCode}");

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        
        // Extract hanya lowonganId dari data lamaran
        final appliedJobIds = data.map<String>((lamaran) {
          return lamaran['lowonganId'] as String;
        }).toList();

        print("✅ Lowongan yang sudah dilamar: $appliedJobIds");
        return appliedJobIds;
      } else {
        print("⚠️ Gagal ambil data lowongan yang sudah dilamar: ${response.data}");
        throw Exception('Failed to load applied jobs');
      }
    } on DioException catch (e) {
      print("❌ Error ambil lowongan yang sudah dilamar: ${e.message}");
      
      if (e.response != null) {
        final errorData = e.response!.data;
        final errorMessage = errorData['message'] ?? 'Terjadi kesalahan saat mengambil data lowongan yang sudah dilamar';
        throw Exception(errorMessage);
      }
      
      throw Exception('Terjadi kesalahan jaringan');
    }
  }


    // ================== BATAL LAMARAN ==================
    Future<BatalLamaranResponse> batalkanLamaran(String lamaranId) async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final talentId = prefs.getString('talentId');

      if (token == null || talentId == null) {
        print("❌ Token atau TalentId tidak ditemukan");
        throw Exception('Unauthorized');
      }

      try {
        // Set headers dengan token
        _dio.options.headers = {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        };

        final response = await _dio.delete(
          ApiConfig.batalkanLamaran(lamaranId),
        );

        print("DELETE Batalkan Lamaran - STATUS: ${response.statusCode}");
        print("DELETE Batalkan Lamaran - BODY: ${response.data}");

        if (response.statusCode == 200) {
          return BatalLamaranResponse.fromJson(response.data);
        } else {
          print("⚠️ Gagal batalkan lamaran: ${response.data}");
          throw Exception(response.data['message'] ?? 'Failed to cancel application');
        }
      } on DioException catch (e) {
        print("❌ Error batalkan lamaran: ${e.message}");
        
        if (e.response != null) {
          final errorData = e.response!.data;
          final errorMessage = errorData['message'] ?? 'Terjadi kesalahan saat membatalkan lamaran';
          throw Exception(errorMessage);
        }
        
        throw Exception('Terjadi kesalahan jaringan');
      }
    }


















}
