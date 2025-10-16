import 'package:flutter/material.dart';
import '../../widget/lama/bottom_navbar.dart';
import '/widget/header.dart';

class ApplicationScreen extends StatefulWidget {
  const ApplicationScreen({Key? key}) : super(key: key);

  @override
  State<ApplicationScreen> createState() => _ApplicationScreenState();
}

class _ApplicationScreenState extends State<ApplicationScreen> {
  int _selectedTab = 0; // 0 = Semua, 1 = Proses
  
  // Dummy data - ganti dengan data real dari API/database
  final List<ApplicationItem> _allApplications = [
    ApplicationItem(
      title: 'Senior UI/UX Designer',
      company: 'Gojek Indonesia',
      description: 'Lead design initiatives for next-gen mobile experiences',
      appliedDate: 'Dilamar 16 Sep 2025',
      status: ApplicationStatus.pending,
      logoColor: Color(0xFF0987BB),
    ),
    ApplicationItem(
      title: 'Senior UI/UX Designer',
      company: 'Gojek Indonesia',
      description: 'Lead design initiatives for next-gen mobile experiences',
      appliedDate: 'Dilamar 14 Sep 2025',
      status: ApplicationStatus.interview,
      logoColor: Color(0xFF0987BB),
    ),
  ];

  List<ApplicationItem> get _processApplications {
    return _allApplications
        .where((app) => app.status == ApplicationStatus.interview)
        .toList();
  }

  @override
 Widget build(BuildContext context) {
  final displayApplications = _selectedTab == 0 ? _allApplications : _processApplications;
  final isEmpty = displayApplications.isEmpty;

  return Scaffold(
    backgroundColor: const Color(0xFFF1F0F5),
    body: SafeArea(
      child: Column(
        children: [
          // Header
          const HeaderWidget(),

          // Tabs Section
          Container(
            color: Colors.white,
            child: Row(
              children: [
                _buildTab('Semua (${_allApplications.length})', 0),
                _buildTab('Proses', 1),
              ],
            ),
          ),

          // Content
          Expanded(
            child: isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(18),
                    itemCount: displayApplications.length,
                    itemBuilder: (context, index) {
                      return _buildApplicationCard(displayApplications[index]);
                    },
                  ),
          ),
        ],
      ),
    ),
    bottomNavigationBar: const BottomNavBar(
      currentIndex: 3, // Job Fair page
    ),
  );
}

  
  Widget _buildTab(String label, int index) {
    final isSelected = _selectedTab == index;
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: Container(
          padding: EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? Color(0xFF006D9A) : Colors.transparent,
                width: 1,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Color(0xFF006D9A) : Color(0xFF737373),
                ),
              ),
              if (index == 1) ...[
                SizedBox(width: 4),
                Icon(
                  Icons.flag,
                  size: 13,
                  color: isSelected ? Color(0xFF006D9A) : Color(0xFF737373),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildApplicationCard(ApplicationItem item) {
    return Container(
      margin: EdgeInsets.only(bottom: 17),
      padding: EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: item.logoColor,
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 14),
              // Title & Company
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      item.company,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF7D7D7D),
                      ),
                    ),
                  ],
                ),
              ),
              // Status Badge
              _buildStatusBadge(item.status),
            ],
          ),
          SizedBox(height: 16),
          // Description
          Text(
            item.description,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color(0xFF7D7D7D),
              height: 1.6,
            ),
          ),
          SizedBox(height: 10),
          Divider(
            color: Color(0xFFDAD9DD),
            thickness: 1,
            height: 1,
          ),
          SizedBox(height: 10),
          // Applied Date
          Text(
            item.status == ApplicationStatus.interview
                ? 'Jadwal: 20 Sep 2024, 10:00'
                : item.appliedDate,
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w300,
              color: Color(0xFF7D7D7D),
              height: 2.25,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatusBadge(ApplicationStatus status) {
    final isPending = status == ApplicationStatus.pending;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: isPending ? Color(0xFFFFF3CD) : Color(0xFFD4EDDA),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isPending ? 'Pending' : 'Interview',
        style: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.w600,
          color: isPending ? Color(0xFF856604) : Color(0xFF155724),
        ),
      ),
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.description_outlined,
            size: 75,
            color: Color(0xFFCBCBCE),
          ),
          SizedBox(height: 20),
          Text(
            'Belum ada riwayat lamaran',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Mulai melamar pekerjaan untuk melihat riwayat di sini',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w300,
              color: Colors.black.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}

enum ApplicationStatus {
  pending,
  interview,
}

class ApplicationItem {
  final String title;
  final String company;
  final String description;
  final String appliedDate;
  final ApplicationStatus status;
  final Color logoColor;

  ApplicationItem({
    required this.title,
    required this.company,
    required this.description,
    required this.appliedDate,
    required this.status,
    required this.logoColor,
  });
}