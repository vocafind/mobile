import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:jobfair/models/loker_umum_detail_model.dart';
import 'package:jobfair/models/loker_umum_model.dart';
import 'package:jobfair/models/talent_profile_model.dart';
import 'endpoints.dart';
import 'dart:convert';
import 'package:jobfair/models/talent_social_media_model.dart';


class ApiService {
  



  // --------------------------------------------------------------------------Talents-----------------------------------------------------------
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

  // ================== LOGIN ==================
  Future<Map<String, dynamic>> loginTalent(
    String email,
    String password,
  ) async {
    var url = Uri.parse(ApiConfig.loginTalent);

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "Email": email, // Gunakan huruf besar "E" karena DTO pakai Email
          "Password": password,
        },
      );

      print("STATUS: ${response.statusCode}");
      print("RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // { message, token, talentId }
      } else {
        return jsonDecode(response.body); // { message: ... }
      }
    } catch (e) {
      return {"message": "Gagal terhubung ke server"};
    }
  }



  // ================== GET PROFIL / DATA DIRI ==================
  Future<TalentProfileModel?> getProfilDataDiri() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final talentId = prefs.getString('talentId');

    if (token == null || talentId == null) {
      print("❌ Token atau TalentId tidak ditemukan di SharedPreferences");
      return null;
    }

    final url = Uri.parse(ApiConfig.profilDataDiri(talentId));

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print("URL: $url");
      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Simpan cache profil
        prefs.setString('cachedProfile', response.body);

        return TalentProfileModel.fromJson(data);
      } else {
        print("⚠️ Gagal ambil data profil: ${response.body}");
        return null;
      }
    } catch (e) {
      print("❌ Error ambil profil: $e");
      return null;
    }
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


// Tambahkan methods ini ke dalam class ApiService yang sudah ada

  // ================== GET SOCIAL MEDIA ==================
  Future<List<SocialMediaModel>> getSocialMedia() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final talentId = prefs.getString('talentId');

    if (token == null || talentId == null) {
      print("❌ Token atau TalentId tidak ditemukan");
      throw Exception('Unauthorized');
    }

    final url = Uri.parse(ApiConfig.getSocialMediaByTalent(talentId));

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print("GET Social Media - URL: $url");
      print("GET Social Media - STATUS: ${response.statusCode}");
      print("GET Social Media - BODY: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => SocialMediaModel.fromJson(json)).toList();
      } else {
        print("⚠️ Gagal ambil social media: ${response.body}");
        throw Exception('Failed to load social media');
      }
    } catch (e) {
      print("❌ Error ambil social media: $e");
      rethrow;
    }
  }

  // ================== CREATE SOCIAL MEDIA ==================
  Future<Map<String, dynamic>> createSocialMedia(SocialMediaModel socialMedia) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final talentId = prefs.getString('talentId');

    if (token == null || talentId == null) {
      print("❌ Token atau TalentId tidak ditemukan");
      throw Exception('Unauthorized');
    }

    final url = Uri.parse(ApiConfig.createSocialMedia());

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(socialMedia.toJsonPost(talentId)),
      );

      print("POST Social Media - URL: $url");
      print("POST Social Media - STATUS: ${response.statusCode}");
      print("POST Social Media - BODY: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("⚠️ Gagal tambah social media: ${response.body}");
        throw Exception('Failed to create social media');
      }
    } catch (e) {
      print("❌ Error tambah social media: $e");
      rethrow;
    }
  }

  // ================== UPDATE SOCIAL MEDIA ==================
  Future<Map<String, dynamic>> updateSocialMedia(String socialId, SocialMediaModel socialMedia) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print("❌ Token tidak ditemukan");
      throw Exception('Unauthorized');
    }

    final url = Uri.parse(ApiConfig.updateSocialMedia(socialId));

    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(socialMedia.toJsonPut()),
      );

      print("PUT Social Media - URL: $url");
      print("PUT Social Media - STATUS: ${response.statusCode}");
      print("PUT Social Media - BODY: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("⚠️ Gagal update social media: ${response.body}");
        throw Exception('Failed to update social media');
      }
    } catch (e) {
      print("❌ Error update social media: $e");
      rethrow;
    }
  }

  // ================== DELETE SOCIAL MEDIA ==================
  Future<Map<String, dynamic>> deleteSocialMedia(String socialId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print("❌ Token tidak ditemukan");
      throw Exception('Unauthorized');
    }

    final url = Uri.parse(ApiConfig.deleteSocialMedia(socialId));

    try {
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print("DELETE Social Media - URL: $url");
      print("DELETE Social Media - STATUS: ${response.statusCode}");
      print("DELETE Social Media - BODY: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("⚠️ Gagal hapus social media: ${response.body}");
        throw Exception('Failed to delete social media');
      }
    } catch (e) {
      print("❌ Error hapus social media: $e");
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
}
