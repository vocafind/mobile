class ApiConfig {
  // Ganti IP dengan IP komputer server kamu
  static const String baseUrl = "http://10.136.136.147:5035/api";
  static const String baseUrlFoto = "http://10.136.136.147:5035/";
  // static const String baseUrl = "https://trpl306-001-site1.ntempurl.com/api";
  // static const String baseUrlFoto = "https://trpl306-001-site1.ntempurl.com/";

  // ------------------------------------------------------------- TALENTS AUTH

  static const String registerTalent = "$baseUrl/Auth/registerTalent";   // Register
  static const String loginTalent = "$baseUrl/Auth/loginTalent";   // Login
  static const String refreshToken = "$baseUrl/Auth/refresh-token";   // Refresh token
  static const String logout = "$baseUrl/Auth/logout";   // Logout

  //Save fcm token
  static const String saveFcmToken = "$baseUrl/fcmtoken/saveFcmToken";


  //Change PW
  static const String changePW = "$baseUrl/Auth/change-password";







  //Logo Perusahaan
  static const String allLogoPerusahaan = "$baseUrl/Company/logos";







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








  // ---------------------------TALENTS Kompetensi---------------------------TALENTS Kompetensi---------------------------TALENTS Kompetensi 

  // ------------------------------------------------------------------------------------------ SERTIFIKASI
  static String getCertificationByTalent(String talentId) => "$baseUrl/Talents/profil/sertifikasi/$talentId";         // GET sertifikasi
  static String createCertification() => "$baseUrl/Talents/profil/sertifikasi/";                                      // POST sertifikasi
  static String updateCertification(String certificationId) => "$baseUrl/Talents/profil/sertifikasi/$certificationId";                // Update sertifikasi
  static String deleteCertification(String certificationId) => "$baseUrl/Talents/profil/sertifikasi/$certificationId";                // Hapus sertifikasi


  // ------------------------------------------------------------------------------------------ PELATIHAN
  static String getTrainingByTalent(String talentId) => "$baseUrl/Talents/profil/pelatihan/$talentId";         // GET pelatihan
  static String createTraining() => "$baseUrl/Talents/profil/pelatihan/";                                      // POST pelatihan
  static String updateTraining(String trainingId) => "$baseUrl/Talents/profil/pelatihan/$trainingId";                // Update pelatihan
  static String deleteTraining(String trainingId) => "$baseUrl/Talents/profil/pelatihan/$trainingId";                // Hapus pelatihan


  // ------------------------------------------------------------------------------------------ Soft Skill
  static String getSoftskillByTalent(String talentId) => "$baseUrl/Talents/profil/softskill/$talentId";         // GET softskill
  static String createSoftskill() => "$baseUrl/Talents/profil/softskill/";                                      // POST softskill
  static String updateSoftskill(String softskillId) => "$baseUrl/Talents/profil/softskill/$softskillId";                // Update softskill
  static String deleteSoftskill(String softskillId) => "$baseUrl/Talents/profil/softskill/$softskillId";                // Hapus softskill







  // ---------------------------TALENTS Pengalaman---------------------------TALENTS Pengalaman---------------------------TALENTS Pengalaman 

  // ------------------------------------------------------------------------------------------ RIWAYAT PEKERJAAN
  static String getWorkHistoryByTalent(String talentId) => "$baseUrl/Talents/profil/riwayat_pekerjaan/$talentId";         // GET WorkHistory
  static String createWorkHistory() => "$baseUrl/Talents/profil/riwayat_pekerjaan/";                                      // POST WorkHistory
  static String updateWorkHistory(String workHistoryId) => "$baseUrl/Talents/profil/riwayat_pekerjaan/$workHistoryId";                // Update WorkHistory
  static String deleteWorkHistory(String workHistoryId) => "$baseUrl/Talents/profil/riwayat_pekerjaan/$workHistoryId";                // Hapus WorkHistory


  // ------------------------------------------------------------------------------------------ PROYEK
  static String getProjectByTalent(String talentId) => "$baseUrl/Talents/profil/proyek/$talentId";         // GET proyek
  static String createProject() => "$baseUrl/Talents/profil/proyek/";                                      // POST proyek
  static String updateProject(String projectId) => "$baseUrl/Talents/profil/proyek/$projectId";                // Update proyek
  static String deleteProject(String projectId) => "$baseUrl/Talents/profil/proyek/$projectId";                // Hapus proyek


  // ------------------------------------------------------------------------------------------ PORTOFOLIO
  static String getPortofolioByTalent(String talentId) => "$baseUrl/Talents/profil/portofolio/$talentId";         // GET portofolio
  static String createPortofolio() => "$baseUrl/Talents/profil/portofolio/";                                      // POST portofolio
  static String updatePortofolio(String portofolioId) => "$baseUrl/Talents/profil/portofolio/$portofolioId";                // Update portofolio
  static String deletePortofolio(String portofolioId) => "$baseUrl/Talents/profil/portofolio/$portofolioId";                // Hapus portofolio




  // ------------------------------------------------------------- LOKER REKOMENDASI
  static String allLokerRekomendasi = "$baseUrl/LokerRekomendasi";                                // Get All Loker Rekomendasi


  // ------------------------------------------------------------- LOKER UMUM
  static String allLokerUmum = "$baseUrl/LokerUmum";                                // Get All Loker Um// Get all Loker Umum
  static String lokerById(String id) => "$baseUrl/LokerUmum/$id";                   // Get Loker Umum by ID


  // ------------------------------------------------------------- Search Filter
  static String searchLokerUmum = '$baseUrl/LokerUmum/search';

  static String filterLokerUmum = '$baseUrl/LokerUmum/filter';
  static String lokasi = '$baseUrl/LokerUmum/locations';



  // ------------------------------------------------------------- Lamar Loker Umum
  static String Lamarloker(String lowonganId) => "$baseUrl/Lamar/lokerUmum/$lowonganId";                   // Lamar Loker UUmum
  static String getLamaranSaya() => "$baseUrl/Lamar/lamaran-saya";                                         // Get Lamaran Saya
    static String getLamaranJobfairSaya() => "$baseUrl/Lamar/lamaran-jobfair-saya"; // Hanya jobfair
  static String batalkanLamaran(String lamaranId) => "$baseUrl/Lamar/batal/$lamaranId";                    // Batalkan Lamaran


  // ------------------------------------------------------------- Simpan Loker
  static String saveJob(String lowonganId) => "$baseUrl/SavedJobs/simpan/$lowonganId";                   // Lamar Loker UUmum
  static String getSaveJob() => "$baseUrl/SavedJobs/saya";                                         // Get saved Saya
  static String unsaveJob(String savedJobId) => "$baseUrl/SavedJobs/hapus/$savedJobId";     

  static String checkSavedJob(String lowonganId) => "$baseUrl/SavedJobs/cek/$lowonganId";
  static String getSavedJobsCount() => "$baseUrl/SavedJobs/jumlah";
  static String unsaveJobByLowonganId(String lowonganId) => "$baseUrl/SavedJobs/hapus-by-lowongan/$lowonganId";






  // ------------------------------------------------------------- JOB FAIR
  static String allJobfair = "$baseUrl/Jobfair";                                // Get All Job Fair
  static String jobfairById(String id) => "$baseUrl/Jobfair/$id";                   // Get Jobfair Detail
  static String allLokerByJobfair(String jobfairId) => "$baseUrl/LokerJobfair/by-jobfair/$jobfairId";                   // Get Jobfair Detail
  static String lokerJobfairDetail(String id) => "$baseUrl/LokerJobfair/detail/$id";                   // Get Jobfair Detail


  // Helper untuk mendapatkan full image URL
  static String getFullImageUrl(String? relativePath) {
    if (relativePath == null || relativePath.isEmpty) {
      return '';
    }
    
    // Jika URL sudah lengkap (http/https), return langsung
    if (relativePath.startsWith('http://') || relativePath.startsWith('https://')) {
      return relativePath;
    }
    
    // Jika relative path, gabungkan dengan baseUrlFoto
    // Hapus slash di depan jika ada
    final cleanPath = relativePath.startsWith('/') 
        ? relativePath.substring(1) 
        : relativePath;
    
    return '$baseUrlFoto$cleanPath';
  }


  // Lamar Jobfair
  static String lamarJobfair(String lowonganId) => "$baseUrl/LamarJobfair/lokerAcara/$lowonganId";
  static String getLamaranAcaraSaya(String acaraId) => "$baseUrl/LamarJobfair/lamaran-acara-saya/$acaraId";
  static String getSemuaLamaranAcara() => "$baseUrl/LamarJobfair/semua-lamaran-acara";
  static String batalkanLamaranAcara(String applyId) => "$baseUrl/LamarJobfair/batal/$applyId";
  static String getStatusRegistrasiAcara(int acaraId) => "$baseUrl/LamarJobfair/status-registrasi/$acaraId";



  // Notifikasi
  static String allNotifikasi = "$baseUrl/Notification";                                // Get All Notifikasi
  static String readNotifikasi(String notificationId) => "$baseUrl/Notification/read/$notificationId";
  static String deleteNotifikasi(String notificationId) => "$baseUrl/Notification/$notificationId";

}
