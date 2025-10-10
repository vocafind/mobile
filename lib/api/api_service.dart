import 'package:http/http.dart' as http;
import 'endpoints.dart';

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




}
