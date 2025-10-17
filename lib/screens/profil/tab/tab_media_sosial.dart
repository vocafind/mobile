import 'package:flutter/material.dart';

class TabMediaSosial extends StatelessWidget {
  const TabMediaSosial({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 20),
      child: Column(
        children: [
          // Add Button
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 39,
              height: 39,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF113CEE)),
              ),
              child: const Center(
                child: Text(
                  '+',
                  style: TextStyle(
                    color: Color(0xFF0C32E8),
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Instagram
          _buildSocialMediaItem(
            icon: _buildInstagramIcon(),
            platform: 'Instagram',
            username: 'pergijauh',
            isFirst: true,
          ),

          // Facebook
          _buildSocialMediaItem(
            icon: _buildFacebookIcon(),
            platform: 'Facebook',
            username: 'pergijauh',
          ),

          // LinkedIn
          _buildSocialMediaItem(
            icon: _buildLinkedInIcon(),
            platform: 'LinkedIn',
            username: 'pergijauh',
            isLast: true,
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildSocialMediaItem({
    required Widget icon,
    required String platform,
    required String username,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
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
          icon,
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  platform,
                  style: const TextStyle(
                    color: Color(0xFF515151),
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  username,
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
          const Icon(
            Icons.edit_outlined,
            size: 20,
            color: Colors.black54,
          ),
        ],
      ),
    );
  }

  Widget _buildInstagramIcon() {
    return Container(
      width: 31,
      height: 31,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFDDD55),
            Color(0xFFFF543E),
            Color(0xFFC837AB),
          ],
        ),
      ),
      child: Center(
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(
            Icons.camera_alt_outlined,
            size: 16,
            color: Color(0xFFC837AB),
          ),
        ),
      ),
    );
  }

  Widget _buildFacebookIcon() {
    return Container(
      width: 31,
      height: 31,
      decoration: BoxDecoration(
        color: const Color(0xFF1877F2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Text(
          'f',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontFamily: 'SF Pro',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildLinkedInIcon() {
    return Container(
      width: 31,
      height: 31,
      decoration: BoxDecoration(
        color: const Color(0xFF0A66C2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Text(
          'in',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: 'SF Pro',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}