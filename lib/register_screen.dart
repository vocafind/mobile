import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedGender;
  String? _selectedFileName;

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
                ),

                // Jenis Kelamin Dropdown
                _buildLabel("Jenis Kelamin"),
                _buildGenderDropdown(),
                const SizedBox(height: 12),

                // Usia
                _buildInputField(
                  label: "Usia",
                  hint: "Masukkan usia anda",
                  keyboardType: TextInputType.number,
                ),

                // Email
                _buildInputField(
                  label: "Email",
                  hint: "Masukkan email anda",
                  keyboardType: TextInputType.emailAddress,
                ),

                // Nomor Whatsapp
                _buildInputField(
                  label: "Nomor Whatsapp",
                  hint: "Masukkan nomor anda",
                  keyboardType: TextInputType.phone,
                ),

                // NIK
                _buildInputField(
                  label: "NIK",
                  hint: "Masukkan NIK sesuai KTP",
                  keyboardType: TextInputType.number,
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
    bool isPassword = false,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(label),
          TextField(
            obscureText: isPassword,
            keyboardType: keyboardType,
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
          ),
        ],
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Container(
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
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedGender,
          hint: const Text(
            "Pilih jenis kelamin",
            style: TextStyle(
              fontFamily: "SFProDisplay",
              fontSize: 15,
              color: Color(0xFF9AA8BC),
            ),
          ),
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: Color(0xFF9AA8BC),
          ),
          items: const [
            DropdownMenuItem(
              value: "Laki-laki",
              child: Text(
                "Laki-laki",
                style: TextStyle(
                  fontFamily: "SFProDisplay",
                  fontSize: 15,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ),
            DropdownMenuItem(
              value: "Perempuan",
              child: Text(
                "Perempuan",
                style: TextStyle(
                  fontFamily: "SFProDisplay",
                  fontSize: 15,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ),
          ],
          onChanged: (value) {
            setState(() {
              _selectedGender = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildFileUpload() {
    return InkWell(
      onTap: () {
        // TODO: Implement file picker
        setState(() {
          _selectedFileName = "ktp_example.jpg";
        });
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
          onTap: () {
            if (_formKey.currentState!.validate()) {
              // Handle registration
            }
          },
          borderRadius: BorderRadius.circular(14),
          child: const Center(
            child: Text(
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
}