import 'package:flutter/material.dart';
import '/widget/bottom_navbar.dart';
import 'halaman_notifikasi.dart';
import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';

class HalamanBeranda extends StatefulWidget {
  const HalamanBeranda({super.key});

  @override
  State<HalamanBeranda> createState() => _HalamanBerandaState();
}

class _HalamanBerandaState extends State<HalamanBeranda> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool showSearchOnly = _scrollOffset > 100;
    final double topPadding = MediaQuery.of(context).padding.top;
    
    final double headerHeight = showSearchOnly 
        ? topPadding + 25 + 50 + 16
        : topPadding + 12 + 120 + 44 + 30;

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/frame15.jpg'),
                  fit: BoxFit.cover,
                   alignment: Alignment(0, -0.9),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 220),
                  _buildCocokUntukKamuSection(),
                  const SizedBox(height: 50),
                  const AyoTemuiMerekaSection(), // Widget baru dengan animasi
                  const SizedBox(height: 60),
                  _buildJobFairSection(),
                  const SizedBox(height: 60),
                  _buildKesepatanSegeraSection(),
                  const SizedBox(height: 0),
                ],
              ),
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: headerHeight,
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topRight,
                  colors: [Color(0xFF0118D8), Color(0xFF1B56FD)],
                ),
                boxShadow: showSearchOnly
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                      ]
                    : null,
              ),
              child: SafeArea(
                bottom: false,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: showSearchOnly ? 12 : 16,
                    bottom: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedOpacity(
                        opacity: showSearchOnly ? 0.0 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: showSearchOnly ? 0 : null,
                          child: const Padding(
                            padding: EdgeInsets.only(bottom: 24),
                            child: Text(
                              'Hai! Aku siap bantu cari pekerjaan terbaik buat kamu.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                height: 1.15,
                              ),
                            ),
                          ),
                        ),
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Row(
                                children: [
                                  SizedBox(width: 20),
                                  Icon(Icons.search,
                                      color: Colors.white, size: 20),
                                  SizedBox(width: 12),
                                  Text(
                                    'Cari lowongan kerja...',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationPage(),
                                ),
                              );
                            },
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.notifications_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomNavBar(currentIndex: 0),
          ),
        ],
      ),
    );
  }

  Widget _buildCocokUntukKamuSection() {
    return Container(
      margin: const EdgeInsets.only(top: 0),
      height: 620,
      child: Stack(
        children: [
          Positioned.fill(
            child: ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white,
                    Colors.white, 
                    Colors.white, 
                    Colors.white, 
                    Colors.white.withOpacity(0.5),
                    Colors.white.withOpacity(0.0),
                  ],
                  stops: const [0.0,0.0,0.4, 0.7, 0.85, 1.0],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: Image.asset(
                'assets/images/iphone14bg.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Cocok untuk kamu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 20, bottom: 5),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return const Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: _CocokUntukKamuCard(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobFairSection() {
  final List<String> backgrounds = [
    'assets/images/biru.png',
    'assets/images/kuning.png',
    'assets/images/pink.png',
  ];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          'Jelajahi Kesempatan Karier',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      const SizedBox(height: 16),
      SizedBox(
        height: 335,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(left: 20, bottom: 5),
          itemCount: 3,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(right: 16),
              child: _JobFairCard(backgroundImage: backgrounds[index]),
            );
          },
        ),
      ),
    ],
  );
}

  Widget _buildKesepatanSegeraSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA).withValues(alpha: 0.8),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(34),
          topRight: Radius.circular(34),
        ),
      ),
      padding: const EdgeInsets.only(top: 31, bottom: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 23),
            child: Text(
              'Kesempatan Segera!',
              style: TextStyle(
                color: Colors.black,
                fontSize: 26,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 24),
          _UrgentJobCard(),
          SizedBox(height: 15),
          _UrgentJobCard(),
          SizedBox(height: 15),
          _UrgentJobCard(),
        ],
      ),
    );
  }
}

// Widget untuk bagian "Ayo Temui Mereka" dengan auto-scroll looping
class AyoTemuiMerekaSection extends StatefulWidget {
  const AyoTemuiMerekaSection({Key? key}) : super(key: key);

  @override
  State<AyoTemuiMerekaSection> createState() => _AyoTemuiMerekaSectionState();
}

class _AyoTemuiMerekaSectionState extends State<AyoTemuiMerekaSection> {
  late ScrollController _scrollController;
  bool _isAutoScrolling = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _startAutoScroll();
  }

  void _startAutoScroll() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    while (mounted && _isAutoScrolling) {
      if (_scrollController.hasClients) {
        final maxScroll = _scrollController.position.maxScrollExtent;
        
        // Scroll ke kanan sampai akhir
        await _scrollController.animateTo(
          maxScroll,
          duration: const Duration(seconds: 10),
          curve: Curves.linear,
        );
        
        // Instant jump ke awal tanpa animasi
        if (mounted && _isAutoScrolling) {
          _scrollController.jumpTo(0);
          await Future.delayed(const Duration(milliseconds: 100));
        }
      } else {
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }
  }

  @override
  void dispose() {
    _isAutoScrolling = false;
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Ayo Temui Mereka',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onHorizontalDragStart: (_) {
            setState(() {
              _isAutoScrolling = false;
            });
          },
          onHorizontalDragEnd: (_) {
            setState(() {
              _isAutoScrolling = true;
              _startAutoScroll();
            });
          },
          child: Container(
            height: 113,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(34),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
              itemCount: 15, // Lebih banyak item untuk looping smooth
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(right: index < 14 ? 35 : 0),
                  child: Container(
                    width: 62,
                    height: 56,
                    child: Center(
                      child: Image.asset(
                        'assets/icons/poltek.png',
                        width: 62,
                        height: 56,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

// Card untuk "Cocok untuk kamu" dengan animasi bookmark
class _CocokUntukKamuCard extends StatefulWidget {
  const _CocokUntukKamuCard();

  @override
  State<_CocokUntukKamuCard> createState() => _CocokUntukKamuCardState();
}

class _CocokUntukKamuCardState extends State<_CocokUntukKamuCard> {
  bool isSaved = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 338,
      height: 410,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(34),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(34),
                  topRight: Radius.circular(34),
                ),
                child: Container(
                  width: 338,
                  height: 236,
                  color: const Color(0xFFE8F0FE),
                  child: Image.asset(
                    'assets/images/job.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                top: 22,
                child: Container(
                  width: 153,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(22),
                      bottomLeft: Radius.circular(22),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Kecocokan 76 %',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Fulltime Backend Develop...',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Kota Batam',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Rp. 9.000.000',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 0.5,
                  color: Colors.black.withValues(alpha: 0.36),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.asset(
                        'assets/icons/poltek.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Perusahaan',
                            style: TextStyle(
                              color: Colors.black.withValues(alpha: 0.6),
                              fontSize: 11,
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Text(
                            'Inforsys Indonesia',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _JobFairCard extends StatelessWidget {
  final String backgroundImage;
  
  const _JobFairCard({required this.backgroundImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 338,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(34),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Tech Career Expo 2025',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '3 hari lagi',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Politeknik Negeri Batam',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(34),
                  bottomRight: Radius.circular(34),
                ),
                child: Container(
                  width: 338,
                  height: 236,
                  color: const Color(0xFFE8F0FE),
                  child: Image.asset(
                    backgroundImage, // Menggunakan background dinamis
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                width: 338,
                height: 236,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.1),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(34),
                    bottomRight: Radius.circular(34),
                  ),
                ),
              ),
              Positioned(
                left: 24,
                top: 24,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(45),
                        border: Border.all(
                          color:
                              const Color(0xFFF3F6F9).withValues(alpha: 0.4),
                        ),
                      ),
                      child: const Text(
                        '10 Lowongan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(45),
                        border: Border.all(
                          color:
                              const Color(0xFFF3F6F9).withValues(alpha: 0.4),
                        ),
                      ),
                      child: const Text(
                        '3 Perusahaan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 24,
                bottom: 110,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.location_on, color: Colors.white, size: 14),
                        SizedBox(width: 4),
                        Text(
                          'Batam Kota',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: const [
                        Icon(Icons.calendar_today,
                            color: Colors.white, size: 12),
                        SizedBox(width: 6),
                        Text(
                          '19 Sep 2025 - 20 Sep 2025',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Pendaftaran : 7 Sep 2025 - 19 Sep 2025',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 24,
                right: 24,
                bottom: 14,
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(45),
                    border: Border.all(
                      color: const Color(0xFFF3F6F9).withValues(alpha: 0.4),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Daftar Sekarang',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Card untuk Kesempatan Segera dengan animasi swipe dan bookmark
class _UrgentJobCard extends StatefulWidget {
  const _UrgentJobCard();

  @override
  State<_UrgentJobCard> createState() => _UrgentJobCardState();
}

class _UrgentJobCardState extends State<_UrgentJobCard> with SingleTickerProviderStateMixin {
  bool isSaved = false;
  double _dragOffset = 0;
  bool _isDismissed = false;
  late AnimationController _bookmarkController;
  late Animation<double> _bookmarkScale;

  @override
  void initState() {
    super.initState();
    _bookmarkController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _bookmarkScale = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _bookmarkController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _bookmarkController.dispose();
    super.dispose();
  }

  void _toggleBookmark() {
    setState(() {
      isSaved = !isSaved;
    });
    _bookmarkController.forward().then((_) {
      _bookmarkController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isDismissed) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: [
          // Background delete indicator
          if (_dragOffset < -10)
            Container(
              height: 306,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 30),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(34),
              ),
              child: const Icon(
                Icons.delete_outline,
                color: Colors.red,
                size: 28,
              ),
            ),
          
          // Main card with swipe gesture
          GestureDetector(
            onHorizontalDragUpdate: (details) {
              setState(() {
                _dragOffset += details.delta.dx;
                _dragOffset = _dragOffset.clamp(-100.0, 0.0);
              });
            },
            onHorizontalDragEnd: (details) {
              if (_dragOffset < -50) {
                setState(() {
                  _dragOffset = -MediaQuery.of(context).size.width;
                });
                Future.delayed(const Duration(milliseconds: 300), () {
                  setState(() {
                    _isDismissed = true;
                  });
                });
              } else {
                setState(() {
                  _dragOffset = 0;
                });
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              transform: Matrix4.translationValues(_dragOffset, 0, 0),
              width: double.infinity,
              height: 306,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(34),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Urgent badge
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      width: 220,
                      height: 29,
                      decoration: const BoxDecoration(
                        color: Color(0xFF0E37EB),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(34),
                          bottomRight: Radius.circular(90),
                        ),
                      ),
                      child: Row(
                        children: const [
                          SizedBox(width: 16),
                          Icon(Icons.bolt, 
                            color: Color(0xFFFFCC00), 
                            size: 18
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Dibutuhkan segera',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Company logo
                  Positioned(
                    left: 16,
                    top: 47,
                    child: Container(
                      width: 40,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.asset(
                        'assets/icons/poltek.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  // Job title and company
                  Positioned(
                    left: 66,
                    top: 47,
                    right: 66,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Fulltime Backend Developer',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Inforsys Indonesia',
                          style: TextStyle(
                            color: Color(0x993C3C43),
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Bookmark icon with animation
                  Positioned(
                    right: 16,
                    top: 47,
                    child: GestureDetector(
                      onTap: _toggleBookmark,
                      child: ScaleTransition(
                        scale: _bookmarkScale,
                        child: Container(
                          width: 32,
                          height: 32,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            transitionBuilder: (child, animation) {
                              return ScaleTransition(
                                scale: animation,
                                child: child,
                              );
                            },
                            child: isSaved
                                ? const Icon(
                                    Icons.bookmark,
                                    key: ValueKey('saved'),
                                    color: Color(0xFF0E37EB),
                                    size: 28,
                                  )
                                : Icon(
                                    Icons.bookmark_border,
                                    key: const ValueKey('unsaved'),
                                    color: Colors.black.withValues(alpha: 0.5),
                                    size: 28,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Description
                  Positioned(
                    left: 16,
                    top: 125,
                    right: 16,
                    child: const Text(
                      'Bertanggung jawab dalam  mengelola, dan mengoptimal siste . . .',
                      style: TextStyle(
                        color: Color(0xFF404040),
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w300,
                        height: 1,
                      ),
                    ),
                  ),
                  // Salary
                  Positioned(
                    left: 16,
                    top: 172,
                    child: RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Rp',
                            style: TextStyle(
                              color: Color(0xFF40403F),
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: ' 9.000.000 - ',
                            style: TextStyle(
                              color: Color(0xFF40403F),
                              fontSize: 18,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: 'Rp',
                            style: TextStyle(
                              color: Color(0xFF40403F),
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: ' 12.000.000',
                            style: TextStyle(
                              color: Color(0xFF40403F),
                              fontSize: 18,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Tags
                  Positioned(
                    left: 16,
                    top: 210,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12, 
                            vertical: 2
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                                color: Colors.black.withValues(alpha: 0.06)),
                          ),
                          child: const Text(
                            'Batam Kota, Kepulauan Riau',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12, 
                            vertical: 2
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                                color: Colors.black.withValues(alpha: 0.06)),
                          ),
                          child: const Text(
                            'Remote',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Time ago
                  Positioned(
                    right: 16,
                    bottom: 18,
                    child: const Text(
                      '1 hari lalu',
                      style: TextStyle(
                        color: Color(0xFF464E5E),
                        fontSize: 12,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w400,
                      ),
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