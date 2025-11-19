import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jobfair/api/endpoints.dart';
import 'package:jobfair/models/talent_profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'tab_media_sosial.dart';
import 'tab_minat_karir.dart';
import 'tab_referensi.dart';
import 'package:jobfair/api/api_service.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class TabProfil extends StatefulWidget {
  const TabProfil({super.key});

  @override
  State<TabProfil> createState() => _TabProfilState();
}

class _TabProfilState extends State<TabProfil> {
  int _selectedSubTab = 0;

  // Data profil dari API
  File? _selectedImage;
  bool _isUploadingImage = false;
  TalentProfileModel? _profil;
  bool _isLoading = true;
  String? _editingField;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadProfil();
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image == null) return;

      if (!mounted) return; // ✅ TAMBAHKAN INI

      setState(() {
        _selectedImage = File(image.path);
        _isUploadingImage = true;
      });

      final prefs = await SharedPreferences.getInstance();
      final talentId = prefs.getString('talentId');

      if (talentId == null) {
        if (mounted) {
          // ✅ TAMBAHKAN INI
          _showSnackBar('Error: ID talent tidak ditemukan', isError: true);
          setState(() {
            _isUploadingImage = false;
          });
        }
        return;
      }

      // Upload foto
      final result = await ApiService().updateProfilTalent(
        talentId: talentId,
        fotoProfil: _selectedImage!,
        nama: _profil!.nama,
        alamat: _profil!.alamat,
        nomorTelepon: _profil!.nomorTelepon,
        lokasiKerjaDiinginkan: _profil!.lokasiKerjaDiinginkan,
        statusPekerjaanSaatIni: _profil!.statusPekerjaanSaatIni,
        preferensiGaji: _profil!.preferensiGaji,
        preferensiJamKerjaMulai: _profil!.preferensiJamKerjaMulai,
        preferensiJamKerjaSelesai: _profil!.preferensiJamKerjaSelesai,
        preferensiPerjalananDinas: _profil!.preferensiPerjalananDinas,
      );

      if (mounted) {
        // ✅ TAMBAHKAN INI
        setState(() {
          _isUploadingImage = false;
        });

        if (result['success'] == true) {
          _showSnackBar('Foto profil berhasil diperbarui');
          await _loadProfil();
        } else {
          _showSnackBar(
            result['message'] ?? 'Gagal memperbarui foto profil',
            isError: true,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        // ✅ TAMBAHKAN INI
        setState(() {
          _isUploadingImage = false;
        });
        _showSnackBar('Gagal mengupload foto: $e', isError: true);
      }
      debugPrint('Error upload foto: $e');
    }
  }

  Future<void> _loadProfil() async {
    try {
      final profil = await ApiService().getProfilDataDiri();
      if (mounted) {
        // ✅ SUDAH BENAR
        setState(() {
          _profil = profil;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        // ✅ SUDAH BENAR
        setState(() {
          _isLoading = false;
        });
      }
      debugPrint('Gagal memuat profil: $e');
    }
  }

  Future<void> _saveField() async {
    if (_profil == null || _isSaving) return;

    if (!mounted) return; // ✅ TAMBAHKAN INI

    setState(() {
      _isSaving = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final talentId = prefs.getString('talentId');

    if (talentId == null) {
      if (mounted) {
        // ✅ TAMBAHKAN INI
        _showSnackBar('Error: ID talent tidak ditemukan', isError: true);
        setState(() {
          _isSaving = false;
        });
      }
      return;
    }

    // Format jam kerja dengan detik :00
    String? jamMulai = _profil!.preferensiJamKerjaMulai;
    String? jamSelesai = _profil!.preferensiJamKerjaSelesai;

    if (jamMulai != null && jamMulai.isNotEmpty && jamMulai.length == 5) {
      jamMulai = '$jamMulai:00';
    }
    if (jamSelesai != null && jamSelesai.isNotEmpty && jamSelesai.length == 5) {
      jamSelesai = '$jamSelesai:00';
    }

    final result = await ApiService().updateProfilTalent(
      talentId: talentId,
      nama: _profil!.nama,
      alamat: _profil!.alamat,
      nomorTelepon: _profil!.nomorTelepon,
      lokasiKerjaDiinginkan: _profil!.lokasiKerjaDiinginkan,
      statusPekerjaanSaatIni: _profil!.statusPekerjaanSaatIni,
      preferensiGaji: _profil!.preferensiGaji,
      preferensiJamKerjaMulai: jamMulai,
      preferensiJamKerjaSelesai: jamSelesai,
      preferensiPerjalananDinas: _profil!.preferensiPerjalananDinas,
    );

    if (mounted) {
      // ✅ TAMBAHKAN INI
      setState(() {
        _isSaving = false;
      });

      if (result['success'] == true) {
        _showSnackBar('Profil berhasil diperbarui');
        await _loadProfil();
      } else {
        _showSnackBar(
          result['message'] ?? 'Gagal memperbarui profil',
          isError: true,
        );
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return; // ✅ SUDAH BENAR

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: isError ? Colors.red.shade100 : Colors.white,
        behavior: SnackBarBehavior.floating,
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          color: const Color(0xFFF0F4F9),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 8),
            child: Row(
              children: [
                _buildSubTab('Data diri', 0),
                const SizedBox(width: 8),
                _buildSubTab('Media sosial', 1),
                const SizedBox(width: 8),
                _buildSubTab('Minat karir', 2),
                const SizedBox(width: 8),
                _buildSubTab('Referensi', 3),
              ],
            ),
          ),
        ),
        Expanded(child: _buildContent()),
      ],
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_profil == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Gagal memuat data profil',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                });
                _loadProfil();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    switch (_selectedSubTab) {
      case 0:
        return _buildDataDiriContent();
      case 1:
        return const TabMediaSosial();
      case 2:
        return const TabMinatKarir();
      case 3:
        return const TabReferensi();
      default:
        return _buildDataDiriContent();
    }
  }

  Widget _buildSubTab(String text, int index) {
    final isSelected = _selectedSubTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSubTab = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : const Color(0xFFB8B8B8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: 'SF Pro',
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  Widget _buildDataDiriContent() {
    final profil = _profil!;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.person, size: 27, color: Colors.black54),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Kelengkapan Profil',
                                style: TextStyle(
                                  color: Color(0xFF515151),
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '24 %',
                                style: TextStyle(
                                  color: Color(0xFF515151),
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 8,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 71,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Colors.white, Color(0xFF0727E1)],
                                    ),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: const [
                              Icon(
                                Icons.info_outline,
                                size: 15,
                                color: Colors.black54,
                              ),
                              SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'Lengkapi profil Anda agar AI dapat memberikan rekomendasi yang lebih akurat dan sesuai',
                                  style: TextStyle(
                                    color: Color(0xFF515151),
                                    fontSize: 9,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w300,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _buildFotoProfilField(profil.fotoProfil),
          _buildInlineEditableField(
            Icons.person_outline,
            'Nama',
            'nama',
            profil.nama ?? '-',
            (value) {
              setState(() {
                _profil = profil.copyWith(nama: value);
              });
              _saveField();
            },
          ),
          _buildProfileField(
            Icons.badge_outlined,
            'NIK',
            value: profil.nik ?? '-',
          ),
          _buildProfileField(
            Icons.calendar_today,
            'Usia',
            value: profil.usia?.toString() ?? '-',
          ),
          _buildProfileField(
            Icons.wc,
            'Jenis Kelamin',
            value: profil.jenisKelamin ?? '-',
          ),
          _buildProfileField(
            Icons.location_city_outlined,
            'Provinsi',
            value: profil.provinsi ?? '-',
          ),
          _buildProfileField(
            Icons.location_on_outlined,
            'Kabupaten / Kota',
            value: profil.kabupatenKota ?? '-',
          ),
          _buildInlineEditableField(
            Icons.home_outlined,
            'Alamat',
            'alamat',
            profil.alamat ?? '-',
            (value) {
              setState(() {
                _profil = profil.copyWith(alamat: value);
              });
              _saveField();
            },
            maxLines: 1, // ← ubah ini
          ),

          _buildInlineEditableField(
            Icons.phone_outlined,
            'Nomor Whatsapp',
            'nomorWa',
            profil.nomorTelepon ?? '-',
            (value) {
              setState(() {
                _profil = profil.copyWith(nomorTelepon: value);
              });
              _saveField();
            },
            isLast: true,
          ),
          const SizedBox(height: 18),
          _buildInlineEditableField(
            Icons.location_searching,
            'Lokasi kerja diinginkan',
            'lokasiKerja',
            profil.lokasiKerjaDiinginkan ?? '-',
            (value) {
              setState(() {
                _profil = profil.copyWith(lokasiKerjaDiinginkan: value);
              });
              _saveField();
            },
            isFirst: true,
          ),
          _buildInlineEditableField(
            Icons.work_outline,
            'Status pekerjaan saat ini',
            'statusPekerjaan',
            profil.statusPekerjaanSaatIni ?? '-',
            (value) {
              setState(() {
                _profil = profil.copyWith(statusPekerjaanSaatIni: value);
              });
              _saveField();
            },
          ),
          _buildInlineEditableField(
            Icons.attach_money,
            'Preferensi gaji',
            'preferensiGaji',
            profil.preferensiGaji != null
                ? 'Rp. ${_formatCurrency(profil.preferensiGaji!)}'
                : '-',
            (value) {
              final gaji = int.tryParse(
                value.replaceAll(RegExp(r'[^0-9]'), ''),
              );
              if (gaji != null) {
                setState(() {
                  _profil = profil.copyWith(preferensiGaji: gaji);
                });
                _saveField();
              }
            },
            isNumeric: true,
          ),
          _buildJamKerjaField(
            profil.preferensiJamKerjaMulai ?? '',
            profil.preferensiJamKerjaSelesai ?? '',
          ),
          _buildPerjalananDinasField(
            profil.preferensiPerjalananDinas ?? 'Tidak',
            isLast: true,
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildInlineEditableField(
    IconData icon,
    String label,
    String fieldKey,
    String currentValue,
    Function(String) onSave, {
    bool isLast = false,
    bool isFirst = false,
    bool isNumeric = false,
    int maxLines = 1,
  }) {
    final isEditing = _editingField == fieldKey;
    final isPhoneNumber = fieldKey == 'nomorWa';

    return GestureDetector(
      onTap: () {
        if (!isEditing) {
          setState(() {
            _editingField = fieldKey;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: isLast ? Colors.transparent : const Color(0xFFE8E8E8),
              width: 1,
            ),
          ),
          borderRadius: isFirst
              ? const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                )
              : isLast
              ? const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                )
              : BorderRadius.zero,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(icon, size: 24, color: Colors.black54),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Color(0xFF515151),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (isEditing)
                    TextField(
                      autofocus: true,
                      maxLines: maxLines,
                      controller:
                          TextEditingController(
                              text: isNumeric
                                  ? currentValue.replaceAll(
                                      RegExp(r'[^0-9]'),
                                      '',
                                    )
                                  : currentValue,
                            )
                            ..selection = TextSelection.fromPosition(
                              TextPosition(
                                offset: isNumeric
                                    ? currentValue
                                          .replaceAll(RegExp(r'[^0-9]'), '')
                                          .length
                                    : currentValue.length,
                              ),
                            ),
                      style: const TextStyle(
                        color: Color(0xFF515151),
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      keyboardType: isPhoneNumber
                          ? TextInputType.phone
                          : isNumeric
                          ? TextInputType.number
                          : maxLines > 1
                          ? TextInputType.multiline
                          : TextInputType.text,
                      inputFormatters: isPhoneNumber
                          ? [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(13),
                              _PhoneNumberFormatter(),
                            ]
                          : isNumeric
                          ? [
                              FilteringTextInputFormatter.digitsOnly,
                              _CurrencyInputFormatter(),
                            ]
                          : null,
                      onSubmitted: (value) {
                        onSave(value);
                        setState(() {
                          _editingField = null;
                        });
                      },
                      onTapOutside: (event) {
                        setState(() {
                          _editingField = null;
                        });
                      },
                    )
                  else
                    Text(
                      currentValue,
                      style: const TextStyle(
                        color: Color(0xFF515151),
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                ],
              ),
            ),
            if (!isEditing)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: const Icon(Icons.edit, size: 20, color: Colors.black38),
              ),
            if (isEditing && _isSaving)
              const Padding(
                padding: EdgeInsets.only(top: 2),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.black,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildJamKerjaField(String jamMulai, String jamSelesai) {
    final isEditing = _editingField == 'jamKerja';

    // Format tampilan (hapus :00 di belakang kalau ada)
    String displayJamMulai = jamMulai.length > 5
        ? jamMulai.substring(0, 5)
        : jamMulai;
    String displayJamSelesai = jamSelesai.length > 5
        ? jamSelesai.substring(0, 5)
        : jamSelesai;

    final TextEditingController controllerMulai = TextEditingController(
      text: displayJamMulai,
    );
    final TextEditingController controllerSelesai = TextEditingController(
      text: displayJamSelesai,
    );

    return GestureDetector(
      onTap: () {
        if (!isEditing) {
          setState(() {
            _editingField = 'jamKerja';
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Color(0xFFE8E8E8), width: 1),
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.access_time, size: 24, color: Colors.black54),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Preferensi jam kerja',
                    style: TextStyle(
                      color: Color(0xFF515151),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (isEditing)
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controllerMulai,
                            autofocus: true,
                            style: const TextStyle(
                              color: Color(0xFF515151),
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                            decoration: const InputDecoration(
                              hintText: '08:00',
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            keyboardType: TextInputType.datetime,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9:]'),
                              ),
                              LengthLimitingTextInputFormatter(5),
                              _TimeInputFormatter(),
                            ],
                            onChanged: (value) {
                              if (value.length == 5) {
                                setState(() {
                                  _profil = _profil!.copyWith(
                                    preferensiJamKerjaMulai: value,
                                  );
                                });
                              }
                            },
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            '-',
                            style: TextStyle(
                              color: Color(0xFF515151),
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: controllerSelesai,
                            style: const TextStyle(
                              color: Color(0xFF515151),
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                            decoration: const InputDecoration(
                              hintText: '17:00',
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            keyboardType: TextInputType.datetime,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9:]'),
                              ),
                              LengthLimitingTextInputFormatter(5),
                              _TimeInputFormatter(),
                            ],
                            onChanged: (value) {
                              if (value.length == 5) {
                                setState(() {
                                  _profil = _profil!.copyWith(
                                    preferensiJamKerjaSelesai: value,
                                  );
                                });
                              }
                            },
                            onSubmitted: (value) {
                              setState(() {
                                _profil = _profil!.copyWith(
                                  preferensiJamKerjaSelesai: value,
                                );
                                _editingField = null;
                              });
                              _saveField();
                            },
                            onTapOutside: (event) {
                              setState(() {
                                _editingField = null;
                              });
                              _saveField();
                            },
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      (displayJamMulai.isNotEmpty &&
                              displayJamSelesai.isNotEmpty)
                          ? '$displayJamMulai - $displayJamSelesai'
                          : '-',
                      style: const TextStyle(
                        color: Color(0xFF515151),
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                ],
              ),
            ),
            if (!isEditing)
              const Icon(Icons.edit, size: 20, color: Colors.black38),
            if (isEditing && _isSaving)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.black,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerjalananDinasField(
    String currentValue, {
    bool isLast = false,
  }) {
    final isEditing = _editingField == 'perjalananDinas';

    return GestureDetector(
      onTap: () {
        if (!isEditing) {
          setState(() {
            _editingField = 'perjalananDinas';
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: isLast ? Colors.transparent : const Color(0xFFE8E8E8),
              width: 1,
            ),
          ),
          borderRadius: isLast
              ? const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                )
              : BorderRadius.zero,
        ),
        child: Row(
          children: [
            const Icon(Icons.flight_outlined, size: 24, color: Colors.black54),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Preferensi perjalanan dinas',
                    style: TextStyle(
                      color: Color(0xFF515151),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (isEditing)
                    Row(
                      children: [
                        _buildOptionButton('Ya', currentValue == 'Ya'),
                        const SizedBox(width: 12),
                        _buildOptionButton('Tidak', currentValue == 'Tidak'),
                      ],
                    )
                  else
                    Text(
                      currentValue.isNotEmpty ? currentValue : '-',
                      style: const TextStyle(
                        color: Color(0xFF515151),
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                ],
              ),
            ),
            if (!isEditing)
              const Icon(Icons.edit, size: 20, color: Colors.black38),
            if (isEditing && _isSaving)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.black,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _profil = _profil!.copyWith(preferensiPerjalananDinas: text);
          _editingField = null;
        });
        _saveField();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.black : const Color(0xFFE8E8E8),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF515151),
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildFotoProfilField(String? avatarUrl) {
    return GestureDetector(
      onTap: _isUploadingImage ? null : _pickAndUploadImage,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Color(0xFFE8E8E8), width: 1),
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.photo_camera_outlined,
              size: 24,
              color: Colors.black54,
            ),
            const SizedBox(width: 20),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Foto profil',
                    style: TextStyle(
                      color: Color(0xFF515151),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Ketuk untuk mengubah',
                    style: TextStyle(
                      color: Color(0xFF999999),
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Stack(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    shape: BoxShape.circle,
                    image: _selectedImage != null
                        ? DecorationImage(
                            image: FileImage(_selectedImage!),
                            fit: BoxFit.cover,
                          )
                        : (avatarUrl != null && avatarUrl.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(
                                    '${ApiConfig.baseUrlFoto}/$avatarUrl',
                                  ),
                                  fit: BoxFit.cover,
                                )
                              : null),
                  ),
                  child:
                      (avatarUrl == null || avatarUrl.isEmpty) &&
                          _selectedImage == null
                      ? const Icon(
                          Icons.person,
                          size: 30,
                          color: Colors.white54,
                        )
                      : null,
                ),
                if (_isUploadingImage)
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileField(
    IconData icon,
    String label, {
    String? value,
    bool hasAvatar = false,
    String? avatarUrl,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isLast ? Colors.transparent : const Color(0xFFE8E8E8),
            width: 1,
          ),
        ),
        borderRadius: isFirst
            ? const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              )
            : isLast
            ? const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              )
            : BorderRadius.zero,
      ),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.black54),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF515151),
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (value != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      color: Color(0xFF515151),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (hasAvatar)
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                shape: BoxShape.circle,
                image: avatarUrl != null && avatarUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(avatarUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: avatarUrl == null || avatarUrl.isEmpty
                  ? const Icon(Icons.person, size: 30, color: Colors.white54)
                  : null,
            ),
        ],
      ),
    );
  }
}

// ==================== FORMATTERS ====================

class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    if (text.isEmpty) {
      return newValue;
    }

    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      if (i == 4 || i == 8) {
        buffer.write('-');
      }
      buffer.write(text[i]);
    }

    final formatted = buffer.toString();

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class _CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final value = int.tryParse(newValue.text.replaceAll(RegExp(r'[^0-9]'), ''));
    if (value == null) {
      return oldValue;
    }

    final formatted = 'Rp. ${_formatNumber(value)}';

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}

class _TimeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(':', '');

    if (text.isEmpty) {
      return newValue;
    }

    final buffer = StringBuffer();

    for (int i = 0; i < text.length && i < 4; i++) {
      if (i == 2) {
        buffer.write(':');
      }
      buffer.write(text[i]);
    }

    final formatted = buffer.toString();

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
