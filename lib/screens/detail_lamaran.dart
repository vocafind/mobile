import 'package:flutter/material.dart';
import 'package:vocafind/models/lamar_loker.dart';

class DetailLamaran extends StatefulWidget {
  final LamaranSaya lamaran;

  const DetailLamaran({super.key, required this.lamaran});

  static void show(BuildContext context, {required LamaranSaya lamaran}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Builder(
        builder: (bottomSheetContext) => DetailLamaran(lamaran: lamaran),
      ),
    );
  }

  @override
  State<DetailLamaran> createState() => _DetailLamaranState();
}

class _DetailLamaranState extends State<DetailLamaran> {
  String _activeTimeline = 'pending';

  @override
  void initState() {
    super.initState();
    _setInitialTimeline();
  }

  void _setInitialTimeline() {
    final status = widget.lamaran.status.toLowerCase();
    switch (status) {
      case 'pending':
        _activeTimeline = 'pending';
        break;
      case 'reviewed':
        _activeTimeline = 'reviewed';
        break;
      case 'interview':
        _activeTimeline = 'interview';
        break;
      case 'accepted':
      case 'reject_interview':
        _activeTimeline = 'hasil'; // Untuk status akhir, langsung ke tab hasil
        break;
      default:
        _activeTimeline = 'pending';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_getMonthName(date.month)} ${date.year}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} WIB';
  }

  String _getMonthName(int month) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return months[month - 1];
  }

  int _getTimelineOrder(String timelineKey) {
    final order = {'pending': 1, 'reviewed': 2, 'interview': 3, 'hasil': 4};
    return order[timelineKey] ?? 0;
  }

  int _getCurrentStatusOrder() {
    final statusOrder = {
      'pending': 1,
      'reviewed': 2,
      'interview': 3,
      'accepted': 4,
      'reject_interview': 4,
    };
    return statusOrder[widget.lamaran.status.toLowerCase()] ?? 1;
  }

  bool _isTimelineAccessible(String timelineKey) {
    final timelineOrder = _getTimelineOrder(timelineKey);
    final currentStatusOrder = _getCurrentStatusOrder();
    return timelineOrder <= currentStatusOrder;
  }

  void _showNotAvailableSnackbar(String phaseName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Fase $phaseName belum tersedia. Tunggu hingga proses sebelumnya selesai.',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF6B7280),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  // Data untuk setiap fase timeline - DIUPDATE
  Map<String, Map<String, dynamic>> get _timelineData {
    final currentStatus = widget.lamaran.status.toLowerCase();
    final isAccepted = currentStatus == 'accepted';
    final isRejected = currentStatus == 'reject_interview';
    final hasInterviewData = widget.lamaran.hasInterviewData;
    final isFinalStatus = isAccepted || isRejected;

    return {
      'pending': {
        'title': 'Menunggu',
        'icon': Icons.access_time_rounded,
        'isCompleted':
            currentStatus == 'pending' ||
            currentStatus == 'reviewed' ||
            currentStatus == 'interview' ||
            isFinalStatus,
        'description': 'Lamaran Anda telah diterima dan menunggu untuk ditinjau',
        'details': [
          {
            'icon': Icons.schedule_rounded,
            'title': 'Waktu Submit',
            'value':
                '${_formatDate(widget.lamaran.appliedAt)}, ${_formatTime(widget.lamaran.appliedAt)}',
          },
          {
            'icon': Icons.info_rounded,
            'title': 'Status',
            'value': 'Menunggu review dari HR',
          },
        ],
      },
      'reviewed': {
        'title': 'Ditinjau',
        'icon': Icons.remove_red_eye_rounded,
        'isCompleted':
            currentStatus == 'reviewed' ||
            currentStatus == 'interview' ||
            isFinalStatus,
        'description': 'Tim HR sedang meninjau lamaran Anda',
        'details': [
          {
            'icon': Icons.schedule_rounded,
            'title': 'Waktu Direview',
            'value': widget.lamaran.createdAt != null
                ? '${_formatDate(widget.lamaran.createdAt)}'
                : 'Belum direview',
          },
          {
            'icon': Icons.info_rounded,
            'title': 'Hasil Review',
            'value': 'Kualifikasi memenuhi syarat',
          },
        ],
      },
      'interview': {
        'title': 'Interview',
        'icon': Icons.people_rounded,
        'isCompleted': currentStatus == 'interview' || isFinalStatus,
        'description': hasInterviewData
            ? 'Anda dijadwalkan untuk wawancara'
            : 'Menunggu jadwal interview dari HR',
        'details': hasInterviewData
            ? [
                {
                  'icon': Icons.calendar_today_rounded,
                  'title': 'Waktu Interview',
                  'value': widget.lamaran.interview ?? 'Belum dijadwalkan',
                },
                {
                  'icon': Icons.location_on_rounded,
                  'title': 'Tempat Interview',
                  'value':
                      widget.lamaran.locationInterview ?? 'Belum ditentukan',
                },
              ]
            : [
                {
                  'icon': Icons.info_rounded,
                  'title': 'Status',
                  'value': 'Menunggu penjadwalan interview',
                },
              ],
      },
      'hasil': {
        'title': 'Hasil',
        'icon': isAccepted ? Icons.check_circle_rounded : Icons.cancel_rounded,
        'isCompleted': isFinalStatus,
        'isSuccess': isAccepted,
        'isRejected': isRejected,
        'description': isAccepted
            ? 'Selamat! Lamaran Anda diterima'
            : 'Maaf, lamaran Anda belum berhasil',
        'details': isAccepted
            ? [
                {
                  'icon': Icons.celebration_rounded,
                  'title': 'Tanggal Diterima',
                  'value': '${_formatDate(widget.lamaran.appliedAt)}',
                },
                {
                  'icon': Icons.work_rounded,
                  'title': 'Posisi',
                  'value': widget.lamaran.lowongan.posisi,
                },
                {
                  'icon': Icons.business_rounded,
                  'title': 'Perusahaan',
                  'value': widget.lamaran.lowongan.company.namaPerusahaan,
                },
                {
                  'icon': Icons.location_on_rounded,
                  'title': 'Lokasi Kerja',
                  'value': widget.lamaran.lowongan.lokasi,
                },
                {
                  'icon': Icons.attach_money_rounded,
                  'title': 'Gaji',
                  'value': widget.lamaran.lowongan.gaji,
                },
              ]
            : [
                {
                  'icon': Icons.schedule_rounded,
                  'title': 'Tanggal Keputusan',
                  'value': '${_formatDate(widget.lamaran.appliedAt)}',
                },
                {
                  'icon': Icons.work_rounded,
                  'title': 'Posisi',
                  'value': widget.lamaran.lowongan.posisi,
                },
                {
                  'icon': Icons.business_rounded,
                  'title': 'Perusahaan',
                  'value': widget.lamaran.lowongan.company.namaPerusahaan,
                },
                {
                  'icon': Icons.info_rounded,
                  'title': 'Status',
                  'value': 'Tidak melanjutkan ke proses selanjutnya',
                },
              ],
      },
    };
  }

  void _setActiveTimeline(String timeline) {
    if (!_isTimelineAccessible(timeline)) {
      _showNotAvailableSnackbar(_timelineData[timeline]!['title']);
      return;
    }

    setState(() {
      _activeTimeline = timeline;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isAccepted = widget.lamaran.status.toLowerCase() == 'accepted';
    final isRejected =
        widget.lamaran.status.toLowerCase() == 'reject_interview';
    final hasInterviewData = widget.lamaran.hasInterviewData;
    final isFinalStatus = isAccepted || isRejected;

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 143,
            height: 5,
            decoration: BoxDecoration(
              color: const Color(0xFF162781).withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
            ),
          ),

          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(18, 30, 18, 24),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 60,
                      height: 53,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFF1F5F9)),
                      ),
                      padding: const EdgeInsets.all(8),
                      child:
                          widget.lamaran.lowongan.company.logo.startsWith(
                            'http',
                          )
                          ? Image.network(
                              widget.lamaran.lowongan.company.logo,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/icons/icon.png',
                                  fit: BoxFit.contain,
                                );
                              },
                            )
                          : Image.asset(
                              widget.lamaran.lowongan.company.logo,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.business,
                                  size: 36,
                                  color: Color(0xFF162781),
                                );
                              },
                            ),
                    ),
                    const SizedBox(width: 20),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.lamaran.lowongan.posisi,
                            style: const TextStyle(
                              color: Color(0xFF1A1A1A),
                              fontSize: 24,
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w500,
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.lamaran.lowongan.company.namaPerusahaan,
                            style: const TextStyle(
                              color: Color(0xFF515151),
                              fontSize: 16,
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w400,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 8),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFFE2E2E2),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 14,
                                  color: const Color(0xFF464E5E),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  widget.lamaran.lowongan.lokasi,
                                  style: const TextStyle(
                                    color: Color(0xFF464E5E),
                                    fontSize: 12,
                                    fontFamily: 'SF Pro',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (isRejected) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF383C).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFFFF383C).withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.cancel_rounded,
                              color: const Color(0xFFFF383C),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Lamaran Anda tidak berhasil pada proses ini',
                                style: TextStyle(
                                  color: const Color(0xFF1A1A1A),
                                  fontSize: 14,
                                  fontFamily: 'SF Pro',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.only(left: 28),
                          child: Text(
                            'Terima kasih telah melamar. Kami menghargai waktu dan usaha Anda.',
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
                ],
                if (isAccepted) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF34C759).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF34C759).withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          color: const Color(0xFF34C759),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Selamat! Lamaran Anda diterima',
                            style: TextStyle(
                              color: const Color(0xFF1A1A1A),
                              fontSize: 14,
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                // Tampilkan info interview jika ada
                if (hasInterviewData &&
                    widget.lamaran.status.toLowerCase() == 'interview') ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0088FF).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF0088FF).withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          color: const Color(0xFF0088FF),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Interview Dijadwalkan',
                                style: TextStyle(
                                  color: const Color(0xFF1A1A1A),
                                  fontSize: 14,
                                  fontFamily: 'SF Pro',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.lamaran.interview!,
                                style: TextStyle(
                                  color: const Color(0xFF515151),
                                  fontSize: 13,
                                  fontFamily: 'SF Pro',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                widget.lamaran.locationInterview!,
                                style: TextStyle(
                                  color: const Color(0xFF515151),
                                  fontSize: 13,
                                  fontFamily: 'SF Pro',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          Container(height: 1, color: const Color(0xFFE9E9E9)),

          _buildHorizontalTimeline(),

          Expanded(child: _buildActiveContent()),
        ],
      ),
    );
  }

  Widget _buildHorizontalTimeline() {
    final List<Map<String, dynamic>> timelineSteps = [
      _timelineData['pending']!,
      _timelineData['reviewed']!,
      _timelineData['interview']!,
      _timelineData['hasil']!,
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        children: [
          Container(
            height: 4,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFE5E8EB),
              borderRadius: BorderRadius.circular(2),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final progress =
                    (_timelineData.keys.toList().indexOf(_activeTimeline) + 1) /
                    _timelineData.length;
                return Stack(
                  children: [
                    Container(
                      width: constraints.maxWidth,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5E8EB),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: constraints.maxWidth * progress,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0088FF), Color(0xFF2345F7)],
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: timelineSteps.asMap().entries.map((entry) {
              final index = entry.key;
              final step = entry.value;
              final stepKey = _timelineData.keys.elementAt(index);
              final isActive = _activeTimeline == stepKey;
              final isCompleted = step['isCompleted'] ?? false;
              final isAccessible = _isTimelineAccessible(stepKey);
              final isSuccess = step['isSuccess'] ?? false;
              final isRejected = step['isRejected'] ?? false;

              return _buildTimelineStep(
                title: step['title'],
                icon: step['icon'],
                isActive: isActive,
                isCompleted: isCompleted,
                isAccessible: isAccessible,
                isSuccess: isSuccess,
                isRejected: isRejected,
                onTap: () => _setActiveTimeline(stepKey),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineStep({
    required String title,
    required IconData icon,
    required bool isActive,
    required bool isCompleted,
    required bool isAccessible,
    required VoidCallback onTap,
    bool isSuccess = false,
    bool isRejected = false,
  }) {
    Color backgroundColor;
    if (!isAccessible) {
      backgroundColor = const Color(0xFFE5E8EB);
    } else if (isActive) {
      backgroundColor = const Color(0xFF0088FF);
    } else if (isCompleted) {
      if (isSuccess) {
        backgroundColor = const Color(0xFF34C759);
      } else if (isRejected) {
        backgroundColor = const Color(0xFFFF383C);
      } else {
        backgroundColor = const Color(0xFF34C759);
      }
    } else {
      backgroundColor = const Color(0xFFBDBDBD);
    }

    final textColor = !isAccessible
        ? const Color(0xFF9CA3AF)
        : (isActive ? const Color(0xFF0088FF) : const Color(0xFF9CA3AF));

    return GestureDetector(
      onTap: isAccessible ? onTap : () => _showNotAvailableSnackbar(title),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
              boxShadow: (isActive || isCompleted) && isAccessible
                  ? [
                      BoxShadow(
                        color: backgroundColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              icon,
              color: !isAccessible ? const Color(0xFFBDBDBD) : Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontFamily: 'Poppins',
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveContent() {
    final activeData = _timelineData[_activeTimeline]!;
    final isAccepted = widget.lamaran.status.toLowerCase() == 'accepted';
    final isRejected =
        widget.lamaran.status.toLowerCase() == 'reject_interview';

    // ✅ TAMBAHKAN: Cek status untuk menentukan teks yang tepat
    final currentStatus = widget.lamaran.status.toLowerCase();
    final isPending = currentStatus == 'pending';
    final isReviewed = currentStatus == 'reviewed';
    final isInterview = currentStatus == 'interview';

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E8EB), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      activeData['title'],
                      style: const TextStyle(
                        color: Color(0xFF191919),
                        fontSize: 20,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                      ),
                    ),
                    if (activeData['isCompleted'] ?? false)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: (activeData['isSuccess'] ?? false)
                              ? const Color(0xFF34C759).withOpacity(0.1)
                              : (activeData['isRejected'] ?? false)
                              ? const Color(0xFFFF383C).withOpacity(0.1)
                              : const Color(0xFF0088FF).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              // ✅ ICON BERBEDA BERDASARKAN STATUS
                              (activeData['isSuccess'] ?? false)
                                  ? Icons.check_circle_rounded
                                  : (activeData['isRejected'] ?? false)
                                  ? Icons.cancel_rounded
                                  : Icons.access_time_rounded,
                              color: (activeData['isSuccess'] ?? false)
                                  ? const Color(0xFF34C759)
                                  : (activeData['isRejected'] ?? false)
                                  ? const Color(0xFFFF383C)
                                  : const Color(0xFF0088FF),
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              // ✅ TEKS BERBEDA BERDASARKAN STATUS
                              (activeData['isSuccess'] ?? false)
                                  ? 'Diterima'
                                  : (activeData['isRejected'] ?? false)
                                  ? 'Ditolak'
                                  : _getStatusText(
                                      currentStatus,
                                      activeData['title'],
                                    ),
                              style: TextStyle(
                                color: (activeData['isSuccess'] ?? false)
                                    ? const Color(0xFF34C759)
                                    : (activeData['isRejected'] ?? false)
                                    ? const Color(0xFFFF383C)
                                    : const Color(0xFF0088FF),
                                fontSize: 11,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  activeData['description'],
                  style: TextStyle(
                    color: (activeData['isRejected'] ?? false)
                        ? const Color(0xFFFF383C)
                        : const Color(0xFF515151),
                    fontSize: 14,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          if (activeData['details'] != null)
            ..._buildDetailItems(activeData['details']),

          // ❌ DIHAPUS: Bagian QR Code untuk interview
          // if (_activeTimeline == 'interview' && widget.lamaran.hasInterviewData)
          //   _buildInterviewQRCode(),
          if (_activeTimeline == 'hasil')
            _buildFinalStatusInfo(isAccepted, isRejected),
        ],
      ),
    );
  }

  String _getStatusText(String currentStatus, String phaseTitle) {
    switch (currentStatus) {
      case 'pending':
        return 'Diproses';
      case 'reviewed':
        return 'Ditinjau';
      case 'interview':
        return 'Interview';
      case 'accepted':
        return 'Diterima';
      case 'reject_interview':
        return 'Ditolak';
      default:
        return 'Diproses';
    }
  }

  List<Widget> _buildDetailItems(List<dynamic> details) {
    return details.map<Widget>((detail) {
      return _buildDetailItem(
        icon: detail['icon'],
        title: detail['title'],
        value: detail['value'],
        isLink: detail['isLink'] ?? false,
      );
    }).toList();
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String value,
    bool isLink = false,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E8EB), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: const Color(0xFF6B7280)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF515151),
                    fontSize: 13,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                if (isLink)
                  GestureDetector(
                    onTap: () {
                      // Handle link tap
                    },
                    child: Text(
                      value,
                      style: const TextStyle(
                        color: Color(0xFF2345F7),
                        fontSize: 14,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )
                else
                  Text(
                    value,
                    style: const TextStyle(
                      color: Color(0xFF1A1A1A),
                      fontSize: 14,
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinalStatusInfo(bool isAccepted, bool isRejected) {
    // ✅ DIUBAH: Hanya tampilkan untuk status diterima saja
    if (isAccepted) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF34C759).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF34C759).withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.email_rounded,
                  color: const Color(0xFF34C759),
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  'Informasi Selanjutnya',
                  style: TextStyle(
                    color: const Color(0xFF1A1A1A),
                    fontSize: 14,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Tim HR akan menghubungi anda untuk proses selanjutnya. Pastikan email dan nomor telepon Anda aktif.',
              style: const TextStyle(
                color: Color(0xFF515151),
                fontSize: 13,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      );
    }

    // ✅ Untuk status ditolak, return widget kosong (tidak tampil apa-apa)
    return const SizedBox.shrink();
  }
}
