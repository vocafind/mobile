import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
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

  //error live form validation
  String? _nikError;
  String? _ageError;
  String? _whatsappError;
  String? _ktpError;

  final _nikFocus = FocusNode();
  final _whatsappFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _nikController.addListener(_handleNikChange);
  }

  @override
  void dispose() {
    _nikController.dispose();
    _whatsappController.dispose();
    _nikFocus.dispose();
    _whatsappFocus.dispose();
    super.dispose();
  }

  // 🔹 Fungsi untuk handle perubahan NIK (Auto-fill)
  void _handleNikChange() async {
    final nik = _nikController.text;

    // 🔍 Validasi NIK (Live Error)
    if (nik.isEmpty) {
      setState(() {
        _nikError = 'NIK tidak boleh kosong';
      });
    } else if (nik.length < 16) {
      setState(() {
        _nikError = 'NIK harus 16 digit';
      });
    } else if (nik.length > 16) {
      setState(() {
        _nikError = 'NIK tidak boleh lebih dari 16 digit';
      });
    } else {
      setState(() {
        _nikError = null;
      });
    }

    // Ambil provinsi & kabupaten dari 6 digit pertama
    if (nik.length >= 6) {
      final kodeProv = nik.substring(0, 2);
      final kodeKab = nik.substring(0, 4);

      try {
        // Ambil daftar provinsi
        final provRes = await http.get(
          Uri.parse(
            'https://www.emsifa.com/api-wilayah-indonesia/api/provinces.json',
          ),
        );
        if (provRes.statusCode == 200) {
          final provList = json.decode(provRes.body);
          final prov = provList.firstWhere(
            (p) => p['id'] == kodeProv,
            orElse: () => null,
          );

          if (prov != null) {
            setState(() {
              _selectedProvince = prov['name'];
            });

            // Ambil daftar kota
            final kotaRes = await http.get(
              Uri.parse(
                'https://www.emsifa.com/api-wilayah-indonesia/api/regencies/${prov['id']}.json',
              ),
            );
            if (kotaRes.statusCode == 200) {
              final kotaList = json.decode(kotaRes.body);
              final kota = kotaList.firstWhere(
                (k) => k['id'] == kodeKab,
                orElse: () => null,
              );

              if (kota != null) {
                setState(() {
                  _selectedCity = kota['name'];
                });
              }
            }
          }
        }
      } catch (e) {
        debugPrint("Gagal ambil provinsi/kota: $e");
      }
    }

    // Ambil jenis kelamin & usia dari NIK
    if (nik.length >= 12) {
      final tanggalRaw = int.tryParse(nik.substring(6, 8)) ?? 0;
      final bulanRaw = int.tryParse(nik.substring(8, 10)) ?? 0;
      final tahunRaw = int.tryParse(nik.substring(10, 12)) ?? 0;

      // Jenis Kelamin
      final jenisKelamin = tanggalRaw > 40 ? 'Perempuan' : 'Laki-Laki';
      setState(() {
        _selectedGender = jenisKelamin;
      });

      // Hitung Usia
      final tanggal = tanggalRaw > 40 ? tanggalRaw - 40 : tanggalRaw;
      final tahun = (tahunRaw <= 24) ? 2000 + tahunRaw : 1900 + tahunRaw;
      final birthDate = DateTime(tahun, bulanRaw, tanggal);
      final now = DateTime.now();

      int usia = now.year - birthDate.year;
      if (now.month < birthDate.month ||
          (now.month == birthDate.month && now.day < birthDate.day)) {
        usia--;
      }

    
      if (usia < 17) {
        setState(() {
          _selectedAge = null; 
          _ageError = 'Usia Anda belum 17 tahun'; 
        });
        return;
      } else {
        setState(() {
          _ageError = null; 
          _selectedAge = '$usia Tahun';
        });
      }

      // Set usia pasti
      if (usia > 0 && usia < 120) {
        setState(() {
          _selectedAge = '$usia';
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

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
                  'Daftar Akun',
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
                  'Lengkapi data diri untuk mendaftar',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF65758C),
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 32),

                // NIK Input
                AnimatedTextField(
                  controller: _nikController,
                  focusNode: _nikFocus,
                  label: 'NIK',
                  icon: Icons.credit_card,
                  keyboardType: TextInputType.number,
                ),

                // ERROR ala USIA 📌
                if (_nikError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6, left: 12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _nikError!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 11,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 24),

                // Jenis Kelamin (Read Only)
                IgnorePointer(
                  ignoring: true,
                  child: AnimatedDropdown(
                    label: 'Jenis Kelamin',
                    icon: Icons.person,
                    value: _selectedGender,
                    items: const ['Laki-Laki', 'Perempuan'],
                    onChanged: (_) {}, 
                  ),
                ),

                const SizedBox(height: 24),

                // Usia (Read Only)
                IgnorePointer(
                  ignoring: true,
                  child: AnimatedDropdown(
                    label: 'Usia',
                    icon: Icons.calendar_today,
                    value: _selectedAge,
                    items: const ['17-25', '26-35', '36-45', '46-55', '56+'],
                    onChanged: (_) {}, 
                  ),
                ),
                // Tampilkan error usia (< 17 tahun)
                if (_ageError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6, left: 12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _ageError!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 11,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 24),

                // Provinsi (Read Only)
                IgnorePointer(
                  ignoring: true,
                  child: AnimatedDropdown(
                    label: 'Provinsi',
                    icon: Icons.location_on,
                    value: _selectedProvince,
                    items: const [],
                    onChanged: (_) {},
                  ),
                ),

                const SizedBox(height: 24),

                // Kabupaten / Kota (Read Only)
                IgnorePointer(
                  ignoring: true,
                  child: AnimatedDropdown(
                    label: 'Kabupaten / Kota',
                    icon: Icons.location_city,
                    value: _selectedCity,
                    items: const [],
                    onChanged: (_) {}, // atau boleh dihapus saja kalau otomatis
                  ),
                ),

                const SizedBox(height: 24),

                // Nomor Whatsapp
                AnimatedTextField(
                  controller: _whatsappController,
                  focusNode: _whatsappFocus,
                  label: 'Nomor Whatsapp',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nomor WhatsApp tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                if (_whatsappError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6, left: 12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _whatsappError!,
                        style: const TextStyle(color: Colors.red, fontSize: 11),
                      ),
                    ),
                  ),

                const SizedBox(height: 24),

                // Upload KTP
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(70),
                      border: Border.all(
                        color: const Color(0xFF98AFFF),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 95,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF9F9F9),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(70),
                              bottomLeft: Radius.circular(70),
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

                if (_ktpError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6, left: 12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _ktpError!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 11,
                          fontFamily: 'Poppins',
                        ),
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
                      // 🔍 Cek NIK Error
                      if (_nikController.text.isEmpty) {
                        setState(() => _nikError = 'NIK tidak boleh kosong');
                        return;
                      }
                      if (_nikError != null) return; // kalau masih error, stop

                      // 🔍 Cek Usia (hasil NIK)
                      if (_selectedAge == null || _ageError != null) {
                        setState(
                          () => _ageError =
                              'Usia tidak valid atau belum 17 tahun',
                        );
                        return;
                      }

                      // 🔍 Cek Provinsi & Kota
                      if (_selectedProvince == null || _selectedCity == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Data Provinsi/Kota belum terbaca dari NIK',
                            ),
                          ),
                        );
                        return;
                      }

                      // 🔍 Cek Nomor WhatsApp
                      if (_whatsappController.text.isEmpty) {
                        setState(
                          () => _whatsappError =
                              'Nomor WhatsApp tidak boleh kosong',
                        );
                        return;
                      }

                      // 🔍 Cek Foto KTP
                      if (_ktpImage == null) {
                        setState(() => _ktpError = 'Harap upload scan KTP');
                        return;
                      } else {
                        setState(() => _ktpError = null);
                      }

                      // ✅ Kalau semua valid → Lanjut
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BuatAkunPage(
                            nik: _nikController.text,
                            jenisKelamin: _selectedGender ?? '',
                            usia: _selectedAge ?? '',
                            provinsi: _selectedProvince ?? '',
                            kabupatenKota: _selectedCity ?? '',
                            nomorWhatsapp: _whatsappController.text,
                            ktpImagePath: _ktpImage?.path,
                          ),
                        ),
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
                      'Selanjutnya',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

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
                      onTap: () => Navigator.pop(context),
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
  final String? Function(String?)? validator;

  const AnimatedTextField({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.validator,
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
              validator: widget.validator,
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
    final bool hasValue = widget.value != null && widget.value!.isNotEmpty;
    final bool isActive = hasValue || _isOpen;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      height: 52,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255), // PUTIH
        borderRadius: BorderRadius.circular(70),
        border: Border.all(
          color: const Color(0xFF98AFFF), 
          width: 1.7,
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.value ?? '',
                style: const TextStyle(
                  color: Color(0xFF515151),
                  fontSize: 14,
                  fontFamily: 'Poppins',
                ),
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
                    ? const Color.fromARGB(255, 255, 255, 255)
                    : const Color.fromARGB(0, 0, 0, 0),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    widget.icon,
                    size: isActive ? 14 : 16,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    widget.label,
                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontSize: isActive ? 11 : 14,
                      fontFamily: 'Poppins',
                      fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
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
