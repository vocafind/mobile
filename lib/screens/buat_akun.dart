import 'package:flutter/material.dart';

class BuatAkunPage extends StatefulWidget {
  const BuatAkunPage({super.key});

  @override
  State<BuatAkunPage> createState() => _BuatAkunPageState();
}

class _BuatAkunPageState extends State<BuatAkunPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  final _namaFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();
  
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 38),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 64),
                
                // Logo
                Container(
                  margin: const EdgeInsets.only(top: 64),
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

                
                const SizedBox(height: 37),
                
                // Title
                const Text(
                  'Buat akun anda',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xCC000000),
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                
                const SizedBox(height: 28),
                
                // Nama
                AnimatedTextField(
                  controller: _namaController,
                  focusNode: _namaFocus,
                  label: 'Nama',
                  icon: Icons.person,
                  keyboardType: TextInputType.name,
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
                
                const SizedBox(height: 17),
                
                // Password
                AnimatedPasswordField(
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  label: 'Password minimal 8 karakter',
                  isPasswordVisible: _isPasswordVisible,
                  onToggleVisibility: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                
                const SizedBox(height: 24),
                
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
                
                const SizedBox(height: 61),
                
                // Button Selanjutnya
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Handle form submission
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1548F5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Selanjutnya',
                      style: TextStyle(
                        color: Color(0xFFFFF8F8),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 52),
                
                // Login Link
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     const Text(
                //       'Sudah punya akun? ',
                //       style: TextStyle(
                //         color: Color(0xFF464E5E),
                //         fontSize: 12,
                //         fontWeight: FontWeight.w500,
                //         fontFamily: 'Poppins',
                //       ),
                //     ),
                //     GestureDetector(
                //       onTap: () {
                //         Navigator.pop(context);
                //       },
                //       child: const Text(
                //         'Masuk',
                //         style: TextStyle(
                //           color: Color(0xFF026F9D),
                //           fontSize: 12,
                //           fontWeight: FontWeight.w500,
                //           fontFamily: 'Poppins',
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                
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
      _isFocused = widget.focusNode.hasFocus || 
                   widget.controller.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F8),
        borderRadius: BorderRadius.circular(70),
        border: Border.all(
          color: _isFocused 
            ? const Color(0xFF1548F5) 
            : const Color(0xFF98AFFF),
          width: 1.5,
        ),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: const Color(0xFF1548F5).withOpacity(0.15),
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
                contentPadding: EdgeInsets.only(top: 14),
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
                  ? const Color(0xFFFFF8F8) 
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
      _isFocused = widget.focusNode.hasFocus || 
                   widget.controller.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F8),
        borderRadius: BorderRadius.circular(70),
        border: Border.all(
          color: _isFocused 
            ? const Color(0xFF1548F5) 
            : const Color(0xFF98AFFF),
          width: 1.5,
        ),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: const Color(0xFF1548F5).withOpacity(0.15),
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
                contentPadding: EdgeInsets.only(top: 14),
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
                  ? const Color(0xFFFFF8F8) 
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