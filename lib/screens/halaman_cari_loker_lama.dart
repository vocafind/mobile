// import 'package:flutter/material.dart';
// import 'package:jobfair/widget/bottom_navbar.dart';
// import 'package:jobfair/widget/header.dart';
// import 'detail_job_sheet.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class HalamanCariLoker extends StatefulWidget {
//   const HalamanCariLoker({super.key});

//   @override
//   State<HalamanCariLoker> createState() => _HalamanCariLokerState();
// }

// class _HalamanCariLokerState extends State<HalamanCariLoker> {
//   final ScrollController _scrollController = ScrollController();
  
//   // ✅ ValueNotifier untuk state management efisien
//   final ValueNotifier<int> _selectedTab = ValueNotifier<int>(0);
//   final ValueNotifier<int> _currentPage = ValueNotifier<int>(0);

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     _selectedTab.dispose();
//     _currentPage.dispose();
//     super.dispose();
//   }

//   void _onTabChanged(int index) {
//     _selectedTab.value = index;
//     _currentPage.value = 0;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBody: true,
//       body: Container(
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage('assets/images/fullip.jpg'),
//             fit: BoxFit.cover,
//             alignment: Alignment(0, -0.9),
//           ),
//         ),
//         child: Column(
//           children: [
//             // Fixed Header
//             const HeaderWidget(
//               showNotification: true,
//               showFilter: false,
//             ),

//             // ✅ Fixed Filter Tabs dengan ValueListenableBuilder
//             ValueListenableBuilder<int>(
//               valueListenable: _selectedTab,
//               builder: (context, selectedTab, child) {
//                 return _FilterTabs(
//                   selectedTab: selectedTab,
//                   onTabChanged: _onTabChanged,
//                 );
//               },
//             ),

//             // ✅ Main content dengan ValueListenableBuilder
//             Expanded(
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFFAFAFA).withValues(alpha: 0.95),
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(37),
//                     topRight: Radius.circular(37),
//                   ),
//                 ),
//                 child: ClipRRect(
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(37),
//                     topRight: Radius.circular(37),
//                   ),
//                   child: ValueListenableBuilder<int>(
//                     valueListenable: _selectedTab,
//                     builder: (context, selectedTab, child) {
//                       return SingleChildScrollView(
//                         controller: _scrollController,
//                         child: Column(
//                           children: [
//                             const SizedBox(height: 17),
//                             _LowonganList(isAI: selectedTab == 1),
//                             const SizedBox(height: 24),
//                             ValueListenableBuilder<int>(
//                               valueListenable: _currentPage,
//                               builder: (context, currentPage, child) {
//                                 return EnhancedPagination(
//                                   currentPage: currentPage,
//                                   totalPages: 4,
//                                   onPageChanged: (page) {
//                                     _currentPage.value = page;
//                                     _scrollController.animateTo(
//                                       0,
//                                       duration: const Duration(milliseconds: 300),
//                                       curve: Curves.easeOut,
//                                     );
//                                   },
//                                 );
//                               },
//                             ),
//                             const SizedBox(height: 100),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: const BottomNavBar(currentIndex: 1),
//     );
//   }
// }

// // ✅ Extract Filter Tabs sebagai StatelessWidget
// class _FilterTabs extends StatelessWidget {
//   final int selectedTab;
//   final Function(int) onTabChanged;

//   const _FilterTabs({
//     required this.selectedTab,
//     required this.onTabChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//       child: Row(
//         children: [
//           Expanded(
//             child: Container(
//               height: 45,
//               decoration: BoxDecoration(
//                 color: const Color(0xFF162781).withValues(alpha: 0.9),
//                 borderRadius: BorderRadius.circular(50),
//               ),
//               child: Row(
//                 children: [
//                   const SizedBox(width: 6),
//                   // ✅ Semua tab
//                   _TabButton(
//                     label: 'Semua',
//                     isSelected: selectedTab == 0,
//                     onTap: () => onTabChanged(0),
//                     width: 136,
//                   ),
//                   const SizedBox(width: 10),
//                   // ✅ Rekomendasi AI tab
//                   _TabButton(
//                     label: 'Rekomendasi AI',
//                     isSelected: selectedTab == 1,
//                     onTap: () => onTabChanged(1),
//                     isFlexible: true,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(width: 5),
//           // Filter button
//           Container(
//             width: 45,
//             height: 45,
//             decoration: BoxDecoration(
//               color: const Color(0xFF162781).withValues(alpha: 0.9),
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(
//               Icons.tune,
//               color: Colors.white,
//               size: 18,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ✅ Extract Tab Button untuk reusability
// class _TabButton extends StatelessWidget {
//   final String label;
//   final bool isSelected;
//   final VoidCallback onTap;
//   final double? width;
//   final bool isFlexible;

//   const _TabButton({
//     required this.label,
//     required this.isSelected,
//     required this.onTap,
//     this.width,
//     this.isFlexible = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final widget = GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//         width: width,
//         height: 35,
//         padding: isFlexible 
//             ? const EdgeInsets.symmetric(horizontal: 16) 
//             : null,
//         decoration: BoxDecoration(
//           color: isSelected
//               ? const Color(0xFF2345F7).withValues(alpha: 0.7)
//               : Colors.transparent,
//           borderRadius: BorderRadius.circular(100),
//         ),
//         child: Center(
//           child: Text(
//             label,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 14,
//               fontFamily: 'Poppins',
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ),
//       ),
//     );

//     return isFlexible ? Expanded(child: widget) : widget;
//   }
// }

// // ✅ Extract Lowongan List
// class _LowonganList extends StatelessWidget {
//   final bool isAI;

//   const _LowonganList({required this.isAI});

//   @override
//   Widget build(BuildContext context) {
//     return const Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         children: [
//           _JobCard(isUrgent: true),
//           SizedBox(height: 16),
//           _JobCard(isUrgent: true),
//           SizedBox(height: 16),
//           _JobCard(isUrgent: false),
//           SizedBox(height: 16),
//           _JobCard(isUrgent: false),
//         ],
//       ),
//     );
//   }
// }

// // ✅ Optimized Job Card dengan RepaintBoundary
// class _JobCard extends StatelessWidget {
//   final bool isUrgent;

//   const _JobCard({this.isUrgent = false});

//   @override
//   Widget build(BuildContext context) {
//     return RepaintBoundary(
//       child: GestureDetector(
//         onTap: () {
//           showJobDetail(context);
//         },
//         child: Container(
//           width: double.infinity,
//           height: 320,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(34),
//             // ✅ Reduced shadow complexity
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withValues(alpha: 0.03),
//                 blurRadius: 6,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: Stack(
//             children: [
//               // ✅ Urgent badge dengan conditional rendering
//               if (isUrgent) ...[
//                 const _UrgentBadge(),
//                 const _BoltIcon(),
//               ],

//               // ✅ Logo box
//               const _CompanyLogo(),

//               // ✅ Job info
//               const _JobTitle(),
//               const _CompanyName(),
//               const _BookmarkIcon(),

//               // ✅ Description
//               const _JobDescription(),

//               // ✅ Salary
//               const _SalaryText(),

//               // ✅ Tags
//               const _LocationTag(),
//               const _RemoteTag(),

//               // ✅ Time
//               const _TimeAgo(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ✅ Extract semua Positioned widget sebagai const widget
// class _UrgentBadge extends StatelessWidget {
//   const _UrgentBadge();

//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       left: 0,
//       top: 0,
//       child: Container(
//         height: 28,
//         padding: const EdgeInsets.only(left: 52, right: 20, top: 1),
//         decoration: const BoxDecoration(
//           color: Color(0xFF1E40AF),
//           borderRadius: BorderRadius.only(
//             bottomRight: Radius.circular(90),
//             topLeft: Radius.circular(34),
//           ),
//         ),
//         child: const Text(
//           'Dibutuhkan segera',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 14,
//             fontFamily: 'Poppins',
//             fontWeight: FontWeight.w600,
//             height: 2,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _BoltIcon extends StatelessWidget {
//   const _BoltIcon();

//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       left: 29,
//       top: 6,
//       child: SvgPicture.asset(
//         'assets/icons/bolt.svg',
//         width: 10,
//         height: 16,
//         colorFilter: const ColorFilter.mode(
//           Color(0xFFFFD700),
//           BlendMode.srcIn,
//         ),
//       ),
//     );
//   }
// }

// class _CompanyLogo extends StatelessWidget {
//   const _CompanyLogo();

//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       left: 16,
//       top: 47,
//       child: Container(
//         width: 40,
//         height: 36,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(4),
//           child: Image.asset(
//             'assets/icons/icon.png',
//             fit: BoxFit.contain,
//             cacheWidth: 80,
//             cacheHeight: 72,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _JobTitle extends StatelessWidget {
//   const _JobTitle();

//   @override
//   Widget build(BuildContext context) {
//     return const Positioned(
//       left: 66,
//       top: 47,
//       right: 50,
//       child: Text(
//         'Fulltime Backend Developer',
//         maxLines: 1,
//         overflow: TextOverflow.ellipsis,
//         style: TextStyle(
//           color: Colors.black,
//           fontSize: 16,
//           fontFamily: 'Poppins',
//           fontWeight: FontWeight.w500,
//           height: 1.2,
//         ),
//       ),
//     );
//   }
// }

// class _CompanyName extends StatelessWidget {
//   const _CompanyName();

//   @override
//   Widget build(BuildContext context) {
//     return const Positioned(
//       left: 66,
//       top: 71,
//       child: Text(
//         'Inforsys Indonesia',
//         style: TextStyle(
//           color: Color(0xFF71717A),
//           fontSize: 14,
//           fontFamily: 'Poppins',
//           fontWeight: FontWeight.w400,
//           height: 1.0,
//         ),
//       ),
//     );
//   }
// }

// class _BookmarkIcon extends StatelessWidget {
//   const _BookmarkIcon();

//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       right: 25,
//       top: 40,
//       child: SizedBox(
//         width: 16,
//         height: 24,
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(4),
//           child: SvgPicture.asset(
//             'assets/icons/bookmark.svg',
//             fit: BoxFit.contain,
//             colorFilter: ColorFilter.mode(
//               Colors.black.withValues(alpha: 1),
//               BlendMode.srcIn,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _JobDescription extends StatelessWidget {
//   const _JobDescription();

//   @override
//   Widget build(BuildContext context) {
//     return const Positioned(
//       left: 16,
//       top: 107,
//       right: 16,
//       child: Text(
//         'Bertanggung jawab dalam  mengelola, dan mengoptimal siste . . .',
//         maxLines: 2,
//         style: TextStyle(
//           color: Color(0xFF71717A),
//           fontSize: 14,
//           fontFamily: 'Poppins',
//           fontWeight: FontWeight.w300,
//           height: 1.7,
//         ),
//       ),
//     );
//   }
// }

// class _SalaryText extends StatelessWidget {
//   const _SalaryText();

//   @override
//   Widget build(BuildContext context) {
//     return const Positioned(
//       left: 16,
//       top: 172,
//       child: Text.rich(
//         TextSpan(
//           style: TextStyle(
//             color: Color(0xFF404040),
//             fontFamily: 'Poppins',
//             height: 1.2,
//           ),
//           children: [
//             TextSpan(
//               text: 'Rp',
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             TextSpan(
//               text: ' 9.000.000 - ',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             TextSpan(
//               text: 'Rp',
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             TextSpan(
//               text: ' 12.000.000',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _LocationTag extends StatelessWidget {
//   const _LocationTag();

//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       left: 16,
//       top: 210,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(100),
//           border: Border.all(
//             color: Colors.black.withValues(alpha: 0.05),
//             width: 1,
//           ),
//         ),
//         child: const Text(
//           'Batam Kota, Kepulauan Riau ke...',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 14,
//             fontFamily: 'SF Pro',
//             fontWeight: FontWeight.w400,
//             height: 1.2,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _RemoteTag extends StatelessWidget {
//   const _RemoteTag();

//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       right: 16,
//       top: 210,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
//         decoration: BoxDecoration(
//           color: const Color(0xFFF1F5F9),
//           borderRadius: BorderRadius.circular(100),
//           border: Border.all(
//             color: Colors.black.withValues(alpha: 0.05),
//             width: 1,
//           ),
//         ),
//         child: const Text(
//           'Remote',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 14,
//             fontFamily: 'SF Pro',
//             fontWeight: FontWeight.w400,
//             height: 1.2,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _TimeAgo extends StatelessWidget {
//   const _TimeAgo();

//   @override
//   Widget build(BuildContext context) {
//     return const Positioned(
//       right: 16,
//       bottom: 16,
//       child: Text(
//         '1 hari lalu',
//         textAlign: TextAlign.right,
//         style: TextStyle(
//           color: Color(0xFF6B7280),
//           fontSize: 12,
//           fontFamily: 'SF Pro',
//           fontWeight: FontWeight.w400,
//           height: 1.7,
//         ),
//       ),
//     );
//   }
// }

// // ✅ Optimized Pagination
// class EnhancedPagination extends StatelessWidget {
//   final int currentPage;
//   final int totalPages;
//   final Function(int) onPageChanged;

//   const EnhancedPagination({
//     super.key,
//     required this.currentPage,
//     required this.totalPages,
//     required this.onPageChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 16),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: List.generate(totalPages, (index) {
//           final isActive = currentPage == index;
//           double size = 8;
          
//           if (isActive) {
//             size = 10;
//           } else if (index == currentPage - 1 || index == currentPage + 1) {
//             size = 8;
//           } else {
//             size = 6;
//           }

//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 4),
//             child: GestureDetector(
//               onTap: () => onPageChanged(index),
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 300),
//                 curve: Curves.easeInOut,
//                 width: size,
//                 height: size,
//                 decoration: BoxDecoration(
//                   color: isActive
//                       ? const Color(0xFF1E40AF)
//                       : const Color(0xFFD1D5DB),
//                   shape: BoxShape.circle,
//                 ),
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }