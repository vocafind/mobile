import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'dart:convert';

import 'package:jobfair/api/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedFileName;
  String? _selectedFilePath;
  bool _isLoading = false;

  final apiService = ApiService();

  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _provinsiController = TextEditingController();
  final TextEditingController _kabupatenController = TextEditingController();
  final TextEditingController _jenisKelaminController = TextEditingController();
  final TextEditingController _usiaController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nomorController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nikController.addListener(_handleNikChange);
  }

  @override
  void dispose() {
    _nikController.dispose();
    _provinsiController.dispose();
    _kabupatenController.dispose();
    _jenisKelaminController.dispose();
    _usiaController.dispose();
    _namaController.dispose();
    _emailController.dispose();
    _nomorController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

   // 🔹 Fungsi untuk handle perubahan NIK
  void _handleNikChange() async {
    final nik = _nikController.text;

    // Ambil kode provinsi & kabupaten dari 6 digit pertama
    if (nik.length >= 6) {
      final kodeProv = nik.substring(0, 2);
      final kodeKab = nik.substring(0, 4);

      try {
        // Ambil daftar provinsi
        final provRes = await http.get(
          Uri.parse('https://www.emsifa.com/api-wilayah-indonesia/api/provinces.json'),
        );
        if (provRes.statusCode == 200) {
          final provList = json.decode(provRes.body);
          final prov = provList.firstWhere(
            (p) => p['id'] == kodeProv,
            orElse: () => null,
          );

          if (prov != null) {
            _provinsiController.text = prov['name'];

            // Ambil daftar kota
            final kotaRes = await http.get(
              Uri.parse('https://www.emsifa.com/api-wilayah-indonesia/api/regencies/${prov['id']}.json'),
            );
            if (kotaRes.statusCode == 200) {
              final kotaList = json.decode(kotaRes.body);
              final kota = kotaList.firstWhere(
                (k) => k['id'] == kodeKab,
                orElse: () => null,
              );

              if (kota != null) {
                _kabupatenController.text = kota['name'];
              }
            }
          }
        }
      } catch (e) {
        debugPrint("Gagal ambil provinsi/kota: $e");
      }
    }

    // Ambil jenis kelamin & usia
    if (nik.length >= 12) {
      final tanggalRaw = int.tryParse(nik.substring(6, 8)) ?? 0;
      final bulanRaw = int.tryParse(nik.substring(8, 10)) ?? 0;
      final tahunRaw = int.tryParse(nik.substring(10, 12)) ?? 0;

      final jenisKelamin = tanggalRaw > 40 ? 'Perempuan' : 'Laki-Laki';
      _jenisKelaminController.text = jenisKelamin;

      final tanggal = tanggalRaw > 40 ? tanggalRaw - 40 : tanggalRaw;
      final tahun = (tahunRaw <= 24) ? 2000 + tahunRaw : 1900 + tahunRaw;
      final birthDate = DateTime(tahun, bulanRaw, tanggal);
      final now = DateTime.now();

      int usia = now.year - birthDate.year;
      if (now.month < birthDate.month ||
          (now.month == birthDate.month && now.day < birthDate.day)) {
        usia--;
      }

      if (usia > 0 && usia < 120) {
        _usiaController.text = usia.toString();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                
                // Logo
                Center(
                  child: Image.asset(
                    "assets/images/Logo2.png",
                    width: 82,
                    height: 82,
                  ),
                ),
                const SizedBox(height: 24),

                // Title
                const Center(
                  child: Text(
                    "Buat Akun Baru",
                    style: TextStyle(
                      fontFamily: "SFProDisplay",
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    "Lengkapi data diri untuk mendaftar",
                    style: TextStyle(
                      fontFamily: "SFProDisplay",
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Color(0xFF65758C),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Nama
                _buildInputField(
                  label: "Nama",
                  hint: "Masukkan nama lengkap",
                  controller: _namaController,
                ),


                // NIK
                _buildInputField(
                  label: "NIK",
                  hint: "Masukkan NIK sesuai KTP",
                  keyboardType: TextInputType.number,
                  controller: _nikController,
                ),

                // Provinsi (otomatis)
                _buildInputField(
                  label: "Provinsi",
                  hint: "Otomatis dari NIK",
                  controller: _provinsiController,
                  readOnly: true,
                ),

                // Kabupaten / Kota (otomatis)
                _buildInputField(
                  label: "Kabupaten / Kota",
                  hint: "Otomatis dari NIK",
                  controller: _kabupatenController,
                  readOnly: true,
                ),

                // Jenis Kelamin (otomatis)
                _buildInputField(
                  label: "Jenis Kelamin",
                  hint: "Otomatis dari NIK",
                  controller: _jenisKelaminController,
                  readOnly: true,
                ),

                // Usia (otomatis)
                _buildInputField(
                  label: "Usia",
                  hint: "Otomatis dari NIK",
                  controller: _usiaController,
                  readOnly: true,
                ),

                // Email
                _buildInputField(
                  label: "Email",
                  hint: "Masukkan email anda",
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                ),

                // Nomor Whatsapp
                _buildInputField(
                  label: "Nomor Whatsapp",
                  hint: "Masukkan nomor anda",
                  keyboardType: TextInputType.phone,
                  controller: _nomorController,
                ),

                // Upload KTP
                _buildLabel("Upload Scan KTP"),
                _buildFileUpload(),
                const SizedBox(height: 12),

                // Password
                _buildInputField(
                  label: "Password",
                  hint: "Masukkan password",
                  isPassword: true,
                  controller: _passwordController,
                ),

                // Konfirmasi Password
                _buildInputField(
                  label: "Konfirmasi Password",
                  hint: "Masukkan konfirmasi password",
                  isPassword: true,
                ),

                const SizedBox(height: 24),

                // Tombol Daftar
                _buildRegisterButton(),
                
                const SizedBox(height: 24),

                // Divider "Atau"
                Row(
                  children: const [
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Color(0xFFCCCCCC),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "Atau",
                        style: TextStyle(
                          fontFamily: "SFProDisplay",
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: Color(0xFF464E5E),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Color(0xFFCCCCCC),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Footer Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Sudah punya akun? ",
                      style: TextStyle(
                        fontFamily: "SFProDisplay",
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF464E5E),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontFamily: "SFProDisplay",
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0987BB),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: "SFProDisplay",
          fontWeight: FontWeight.w600,
          fontSize: 12,
          color: Color(0xFF464E5E),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    TextEditingController? controller,
    bool isPassword = false,
    bool readOnly = false,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(label),
          TextFormField(
            controller: controller,
            obscureText: isPassword,
            readOnly: readOnly,
            keyboardType: keyboardType,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '$label tidak boleh kosong';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                fontFamily: "SFProDisplay",
                fontSize: 15,
                color: Color(0xFF9AA8BC),
              ),
              filled: true,
              fillColor: const Color(0xFFFAFAFA),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: Color(0xFFF3F6F9),
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: Color(0xFF0987BB),
                  width: 1.5,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFileUpload() {
    return InkWell(
      onTap: () async {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.image,
        );

        if (result != null) {
          setState(() {
            _selectedFileName = result.files.single.name;
            _selectedFilePath = result.files.single.path;
          });
        }
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFFF3F6F9),
            width: 1.5,
          ),
          color: const Color(0xFFFAFAFA),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Choose File",
              style: TextStyle(
                fontFamily: "SFProDisplay",
                fontSize: 15,
                color: Color(0xFF0987BB),
                fontWeight: FontWeight.w600,
              ),
            ),
            Expanded(
              child: Text(
                _selectedFileName ?? "No file chosen",
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: "SFProDisplay",
                  fontSize: 15,
                  color: Color(0xFF9AA8BC),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return Container(
      height: 49,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF202225), Color(0xFF323A47)],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isLoading
              ? null
              : () {
                  if (_formKey.currentState!.validate()) {
                    _registerTalent();
                  }
                },
          borderRadius: BorderRadius.circular(14),
          child: Center(
            child: _isLoading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : const Text(
                    "Daftar",
                    style: TextStyle(
                      fontFamily: "SFProDisplay",
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }


  Future<void> _registerTalent() async {
    setState(() => _isLoading = true); // ⬅️ mulai loading

    try {
      final fields = {
        'Nama': _namaController.text,
        'Nik': _nikController.text,
        'Provinsi': _provinsiController.text,
        'Kabupaten_Kota': _kabupatenController.text,
        'JenisKelamin': _jenisKelaminController.text,
        'Usia': _usiaController.text,
        'Email': _emailController.text,
        'NomorTelepon': _nomorController.text,
        'Password': _passwordController.text,
      };

      var response = await apiService.registerTalent(fields, _selectedFilePath);
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        debugPrint("✅ Success: $responseBody");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registrasi berhasil!")),
        );
      } else {
        debugPrint("❌ Error ${response.statusCode}: $responseBody");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error ${response.statusCode}: $responseBody")),
        );
      }
    } catch (e) {
      debugPrint("❗ Exception: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan: $e")),
      );
    } finally {
      setState(() => _isLoading = false); // ⬅️ selesai loading
    }
  }


}