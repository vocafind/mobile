import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Center(
                child: Image.asset(
                  "assets/images/logo2.png",
                  width: 82,
                  height: 82,
                ),
              ),
              const SizedBox(height: 30),

              // Nama
              buildLabel("Nama"),
              buildInput("Masukkan nama lengkap"),

              // Jenis Kelamin
              buildLabel("Jenis Kelamin"),
              buildInput("Pilih jenis kelamin"),

              // Usia
              buildLabel("Usia"),
              buildInput("Masukkan usia anda"),

              // Email
              buildLabel("Email"),
              buildInput("Masukkan email anda"),

              // Nomor Whatsapp
              buildLabel("Nomor Whatsapp"),
              buildInput("Masukkan nomor anda"),

              // NIK
              buildLabel("NIK"),
              buildInput("Masukkan NIK sesuai KTP"),

              // Upload KTP (dummy text field)
              buildLabel("Upload Scan KTP"),
              Container(
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFF3F6F9), width: 1.5),
                  color: const Color(0xFFFAFAFA),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Choose File",
                        style: TextStyle(color: Color(0xFF9AA8BC), fontSize: 15)),
                    Text("No file chosen",
                        style: TextStyle(color: Color(0xFF9AA8BC), fontSize: 15)),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Password
              buildLabel("Password"),
              buildInput("Masukkan password", obscure: true),

              // Konfirmasi Password
              buildLabel("Konfirmasi Password"),
              buildInput("Masukkan konfirmasi password", obscure: true),

              const SizedBox(height: 30),

              // Tombol Daftar
              Container(
                height: 49,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF202225), Color(0xFF323A47)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
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

              const SizedBox(height: 20),

              // Atau
              Row(
                children: const [
                  Expanded(
                    child: Divider(thickness: 1, color: Colors.black26),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      "Atau",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(thickness: 1, color: Colors.black26),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Sudah punya akun?",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF464E5E),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // balik ke login
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0987BB),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 4, left: 2),
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

  Widget buildInput(String hint, {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            fontFamily: "SFProDisplay",
            fontSize: 15,
            color: Color(0xFF9AA8BC),
          ),
          filled: true,
          fillColor: const Color(0xFFFAFAFA),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFF3F6F9), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF0987BB), width: 1.5),
          ),
        ),
      ),
    );
  }
}
