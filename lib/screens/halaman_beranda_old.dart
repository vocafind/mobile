import 'package:flutter/material.dart';
import '/widget/bottom_navbar.dart';
import 'halaman_notifikasi.dart';
import 'halaman_bookmark.dart'; // Import halaman bookmark

class HalamanBeranda extends StatefulWidget {
  const HalamanBeranda({super.key});

  @override
  State<HalamanBeranda> createState() => _HalamanBerandaState();
}

class _HalamanBerandaState extends State<HalamanBeranda> {
  final ScrollController _scrollController = ScrollController();

  // ✅ ValueNotifier untuk scroll offset (tidak rebuild seluruh widget)
  final ValueNotifier<double> _scrollOffset = ValueNotifier<double>(0.0);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  // ✅ Update ValueNotifier, bukan setState
  void _onScroll() {
    _scrollOffset.value = _scrollController.offset;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _scrollOffset.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Stack(
        children: [
          // ✅ RepaintBoundary untuk isolasi scroll content
          RepaintBoundary(
            child: SingleChildScrollView(
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
                  children: const [
                    SizedBox(height: 220),
                    _CocokUntukKamuSection(),
                    SizedBox(height: 50),
                    AyoTemuiMerekaSection(),
                    SizedBox(height: 60),
                    _JobFairSection(),
                    SizedBox(height: 60),
                    _KesepatanSegeraSection(),
                    SizedBox(height: 0),
                  ],
                ),
              ),
            ),
          ),

          // ✅ Header dengan ValueListenableBuilder (hanya rebuild header)
          ValueListenableBuilder<double>(
            valueListenable: _scrollOffset,
            builder: (context, offset, child) {
              final bool showSearchOnly = offset > 100;
              final double headerHeight = showSearchOnly
                  ? topPadding + 25 + 50 + 16
                  : topPadding + 12 + 120 + 44 + 30;

              return Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: headerHeight,
                child: _AnimatedHeader(
                  showSearchOnly: showSearchOnly,
                  topPadding: topPadding,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ✅ Extract Header sebagai widget terpisah (MODIFIED)
class _AnimatedHeader extends StatelessWidget {
  final bool showSearchOnly;
  final double topPadding;

  const _AnimatedHeader({
    required this.showSearchOnly,
    required this.topPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                ),
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
              // ✅ Gunakan Visibility untuk hide/show
              Visibility(
                visible: !showSearchOnly,
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
                          Icon(Icons.search, color: Colors.white, size: 20),
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

                  // ✅ TAMBAHKAN ICON BOOKMARK DI SAMPING NOTIFICATION
                  Row(
                    children: [
                      // Bookmark Icon
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HalamanBookmark(),
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
                            Icons.bookmark_border,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Notification Icon
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationPage(),
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
            ],
          ),
        ),
      ),
    );
  }
}

// ✅ Extract section sebagai StatelessWidget
class _CocokUntukKamuSection extends StatelessWidget {
  const _CocokUntukKamuSection();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 610,
      child: Stack(
        children: [
          // ✅ Positioned.fill di luar, RepaintBoundary di dalam
          Positioned.fill(
            child: RepaintBoundary(
              child: ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white,
                      Colors.white,
                      Colors.white,
                      Colors.white.withValues(alpha: 0.5),
                      Colors.white.withValues(alpha: 0.0),
                    ],
                    stops: const [0.0, 0.0, 0.7, 0.85, 1.0],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.dstIn,
                child: Image.asset(
                  'assets/images/iphone14bg.jpg',
                  fit: BoxFit.cover,
                ),
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
                    itemExtent: 354,
                    itemBuilder: (context, index) {
                      return const _CocokUntukKamuCard();
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
}

// Widget untuk bagian "Ayo Temui Mereka" dengan auto-scroll looping
class AyoTemuiMerekaSection extends StatefulWidget {
  const AyoTemuiMerekaSection({super.key});

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

        await _scrollController.animateTo(
          maxScroll,
          duration: const Duration(seconds: 10),
          curve: Curves.linear,
        );

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
        // ✅ RepaintBoundary untuk isolasi animasi scroll
        RepaintBoundary(
          child: GestureDetector(
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 28,
                ),
                itemCount: 15,
                // ✅ Tambahkan itemExtent
                itemExtent: 97, // 62 width + 35 padding
                itemBuilder: (context, index) {
                  return const _CompanyLogo();
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ✅ Extract logo sebagai widget terpisah dengan const
class _CompanyLogo extends StatelessWidget {
  const _CompanyLogo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 62,
      height: 56,
      child: Image.asset(
        'assets/icons/poltek.png',
        width: 62,
        height: 56,
        fit: BoxFit.contain,
        // ✅ Cache image
        cacheWidth: 124, // 2x untuk retina
        cacheHeight: 112,
      ),
    );
  }
}

class _JobFairSection extends StatelessWidget {
  const _JobFairSection();

  static const List<String> backgrounds = [
    'assets/images/biru.png',
    'assets/images/kuning.png',
    'assets/images/pink.png',
  ];

  @override
  Widget build(BuildContext context) {
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
            // ✅ Tambahkan itemExtent
            itemExtent: 354, // 338 width + 16 padding
            itemBuilder: (context, index) {
              return _JobFairCard(backgroundImage: backgrounds[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _KesepatanSegeraSection extends StatelessWidget {
  const _KesepatanSegeraSection();

  @override
  Widget build(BuildContext context) {
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
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Container(
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
                      // ✅ Cache image
                      cacheWidth: 676,
                      cacheHeight: 472,
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
                          cacheWidth: 56,
                          cacheHeight: 56,
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
      ),
    );
  }
}

class _JobFairCard extends StatelessWidget {
  final String backgroundImage;

  const _JobFairCard({required this.backgroundImage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Container(
        width: 338,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(34),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                  SizedBox(height: 4),
                  Text(
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
                      backgroundImage,
                      fit: BoxFit.cover,
                      cacheWidth: 676,
                      cacheHeight: 472,
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
                          horizontal: 16,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(45),
                          border: Border.all(
                            color: const Color(
                              0xFFF3F6F9,
                            ).withValues(alpha: 0.4),
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
                          horizontal: 16,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(45),
                          border: Border.all(
                            color: const Color(
                              0xFFF3F6F9,
                            ).withValues(alpha: 0.4),
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
                const Positioned(
                  left: 24,
                  bottom: 110,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 14,
                          ),
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
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Colors.white,
                            size: 12,
                          ),
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
                      SizedBox(height: 8),
                      Text(
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
      ),
    );
  }
}

class _UrgentJobCard extends StatefulWidget {
  const _UrgentJobCard();

  @override
  State<_UrgentJobCard> createState() => _UrgentJobCardState();
}

class _UrgentJobCardState extends State<_UrgentJobCard>
    with SingleTickerProviderStateMixin {
  bool isSaved = false;
  late AnimationController _bookmarkController;
  late Animation<double> _bookmarkScale;

  @override
  void initState() {
    super.initState();
    isSaved = false; // Default tidak disimpan
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

  // ✅ TAG TANPA ICON - SAMA DENGAN HALAMAN CARI LOKER
  Widget _buildTag(String text, {Color? backgroundColor, Color? textColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: backgroundColor != null
              ? Colors.transparent
              : Colors.grey.shade200,
        ),
      ),
      child: Text(
        text.length > 15 ? '${text.substring(0, 15)}...' : text,
        style: TextStyle(
          color: textColor ?? Colors.grey.shade700,
          fontSize: 12,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        height: 220, // ✅ SAMA DENGAN HALAMAN CARI LOKER
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // ✅ URGENT BADGE - SAMA DENGAN HALAMAN CARI LOKER
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: 130,
                height: 28,
                decoration: const BoxDecoration(
                  color: Color(0xFF0E37EB),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.bolt, color: Color(0xFFFFCC00), size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '5 hari lagi', // Contoh hari tersisa
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Company Logo
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.asset(
                          'assets/icons/poltek.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Job Info
                      Expanded(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 200),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Fulltime Backend Developer', // Contoh data
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Inforsys Indonesia', // Contoh data
                                style: const TextStyle(
                                  color: Color(0xFF666666),
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Bookmark Button
                      GestureDetector(
                        onTap: _toggleBookmark,
                        child: ScaleTransition(
                          scale: _bookmarkScale,
                          child: SizedBox(
                            width: 32,
                            height: 32,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: isSaved
                                  ? const Icon(
                                      Icons.bookmark,
                                      key: ValueKey('saved'),
                                      color: Color(0xFF0E37EB),
                                      size: 24,
                                    )
                                  : Icon(
                                      Icons.bookmark_border,
                                      key: const ValueKey('unsaved'),
                                      color: Colors.black.withValues(alpha:0.3),
                                      size: 24,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Salary
                  Text(
                    'Rp 9.000.000', // Contoh data
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ✅ TAGS - SAMA DENGAN HALAMAN CARI LOKER
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildTag('Batam Kota'), // Contoh data

                      _buildTag('Full-time'), // Contoh data

                      _buildTag('Remote'),
                    ],
                  ),

                  const Spacer(),

                  // Footer info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatTimeAgo(
                          DateTime.now().subtract(const Duration(days: 1)),
                        ), // Contoh data
                        style: const TextStyle(
                          color: Color(0xFF999999),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      Text(
                        '50 pelamar', // Contoh data
                        style: const TextStyle(
                          color: Color(0xFF999999),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime tanggal) {
    final now = DateTime.now();
    final difference = now.difference(tanggal);

    if (difference.inDays == 0) {
      return 'Hari ini';
    } else if (difference.inDays == 1) {
      return '1 hari lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari lalu';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks minggu lalu';
    } else {
      final months = (difference.inDays / 30).floor();
      return '$months bulan lalu';
    }
  }
}
