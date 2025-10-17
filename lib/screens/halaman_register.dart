import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:jobfair/screens/halaman_login.dart';
import 'buat_akun.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nikController = TextEditingController();
  final _whatsappController = TextEditingController();
  
  String? _selectedGender;
  String? _selectedAge;
  String? _selectedProvince;
  String? _selectedCity;
  File? _ktpImage;
  
  final _nikFocus = FocusNode();
  final _whatsappFocus = FocusNode();
  
  final List<String> _genderOptions = ['Laki-laki', 'Perempuan'];
  final List<String> _ageOptions = ['17-25', '26-35', '36-45', '46-55', '56+'];
  final List<String> _provinces = [
    'DKI Jakarta', 
    'Jawa Barat', 
    'Jawa Tengah', 
    'Jawa Timur'
  ];
  final List<String> _cities = [
    'Jakarta Pusat', 
    'Bandung', 
    'Semarang', 
    'Surabaya'
  ];

  @override
  void dispose() {
    _nikController.dispose();
    _whatsappController.dispose();
    _nikFocus.dispose();
    _whatsappFocus.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery
    );
    
    if (image != null) {
      setState(() {
        _ktpImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 38),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 40),
                
                // NIK Input
                AnimatedTextField(
                  controller: _nikController,
                  focusNode: _nikFocus,
                  label: 'NIK',
                  icon: Icons.credit_card,
                  keyboardType: TextInputType.number,
                ),
                
                const SizedBox(height: 24),
                
                // Jenis Kelamin
                AnimatedDropdown(
                  label: 'Jenis Kelamin',
                  icon: Icons.person,
                  value: _selectedGender,
                  items: _genderOptions,
                  onChanged: null,
                  isEnabled: false,
                ),
                
                const SizedBox(height: 24),
                
                // Usia
                AnimatedDropdown(
                  label: 'Usia',
                  icon: Icons.calendar_today,
                  value: _selectedAge,
                  items: _ageOptions,
                  onChanged: null,
                  isEnabled: false,
                ),
                
                const SizedBox(height: 24),
                
                // Provinsi
                AnimatedDropdown(
                  label: 'Provinsi',
                  icon: Icons.location_on,
                  value: _selectedProvince,
                  items: _provinces,
                  onChanged: null,
                  isEnabled: false,
                ),
                
                const SizedBox(height: 24),
                
                // Kabupaten/Kota
                AnimatedDropdown(
                  label: 'Kabupaten / Kota',
                  icon: Icons.location_city,
                  value: _selectedCity,
                  items: _cities,
                  onChanged: null,
                  isEnabled: false,
                ),
                
                const SizedBox(height: 24),
                
                // Nomor Whatsapp
                AnimatedTextField(
                  controller: _whatsappController,
                  focusNode: _whatsappFocus,
                  label: 'Nomor Whatsapp',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                ),
                
                const SizedBox(height: 24),
                
                // Upload KTP
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8F8),
                      borderRadius: BorderRadius.circular(70),
                      border: Border.all(
                        color: const Color(0xFF98AFFF), 
                        width: 1.5
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 95,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF9F9F9),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(14),
                              bottomLeft: Radius.circular(14),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'Pilih File',
                              style: TextStyle(
                                color: Color(0xFF9AA8BC),
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            _ktpImage == null 
                              ? 'Upload Scan KTP' 
                              : 'KTP Dipilih',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                              color: Color(0xFF515151),
                              fontSize: 14,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Button Selanjutnya
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BuatAkunPage(),
                          ),
                        );
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
                
                const SizedBox(height: 40),
                
                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Sudah punya akun? ',
                      style: TextStyle(
                        color: Color(0xFF464E5E),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HalamanLogin(),
                          ),
                        );
                      },
                      child: const Text(
                        'Masuk',
                        style: TextStyle(
                          color: Color(0xFF026F9D),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ],
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
          width: 1.7,
        ),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: const Color(0xFF1548F5).withValues(alpha:0.15),
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

// Widget Dropdown dengan Animasi
class AnimatedDropdown extends StatefulWidget {
  final String label;
  final IconData icon;
  final String? value;
  final List<String> items;
  final ValueChanged<String?>? onChanged;
  final bool isEnabled;

  const AnimatedDropdown({
    Key? key,
    required this.label,
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  State<AnimatedDropdown> createState() => _AnimatedDropdownState();
}

class _AnimatedDropdownState extends State<AnimatedDropdown> {
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    final bool hasValue = widget.value != null;
    final bool isActive = hasValue || _isOpen;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      height: 52,
      decoration: BoxDecoration(
        color: widget.isEnabled 
          ? const Color(0xFFFFF8F8) 
          : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(70),
        border: Border.all(
          color: widget.isEnabled
              ? (_isOpen 
                  ? const Color(0xFF1548F5) 
                  : const Color(0xFF98AFFF))
              : const Color(0xFFD0D0D0),
          width: 1.7,
        ),
        boxShadow: _isOpen && widget.isEnabled
            ? [
                BoxShadow(
                  color: const Color(0xFF1548F5).withValues(alpha:0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                )
              ]
            : [],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 20),
            child: IgnorePointer(
              ignoring: !widget.isEnabled,
              child: DropdownButtonFormField<String>(
                value: widget.value,
                onChanged: widget.isEnabled ? (value) {
                  if (widget.onChanged != null) {
                    widget.onChanged!(value);
                  }
                  setState(() => _isOpen = false);
                } : null,
                onTap: widget.isEnabled ? () {
                  setState(() => _isOpen = !_isOpen);
                } : null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 14),
                ),
                style: TextStyle(
                  color: widget.isEnabled 
                    ? const Color(0xFF515151) 
                    : const Color(0xFFAAAAAA),
                  fontSize: 14,
                  fontFamily: 'Poppins',
                ),
                dropdownColor: const Color(0xFFFFF8F8),
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: widget.isEnabled 
                    ? const Color(0xFF515151) 
                    : const Color(0xFFAAAAAA),
                ),
                items: widget.items
                    .map((value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ))
                    .toList(),
              ),
            ),
          ),

          // Label Animated
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            left: 12,
            top: isActive ? -10 : 14,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: EdgeInsets.symmetric(
                horizontal: isActive ? 6 : 4,
                vertical: isActive ? 2 : 0,
              ),
              decoration: BoxDecoration(
                color: isActive 
                    ? (widget.isEnabled 
                        ? const Color(0xFFFFF8F8) 
                        : const Color(0xFFF5F5F5))
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    widget.icon,
                    size: isActive ? 14 : 16,
                    color: widget.isEnabled 
                      ? const Color(0xFF515151) 
                      : const Color(0xFFAAAAAA),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    widget.label,
                    style: TextStyle(
                      color: widget.isEnabled 
                        ? const Color(0xFF515151) 
                        : const Color(0xFFAAAAAA),
                      fontSize: isActive ? 11 : 14,
                      fontFamily: 'Poppins',
                      fontWeight: isActive 
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