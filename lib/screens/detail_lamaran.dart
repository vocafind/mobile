import 'package:flutter/material.dart';
import 'package:jobfair/models/lamar_loker.dart';

class DetailLamaran extends StatefulWidget {
  final LamaranSaya lamaran;

  const DetailLamaran({super.key, required this.lamaran});

  static void show(
    BuildContext context, {
    required LamaranSaya lamaran,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DetailLamaran(lamaran: lamaran),
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
        _activeTimeline = 'accepted';
        break;
      case 'reject_interview':
        _activeTimeline = 'pending'; // Default untuk status ditolak
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
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return months[month - 1];
  }

  int _getTimelineOrder(String timelineKey) {
    final order = {'pending': 1, 'reviewed': 2, 'interview': 3, 'accepted': 4};
    return order[timelineKey] ?? 0;
  }

  int _getCurrentStatusOrder() {
    final statusOrder = {
      'pending': 1,
      'reviewed': 2,
      'interview': 3,
      'accepted': 4
    };
    return statusOrder[widget.lamaran.status.toLowerCase()] ?? 1;
  }

  bool _isTimelineAccessible(String timelineKey) {
    // Jika status ditolak, hanya bisa akses pending
    if (widget.lamaran.status.toLowerCase() == 'reject_interview') {
      return timelineKey == 'pending';
    }
    
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
                widget.lamaran.status.toLowerCase() == 'reject_interview'
                    ? 'Lamaran Anda telah ditolak. Tidak dapat mengakses fase $phaseName.'
                    : 'Fase $phaseName belum tersedia. Tunggu hingga proses sebelumnya selesai.',
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  // Data untuk setiap fase timeline - SESUAIKAN DENGAN STATUS MODEL
  Map<String, Map<String, dynamic>> get _timelineData {
    final currentStatus = widget.lamaran.status.toLowerCase();
    final isRejected = currentStatus == 'reject_interview';

    return {
      'pending': {
        'title': 'Pending',
        'icon': Icons.access_time_rounded,
        'isCompleted': currentStatus == 'pending' || 
                       currentStatus == 'reviewed' || 
                       currentStatus == 'interview' || 
                       currentStatus == 'accepted' ||
                       isRejected,
        'description': isRejected 
            ? 'Lamaran Anda telah ditolak setelah proses review'
            : 'Lamaran Anda sedang dalam antrian',
        'details': [
          {
            'icon': Icons.schedule_rounded,
            'title': 'Waktu Submit',
            'value': '${_formatDate(widget.lamaran.appliedAt)}, ${_formatTime(widget.lamaran.appliedAt)}',
          },
          {
            'icon': Icons.info_rounded,
            'title': 'Status',
            'value': isRejected ? 'Ditolak setelah review' : 'Menunggu review dari HR',
          },
        ],
      },
      'reviewed': {
        'title': 'Ditinjau',
        'icon': Icons.remove_red_eye_rounded,
        'isCompleted': currentStatus == 'reviewed' || 
                       currentStatus == 'interview' || 
                       currentStatus == 'accepted' ||
                       isRejected,
        'description': isRejected 
            ? 'Tim HR telah meninjau lamaran Anda'
            : 'Tim HR sedang meninjau lamaran Anda',
        'details': [
          {
            'icon': Icons.schedule_rounded,
            'title': 'Waktu Direview',
            'value': '${_formatDate(widget.lamaran.createdAt)}',
          },
          {
            'icon': Icons.info_rounded,
            'title': 'Hasil Review',
            'value': isRejected ? 'Tidak memenuhi kualifikasi' : 'Kualifikasi memenuhi syarat',
          },
        ],
      },
      'interview': {
        'title': 'Interview',
        'icon': Icons.people_rounded,
        'isCompleted': currentStatus == 'interview' || 
                       currentStatus == 'accepted',
        'description': 'Anda dijadwalkan untuk wawancara',
        'details': [
          {
            'icon': Icons.calendar_today_rounded,
            'title': 'Tanggal Interview',
            'value': '20 Januari 2024',
          },
          {
            'icon': Icons.access_time_rounded,
            'title': 'Waktu',
            'value': '10:00 - 11:00 WIB',
          },
          {
            'icon': Icons.video_call_rounded,
            'title': 'Platform',
            'value': 'Google Meet',
          },
          {
            'icon': Icons.link_rounded,
            'title': 'Link Meeting',
            'value': 'meet.google.com/abc-defg-hij',
            'isLink': true,
          },
          {
            'icon': Icons.person_rounded,
            'title': 'Interviewer',
            'value': 'Sarah Johnson & Team Lead',
          },
        ],
      },
      'accepted': {
        'title': 'Hasil',
        'icon': Icons.check_circle_rounded,
        'isCompleted': currentStatus == 'accepted',
        'isSuccess': true,
        'description': 'Selamat! Lamaran Anda diterima',
        'details': [
          {
            'icon': Icons.celebration_rounded,
            'title': 'Tanggal Diterima',
            'value': '25 Januari 2024',
          },
          {
            'icon': Icons.work_rounded,
            'title': 'Posisi',
            'value': widget.lamaran.lowongan.posisi,
          },
          {
            'icon': Icons.business_rounded,
            'title': 'Departemen',
            'value': 'Engineering Team',
          },
          {
            'icon': Icons.calendar_today_rounded,
            'title': 'Tanggal Mulai',
            'value': '1 Februari 2024',
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
    final isRejected = widget.lamaran.status.toLowerCase() == 'reject_interview';

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
                      child: widget.lamaran.lowongan.company.logo.startsWith('http')
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
                    child: Row(
                      children: [
                        Icon(
                          Icons.cancel_rounded,
                          color: const Color(0xFFFF383C),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Lamaran Anda telah ditolak setelah proses review',
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
      _timelineData['accepted']!,
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

              return _buildTimelineStep(
                title: step['title'],
                icon: step['icon'],
                isActive: isActive,
                isCompleted: isCompleted,
                isAccessible: isAccessible,
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
  }) {
    // Warna untuk timeline yang tidak bisa diakses
    final backgroundColor = !isAccessible
        ? const Color(0xFFE5E8EB) // Abu-abu untuk yang tidak bisa diakses
        : (isActive
            ? const Color(0xFF0088FF) // Biru untuk aktif
            : (isCompleted 
                ? const Color(0xFF34C759) // Hijau untuk selesai
                : const Color(0xFFBDBDBD))); // Abu-abu untuk belum selesai

    final textColor = !isAccessible
        ? const Color(0xFF9CA3AF) // Abu-abu untuk text yang tidak bisa diakses
        : (isActive
            ? const Color(0xFF0088FF)
            : const Color(0xFF9CA3AF));

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
              size: 24
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
                          color: const Color(0xFF34C759).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              color: const Color(0xFF34C759),
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'Selesai',
                              style: TextStyle(
                                color: Color(0xFF34C759),
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
                  style: const TextStyle(
                    color: Color(0xFF515151),
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

          if (_activeTimeline == 'interview') _buildInterviewQRCode(),

          if (_activeTimeline == 'accepted') _buildEmailConfirmation(),
        ],
      ),
    );
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

  Widget _buildInterviewQRCode() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF2643D7).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.qr_code_2_rounded, color: Color(0xFF2643D7), size: 20),
              SizedBox(width: 8),
              Text(
                'QR Code untuk Check-in',
                style: TextStyle(
                  color: Color(0xFF1A1A1A),
                  fontSize: 15,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E8EB)),
            ),
            child: Column(
              children: [
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.qr_code_2_rounded,
                    size: 120,
                    color: Colors.grey[300],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF162781).withOpacity(0.05),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    widget.lamaran.applyId,
                    style: const TextStyle(
                      color: Color(0xFF162781),
                      fontSize: 13,
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Tunjukkan QR code ini saat check-in interview',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 12,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 12),
                      Text('QR Code berhasil diunduh'),
                    ],
                  ),
                  backgroundColor: const Color(0xFF34C759),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF2643D7).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF2643D7).withOpacity(0.3),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.download_rounded,
                    color: Color(0xFF2643D7),
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Unduh QR Code',
                    style: TextStyle(
                      color: Color(0xFF2643D7),
                      fontSize: 14,
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w600,
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

  Widget _buildEmailConfirmation() {
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
              const Text(
                'Email Konfirmasi',
                style: TextStyle(
                  color: Color(0xFF1A1A1A),
                  fontSize: 14,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Email konfirmasi dan detail kontrak telah dikirim ke email Anda. Silakan periksa inbox Anda.',
            style: TextStyle(
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
}