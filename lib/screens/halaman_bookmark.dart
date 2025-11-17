import 'package:flutter/material.dart';

class HalamanBookmark extends StatelessWidget {
  const HalamanBookmark({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lowongan Tersimpan',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF0118D8),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: const Center(
          child: Text(
            'Daftar lowongan yang disimpan akan muncul di sini',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 16,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ),
    );
  }
}