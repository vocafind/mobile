import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileHeader extends StatelessWidget {
  final TabController tabController;

  const ProfileHeader({
    super.key,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1B56FD), Color(0xFF0118D8)],
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(23, 13, 23, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Danu Yudistia',
                          style: TextStyle(
                            color: Color(0xFFFFF8F8),
                            fontSize: 36,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        const Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Color(0xFFFFF8F8),
                              size: 14,
                            ),
                            SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                'Batam , Kepulauan Riau',
                                style: TextStyle(
                                  color: Color(0xFFFFF8F8),
                                  fontSize: 14,
                                  fontFamily: 'SF Pro',
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, -10), // (x, y) → negatif Y artinya ke atas
                     child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(

                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0), // biar SVG-nya gak mepet
                      child: SvgPicture.asset(
                        'assets/icons/setting.svg',
                        colorFilter: const ColorFilter.mode(
                          Color(0xFFFFF8F8),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TabBar(
              controller: tabController,
              isScrollable: true,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: EdgeInsets.zero,
              dividerColor: Colors.transparent,
              labelColor: const Color(0xFFFFF8F8),
              unselectedLabelColor: const Color(0xFFFFF8F8).withValues(alpha:0.7),
              labelStyle: const TextStyle(
                fontSize: 16,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 16,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w400,
              ),
              tabAlignment: TabAlignment.start,
              padding: const EdgeInsets.symmetric(horizontal: 23),
              tabs: const [
                Tab(text: 'Profil'),
                Tab(text: 'Akademik'),
                Tab(text: 'Kompetensi'),
                Tab(text: 'Pengalaman'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
