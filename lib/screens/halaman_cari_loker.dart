import 'package:flutter/material.dart';
import 'package:jobfair/widget/bottom_navbar.dart';
import 'package:jobfair/widget/header.dart';
import 'detail_job_sheet.dart';
import 'package:jobfair/api/api_service.dart';
import 'package:jobfair/models/loker_umum_model.dart';

class HalamanCariLoker extends StatefulWidget {
  const HalamanCariLoker({super.key});

  @override
  State<HalamanCariLoker> createState() => _HalamanCariLokerState();
}

class _HalamanCariLokerState extends State<HalamanCariLoker> {
  final ScrollController _scrollController = ScrollController();
  final ApiService _apiService = ApiService();

  // ✅ ValueNotifier untuk state management efisien
  final ValueNotifier<int> _selectedTab = ValueNotifier<int>(0);

  // Data lowongan
  List<LokerUmum> _allLowongan = [];
  List<LokerUmum> _filteredLowongan = [];
  bool _isLoading = true;
  bool _hasError = false;
  bool _isLoadingMore = false;
  List<String> _appliedJobIds = [];

  // Lazy loading state
  int _currentPage = 1;
  bool _hasMoreData = true;
  final int _itemsPerPage = 10;

  // Filter state
  final ValueNotifier<Map<String, dynamic>> _filterState = ValueNotifier<Map<String, dynamic>>({
    'jenisPekerjaan': '',
    'lokasi': '',
    'gaji': '',
    'pengalaman': '',
  });

  @override
  void initState() {
    super.initState();
    _loadData();
    _setupScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _selectedTab.dispose();
    _filterState.dispose();
    super.dispose();
  }

  void _setupScrollController() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _loadMoreData();
      }
    });
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _currentPage = 1;
      _hasMoreData = true;
    });

    try {
      // Load lowongan dan data lamaran secara bersamaan dengan type annotation
      final results = await Future.wait<dynamic>([
        _apiService.getAllLokerUmum(),
        _apiService.getLowonganSudahDilamar(),
      ]);

      // Cast ke tipe yang benar
      final lowongan = results[0] as List<LokerUmum>;
      final appliedIds = results[1] as List<String>;

      setState(() {
        _allLowongan = lowongan;
        _filteredLowongan = _getPaginatedData(lowongan, 1);
        _appliedJobIds = appliedIds;
        _isLoading = false;
      });

      print(
        "✅ Data loaded: ${lowongan.length} lowongan, ${appliedIds.length} sudah dilamar",
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      print("❌ Error loading data: $e");
    }
  }

  Future<void> _loadMoreData() async {
    if (_isLoadingMore || !_hasMoreData) return;

    setState(() {
      _isLoadingMore = true;
    });

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final nextPage = _currentPage + 1;
      final newData = _getPaginatedData(_allLowongan, nextPage);

      if (newData.isNotEmpty) {
        setState(() {
          _filteredLowongan.addAll(newData);
          _currentPage = nextPage;
        });
      } else {
        setState(() {
          _hasMoreData = false;
        });
      }
    } catch (e) {
      print("❌ Error loading more data: $e");
    } finally {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  List<LokerUmum> _getPaginatedData(List<LokerUmum> data, int page) {
    final startIndex = (page - 1) * _itemsPerPage;
    if (startIndex >= data.length) {
      return [];
    }
    final endIndex = startIndex + _itemsPerPage;
    return data.sublist(
      startIndex,
      endIndex > data.length ? data.length : endIndex,
    );
  }

  void _onTabChanged(int index) {
    _selectedTab.value = index;
    _currentPage = 1;
    _hasMoreData = true;

    // Filter data berdasarkan tab
    if (index == 0) {
      // Semua lowongan
      setState(() {
        _filteredLowongan = _getPaginatedData(_allLowongan, 1);
      });
    } else {
      // Rekomendasi AI - untuk sekarang tampilkan semua juga
      setState(() {
        _filteredLowongan = _getPaginatedData(_allLowongan, 1);
      });
    }
  }

  // ✅ Fungsi untuk menerapkan filter
  void _applyFilters(Map<String, dynamic> filters) {
    _filterState.value = filters;
    _currentPage = 1;
    _hasMoreData = true;
    
    List<LokerUmum> filtered = _allLowongan;

    // Filter berdasarkan jenis pekerjaan
    if (filters['jenisPekerjaan'] != null && filters['jenisPekerjaan'].isNotEmpty) {
      filtered = filtered.where((loker) => 
        loker.jenisPekerjaan.toLowerCase().contains(filters['jenisPekerjaan'].toLowerCase())
      ).toList();
    }

    // Filter berdasarkan lokasi
    if (filters['lokasi'] != null && filters['lokasi'].isNotEmpty) {
      filtered = filtered.where((loker) => 
        loker.lokasi.toLowerCase().contains(filters['lokasi'].toLowerCase())
      ).toList();
    }

    // Filter berdasarkan pengalaman
    if (filters['pengalaman'] != null && filters['pengalaman'].isNotEmpty) {
      filtered = filtered.where((loker) => 
        loker.tingkatPengalaman.toLowerCase().contains(filters['pengalaman'].toLowerCase())
      ).toList();
    }

    // Filter berdasarkan gaji
    if (filters['gaji'] != null && filters['gaji'].isNotEmpty) {
      final gajiFilter = filters['gaji'];
      if (gajiFilter == '0-5') {
        filtered = filtered.where((loker) {
          final gaji = _parseGaji(loker.gaji);
          return gaji <= 5000000;
        }).toList();
      } else if (gajiFilter == '5-10') {
        filtered = filtered.where((loker) {
          final gaji = _parseGaji(loker.gaji);
          return gaji > 5000000 && gaji <= 10000000;
        }).toList();
      } else if (gajiFilter == '10+') {
        filtered = filtered.where((loker) {
          final gaji = _parseGaji(loker.gaji);
          return gaji > 10000000;
        }).toList();
      }
    }

    setState(() {
      _filteredLowongan = _getPaginatedData(filtered, 1);
    });
  }

  // Helper function untuk parse gaji
  double _parseGaji(String gaji) {
    try {
      // Remove non-digit characters except decimal point
      final cleaned = gaji.replaceAll(RegExp(r'[^\d]'), '');
      return double.tryParse(cleaned) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  // ✅ Fungsi untuk reset filter
  void _resetFilters() {
    _filterState.value = {
      'jenisPekerjaan': '',
      'lokasi': '',
      'gaji': '',
      'pengalaman': '',
    };
    _currentPage = 1;
    _hasMoreData = true;
    setState(() {
      _filteredLowongan = _getPaginatedData(_allLowongan, 1);
    });
  }

  // ✅ Fungsi untuk membuka filter dialog
  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        currentFilters: _filterState.value,
        onApplyFilters: _applyFilters,
        onResetFilters: _resetFilters,
      ),
    );
  }

  // ✅ Fungsi untuk membuka detail lowongan
  Future<void> _showJobDetail(LokerUmum lowongan) async {
    try {
      // Tampilkan loading terlebih dahulu
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Ambil data detail dari API
      final detailLowongan = await _apiService.getLokerUmumDetailById(
        lowongan.lowonganId,
      );

      // Tutup loading
      if (mounted) Navigator.of(context).pop();

      // Tampilkan bottom sheet dengan data detail
      if (mounted) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => JobDetailSheet(loker: detailLowongan),
        ).then((shouldRefresh) {
          // Handle refresh setelah melamar
          if (shouldRefresh == true) {
            _loadData(); // Refresh data
          }
        });
      }
    } catch (e) {
      // Tutup loading jika error
      if (mounted) Navigator.of(context).pop();

      // Tampilkan error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat detail lowongan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
        color: const Color(0xFFFAFAFA), // Background color sederhana
        child: Column(
          children: [
            // Fixed Header
            const HeaderWidget(showNotification: true, showFilter: false),

            // ✅ Fixed Filter Tabs dengan ValueListenableBuilder
            ValueListenableBuilder<int>(
              valueListenable: _selectedTab,
              builder: (context, selectedTab, child) {
                return _FilterTabs(
                  selectedTab: selectedTab,
                  onTabChanged: _onTabChanged,
                  onFilterTap: _showFilterDialog,
                );
              },
            ),

            // ✅ Main content dengan ValueListenableBuilder
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(37),
                    topRight: Radius.circular(37),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(37),
                    topRight: Radius.circular(37),
                  ),
                  child: ValueListenableBuilder<int>(
                    valueListenable: _selectedTab,
                    builder: (context, selectedTab, child) {
                      return RefreshIndicator(
                        onRefresh: _loadData,
                        child: CustomScrollView(
                          controller: _scrollController,
                          slivers: [
                            SliverToBoxAdapter(
                              child: Column(
                                children: [
                                  const SizedBox(height: 17),
                                  if (_isLoading)
                                    _buildLoadingState()
                                  else if (_hasError)
                                    _buildErrorState()
                                  else if (_filteredLowongan.isEmpty)
                                    _buildEmptyState()
                                ],
                              ),
                            ),

                            // List lowongan
                            if (!_isLoading && !_hasError && _filteredLowongan.isNotEmpty)
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    if (index < _filteredLowongan.length) {
                                      final lowongan = _filteredLowongan[index];
                                      final daysLeft = _calculateDaysLeft(lowongan.batasLamaran);
                                      final isUrgent = daysLeft <= 10 && daysLeft >= 0;
                                      final isApplied = _appliedJobIds.contains(lowongan.lowonganId);

                                      return Padding(
                                        padding: EdgeInsets.fromLTRB(
                                          16, 
                                          index == 0 ? 0 : 0, 
                                          16, 
                                          16
                                        ),
                                        child: _JobCard(
                                          lowongan: lowongan,
                                          isUrgent: isUrgent,
                                          daysLeft: daysLeft,
                                          isApplied: isApplied,
                                          onTap: () => _showJobDetail(lowongan),
                                        ),
                                      );
                                    }
                                    return null;
                                  },
                                  childCount: _filteredLowongan.length,
                                ),
                              ),

                            // Loading more indicator
                            if (_isLoadingMore)
                              const SliverToBoxAdapter(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              ),

                            // End of list indicator
                            if (!_hasMoreData && _filteredLowongan.isNotEmpty)
                              const SliverToBoxAdapter(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Center(
                                    child: Text(
                                      'Tidak ada lowongan lagi',
                                      style: TextStyle(
                                        color: Color(0xFF666666),
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                            // Bottom spacing
                            const SliverToBoxAdapter(
                              child: SizedBox(height: 100),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }

  Widget _buildLoadingState() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _JobCardSkeleton(),
          SizedBox(height: 16),
          _JobCardSkeleton(),
          SizedBox(height: 16),
          _JobCardSkeleton(),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      padding: const EdgeInsets.all(40),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline, size: 60, color: Color(0xFFDC2626)),
          const SizedBox(height: 16),
          const Text(
            'Gagal memuat data',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              color: Color(0xFF515151),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _loadData,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E40AF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Coba Lagi',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        children: [
          Icon(Icons.work_outline, size: 60, color: Color(0xFFB8B8B8)),
          SizedBox(height: 16),
          Text(
            'Belum ada lowongan',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              color: Color(0xFF515151),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Coba lagi nanti',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins',
              color: Color(0xFFB8B8B8),
            ),
          ),
        ],
      ),
    );
  }

  int _calculateDaysLeft(DateTime batasLamaran) {
    final now = DateTime.now();
    final difference = batasLamaran.difference(now);
    return difference.inDays;
  }
}

// ✅ Extract Filter Tabs sebagai StatelessWidget
class _FilterTabs extends StatelessWidget {
  final int selectedTab;
  final Function(int) onTabChanged;
  final VoidCallback onFilterTap;

  const _FilterTabs({
    required this.selectedTab, 
    required this.onTabChanged,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xFF162781).withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 6),
                  // ✅ Semua tab
                  _TabButton(
                    label: 'Semua',
                    isSelected: selectedTab == 0,
                    onTap: () => onTabChanged(0),
                    width: 136,
                  ),
                  const SizedBox(width: 10),
                  // ✅ Rekomendasi AI tab
                  _TabButton(
                    label: 'Rekomendasi AI',
                    isSelected: selectedTab == 1,
                    onTap: () => onTabChanged(1),
                    isFlexible: true,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 5),
          // Filter button
          GestureDetector(
            onTap: onFilterTap,
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xFF162781).withValues(alpha: 0.9),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.tune, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

// ✅ Extract Tab Button untuk reusability
class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final double? width;
  final bool isFlexible;

  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.width,
    this.isFlexible = false,
  });

  @override
  Widget build(BuildContext context) {
    final widget = GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: width,
        height: 35,
        padding: isFlexible ? const EdgeInsets.symmetric(horizontal: 16) : null,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF2345F7).withValues(alpha: 0.7)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );

    return isFlexible ? Expanded(child: widget) : widget;
  }
}

// ✅ Filter Bottom Sheet dengan Searchable Dropdown untuk Lokasi (Fixed Focus)
class FilterBottomSheet extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onApplyFilters;
  final VoidCallback onResetFilters;

  const FilterBottomSheet({
    super.key,
    required this.currentFilters,
    required this.onApplyFilters,
    required this.onResetFilters,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late Map<String, dynamic> _selectedFilters;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _showDropdown = false;
  List<String> _filteredLocations = [];
  
  final ScrollController _scrollController = ScrollController();
  
  // Daftar lokasi untuk dropdown
  final List<String> _lokasiOptions = [
    'Jakarta',
    'Bandung',
    'Surabaya',
    'Yogyakarta',
    'Semarang',
    'Bali',
    'Medan',
    'Makassar',
    'Palembang',
    'Malang',
    'Solo',
    'Bogor',
    'Tangerang',
    'Bekasi',
    'Depok',
    'Remote',
    'Luar Negeri'
  ];

  @override
  void initState() {
    super.initState();
    _selectedFilters = Map<String, dynamic>.from(widget.currentFilters);
    _filteredLocations = _lokasiOptions;
    _searchController.text = _selectedFilters['lokasi'] ?? '';
    
    _searchFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_searchFocusNode.hasFocus) {
      // Auto scroll ke input field ketika focus
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToInputField();
      });
    } else {
      // Tunggu sedikit sebelum hide dropdown untuk memberi waktu tap item
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          setState(() {
            _showDropdown = false;
          });
        }
      });
    }
  }

  void _scrollToInputField() {
    // Scroll ke posisi input field
    _scrollController.animateTo(
      200, // Estimated position of location field
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.removeListener(_onFocusChange);
    _searchFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {
      if (value.isEmpty) {
        _filteredLocations = _lokasiOptions;
      } else {
        _filteredLocations = _lokasiOptions
            .where((location) => location
                .toLowerCase()
                .contains(value.toLowerCase()))
            .toList();
      }
    });
  }

  void _selectLocation(String location) {
    setState(() {
      _selectedFilters['lokasi'] = location;
      _searchController.text = location;
      _showDropdown = false;
      _searchFocusNode.unfocus();
    });
  }

  void _clearLocation() {
    setState(() {
      _selectedFilters['lokasi'] = '';
      _searchController.clear();
      _showDropdown = true;
      _searchFocusNode.requestFocus();
    });
  }

  void _openDropdown() {
    setState(() {
      _showDropdown = true;
    });
    // Focus dan scroll ke input field
    _searchFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter Lowongan',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: widget.onResetFilters,
                      child: const Text(
                        'Reset',
                        style: TextStyle(
                          color: Color(0xFF666666),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        widget.onApplyFilters(_selectedFilters);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E40AF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Terapkan',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController, // ✅ Tambahkan controller untuk scroll
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Jenis Pekerjaan
                  _buildFilterSection(
                    title: 'Jenis Pekerjaan',
                    options: ['Full-time', 'Part-time', 'Contract', 'Internship', 'Remote'],
                    selectedValue: _selectedFilters['jenisPekerjaan'],
                    onChanged: (value) {
                      setState(() {
                        _selectedFilters['jenisPekerjaan'] = value;
                      });
                    },
                  ),

                  const SizedBox(height: 25),

                  // Lokasi - FIXED FOCUS SEARCHABLE DROPDOWN
                  _buildLocationDropdown(),

                  const SizedBox(height: 25),

                  // Rentang Gaji
                  _buildSalaryFilterSection(),

                  const SizedBox(height: 25),

                  // Tingkat Pengalaman
                  _buildFilterSection(
                    title: 'Pengalaman',
                    options: ['Fresh Graduate', '1-3 tahun', '3-5 tahun', '5+ tahun'],
                    selectedValue: _selectedFilters['pengalaman'],
                    onChanged: (value) {
                      setState(() {
                        _selectedFilters['pengalaman'] = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Fixed Focus Searchable Dropdown Widget
  Widget _buildLocationDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lokasi',
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        
        // Input Field dengan Dropdown di bawahnya
        Column(
          children: [
            // Input Field
            GestureDetector(
              onTap: _openDropdown, // ✅ Gunakan custom function
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _showDropdown ? const Color(0xFF1E40AF) : Colors.grey.shade300,
                    width: _showDropdown ? 2 : 1,
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  decoration: InputDecoration(
                    hintText: 'Pilih atau ketik lokasi...',
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontFamily: 'Poppins',
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    suffixIcon: _selectedFilters['lokasi']?.isNotEmpty ?? false
                        ? IconButton(
                            icon: const Icon(Icons.close, size: 18),
                            onPressed: _clearLocation,
                          )
                        : Icon(
                            _showDropdown ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                            color: Colors.grey.shade600,
                          ),
                  ),
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                  ),
                  onTap: _openDropdown, // ✅ Juga di sini untuk memastikan
                  onChanged: _onSearchChanged,
                ),
              ),
            ),

            // Dropdown List - TAMPIL LANGSUNG DI BAWAH INPUT
            if (_showDropdown && _filteredLocations.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  border: Border.all(color: Colors.grey.shade300),
                ),
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: _filteredLocations.length,
                  itemBuilder: (context, index) {
                    final location = _filteredLocations[index];
                    return ListTile(
                      title: Text(
                        location,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                        ),
                      ),
                      onTap: () => _selectLocation(location),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      visualDensity: const VisualDensity(vertical: -4),
                    );
                  },
                ),
              ),
          ],
        ),

        // Selected Location Chip
        const SizedBox(height: 8),
        if (_selectedFilters['lokasi']?.isNotEmpty ?? false)
          _buildSelectedFilterChip(
            'Lokasi: ${_selectedFilters['lokasi']}',
            onRemove: _clearLocation,
          ),
      ],
    );
  }

  // ✅ Widget untuk menampilkan chip filter yang dipilih
  Widget _buildSelectedFilterChip(String label, {required VoidCallback onRemove}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1E40AF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close,
              color: Colors.white,
              size: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection({
    required String title,
    required List<String> options,
    required String selectedValue,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: options.map((option) {
            final isSelected = selectedValue == option;
            return GestureDetector(
              onTap: () => onChanged(isSelected ? '' : option),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF1E40AF) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF1E40AF) : Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey.shade700,
                    fontFamily: 'Poppins',
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSalaryFilterSection() {
    final salaryOptions = [
      {'label': 'Rp 0 - 5 juta', 'value': '0-5'},
      {'label': 'Rp 5 - 10 juta', 'value': '5-10'},
      {'label': 'Rp 10+ juta', 'value': '10+'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rentang Gaji',
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: salaryOptions.map((option) {
            final isSelected = _selectedFilters['gaji'] == option['value'];
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilters['gaji'] = isSelected ? '' : option['value'];
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF1E40AF) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF1E40AF) : Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  option['label']!,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey.shade700,
                    fontFamily: 'Poppins',
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ✅ Job Card (tetap sama seperti sebelumnya)
class _JobCard extends StatefulWidget {
  final LokerUmum lowongan;
  final bool isUrgent;
  final int daysLeft;
  final bool isApplied;
  final VoidCallback onTap;

  const _JobCard({
    required this.lowongan,
    required this.isUrgent,
    required this.daysLeft,
    required this.isApplied,
    required this.onTap,
  });

  @override
  State<_JobCard> createState() => __JobCardState();
}

class __JobCardState extends State<_JobCard>
    with SingleTickerProviderStateMixin {
  bool isSaved = false;
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
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: double.infinity,
        height: 220,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            if (widget.isApplied)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 130,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: Color(0xFF4CAF50),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'Sudah dilamar',
                        style: TextStyle(
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

            if (widget.isUrgent && !widget.isApplied)
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
                        widget.daysLeft == 0
                            ? 'Hari terakhir!'
                            : '${widget.daysLeft}h',
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
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: widget.lowongan.logo.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  widget.lowongan.logo,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/icons/poltek.png',
                                      fit: BoxFit.contain,
                                    );
                                  },
                                ),
                              )
                            : Image.asset(
                                'assets/icons/poltek.png',
                                fit: BoxFit.contain,
                              ),
                      ),
                      const SizedBox(width: 12),
                      
                      Expanded(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 200,
                          ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.lowongan.posisi,
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
                              widget.lowongan.namaPerusahaan,
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
                                      color: Colors.black.withOpacity(0.3),
                                      size: 24,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Text(
                    _formatSalary(widget.lowongan.gaji),
                    style: const TextStyle(
                      color: Color(0xFF1B56FD),
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildTag(
                        icon: Icons.location_on,
                        text: widget.lowongan.lokasi,
                      ),
                      
                      _buildTag(
                        icon: Icons.work_outline,
                        text: widget.lowongan.jenisPekerjaan,
                      ),
                      
                      if (widget.lowongan.opsiKerjaRemote)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Remote',
                            style: TextStyle(
                              color: Color(0xFF2E7D32),
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const Spacer(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatTimeAgo(widget.lowongan.tanggalPosting),
                        style: const TextStyle(
                          color: Color(0xFF999999),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      
                      Text(
                        '${widget.lowongan.jumlahPelamar} pelamar',
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

  Widget _buildTag({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.grey.shade600),
          const SizedBox(width: 4),
          Text(
            text.length > 12 ? '${text.substring(0, 12)}...' : text,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  String _formatSalary(String gaji) {
    if (gaji.startsWith('Rp')) {
      return gaji;
    }
    return 'Rp $gaji';
  }

  String _formatTimeAgo(DateTime tanggalPosting) {
    final now = DateTime.now();
    final difference = now.difference(tanggalPosting);

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

// ✅ Skeleton loading (tetap sama)
class _JobCardSkeleton extends StatelessWidget {
  const _JobCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 120,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 80,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: 100,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 60,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 50,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 60,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  width: 50,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4),
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