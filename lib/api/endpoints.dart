class ApiConfig {
  // Ganti IP dengan IP komputer server kamu
  static const String baseUrl = "http://10.136.144.240:5035/api";
  static const String baseUrlFoto = "http://10.136.144.240:5035/";

  // ------------------------------------------------------------- TALENTS AUTH

  static const String registerTalent = "$baseUrl/Auth/registerTalent";   // Register
  static const String loginTalent = "$baseUrl/Auth/loginTalent";   // Login
  static const String refreshToken = "$baseUrl/Auth/refresh-token";   // Refresh token



  // ---------------------------TALENTS PROFIL---------------------------TALENTS PROFIL---------------------------TALENTS PROFIL 
  
  // ------------------------------------------------------------------------------------------DATA DIRI
  
  static String profilDataDiri(String id) => "$baseUrl/Talents/profil/data_diri/$id";   // get headerprofil data diri
  static String updateTalent(String id) => "$baseUrl/Talents/$id";                      // Update profil 



  // ----------------------------------------------------------------------------------------  MEDIA SOSIAL
  
  static String getSocialMediaByTalent(String talentId) => "$baseUrl/Talents/profil/media_sosial/$talentId";  // GET sosmed
  static String createSocialMedia() => "$baseUrl/Talents/profil/media_sosial/";                               // Post sosmed
  static String updateSocialMedia(String socialId) => "$baseUrl/Talents/profil/media_sosial/$socialId";       // Update sosmed
  static String deleteSocialMedia(String socialId) => "$baseUrl/Talents/profil/media_sosial/$socialId";       // Hapussosmed



  // ----------------------------------------------------------------------------------------- MINAT KARIR
  
  static String getCareerInterestByTalent(String talentId) => "$baseUrl/Talents/profil/minat_karir/$talentId";  // get minat karir 
  static String createCareerInterest() => "$baseUrl/Talents/profil/minat_karir/";                               // POST minat karir
  static String updateCareerInterest(String minatId) => "$baseUrl/Talents/profil/minat_karir/$minatId";         // Update minat karir
  static String deleteCareerInterest(String minatId) => "$baseUrl/Talents/profil/minat_karir/$minatId";         // DELETE minat karir



  // ------------------------------------------------------------------------------------------ REFERENSI
  
  static String getReferenceByTalent(String talentId) => "$baseUrl/Talents/profil/referensi/$talentId";         // GET referensi
  static String createReference() => "$baseUrl/Talents/profil/referensi/";                                      // POST referensi
  static String updateReference(String referenceId) => "$baseUrl/Talents/profil/referensi/$referenceId";                // Update referensi
  static String deleteReference(String referenceId) => "$baseUrl/Talents/profil/referensi/$referenceId";                // Hapus referensi




  // ---------------------------TALENTS AKADEMIK---------------------------TALENTS AKADEMIK---------------------------TALENTS AKADEMIK 

  // ------------------------------------------------------------------------------------------ PENDIDIKAN
  
  static String getEducationByTalent(String talentId) => "$baseUrl/Talents/profil/pendidikan/$talentId";         // GET pendidikan
  static String createEducation() => "$baseUrl/Talents/profil/pendidikan/";                                      // POST pendidikan
  static String updateEducation(String educationId) => "$baseUrl/Talents/profil/pendidikan/$educationId";                // Update pendidikan
  static String deleteEducation(String educationId) => "$baseUrl/Talents/profil/pendidikan/$educationId";                // Hapus pendidikan


  // ------------------------------------------------------------------------------------------ BAHASA
  
  static String getLanguageByTalent(String talentId) => "$baseUrl/Talents/profil/bahasa/$talentId";         // GET bahasa
  static String createLanguage() => "$baseUrl/Talents/profil/bahasa/";                                      // POST bahasa
  static String updateLanguage(String languageId) => "$baseUrl/Talents/profil/bahasa/$languageId";                // Update bahasa
  static String deleteLanguage(String languageId) => "$baseUrl/Talents/profil/bahasa/$languageId";                // Hapus bahasa



  // ------------------------------------------------------------------------------------------ PENGHARGAAN
  
  static String getAwardByTalent(String talentId) => "$baseUrl/Talents/profil/penghargaan/$talentId";         // GET penghargaan
  static String createAward() => "$baseUrl/Talents/profil/penghargaan/";                                      // POST penghargaan
  static String updateAward(String awardId) => "$baseUrl/Talents/profil/penghargaan/$awardId";                // Update penghargaan
  static String deleteAward(String awardId) => "$baseUrl/Talents/profil/penghargaan/$awardId";                // Hapus penghargaan








  // ------------------------------------------------------------- LOKER UMUM
  // Get all Loker Umum
  static const String allLokerUmum = "$baseUrl/LokerUmum";

  // Get Loker Umum by ID
  static String lokerById(String id) => "$baseUrl/LokerUmum/$id";
}
