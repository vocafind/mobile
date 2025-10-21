import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  String? expandedId;

  List<NotificationItem> notifications = [
    NotificationItem(
      id: '1',
      company: 'Inforsys Indonesia',
      title: 'Lamaran anda diterima',
      message: 'Lamaran Fulltime Backend Deve...',
      fullMessage:
          'Selamat! Lamaran Anda untuk posisi Fulltime Backend Developer telah diterima. Tim HR kami akan menghubungi Anda dalam 2-3 hari kerja untuk proses selanjutnya.',
      time: '34m lalu',
      isRead: false,
      logoUrl: 'https://via.placeholder.com/40',
    ),
    NotificationItem(
      id: '2',
      company: 'Inforsys Indonesia',
      title: 'Lamaran anda diterima',
      message: 'Lamaran Fulltime Backend Deve...',
      fullMessage:
          'Selamat! Lamaran Anda untuk posisi Fulltime Backend Developer telah diterima. Tim HR kami akan menghubungi Anda dalam 2-3 hari kerja untuk proses selanjutnya.',
      time: '34m lalu',
      isRead: true,
      logoUrl: 'https://via.placeholder.com/40',
    ),
    NotificationItem(
      id: '3',
      company: 'Inforsys Indonesia',
      title: 'Lamaran anda diterima',
      message: 'Lamaran Fulltime Backend Deve...',
      fullMessage:
          'Selamat! Lamaran Anda untuk posisi Fulltime Backend Developer telah diterima. Tim HR kami akan menghubungi Anda dalam 2-3 hari kerja untuk proses selanjutnya.',
      time: '34m lalu',
      isRead: true,
      logoUrl: 'https://via.placeholder.com/40',
    ),
    NotificationItem(
      id: '4',
      company: 'Inforsys Indonesia',
      title: 'Lamaran anda diterima',
      message: 'Lamaran Fulltime Backend Deve...',
      fullMessage:
          'Selamat! Lamaran Anda untuk posisi Fulltime Backend Developer telah diterima. Tim HR kami akan menghubungi Anda dalam 2-3 hari kerja untuk proses selanjutnya.',
      time: '34m lalu',
      isRead: true,
      logoUrl: 'https://via.placeholder.com/40',
    ),
    NotificationItem(
      id: '5',
      company: 'Inforsys Indonesia',
      title: 'Lamaran anda diterima',
      message: 'Lamaran Fulltime Backend Deve...',
      fullMessage:
          'Selamat! Lamaran Anda untuk posisi Fulltime Backend Developer telah diterima. Tim HR kami akan menghubungi Anda dalam 2-3 hari kerja untuk proses selanjutnya.',
      time: '34m lalu',
      isRead: true,
      logoUrl: 'https://via.placeholder.com/40',
    ),
  ];

  void _deleteNotification(String id) {
    setState(() {
      notifications.removeWhere((n) => n.id == id);
      if (expandedId == id) {
        expandedId = null;
      }
    });
  }

  void _markAsRead(String id) {
    setState(() {
      final index = notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        notifications[index].isRead = true;
      }
    });
  }

  void _toggleExpand(String id) {
    setState(() {
      if (expandedId == id) {
        expandedId = null;
      } else {
        expandedId = id;
        _markAsRead(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFF0F4F9),
        child: Column(
          children: [
            // Header with gradient
            Container(
              height: 108,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF1B56FD), Color(0xFF0118D8)],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 21),
                  child: Row(
                    children: [
                      // Back button
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new,
                              color: Colors.white, size: 20),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: 18),
                      const Text(
                        'Notifikasi',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Notification List
            Expanded(
              child: notifications.isEmpty
                  ? const Center(
                      child: Text(
                        'Tidak ada notifikasi',
                        style: TextStyle(
                          color: Color(0xFF515151),
                          fontSize: 16,
                          fontFamily: 'SF Pro',
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(top: 30, left: 21, right: 21),
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final notification = notifications[index];
                        final isExpanded = expandedId == notification.id;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Dismissible(
                            key: Key(notification.id),
                            direction: DismissDirection.endToStart,
                            confirmDismiss: (direction) async {
                              return true;
                            },
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(23),
                              ),
                              child: const Icon(
                                Icons.delete_outline,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            onDismissed: (direction) {
                              _deleteNotification(notification.id);
                            },
                            child: GestureDetector(
                              onTap: () {
                                _toggleExpand(notification.id);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                decoration: BoxDecoration(
                                  color: notification.isRead
                                      ? const Color(0xFFEDEEF0)
                                          .withValues(alpha: 0.75)
                                      : Colors.white.withValues(alpha: 1),
                                  borderRadius: BorderRadius.circular(23),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.1),
                                      blurRadius: 10,
                                      spreadRadius: 0,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    // Main notification content
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Company Logo
                                          Container(
                                            width: 38,
                                            height: 38,
                                            decoration: BoxDecoration(
                                            ),
                                            child: ClipRRect(
                                              child: Image.asset(
                                                "assets/icons/poltek.png",
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                        stack) =>
                                                    const Icon(
                                                  Icons.business,
                                                  color: Colors.grey,
                                                  size: 24,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 11),
                                          // Content
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        notification.company,
                                                        style: const TextStyle(
                                                          color:
                                                              Color(0xFF515151),
                                                          fontSize: 13,
                                                          fontFamily: 'Poppins',
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          height: 1.38,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      notification.time,
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xFF7D7D7D),
                                                        fontSize: 13,
                                                        fontFamily: 'Poppins',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        height: 1.38,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 3),
                                                Text(
                                                  notification.title,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w600,
                                                    height: 1.12,
                                                  ),
                                                ),
                                                const SizedBox(height: 3),
                                                Text(
                                                  notification.message,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w400,
                                                    height: 1.28,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Expanded Detail Section
                                    AnimatedSize(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                      child: isExpanded
                                          ? Container(
                                              width: double.infinity,
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      16, 0, 16, 16),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  top: BorderSide(
                                                    color: Colors.grey
                                                        .withValues(alpha: 0.2),
                                                    width: 1,
                                                  ),
                                                ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(height: 16),
                                                  Text(
                                                    notification.fullMessage,
                                                    style: const TextStyle(
                                                      color: Color(0xFF515151),
                                                      fontSize: 14,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height: 1.5,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: OutlinedButton(
                                                          onPressed: () {
                                                            _toggleExpand(
                                                                notification
                                                                    .id);
                                                          },
                                                          style: OutlinedButton
                                                              .styleFrom(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        12),
                                                            side: BorderSide(
                                                              color: Colors.grey
                                                                  .shade400,
                                                            ),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                          ),
                                                          child: const Text(
                                                            'Tutup',
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFF515151),
                                                              fontSize: 15,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 12),
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          onPressed: () {},
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                const Color(
                                                                    0xFF1B56FD),
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        12),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            elevation: 0,
                                                          ),
                                                          child: const Text(
                                                            'Lihat Detail',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationItem {
  final String id;
  final String company;
  final String title;
  final String message;
  final String fullMessage;
  final String time;
  bool isRead;
  final String logoUrl;

  NotificationItem({
    required this.id,
    required this.company,
    required this.title,
    required this.message,
    required this.fullMessage,
    required this.time,
    required this.isRead,
    required this.logoUrl,
  });
}