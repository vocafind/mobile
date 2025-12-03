import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jobfair/api/api_service.dart';
import 'package:jobfair/screens/halaman_lamaran.dart'; // Import halaman lamaran
import 'package:jobfair/screens/detail_lamaran.dart';
import 'package:jobfair/screens/detail_lamaran_jobfair.dart';
import '../models/notification_model.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  String? expandedId;
  late ApiService _notificationService;
  List<NotificationModel> notifications = [];
  bool isLoading = true;
  String errorMessage = '';

  // Variabel untuk undo
  NotificationModel? _deletedNotification;
  int? _deletedNotificationIndex;
  Timer? _undoTimer;

  @override
  void initState() {
    super.initState();
    _notificationService = ApiService();
    _loadNotifications();
  }

  @override
  void dispose() {
    _undoTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadNotifications() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      final List<NotificationModel> data = await _notificationService
          .getAllNotifications();

      setState(() {
        notifications = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Gagal memuat notifikasi: $e';
        isLoading = false;
      });
      print('Error loading notifications: $e');
    }
  }

  void _deleteNotificationWithUndo(String id) {
    final notificationIndex = notifications.indexWhere(
      (n) => n.notificationId == id,
    );
    if (notificationIndex == -1) return;

    final deletedNotification = notifications[notificationIndex];

    // Simpan data untuk undo
    _deletedNotification = deletedNotification;
    _deletedNotificationIndex = notificationIndex;

    // Hapus dari UI terlebih dahulu
    setState(() {
      notifications.removeAt(notificationIndex);
      if (expandedId == id) {
        expandedId = null;
      }
    });

    // Tampilkan SnackBar dengan undo
    _showUndoSnackbar(id);
  }

  void _showUndoSnackbar(String deletedId) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.clearSnackBars(); // Hapus snackbar sebelumnya

    final snackBar = SnackBar(
      content: const Text(
        'Notifikasi telah dihapus',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.white,
      duration: const Duration(seconds: 7),
      action: SnackBarAction(
        label: 'URUNGKAN',
        textColor: const Color(0xFF1B56FD),
        onPressed: () {
          _undoDelete();
        },
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      elevation: 4,
      margin: const EdgeInsets.all(20),
    );

    scaffold.showSnackBar(snackBar);

    // Set timer untuk menghapus data undo setelah 7 detik
    _undoTimer?.cancel();
    _undoTimer = Timer(const Duration(seconds: 7), () {
      // Setelah 7 detik, hapus secara permanen dari API
      _permanentlyDeleteNotification(deletedId);
      _clearUndoData();
    });
  }

  void _undoDelete() {
    if (_deletedNotification != null && _deletedNotificationIndex != null) {
      // Cancel timer karena user memilih undo
      _undoTimer?.cancel();
      _undoTimer = null;

      // Kembalikan notifikasi ke list
      setState(() {
        notifications.insert(_deletedNotificationIndex!, _deletedNotification!);
      });

      _clearUndoData();

      // Tampilkan feedback bahwa notifikasi dikembalikan
      _showRestoredSnackbar();
    }
  }

  void _showRestoredSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Notifikasi telah dikembalikan',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _permanentlyDeleteNotification(String id) async {
    try {
      await _notificationService.deleteNotification(id);
      print('Notifikasi $id berhasil dihapus permanen dari API');
    } catch (e) {
      print('Gagal menghapus notifikasi dari API: $e');
    }
  }

  void _clearUndoData() {
    _deletedNotification = null;
    _deletedNotificationIndex = null;
  }

  Future<void> _markAsRead(String id) async {
    print('=== DEBUG: _markAsRead called for id: $id');

    // Update UI terlebih dahulu untuk responsif
    setState(() {
      final index = notifications.indexWhere((n) => n.notificationId == id);
      if (index != -1) {
        notifications[index] = notifications[index].copyWith(isRead: true);
        print('=== DEBUG: UI updated - isRead: true');
      }
    });

    // Kirim request ke API di background (fire and forget)
    _notificationService
        .markAsRead(id)
        .then((_) {
          print('=== DEBUG: API call successful');
        })
        .catchError((error) {
          print('=== DEBUG: API call failed: $error');
        });
  }

  void _toggleExpand(String id) {
    print('=== DEBUG: _toggleExpand called for id: $id');
    print('=== DEBUG: Current expandedId: $expandedId');

    final notification = notifications.firstWhere(
      (n) => n.notificationId == id,
    );
    print('=== DEBUG: Notification isRead before: ${notification.isRead}');

    setState(() {
      if (expandedId == id) {
        expandedId = null;
        print('=== DEBUG: Collapsing notification');
      } else {
        expandedId = id;
        print('=== DEBUG: Expanding notification');

        if (!notification.isRead) {
          print('=== DEBUG: Marking as read');
          _markAsRead(id);
        } else {
          print('=== DEBUG: Already read, skipping markAsRead');
        }
      }
    });
  }

  Future<void> _navigateToLamaranDetail(String applyId) async {
    print('=== DEBUG: Navigating to lamaran detail for applyId: $applyId');

    try {
      // Cari lamaran berdasarkan applyId
      final lamaran = await _notificationService.getLamaranByApplyId(applyId);

      if (lamaran == null) {
        print('❌ Lamaran tidak ditemukan');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lamaran tidak ditemukan'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Tentukan apakah ini lamaran jobfair
      final isJobfairLamaran = lamaran.acara != null;

      // Navigasi ke HalamanLamaran terlebih dahulu
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HalamanLamaran(applyIdToOpen: applyId),
        ),
      ).then((_) {
        // Setelah halaman lamaran terbuka, tunggu sedikit lalu buka detail
        Future.delayed(const Duration(milliseconds: 300), () {
          if (isJobfairLamaran) {
            // Buka detail lamaran jobfair
            DetailLamaranJobfair.show(context, lamaran: lamaran);
          } else {
            // Buka detail lamaran umum
            DetailLamaran.show(context, lamaran: lamaran);
          }
        });
      });
    } catch (e) {
      print('❌ Error navigating to lamaran detail: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal membuka detail: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _refreshNotifications() async {
    await _loadNotifications();
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
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 20,
                          ),
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
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : errorMessage.isNotEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            errorMessage,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _refreshNotifications,
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    )
                  : notifications.isEmpty
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
                  : RefreshIndicator(
                      onRefresh: _loadNotifications,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(
                          top: 30,
                          left: 21,
                          right: 21,
                        ),
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          final notification = notifications[index];
                          final isExpanded =
                              expandedId == notification.notificationId;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Dismissible(
                              key: Key(notification.notificationId),
                              direction: DismissDirection.endToStart,
                              confirmDismiss: null, // Hapus modal konfirmasi
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(23),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Hapus',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(
                                      Icons.delete_outline,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ],
                                ),
                              ),
                              onDismissed: (direction) {
                                _deleteNotificationWithUndo(
                                  notification.notificationId,
                                );
                              },
                              child: GestureDetector(
                                onTap: () {
                                  _toggleExpand(notification.notificationId);
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  decoration: BoxDecoration(
                                    color: notification.isRead
                                        ? const Color(
                                            0xFFEDEEF0,
                                          ).withOpacity(0.75)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(23),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
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
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Colors.grey
                                                      .withOpacity(0.2),
                                                ),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(19),
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      notification.companyLogo,
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) =>
                                                      Container(
                                                        color: Colors.grey[200],
                                                        child: const Icon(
                                                          Icons.business,
                                                          color: Colors.grey,
                                                          size: 20,
                                                        ),
                                                      ),
                                                  errorWidget:
                                                      (
                                                        context,
                                                        url,
                                                        error,
                                                      ) => Container(
                                                        color: Colors.grey[200],
                                                        child: const Icon(
                                                          Icons.business,
                                                          color: Colors.grey,
                                                          size: 20,
                                                        ),
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
                                                          notification
                                                              .companyName,
                                                          style:
                                                              const TextStyle(
                                                                color: Color(
                                                                  0xFF515151,
                                                                ),
                                                                fontSize: 13,
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                height: 1.38,
                                                              ),
                                                        ),
                                                      ),
                                                      Text(
                                                        notification.timeAgo,
                                                        style: const TextStyle(
                                                          color: Color(
                                                            0xFF7D7D7D,
                                                          ),
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
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      height: 1.12,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 3),
                                                  Text(
                                                    notification.position,
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w400,
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
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        curve: Curves.easeInOut,
                                        child: isExpanded
                                            ? Container(
                                                width: double.infinity,
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                      16,
                                                      0,
                                                      16,
                                                      16,
                                                    ),
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    top: BorderSide(
                                                      color: Colors.grey
                                                          .withOpacity(0.2),
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
                                                      notification.body,
                                                      style: const TextStyle(
                                                        color: Color(
                                                          0xFF515151,
                                                        ),
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
                                                                    .notificationId,
                                                              );
                                                            },
                                                            style: OutlinedButton.styleFrom(
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    vertical:
                                                                        12,
                                                                  ),
                                                              side: BorderSide(
                                                                color: Colors
                                                                    .grey
                                                                    .shade400,
                                                              ),
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      10,
                                                                    ),
                                                              ),
                                                            ),
                                                            child: const Text(
                                                              'Tutup',
                                                              style: TextStyle(
                                                                color: Color(
                                                                  0xFF515151,
                                                                ),
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
                                                        const SizedBox(
                                                          width: 12,
                                                        ),
                                                        Expanded(
                                                          child: ElevatedButton(
                                                            onPressed: () {
                                                              // Panggil fungsi navigasi ke detail lamaran
                                                              _navigateToLamaranDetail(
                                                                notification
                                                                    .applyId,
                                                              );
                                                            },
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor:
                                                                  const Color(
                                                                    0xFF1B56FD,
                                                                  ),
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    vertical:
                                                                        12,
                                                                  ),
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      10,
                                                                    ),
                                                              ),
                                                              elevation: 0,
                                                            ),
                                                            child: const Text(
                                                              'Lihat Detail',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
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
            ),
          ],
        ),
      ),
    );
  }
}
