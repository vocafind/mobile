import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<NotificationItem> notifications = [
    NotificationItem(
      id: '1',
      title: 'Lowongan',
      message: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor',
      time: '5 menit lalu',
      isRead: false,
    ),
    NotificationItem(
      id: '2',
      title: 'Lowongan',
      message: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor',
      time: '10 menit lalu',
      isRead: false,
    ),
    NotificationItem(
      id: '3',
      title: 'Lowongan',
      message: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor',
      time: '1 jam lalu',
      isRead: true,
    ),
    NotificationItem(
      id: '4',
      title: 'Lowongan',
      message: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor',
      time: '2 jam lalu',
      isRead: true,
    ),
  ];

  void _markAsRead(String id) {
    setState(() {
      final index = notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        notifications[index].isRead = true;
      }
    });
  }

  void _deleteNotification(String id) {
    setState(() {
      notifications.removeWhere((n) => n.id == id);
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in notifications) {
        notification.isRead = true;
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
                          color: Colors.white.withValues(alpha:0.1),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                      const Spacer(),
                      // Mark all as read button
                      TextButton(
                        onPressed: _markAllAsRead,
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha:0.1),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(color: Colors.white24),
                          ),
                        ),
                        child: const Text(
                          'Tandai Semua',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                        ),
                      )

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
          padding: const EdgeInsets.only(top: 16),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return Dismissible(
              key: Key(notification.id),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                color: Colors.red,
                child: const Icon(Icons.delete, color: Colors.white, size: 28),
              ),
              onDismissed: (direction) {
                _deleteNotification(notification.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notifikasi dihapus')),
                );
              },
              child: GestureDetector(
                onTap: () {
                  if (!notification.isRead) {
                    _markAsRead(notification.id);
                  }
                },
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 8),
                  color: notification.isRead
                      ? Colors.white.withValues(alpha:0.7)
                      : Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  notification.title,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: 'SF Pro',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                if (!notification.isRead) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF1B56FD),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert,
                                  color: Color(0xFF515151)),
                              onSelected: (value) {
                                if (value == 'read') {
                                  _markAsRead(notification.id);
                                } else if (value == 'delete') {
                                  _deleteNotification(notification.id);
                                }
                              },
                              itemBuilder: (context) => [
                                if (!notification.isRead)
                                  const PopupMenuItem(
                                    value: 'read',
                                    child: Row(
                                      children: [
                                        Icon(Icons.check, size: 20),
                                        SizedBox(width: 8),
                                        Text('Tandai sudah dibaca'),
                                      ],
                                    ),
                                  ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete,
                                          size: 20, color: Colors.red),
                                      SizedBox(width: 8),
                                      Text('Hapus',
                                          style:
                                              TextStyle(color: Colors.red)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          notification.message,
                          style: const TextStyle(
                            color: Color(0xFF515151),
                            fontSize: 14,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w400,
                            height: 1.43,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        const Divider(color: Color(0xFFE9E9E9), thickness: 1),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            notification.time,
                            style: const TextStyle(
                              color: Color(0xFF515151),
                              fontSize: 13,
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
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
  final String title;
  final String message;
  final String time;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
  });
}