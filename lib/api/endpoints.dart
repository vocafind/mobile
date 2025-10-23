class ApiConfig {
  static const String baseUrl = "http://192.168.1.3:5035/api";  //ganti 10.136.149.51 dengan ip address komputer 


  // -------------------------------------------------------------TALENTS
  //Register
  static const String registerTalent = "$baseUrl/Talents/register";

  //Login
  static const String loginTalent = "$baseUrl/Talents/login";

  //profil header / data diri
  static const String profilDataDiri = "$baseUrl/Talents/profil/data_diri";

  // update profil header / data diri
  static String updateTalent(String id) => "$baseUrl/Talents/$id";
  









  // -------------------------------------------------------------LOKER UMUM
  //Get All Loker Umum
  static const String allLokerUmum = "$baseUrl/LokerUmum";

  //Get Loker Umum By ID 
  static String lokerById(String id) => "$baseUrl/LokerUmum/$id";




}
