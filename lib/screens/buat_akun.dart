import 'package:flutter/material.dart';
import 'package:jobfair/api/api_service.dart';
import 'package:jobfair/screens/halaman_login.dart';

class BuatAkunPage extends StatefulWidget {
  final String nik;
  final String jenisKelamin;
  final String usia;
  final String provinsi;
  final String kabupatenKota;
  final String nomorWhatsapp;
  final String? ktpImagePath;

  const BuatAkunPage({
    Key? key,
    required this.nik,
    required this.jenisKelamin,
    required this.usia,
    required this.provinsi,
    required this.kabupatenKota,
    required this.nomorWhatsapp,
    this.ktpImagePath,
  }) : super(key: key);

  @override
  State<BuatAkunPage> createState() => _BuatAkunPageState();
}

class _BuatAkunPageState extends State<BuatAkunPage> {
  final apiService = ApiService();

  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Focus Nodes
  final _namaFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  // State
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  // Error Messages
  String? _namaError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void initState() {
    super.initState();
    // Add listeners untuk validasi real-time
    _namaController.addListener(_validateNama);
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(() {
      _validatePassword();
      _validateConfirmPassword(); // Re-validate confirm password
    });
    _confirmPasswordController.addListener(_validateConfirmPassword);
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _namaFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  void _validateNama() {
    setState(() {
      if (_namaController.text.isEmpty) {
        _namaError = 'Nama tidak boleh kosong';
      } else {
        _namaError = null;
      }
    });
  }

  void _validateEmail() {
    setState(() {
      if (_emailController.text.isEmpty) {
        _emailError = 'Email tidak boleh kosong';
      } else if (!RegExp(
        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      ).hasMatch(_emailController.text)) {
        _emailError = 'Format email tidak valid';
      } else {
        _emailError = null;
      }
    });
  }

  void _validatePassword() {
    setState(() {
      String password = _passwordController.text;

      if (password.isEmpty) {
        _passwordError = 'kata sandi tidak boleh kosong';
      } else if (password.length < 8) {
        _passwordError = 'kata sandi minimal 8 karakter';
      } else if (!RegExp(r'[A-Z]').hasMatch(password)) {
        _passwordError = 'kata sandi harus mengandung huruf besar';
      } else if (!RegExp(r'[a-z]').hasMatch(password)) {
        _passwordError = 'kata sandi harus mengandung huruf kecil';
      } else if (!RegExp(r'[0-9]').hasMatch(password)) {
        _passwordError = 'kata sandi harus mengandung angka';
      } else if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) {
        _passwordError = 'kata sandi harus mengandung karakter spesial';
      } else {
        _passwordError = null;
      }
    });
  }

  void _validateConfirmPassword() {
    setState(() {
      if (_confirmPasswordController.text.isEmpty) {
        _confirmPasswordError = 'Konfirmasi kata sandi tidak boleh kosong';
      } else if (_confirmPasswordController.text != _passwordController.text) {
        _confirmPasswordError = 'Kata sandi tidak sama';
      } else {
        _confirmPasswordError = null;
      }
    });
  }

  bool _isFormValid() {
    return _namaError == null &&
        _emailError == null &&
        _passwordError == null &&
        _confirmPasswordError == null &&
        _namaController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty;
  }

  // 🎉 FUNGSI DIALOG SUKSES REGISTRASI
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        // Auto close dan redirect setelah 4 detik
        Future.delayed(const Duration(seconds: 4), () {
          if (dialogContext.mounted) {
            Navigator.of(dialogContext).pop(); // Tutup dialog
            Navigator.of(dialogContext).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const HalamanLogin()),
              (route) => false,
            );
          }
        });

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Container(
            width: 320,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: const Color(0xFFD4D4D8),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon Checkmark dengan animasi
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1548F5).withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF1548F5).withOpacity(0.2),
                      width: 8,
                    ),
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Color(0xFF1548F5),
                    size: 24,
                    weight: 700,
                  ),
                ),

                const SizedBox(height: 20),

                // Title
                const Text(
                  'Daftar Berhasil',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF18181B),
                    fontSize: 24,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),

                const SizedBox(height: 14),

                // Description
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'Akun kamu berhasil dibuat!\n\nVerifikasi KTP sedang diproses. \n\nKamu akan mendapatkan pemberitahuan melalui email setelah proses selesai.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Button Lanjut ke Login
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop(); // Tutup dialog
                      Navigator.of(dialogContext).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const HalamanLogin(),
                        ),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1548F5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Ok',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _registerTalent() async {
    // Validasi dulu
    _validateNama();
    _validateEmail();
    _validatePassword();
    _validateConfirmPassword();

    if (!_isFormValid()) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon lengkapi semua field dengan benar'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    debugPrint("🔍 Mencoba kirim data register...");
    setState(() => _isLoading = true);

    try {
      final fields = {
        'Nama': _namaController.text,
        'Nik': widget.nik,
        'Provinsi': widget.provinsi,
        'Kabupaten_Kota': widget.kabupatenKota,
        'JenisKelamin': widget.jenisKelamin,
        'Usia': widget.usia,
        'Email': _emailController.text,
        'NomorTelepon': widget.nomorWhatsapp,
        'Password': _passwordController.text,
      };

      var response = await apiService.registerTalent(
        fields,
        widget.ktpImagePath,
      );
      var responseBody = await response.stream.bytesToString();

      if (!mounted) return; // Pastikan widget masih aktif

      if (response.statusCode == 200) {
        // 🎉 Tampilkan dialog sukses (mengganti SnackBar)
        _showSuccessDialog(context);
      } else {
        debugPrint("Server error ${response.statusCode}:\n$responseBody");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Registrasi gagal: ${response.statusCode}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      debugPrint("Gagal terhubung ke server: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal terhubung ke server"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
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
          padding: const EdgeInsets.symmetric(horizontal: 38),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Logo
                Container(
                  width: 63.23,
                  height: 62,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/icons/icon.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Title
                const Text(
                  'Buat akun anda',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xCC000000),
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Lengkapi informasi akun Anda',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF65758C),
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 32),

                // Nama
                AnimatedTextField(
                  controller: _namaController,
                  focusNode: _namaFocus,
                  label: 'Nama',
                  icon: Icons.person,
                  keyboardType: TextInputType.name,
                ),
                if (_namaError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6, left: 12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _namaError!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 11,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 17),

                // Email
                AnimatedTextField(
                  controller: _emailController,
                  focusNode: _emailFocus,
                  label: 'Email',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                if (_emailError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6, left: 12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _emailError!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 11,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 17),

                // Password
                AnimatedPasswordField(
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  label: 'Password',
                  isPasswordVisible: _isPasswordVisible,
                  onToggleVisibility: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                // Hint text untuk password
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 12, right: 12),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Min. 8 karakter, huruf besar, kecil, angka, simbol',
                      style: TextStyle(
                        color: _passwordError != null
                            ? Colors.red
                            : const Color(0xFF65758C),
                        fontSize: 10,
                        fontFamily: 'Poppins',
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
                if (_passwordError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4, left: 12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _passwordError!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 11,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 17),

                // Konfirmasi Password
                AnimatedPasswordField(
                  controller: _confirmPasswordController,
                  focusNode: _confirmPasswordFocus,
                  label: 'Konfirmasi Password',
                  isPasswordVisible: _isConfirmPasswordVisible,
                  onToggleVisibility: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                ),
                if (_confirmPasswordError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6, left: 12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _confirmPasswordError!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 11,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 61),

                // Button Daftar
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _registerTalent,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1548F5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_isLoading)
                          const Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        const Text(
                          'Daftar',
                          style: TextStyle(
                            color: Color(0xFFFFF8F8),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget TextField dengan Animasi
class AnimatedTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;

  const AnimatedTextField({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.label,
    required this.icon,
    this.keyboardType,
  }) : super(key: key);

  @override
  State<AnimatedTextField> createState() => _AnimatedTextFieldState();
}

class _AnimatedTextFieldState extends State<AnimatedTextField> {
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChange);
    widget.controller.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    widget.controller.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused =
          widget.focusNode.hasFocus || widget.controller.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      height: 52,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(70),
        border: Border.all(
          color: _isFocused ? const Color(0xFF1548F5) : const Color(0xFF98AFFF),
          width: 1.7,
        ),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: const Color(0xFF1548F5).withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ]
            : [],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 20),
            child: TextFormField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              keyboardType: widget.keyboardType,
              style: const TextStyle(
                color: Color(0xFF515151),
                fontSize: 14,
                fontFamily: 'Poppins',
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 0, left: 0),
                errorStyle: TextStyle(fontSize: 0, height: 0),
              ),
            ),
          ),

          // Label Animated
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            left: 12,
            top: _isFocused ? -10 : 14,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: EdgeInsets.symmetric(
                horizontal: _isFocused ? 6 : 4,
                vertical: _isFocused ? 2 : 0,
              ),
              decoration: BoxDecoration(
                color: _isFocused
                    ? const Color.fromARGB(255, 255, 255, 255)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    widget.icon,
                    size: _isFocused ? 14 : 16,
                    color: const Color(0xFF515151),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    widget.label,
                    style: TextStyle(
                      color: const Color(0xFF515151),
                      fontSize: _isFocused ? 11 : 14,
                      fontFamily: 'Poppins',
                      fontWeight: _isFocused
                          ? FontWeight.w500
                          : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget Password Field dengan Animasi
class AnimatedPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String label;
  final bool isPasswordVisible;
  final VoidCallback onToggleVisibility;

  const AnimatedPasswordField({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.label,
    required this.isPasswordVisible,
    required this.onToggleVisibility,
  }) : super(key: key);

  @override
  State<AnimatedPasswordField> createState() => _AnimatedPasswordFieldState();
}

class _AnimatedPasswordFieldState extends State<AnimatedPasswordField> {
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChange);
    widget.controller.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    widget.controller.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused =
          widget.focusNode.hasFocus || widget.controller.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      height: 52,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(70),
        border: Border.all(
          color: _isFocused ? const Color(0xFF1548F5) : const Color(0xFF98AFFF),
          width: 1.7,
        ),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: const Color(0xFF1548F5).withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ]
            : [],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 50),
            child: TextFormField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              obscureText: !widget.isPasswordVisible,
              style: const TextStyle(
                color: Color(0xFF515151),
                fontSize: 14,
                fontFamily: 'Poppins',
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 0, left: 0),
                errorStyle: TextStyle(fontSize: 0, height: 0),
              ),
            ),
          ),

          // Toggle Password Visibility
          Positioned(
            right: 16,
            top: 14,
            child: GestureDetector(
              onTap: widget.onToggleVisibility,
              child: Icon(
                widget.isPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
                size: 20,
                color: const Color(0xFF515151),
              ),
            ),
          ),

          // Label Animated
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            left: 12,
            top: _isFocused ? -10 : 14,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: EdgeInsets.symmetric(
                horizontal: _isFocused ? 6 : 4,
                vertical: _isFocused ? 2 : 0,
              ),
              decoration: BoxDecoration(
                color: _isFocused
                    ? const Color.fromARGB(255, 255, 255, 255)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.lock,
                    size: _isFocused ? 14 : 16,
                    color: const Color(0xFF515151),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    widget.label,
                    style: TextStyle(
                      color: const Color(0xFF515151),
                      fontSize: _isFocused ? 11 : 14,
                      fontFamily: 'Poppins',
                      fontWeight: _isFocused
                          ? FontWeight.w500
                          : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}