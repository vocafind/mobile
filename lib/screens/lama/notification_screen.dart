import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ubah ini untuk testing: true = ada notifikasi, false = kosong
    final bool hasNotifications = true;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F0F5),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              height: 97,
              color: Colors.white,
              padding: const EdgeInsets.only(left: 23, right: 23, top: 7, bottom: 24),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 39,
                      height: 39,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 16,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Notifikasi",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "SF Pro",
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ),
            ),

            // Content - Conditional based on hasNotifications
            Expanded(
              child: hasNotifications
                  ? _buildNotificationList()
                  : _buildEmptyState(),
            ),
          ],
        ),
      ),
    );
  }

  // Empty State
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Empty state illustration
            Image.asset(
              'assets/icons/pesan.png',
              width: 360,
              height: 317,
              fit: BoxFit.fitHeight,
            ),
            // Geser teks ke atas sedikit
            Transform.translate(
              offset: const Offset(0, -50),
              child: Column(
                children: const [
                  SizedBox(height: 10),
                  Text(
                    "Belum ada notifikasi",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontFamily: "SF Pro",
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      height: 0.75,
                    ),
                  ),
                  SizedBox(height: 14),
                  SizedBox(
                    width: 250,
                    child: Text(
                      "Notifikasi mu akan muncul disini",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: "SF Pro",
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Notification List
  Widget _buildNotificationList() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 33, vertical: 34),
      children: [
        _buildNotificationCard(
          title: "Lowongan",
          description: "Lorem ipsum dolor sit amet, consectetur \nadipiscing elit, sed do eiusmod tempor",
          time: "5 menit lalu",
        ),
        const SizedBox(height: 13),
        _buildNotificationCard(
          title: "Lowongan",
          description: "Lorem ipsum dolor sit amet, consectetur \nadipiscing elit, sed do eiusmod tempor",
          time: "5 menit lalu",
        ),
        const SizedBox(height: 13),
        _buildNotificationCard(
          title: "Lowongan",
          description: "Lorem ipsum dolor sit amet, consectetur \nadipiscing elit, sed do eiusmod tempor",
          time: "5 menit lalu",
        ),
      ],
    );
  }

  // Notification Card
  Widget _buildNotificationCard({
    required String title,
    required String description,
    required String time,
  }) {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: "SF Pro",
              fontWeight: FontWeight.w700,
              color: Colors.black,
              height: 1.43,
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: "SF Pro",
                fontWeight: FontWeight.w400,
                color: Color(0xFF7D7D7D),
                height: 1.43,
              ),
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              fontSize: 11,
              fontFamily: "SF Pro",
              fontWeight: FontWeight.w300,
              color: Color(0xFF94A3B8),
              height: 1.82,
            ),
          ),
        ],
      ),
    );
  }
}