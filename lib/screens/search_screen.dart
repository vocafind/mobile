import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/widget/header.dart';
import '/widget/bottom_navbar.dart';
import 'job_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // Page controller for tabs
  late PageController _pageController;
  int _currentTab = 0;
  
  // Pagination
  int _currentPage = 1;
  final int _totalPages = 3;

  // Filter states
  List<String> selectedLocations = ["Batam"];
  List<String> selectedCategories = ["IT"];
  List<String> selectedJobTypes = ["Full time"];
  List<String> selectedWorkModes = ["Remote"];

  // Sample job data
  final List<Map<String, dynamic>> _allJobs = [
    // Page 1
    {
      "title": "Senior UI/UX Designer",
      "company": "Gojek Indonesia",
      "description": "Lead design initiatives for next-gen mobile experiences",
      "location": "Batam",
      "workMode": "Remote",
      "level": "Senior",
      "timeAgo": "1 hari lalu",
      "isClosed": false,
    },
    {
      "title": "Frontend Developer",
      "company": "Tokopedia",
      "description": "Build scalable web applications using React and TypeScript",
      "location": "Jakarta",
      "workMode": "Hybrid",
      "level": "Mid",
      "timeAgo": "2 hari lalu",
      "isClosed": false,
    },
    {
      "title": "Product Manager",
      "company": "Shopee Indonesia",
      "description": "Drive product strategy and roadmap for e-commerce platform",
      "location": "Jakarta",
      "workMode": "On-site",
      "level": "Senior",
      "timeAgo": "3 hari lalu",
      "isClosed": false,
    },
    // Page 2
    {
      "title": "Backend Engineer",
      "company": "Bukalapak",
      "description": "Develop and maintain microservices architecture",
      "location": "Bandung",
      "workMode": "Remote",
      "level": "Mid",
      "timeAgo": "4 hari lalu",
      "isClosed": false,
    },
    {
      "title": "Data Scientist",
      "company": "Traveloka",
      "description": "Analyze user behavior and build ML models for recommendations",
      "location": "Jakarta",
      "workMode": "Hybrid",
      "level": "Senior",
      "timeAgo": "5 hari lalu",
      "isClosed": false,
    },
    {
      "title": "Mobile Developer",
      "company": "OVO",
      "description": "Develop native mobile applications for iOS and Android",
      "location": "Jakarta",
      "workMode": "On-site",
      "level": "Mid",
      "timeAgo": "6 hari lalu",
      "isClosed": false,
    },
    // Page 3 - with closed jobs
    {
      "title": "DevOps Engineer",
      "company": "Blibli",
      "description": "Manage cloud infrastructure and CI/CD pipelines",
      "location": "Jakarta",
      "workMode": "Remote",
      "level": "Senior",
      "timeAgo": "7 hari lalu",
      "isClosed": false,
    },
    {
      "title": "QA Engineer",
      "company": "Dana",
      "description": "Ensure quality through comprehensive testing strategies",
      "location": "Jakarta",
      "workMode": "Hybrid",
      "level": "Mid",
      "timeAgo": "8 hari lalu",
      "isClosed": false,
    },
    {
      "title": "Senior UI/UX Designer",
      "company": "Gojek Indonesia",
      "description": "Lead design initiatives for next-gen mobile experiences",
      "location": "Batam",
      "workMode": "Remote",
      "level": "Senior",
      "timeAgo": "15 hari lalu",
      "isClosed": true, // Closed job
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getJobsForCurrentPage() {
    final startIndex = (_currentPage - 1) * 3;
    final endIndex = startIndex + 3;
    return _allJobs.sublist(
      startIndex,
      endIndex > _allJobs.length ? _allJobs.length : endIndex,
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                constraints: const BoxConstraints(maxHeight: 600),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Filter Pencarian",
                          style: TextStyle(
                            fontFamily: "SF Pro",
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Scrollable Content
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFilterSection(
                              "Lokasi",
                              ["Batam", "Jakarta", "Bandung", "Surabaya", "Bali"],
                              selectedLocations,
                              (value) {
                                setDialogState(() {
                                  if (selectedLocations.contains(value)) {
                                    selectedLocations.remove(value);
                                  } else {
                                    selectedLocations.add(value);
                                  }
                                });
                              },
                            ),
                            const SizedBox(height: 20),
                            _buildFilterSection(
                              "Kategori",
                              ["IT", "Desain", "Marketing", "Keuangan", "HR"],
                              selectedCategories,
                              (value) {
                                setDialogState(() {
                                  if (selectedCategories.contains(value)) {
                                    selectedCategories.remove(value);
                                  } else {
                                    selectedCategories.add(value);
                                  }
                                });
                              },
                            ),
                            const SizedBox(height: 20),
                            _buildFilterSection(
                              "Tipe Pekerjaan",
                              ["Full time", "Part time", "Freelance", "Kontrak", "Internship"],
                              selectedJobTypes,
                              (value) {
                                setDialogState(() {
                                  if (selectedJobTypes.contains(value)) {
                                    selectedJobTypes.remove(value);
                                  } else {
                                    selectedJobTypes.add(value);
                                  }
                                });
                              },
                            ),
                            const SizedBox(height: 20),
                            _buildFilterSection(
                              "Mode Kerja",
                              ["Remote", "On-site", "Hybrid"],
                              selectedWorkModes,
                              (value) {
                                setDialogState(() {
                                  if (selectedWorkModes.contains(value)) {
                                    selectedWorkModes.remove(value);
                                  } else {
                                    selectedWorkModes.add(value);
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setDialogState(() {
                                selectedLocations.clear();
                                selectedCategories.clear();
                                selectedJobTypes.clear();
                                selectedWorkModes.clear();
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: const BorderSide(color: Color(0xFF0987BB)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "Reset",
                              style: TextStyle(
                                fontFamily: "SF Pro",
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0987BB),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {});
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0987BB),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "Terapkan",
                              style: TextStyle(
                                fontFamily: "SF Pro",
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
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
          },
        );
      },
    );
  }

  Widget _buildFilterSection(
    String title,
    List<String> options,
    List<String> selected,
    Function(String) onTap,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: "SF Pro",
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = selected.contains(option);
            return GestureDetector(
              onTap: () => onTap(option),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF0987BB) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF0987BB) : const Color(0xFFE2E8F0),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    fontFamily: "SF Pro",
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : const Color(0xFF64748B),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const HeaderWidget(),

            // Tabs Section
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _currentTab = 0;
                              });
                              _pageController.animateToPage(
                                0,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Center(
                              child: Column(
                                children: [
                                  Text(
                                    "Semua",
                                    style: TextStyle(
                                      color: _currentTab == 0
                                          ? const Color(0xFF0987BB)
                                          : const Color(0xFF737373),
                                      fontSize: 14,
                                      fontFamily: "SF Pro",
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    height: 3,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: _currentTab == 0
                                          ? const Color(0xFF0987BB)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _currentTab = 1;
                              });
                              _pageController.animateToPage(
                                1,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Center(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "☆ ",
                                        style: TextStyle(
                                          color: _currentTab == 1
                                              ? const Color(0xFF0987BB)
                                              : const Color(0xFF737373),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "Rekomendasi AI (1)",
                                          style: TextStyle(
                                            color: _currentTab == 1
                                                ? const Color(0xFF0987BB)
                                                : const Color(0xFF737373),
                                            fontSize: 13,
                                            fontFamily: "SF Pro",
                                            fontWeight: FontWeight.w700,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    height: 3,
                                    width: 120,
                                    decoration: BoxDecoration(
                                      color: _currentTab == 1
                                          ? const Color(0xFF0987BB)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 1,
                    color: const Color(0xFFE2E8F0),
                  ),
                ],
              ),
            ),

            // Filter Chips
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              color: Colors.white,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _showFilterDialog,
                    child: Container(
                      width: 32,
                      height: 32,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/icons/filter.svg',
                          width: 20,
                          height: 20,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF2A3038),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ...selectedLocations.map((e) => Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: _filterChip(e),
                          )),
                          ...selectedCategories.map((e) => Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: _filterChip(e),
                          )),
                          ...selectedJobTypes.map((e) => Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: _filterChip(e),
                          )),
                          ...selectedWorkModes.map((e) => Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: _filterChip(e),
                          )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // PageView for Tab Content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentTab = index;
                  });
                },
                children: [
                  _buildJobList(),
                  _buildAIRecommendationList(),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: const BottomNavBar(
        currentIndex: 1,
      ),
    );
  }

  Widget _buildJobList() {
    final jobs = _getJobsForCurrentPage();
    
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 17),
                child: _jobCard(
                  title: job["title"],
                  company: job["company"],
                  description: job["description"],
                  location: job["location"],
                  workMode: job["workMode"],
                  level: job["level"],
                  timeAgo: job["timeAgo"],
                  isClosed: job["isClosed"],
                  onTap: job["isClosed"]
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const JobDetailScreen(),
                            ),
                          );
                        },
                ),
              );
            },
          ),
        ),
        _buildPagination(),
      ],
    );
  }

  Widget _buildAIRecommendationList() {
    return ListView(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      children: [
        _jobCard(
          title: "Senior UI/UX Designer",
          company: "Gojek Indonesia",
          description: "Lead design initiatives for next-gen mobile experiences",
          location: "Batam",
          workMode: "Remote",
          level: "Senior",
          timeAgo: "1 hari lalu",
          isAIRecommended: true,
          isClosed: false,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const JobDetailScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPagination() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Previous button
          IconButton(
            onPressed: _currentPage > 1
                ? () {
                    setState(() {
                      _currentPage--;
                    });
                  }
                : null,
            icon: Icon(
              Icons.chevron_left,
              color: _currentPage > 1
                  ? const Color(0xFF0987BB)
                  : const Color(0xFFCBD5E1),
            ),
          ),
          const SizedBox(width: 8),
          
          // Page numbers
          ...List.generate(_totalPages, (index) {
            final pageNum = index + 1;
            final isActive = pageNum == _currentPage;
            
            return GestureDetector(
              onTap: () {
                setState(() {
                  _currentPage = pageNum;
                });
              },
              child: Container(
                width: 32,
                height: 32,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFF0987BB)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isActive
                        ? const Color(0xFF0987BB)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Center(
                  child: Text(
                    '$pageNum',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "SF Pro",
                      fontWeight: FontWeight.w600,
                      color: isActive
                          ? Colors.white
                          : const Color(0xFF64748B),
                    ),
                  ),
                ),
              ),
            );
          }),
          
          const SizedBox(width: 8),
          // Next button
          IconButton(
            onPressed: _currentPage < _totalPages
                ? () {
                    setState(() {
                      _currentPage++;
                    });
                  }
                : null,
            icon: Icon(
              Icons.chevron_right,
              color: _currentPage < _totalPages
                  ? const Color(0xFF0987BB)
                  : const Color(0xFFCBD5E1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 13,
            fontFamily: "SF Pro",
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _jobCard({
    required String title,
    required String company,
    required String description,
    required String location,
    required String workMode,
    required String level,
    required String timeAgo,
    bool isAIRecommended = false,
    bool isClosed = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 18),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isClosed ? const Color(0xFFE4E4E4) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 2,
              offset: const Offset(0, 2),
            )
          ],
          borderRadius: BorderRadius.circular(12),
          border: isAIRecommended && !isClosed
              ? Border.all(color: const Color(0xFF006D9A), width: 2)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isAIRecommended && !isClosed)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF006D9A),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      "☆ ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      "Rekomendasi AI",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontFamily: "SF Pro",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isClosed
                        ? const Color(0xFFF1F1F1)
                        : const Color(0xFF0987BB),
                    borderRadius: BorderRadius.circular(9),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 4,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
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
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        company,
                        style: const TextStyle(
                          color: Color(0xFF7D7D7D),
                          fontSize: 11,
                          fontFamily: "SF Pro",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 21),

            Text(
              description,
              style: const TextStyle(
                color: Color(0xFF7D7D7D),
                fontSize: 11,
                fontFamily: "SF Pro",
                fontWeight: FontWeight.w500,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                _smallTag(location, isClosed),
                const SizedBox(width: 7),
                _smallTag(workMode, isClosed),
                const SizedBox(width: 7),
                _smallTag(level, isClosed),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _smallTag(String text, bool isClosed) {
    return Container(
      height: 23,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
      decoration: BoxDecoration(
        color: isClosed ? const Color(0xFFDBDBDB) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isClosed ? const Color(0xFFDBDBDB) : const Color(0xFFF1F5F9),
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 9,
            fontFamily: "SF Pro",
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}