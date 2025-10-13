import 'package:flutter/material.dart';
import 'package:jobfair/api/api_service.dart';
import 'register_screen.dart';
import 'home_screen.dart'; // ✅ Fixed typo

class LoginScreen extends StatefulWidget { // ✅ Changed to StatefulWidget
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final apiService = ApiService();

  // ✅ Added controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showRegistrasiPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 329,
          height: 295,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha:0.25),
                blurRadius: 4,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon Success
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color.fromRGBO(13, 114, 180, 0.22),
                        width: 8,
                      ),
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF197AB1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              // Title
              const Text(
                "Registrasi Berhasil",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "SF Pro",
                  fontWeight: FontWeight.w900,
                  fontSize: 24,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 16),
              
              // Description
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 28),
                child: Text(
                  "Akun berhasil dibuat. Verifikasi KTP membutuhkan waktu ±1 hari kerja. Silakan cek kembali nanti.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "SF Pro",
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xFF65758C),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Added login handler
  void _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email dan password tidak boleh kosong'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

     // 🔥 Panggil API Login
    final result = await ApiService().loginTalent(email, password);

    print(result); // 

    if (result['token'] != null) {
      // ✅ Login Berhasil
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Login berhasil')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      // ❌ Login Gagal
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Login gagal')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.black),
            onPressed: () => _showRegistrasiPopup(context),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              children: [
                const SizedBox(height: 40),
                
                // Logo
                Image.asset(
                  "assets/images/Logo2.png",
                  width: 121,
                  height: 121,
                ),
                const SizedBox(height: 16),
                
                // Welcome Section
                const Text(
                  "Selamat Datang",
                  style: TextStyle(
                    fontFamily: "SFProDisplay",
                    fontWeight: FontWeight.w900,
                    fontSize: 24,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 8),
                const SizedBox(
                  width: 285,
                  child: Text(
                    "Masuk ke akun VocaFind untuk melanjutkan pencarian karir impianmu",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "SFProDisplay",
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Color(0xFF65758C),
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                
                // Email Field
                _buildInputField(
                  label: "Email",
                  hint: "Masukkan email anda",
                  controller: _emailController,
                  isPassword: false,
                ),
                const SizedBox(height: 16),
                
                // Password Field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputField(
                      label: "Password",
                      hint: "Masukkan password",
                      controller: _passwordController,
                      isPassword: true,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Lupa Password?",
                          style: TextStyle(
                            fontFamily: "SFProDisplay",
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: Color(0xFF0987BB),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Login Button
                Container(
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
                      onTap: _handleLogin, // ✅ Changed to use handler
                      borderRadius: BorderRadius.circular(14),
                      child: Center(
                        child: Text(
                          "Masuk",
                          style: TextStyle(
                            fontFamily: "SFProDisplay",
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Colors.white.withValues(alpha:0.95),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                
                // Register Section
                Row(
                  children: [
                    const Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Color(0xFFCCCCCC),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Belum punya akun? ",
                            style: TextStyle(
                              fontFamily: "SFProDisplay",
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF464E5E),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Daftar disini",
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
                    ),
                    const Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Color(0xFFCCCCCC),
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

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller, // ✅ Added controller
    required bool isPassword,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: "SFProDisplay",
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: Color(0xFF464E5E),
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller, // ✅ Added controller
          obscureText: isPassword ? !_isPasswordVisible : false, // ✅ Toggle visibility
          keyboardType: isPassword ? TextInputType.visiblePassword : TextInputType.emailAddress,
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
            // ✅ Added password visibility toggle
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: const Color(0xFF9AA8BC),
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  )
                : null,
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
    );
  }
}