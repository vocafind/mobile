class ApiConfig {
  // Ganti IP dengan IP komputer server kamu
  static const String baseUrl = "http://10.136.144.118:5035/api";
  static const String baseUrlFoto = "http://10.136.144.118:5035/";

  // ------------------------------------------------------------- TALENTS AUTH

  static const String registerTalent = "$baseUrl/Auth/registerTalent";   // Register
  static const String loginTalent = "$baseUrl/Auth/loginTalent";   // Login
  static const String refreshToken = "$baseUrl/Auth/refresh-token";   // Login



  // ------------------------------------------------------------- TALENTS PROFIL / DATA DIRI
  
  static String profilDataDiri(String id) => "$baseUrl/Talents/profil/data_diri/$id"; // headerprofil / data diri
  static String updateTalent(String id) => "$baseUrl/Talents/$id"; // Update profil data diri (PATCH)



  // ------------------------------------------------------------- TALENTS PROFIL / MEDIA SOSIAL
  
  static String getSocialMediaByTalent(String talentId) => "$baseUrl/Talents/profil/media_sosial/$talentId"; /// GET: Ambil semua social media talent berdasarkan talentId
  static String createSocialMedia() => "$baseUrl/Talents/profil/media_sosial/"; // POST: Tambah akun sosial media baru
  static String updateSocialMedia(String socialId) => "$baseUrl/Talents/profil/media_sosial/$socialId"; // PUT: Update akun sosial berdasarkan socialId
  static String deleteSocialMedia(String socialId) => "$baseUrl/Talents/profil/media_sosial/$socialId"; // DELETE: Hapus akun sosial berdasarkan socialId




  // ------------------------------------------------------------- TALENTS PROFIL / MINAT KARIR
  
  static String getCareerInterestByTalent(String talentId) => "$baseUrl/Talents/profil/minat_karir/$talentId"; /// GET: Ambil semua minat karir talent berdasarkan talentId
  static String createCareerInterest() => "$baseUrl/Talents/profil/minat_karir/"; // POST: Tambah minat karir baru
  static String updateCareerInterest(String minatId) => "$baseUrl/Talents/profil/minat_karir/$minatId"; // PUT: Update minat karir berdasarkan minatId
  static String deleteCareerInterest(String minatId) => "$baseUrl/Talents/profil/minat_karir/$minatId"; // DELETE: Hapus minat karir berdasarkan minatId





  // ------------------------------------------------------------- TALENTS PROFIL / REFERENSI
  
  static String getReferenceByTalent(String talentId) => "$baseUrl/Talents/profil/referensi/$talentId"; /// GET: Ambil semua referensi talent berdasarkan talentId
  static String createReference() => "$baseUrl/Talents/profil/referensi/"; // POST: Tambah referensi baru
  static String updateReference(String minatId) => "$baseUrl/Talents/profil/referensi/$minatId"; // PUT: Update referensi berdasarkan minatId
  static String deleteReference(String minatId) => "$baseUrl/Talents/profil/referensi/$minatId"; // DELETE: Hapus referensi berdasarkan minatId















  // ------------------------------------------------------------- LOKER UMUM
  // Get all Loker Umum
  static const String allLokerUmum = "$baseUrl/LokerUmum";

  // Get Loker Umum by ID
  static String lokerById(String id) => "$baseUrl/LokerUmum/$id";
}
