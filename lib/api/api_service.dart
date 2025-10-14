import 'package:http/http.dart' as http;
import 'package:jobfair/models/loker_umum_detail_model.dart';
import 'package:jobfair/models/loker_umum_model.dart';
import 'endpoints.dart';
import 'dart:convert';


class ApiService {

  // --------------------------------------------------------------------------Talents-----------------------------------------------------------
  
  //Register Talents
  Future<http.StreamedResponse> registerTalent(Map<String, String> fields, String? filePath) async {
    var url = Uri.parse(ApiConfig.registerTalent);
    var request = http.MultipartRequest('POST', url);

    request.fields.addAll(fields);

    if (filePath != null) {
      request.files.add(await http.MultipartFile.fromPath('Ktp', filePath));
    }

    return await request.send();
  }


  // ================== LOGIN TALENT ==================
  Future<Map<String, dynamic>> loginTalent(String email, String password) async {
    var url = Uri.parse(ApiConfig.loginTalent);

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: {
          "Email": email,     // Gunakan huruf besar "E" karena DTO pakai Email
          "Password": password
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
