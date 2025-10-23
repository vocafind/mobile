class ApiConfig {
  // Ganti IP dengan IP komputer server kamu
  static const String baseUrl = "http://10.136.143.248:5035/api";

  // ------------------------------------------------------------- TALENTS AUTH
  // Register
  static const String registerTalent = "$baseUrl/Talents/register";

  // Login
  static const String loginTalent = "$baseUrl/Talents/login";

  // ------------------------------------------------------------- TALENTS PROFIL / DATA DIRI
  // Profil header / data diri (GET / PATCH pakai ID)
  static String profilDataDiri(String id) =>
      "$baseUrl/Talents/profil/data_diri/$id";

  // Update profil data diri (PATCH)
  static String updateTalent(String id) => "$baseUrl/Talents/$id";

  // ------------------------------------------------------------- TALENTS PROFIL / MEDIA SOSIAL
  // GET: Ambil semua social media talent berdasarkan talentId
  // Endpoint: GET /api/Talents/profil/media_sosial/{talentId}
  static String getSocialMediaByTalent(String talentId) =>
      "$baseUrl/Talents/profil/media_sosial/$talentId";

  // POST: Tambah akun sosial media baru
  // Endpoint: POST /api/Talents/profil/media_sosial/
  static String createSocialMedia() => "$baseUrl/Talents/profil/media_sosial/";

  // PUT: Update akun sosial berdasarkan socialId
  // Endpoint: PUT /api/Talents/profil/media_sosial/{id}
  static String updateSocialMedia(String socialId) =>
      "$baseUrl/Talents/profil/media_sosial/$socialId";

  // DELETE: Hapus akun sosial berdasarkan socialId
  // Endpoint: DELETE /api/Talents/profil/media_sosial/{id}
  static String deleteSocialMedia(String socialId) =>
      "$baseUrl/Talents/profil/media_sosial/$socialId";

  // ------------------------------------------------------------- LOKER UMUM
  // Get all Loker Umum
  static const String allLokerUmum = "$baseUrl/LokerUmum";

  // Get Loker Umum by ID
  static String lokerById(String id) => "$baseUrl/LokerUmum/$id";
}
