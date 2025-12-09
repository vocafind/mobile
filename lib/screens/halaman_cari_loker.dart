import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jobfair/models/loker_rekomendasi_model.dart';
import 'package:jobfair/models/saved_job_model.dart';
import 'package:jobfair/widget/bottom_navbar.dart';
import 'package:jobfair/widget/header.dart';
import 'detail_job_sheet.dart';
import 'package:jobfair/api/api_service.dart';
import 'package:jobfair/models/loker_umum_model.dart';

class HalamanCariLoker extends StatefulWidget {
  final String? initialSearchQuery;

  const HalamanCariLoker({super.key, this.initialSearchQuery});

  @override
  State<HalamanCariLoker> createState() => _HalamanCariLokerState();
}

class _HalamanCariLokerState extends State<HalamanCariLoker> {
  final ScrollController _scrollController = ScrollController();
  final ApiService _apiService = ApiService();

  final ValueNotifier<int> _selectedTab = ValueNotifier<int>(0);

  // Data untuk tab Semua
  List<LokerUmum> _allLowongan = [];
  List<LokerUmum> _filteredLowongan = [];
  List<LokerUmum> _searchResults = [];

  // Data untuk tab Rekomendasi AI
  List<LokerRekomendasi> _allRekomendasi = [];
  List<LokerRekomendasi> _filteredRekomendasi = [];

  bool _isLoading = true;
  bool _hasError = false;
  bool _isLoadingMore = false;
  bool _isSearching = false;
  String _currentSearchQuery = '';
  List<String> _appliedJobIds = [];
  List<String> _savedJobIds = [];

  // Lazy loading state untuk tab Semua
  int _currentPage = 1;
  bool _hasMoreData = true;
  final int _itemsPerPage = 10;

  // Filter state
  final ValueNotifier<Map<String, dynamic>> _filterState =
      ValueNotifier<Map<String, dynamic>>({
        'jenisPekerjaan': '',
        'lokasi': '',
        'gaji': '',
        'minimalLulusan': '',
        'remote': null,
      });

  // Controller untuk search
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Timer? _searchDebounceTimer;

  @override
  void initState() {
    super.initState();
    _loadData();
    _setupScrollController();
    _setupSearchListener();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialSearchQuery != null) {
        _searchController.text = widget.initialSearchQuery!;
        _performSearch(widget.initialSearchQuery!);
      }

      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted && _searchFocusNode.canRequestFocus) {
          _searchFocusNode.requestFocus();
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _selectedTab.dispose();
    _filterState.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    _searchDebounceTimer?.cancel();
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

  void _setupSearchListener() {
    _searchController.addListener(() {
      final query = _searchController.text;
      _onSearchChanged(query);
    });
  }

  void _onSearchChanged(String query) {
    print("🔍 Search query changed: '$query'");

    _searchDebounceTimer?.cancel();

    setState(() {
      _currentSearchQuery = query;
    });

    if (query.trim().isEmpty) {
      print("🔍 Search cleared, returning to normal data");
      setState(() {
        _isSearching = false;
        _searchResults.clear();
      });
      _applyCurrentFilters();
      return;
    }

    _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      print("🔍 Performing search for: '$query'");
      _performSearch(query.trim());
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) return;

    print("🔍 API Search started for: '$query'");

    setState(() {
      _isSearching = true;
      _isLoading = true;
    });

    try {
      final results = await _apiService.searchLokerUmum(query);

      print("🔍 API Search results: ${results.length} lowongan found");

      setState(() {
        _searchResults = results;
        _isLoading = false;
      });

      print("🔍 Search results for '$query': ${results.length} lowongan found");
    } catch (e) {
      print("❌ Error searching: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearSearch() {
    print("🔍 Clearing search");
    _searchController.clear();
    setState(() {
      _isSearching = false;
      _searchResults.clear();
      _currentSearchQuery = '';
    });
    _applyCurrentFilters();
  }

  void _applyCurrentFilters() {
    if (_filterState.value.values.any(
      (value) =>
          (value != null && value.toString().isNotEmpty) || (value is bool),
    )) {
      _applyFilters(_filterState.value);
    } else {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    print("📥 Loading data...");
    setState(() {
      _isLoading = true;
      _hasError = false;
      _currentPage = 1;
      _hasMoreData = true;
    });

    try {
      // Load data untuk tab Semua dan tab Rekomendasi AI secara bersamaan
      final results = await Future.wait<dynamic>([
        _apiService.getAllLokerUmum(),
        _apiService.getLowonganSudahDilamar(),
        _apiService.getSavedJobs(),
        _apiService.getAllLokerRekomendasi(), // Load rekomendasi AI
      ]);

      // Cast ke tipe yang benar
      final lowongan = results[0] as List<LokerUmum>;
      final appliedIds = results[1] as List<String>;
      final savedJobs = results[2] as List<SavedJob>;
      final rekomendasi = results[3] as List<LokerRekomendasi>;

      setState(() {
        _allLowongan = lowongan;
        _filteredLowongan = _getPaginatedData(lowongan, 1);
        _allRekomendasi = rekomendasi;
        _filteredRekomendasi =
            rekomendasi; // Rekomendasi tidak perlu pagination
        _appliedJobIds = appliedIds;
        _savedJobIds = savedJobs.map((job) => job.lowonganId).toList();
        _isLoading = false;
      });

      print(
        "✅ Data loaded: ${lowongan.length} lowongan, ${rekomendasi.length} rekomendasi, ${appliedIds.length} sudah dilamar, ${savedJobs.length} disimpan",
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
    if (_isLoadingMore || !_hasMoreData || _isSearching) return;

    setState(() {
      _isLoadingMore = true;
    });

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

    if (_isSearching) {
      _clearSearch();
    }

    if (index == 0) {
      // Tab Semua
      setState(() {
        _filteredLowongan = _getPaginatedData(_allLowongan, 1);
      });
    } else {
      // Tab Rekomendasi AI - tidak perlu perubahan
    }
  }

  Future<void> _toggleSaveJob(String lowonganId, bool currentlySaved) async {
    try {
      if (currentlySaved) {
        await _apiService.unsaveJobByLowonganId(lowonganId);
        setState(() {
          _savedJobIds.remove(lowonganId);
        });
        print("✅ Job unsaved: $lowonganId");
      } else {
        await _apiService.saveJob(lowonganId);
        setState(() {
          _savedJobIds.add(lowonganId);
        });
        print("✅ Job saved: $lowonganId");
      }
    } catch (e) {
      print("❌ Error toggling save job: $e");
    }
  }

  Future<void> _applyFilters(Map<String, dynamic> filters) async {
    // Hanya berlaku untuk tab Semua
    if (_selectedTab.value != 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Filter hanya berlaku untuk tab Semua'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (_isSearching) {
      _clearSearch();
    }

    print("🔍 Applying filters: $filters");
    _filterState.value = filters;
    _currentPage = 1;
    _hasMoreData = true;

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      String? rangeGaji;
      if (filters['gaji'] != null && filters['gaji'].isNotEmpty) {
        switch (filters['gaji']) {
          case '0-5':
            rangeGaji = 'below10m';
            break;
          case '5-10':
            rangeGaji = '10m-20m';
            break;
          case '10+':
            rangeGaji = 'above20m';
            break;
          default:
            rangeGaji = filters['gaji'];
        }
      }

      bool? remote;
      if (filters.containsKey('remote') && filters['remote'] != null) {
        remote = filters['remote'];
      }

      final filteredLowongan = await _apiService.filterLokerUmum(
        jenisPekerjaan: filters['jenisPekerjaan']?.isNotEmpty == true
            ? filters['jenisPekerjaan']
            : null,
        lokasi: filters['lokasi']?.isNotEmpty == true
            ? filters['lokasi']
            : null,
        remote: remote,
        minimalLulusan: filters['minimalLulusan']?.isNotEmpty == true
            ? filters['minimalLulusan']
            : null,
        rangeGaji: rangeGaji,
      );

      setState(() {
        _allLowongan = filteredLowongan;
        _filteredLowongan = _getPaginatedData(filteredLowongan, 1);
        _isLoading = false;
      });

      print("✅ Filter applied: ${filteredLowongan.length} lowongan found");

      if (filteredLowongan.isEmpty) {
        print("ℹ️ No lowongan found with current filters");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      print("❌ Error applying filters: $e");
      _applyLocalFilters(filters);
    }
  }

  void _applyLocalFilters(Map<String, dynamic> filters) {
    print("🔄 Using local filter fallback");

    List<LokerUmum> filtered = _allLowongan;

    if (filters['jenisPekerjaan'] != null &&
        filters['jenisPekerjaan'].isNotEmpty) {
      filtered = filtered
          .where(
            (loker) => loker.jenisPekerjaan.toLowerCase().contains(
              filters['jenisPekerjaan'].toLowerCase(),
            ),
          )
          .toList();
    }

    if (filters['lokasi'] != null && filters['lokasi'].isNotEmpty) {
      filtered = filtered
          .where(
            (loker) => loker.lokasi.toLowerCase().contains(
              filters['lokasi'].toLowerCase(),
            ),
          )
          .toList();
    }

    if (filters['minimalLulusan'] != null &&
        filters['minimalLulusan'].isNotEmpty) {
      filtered = filtered
          .where(
            (loker) =>
                loker.minimalLulusan.toLowerCase() ==
                filters['minimalLulusan'].toLowerCase(),
          )
          .toList();
    }

    if (filters['remote'] != null) {
      filtered = filtered
          .where((loker) => loker.opsiKerjaRemote == filters['remote'])
          .toList();
    }

    if (filters['gaji'] != null && filters['gaji'].isNotEmpty) {
      final gajiFilter = filters['gaji'];
      if (gajiFilter == '0-5') {
        filtered = filtered.where((loker) {
          final gaji = _parseGaji(loker.gaji);
          return gaji < 10000000;
        }).toList();
      } else if (gajiFilter == '5-10') {
        filtered = filtered.where((loker) {
          final gaji = _parseGaji(loker.gaji);
          return gaji >= 10000000 && gaji <= 20000000;
        }).toList();
      } else if (gajiFilter == '10+') {
        filtered = filtered.where((loker) {
          final gaji = _parseGaji(loker.gaji);
          return gaji > 20000000;
        }).toList();
      }
    }

    setState(() {
      _filteredLowongan = _getPaginatedData(filtered, 1);
    });

    print("✅ Local filter applied: ${filtered.length} lowongan found");
  }

  double _parseGaji(String gaji) {
    try {
      final cleaned = gaji.replaceAll(RegExp(r'[^\d]'), '');
      return double.tryParse(cleaned) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  void _resetFilters() {
    if (_isSearching) {
      _clearSearch();
    }

    _filterState.value = {
      'jenisPekerjaan': '',
      'lokasi': '',
      'gaji': '',
      'minimalLulusan': '',
      'remote': null,
    };
    _currentPage = 1;
    _hasMoreData = true;

    _loadData();
    print("🔄 Filters reset");
  }

  void _showFilterDialog() {
    // Filter hanya untuk tab Semua
    if (_selectedTab.value != 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Filter hanya tersedia untuk tab Semua'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

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

  Future<void> _showJobDetail(LokerUmum lowongan) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final detailLowongan = await _apiService.getLokerUmumDetailById(
        lowongan.lowonganId,
      );

      if (mounted) Navigator.of(context).pop();

      if (mounted) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => JobDetailSheet(loker: detailLowongan),
        ).then((shouldRefresh) {
          if (shouldRefresh == true) {
            _loadData();
          }
        });
      }
    } catch (e) {
      if (mounted) Navigator.of(context).pop();

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

  Future<void> _showRekomendasiJobDetail(LokerRekomendasi rekomendasi) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Gunakan service yang sama untuk detail lowongan umum
      final detailLowongan = await _apiService.getLokerUmumDetailById(
        rekomendasi.lowonganId,
      );

      if (mounted) Navigator.of(context).pop();

      if (mounted) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => JobDetailSheet(loker: detailLowongan),
        ).then((shouldRefresh) {
          if (shouldRefresh == true) {
            _loadData();
          }
        });
      }
    } catch (e) {
      if (mounted) Navigator.of(context).pop();

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
        color: const Color(0xFFFAFAFA),
        child: Column(
          children: [
            // Header
            HeaderWidget(
              showNotification: true,
              showFilter: false,
              showBookmark: true,
              externalSearchController: _searchController,
              onSearch: _onSearchChanged,
            ),

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

            if (_isSearching && _currentSearchQuery.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "Hasil pencarian: '$_currentSearchQuery'",
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: _clearSearch,
                    ),
                  ],
                ),
              ),

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
                      final isTabSemua = selectedTab == 0;
                      final isTabRekomendasi = selectedTab == 1;

                      // Data yang akan ditampilkan
                      final List<dynamic> displayData;
                      final bool displayIsLoading;
                      final bool displayHasError;

                      if (isTabSemua) {
                        displayData = _isSearching
                            ? _searchResults
                            : _filteredLowongan;
                        displayIsLoading = _isSearching
                            ? _isLoading
                            : (_isLoading && !_isSearching);
                        displayHasError = _hasError && !_isSearching;
                      } else {
                        // Tab Rekomendasi AI
                        displayData = _filteredRekomendasi;
                        displayIsLoading = _isLoading;
                        displayHasError = _hasError;
                      }

                      return RefreshIndicator(
                        onRefresh: _loadData,
                        child: CustomScrollView(
                          controller: _scrollController,
                          slivers: [
                            SliverToBoxAdapter(
                              child: Column(
                                children: [
                                  const SizedBox(height: 17),
                                  if (displayIsLoading)
                                    _buildLoadingState()
                                  else if (displayHasError)
                                    _buildErrorState()
                                  else if (displayData.isEmpty)
                                    _buildEmptyState(
                                      isSearching: _isSearching && isTabSemua,
                                      searchQuery: _currentSearchQuery,
                                      isRekomendasiTab: isTabRekomendasi,
                                    ),
                                ],
                              ),
                            ),

                            if (!displayIsLoading &&
                                !displayHasError &&
                                displayData.isNotEmpty)
                              SliverList(
                                delegate: SliverChildBuilderDelegate((
                                  context,
                                  index,
                                ) {
                                  if (index < displayData.length) {
                                    if (isTabSemua) {
                                      // Tab Semua
                                      final lowongan =
                                          displayData[index] as LokerUmum;
                                      final daysLeft = _calculateDaysLeft(
                                        lowongan.batasLamaran,
                                      );
                                      final isUrgent =
                                          daysLeft <= 10 && daysLeft >= 0;
                                      final isApplied = _appliedJobIds.contains(
                                        lowongan.lowonganId,
                                      );
                                      final isSaved = _savedJobIds.contains(
                                        lowongan.lowonganId,
                                      );

                                      return Padding(
                                        padding: EdgeInsets.fromLTRB(
                                          16,
                                          index == 0 ? 0 : 0,
                                          16,
                                          16,
                                        ),
                                        child: _JobCard(
                                          lowongan: lowongan,
                                          isUrgent: isUrgent,
                                          daysLeft: daysLeft,
                                          isApplied: isApplied,
                                          isSaved: isSaved,
                                          onTap: () => _showJobDetail(lowongan),
                                          onBookmarkToggle:
                                              (lowonganId, currentlySaved) =>
                                                  _toggleSaveJob(
                                                    lowonganId,
                                                    currentlySaved,
                                                  ),
                                        ),
                                      );
                                    } else {
                                      // Tab Rekomendasi AI
                                      final rekomendasi =
                                          displayData[index]
                                              as LokerRekomendasi;
                                      final daysLeft = _calculateDaysLeft(
                                        rekomendasi.batasLamaran,
                                      );
                                      final isUrgent =
                                          daysLeft <= 10 && daysLeft >= 0;
                                      final isApplied = _appliedJobIds.contains(
                                        rekomendasi.lowonganId,
                                      );
                                      final isSaved = _savedJobIds.contains(
                                        rekomendasi.lowonganId,
                                      );

                                      return Padding(
                                        padding: EdgeInsets.fromLTRB(
                                          16,
                                          index == 0 ? 0 : 0,
                                          16,
                                          16,
                                        ),
                                        child: _RekomendasiJobCard(
                                          rekomendasi: rekomendasi,
                                          isUrgent: isUrgent,
                                          daysLeft: daysLeft,
                                          isApplied: isApplied,
                                          isSaved: isSaved,
                                          onTap: () =>
                                              _showRekomendasiJobDetail(
                                                rekomendasi,
                                              ),
                                          onBookmarkToggle:
                                              (lowonganId, currentlySaved) =>
                                                  _toggleSaveJob(
                                                    lowonganId,
                                                    currentlySaved,
                                                  ),
                                        ),
                                      );
                                    }
                                  }
                                  return null;
                                }, childCount: displayData.length),
                              ),

                            if (_isSearching && _isLoading && isTabSemua)
                              const SliverToBoxAdapter(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              ),

                            if (!_isSearching && _isLoadingMore && isTabSemua)
                              const SliverToBoxAdapter(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              ),

                            if (!_hasMoreData &&
                                displayData.isNotEmpty &&
                                !_isSearching &&
                                isTabSemua)
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

  Widget _buildEmptyState({
    bool isSearching = false,
    String searchQuery = '',
    bool isRekomendasiTab = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(40),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(
            isSearching
                ? Icons.search_off
                : isRekomendasiTab
                ? Icons.psychology_outlined
                : Icons.work_outline,
            size: 60,
            color: const Color(0xFFB8B8B8),
          ),
          const SizedBox(height: 16),
          Text(
            isSearching
                ? 'Tidak ditemukan lowongan\nuntuk "$searchQuery"'
                : isRekomendasiTab
                ? 'Belum ada rekomendasi untuk Anda'
                : 'Belum ada lowongan',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              color: Color(0xFF515151),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isSearching
                ? 'Coba kata kunci lain'
                : isRekomendasiTab
                ? 'Lengkapi profil Anda untuk mendapatkan rekomendasi'
                : 'Coba lagi nanti',
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins',
              color: Color(0xFFB8B8B8),
            ),
          ),
          if (isSearching) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _clearSearch,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E40AF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Kembali ke Semua Lowongan',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
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

// Filter Tabs
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallDevice = screenWidth < 360;
    
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallDevice ? 12 : 15,
        vertical: 15,
      ),
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
                  SizedBox(width: isSmallDevice ? 4 : 6),
                  // Tab Semua
                  _TabButton(
                    label: 'Semua',
                    isSelected: selectedTab == 0,
                    onTap: () => onTabChanged(0),
                    width: isSmallDevice ? 100 : 136,
                    isSmallDevice: isSmallDevice,
                  ),
                  SizedBox(width: isSmallDevice ? 6 : 10),
                  // Tab Rekomendasi AI
                  _TabButton(
                    label: 'Rekomendasi AI',
                    isSelected: selectedTab == 1,
                    onTap: () => onTabChanged(1),
                    isFlexible: true,
                    isSmallDevice: isSmallDevice,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 5),
          // Filter button - SELALU TAMPIL
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

// Tab Button
class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final double? width;
  final bool isFlexible;
  final bool isSmallDevice;

  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.width,
    this.isFlexible = false,
    this.isSmallDevice = false,
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
        padding: isFlexible 
            ? EdgeInsets.symmetric(horizontal: isSmallDevice ? 10 : 16)
            : null,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF2345F7).withValues(alpha: 0.7)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: isSmallDevice ? 12 : 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );

    return isFlexible ? Expanded(child: widget) : widget;
  }
}

// Job Card untuk tab Semua
class _JobCard extends StatefulWidget {
  final LokerUmum lowongan;
  final bool isUrgent;
  final int daysLeft;
  final bool isApplied;
  final bool isSaved;
  final VoidCallback onTap;
  final Function(String, bool) onBookmarkToggle;

  const _JobCard({
    required this.lowongan,
    required this.isUrgent,
    required this.daysLeft,
    required this.isApplied,
    required this.isSaved,
    required this.onTap,
    required this.onBookmarkToggle,
  });

  @override
  State<_JobCard> createState() => __JobCardState();
}

class __JobCardState extends State<_JobCard>
    with SingleTickerProviderStateMixin {
  late bool isSaved;
  late AnimationController _bookmarkController;
  late Animation<double> _bookmarkScale;

  @override
  void initState() {
    super.initState();
    isSaved = widget.isSaved;
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
    widget.onBookmarkToggle(widget.lowongan.lowonganId, !isSaved);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth - 32; // 16 padding kiri + 16 padding kanan
    final cardHeight = 235.0; // Tinggi sama dengan card Rekomendasi AI

    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: cardWidth,
        height: cardHeight,
        child: Stack(
          children: [
            // Background - sama dengan Rekomendasi AI
            Container(
              width: cardWidth,
              height: cardHeight,
              decoration: ShapeDecoration(
                color: const Color(0xFFF0F4F9),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color(0xFFC7C7C7)),
                  borderRadius: BorderRadius.circular(cardWidth * 0.102),
                ),
              ),
            ),

            // Main card - tanpa border biru dan shadow khusus
            Container(
              width: cardWidth,
              height: cardHeight,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color(0xFFC7C7C7)),
                  borderRadius: BorderRadius.circular(cardWidth * 0.102),
                ),
              ),
              child: Stack(
                children: [
                  // Badge urgent (kiri atas) - hanya jika urgent
                  if (widget.isUrgent && !widget.isApplied)
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width: cardWidth * 0.45,
                        height: cardHeight * 0.119,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0E37EB),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(cardWidth * 0.102),
                            bottomRight: Radius.circular(cardWidth * 0.058),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.bolt,
                              color: Color(0xFFFFCC00),
                              size: 14,
                            ),
                            SizedBox(width: cardWidth * 0.012),
                            Text(
                              widget.daysLeft == 0
                                  ? 'Hari terakhir!'
                                  : '${widget.daysLeft} hari lagi',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth * 0.029,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Badge sudah dilamar (kanan atas) - hanya jika sudah dilamar
                  if (widget.isApplied)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: cardWidth * 0.45,
                        height: cardHeight * 0.119,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(cardWidth * 0.102),
                            bottomLeft: Radius.circular(cardWidth * 0.058),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 14,
                            ),
                            SizedBox(width: cardWidth * 0.012),
                            const Text(
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

                  Padding(
                    padding: EdgeInsets.all(cardWidth * 0.058),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: cardHeight * 0.119),

                        // Company logo and info - ukuran font sama dengan Rekomendasi AI
                        Row(
                          children: [
                            Container(
                              width: cardWidth * 0.117,
                              height: cardWidth * 0.105,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: widget.lowongan.logo.isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(
                                          widget.lowongan.logo,
                                        ),
                                        fit: BoxFit.contain,
                                      )
                                    : const DecorationImage(
                                        image: AssetImage("images/poltek.png"),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            SizedBox(width: cardWidth * 0.058),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.lowongan.posisi,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: screenWidth * 0.042,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      height: 1.25,
                                      letterSpacing: -0.24,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.lowongan.namaPerusahaan,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: const Color(0x993C3C43),
                                      fontSize: screenWidth * 0.037,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      height: 1.29,
                                      letterSpacing: -0.08,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: _toggleBookmark,
                              child: ScaleTransition(
                                scale: _bookmarkScale,
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 200),
                                    child: isSaved
                                        ? const Icon(
                                            Icons.bookmark,
                                            key: ValueKey('saved'),
                                            color: Color(0xFF0118D8),
                                            size: 20,
                                          )
                                        : Icon(
                                            Icons.bookmark_border,
                                            key: const ValueKey('unsaved'),
                                            color: Colors.black.withOpacity(
                                              0.3,
                                            ),
                                            size: 20,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: cardHeight * 0.085),

                        // Salary - ukuran font sama dengan Rekomendasi AI
                        Text(
                          _formatSalaryValue(widget.lowongan.gaji),
                          style: TextStyle(
                            color: const Color(0xFF40403F),
                            fontSize: screenWidth * 0.047,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            height: 1.11,
                            letterSpacing: -0.24,
                          ),
                        ),

                        SizedBox(height: cardHeight * 0.068),

                        // Tags - ukuran font sama dengan Rekomendasi AI
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: cardWidth * 0.035,
                                vertical: cardHeight * 0.017,
                              ),
                              decoration: ShapeDecoration(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    width: 1,
                                    color: Color(0xFFC7C7C7),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                widget.lowongan.lokasi.length > 20
                                    ? '${widget.lowongan.lokasi.substring(0, 20)}...'
                                    : widget.lowongan.lokasi,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: screenWidth * 0.032,
                                  fontFamily: 'SF Pro',
                                  fontWeight: FontWeight.w400,
                                  height: 1.43,
                                  letterSpacing: -0.50,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: cardWidth * 0.035,
                                vertical: cardHeight * 0.017,
                              ),
                              decoration: ShapeDecoration(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    width: 1,
                                    color: Color(0xFFC7C7C7),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                widget.lowongan.jenisPekerjaan,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: screenWidth * 0.032,
                                  fontFamily: 'SF Pro',
                                  fontWeight: FontWeight.w400,
                                  height: 1.43,
                                  letterSpacing: -0.50,
                                ),
                              ),
                            ),
                            if (widget.lowongan.opsiKerjaRemote)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: cardWidth * 0.035,
                                  vertical: cardHeight * 0.017,
                                ),
                                decoration: ShapeDecoration(
                                  color: const Color.fromARGB(
                                    255,
                                    255,
                                    255,
                                    255,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                      width: 1,
                                      color: Color(0xFFC7C7C7),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Remote',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontFamily: 'SF Pro',
                                    fontWeight: FontWeight.w400,
                                    height: 1.43,
                                    letterSpacing: -0.50,
                                  ),
                                ),
                              ),
                          ],
                        ),

                        const Spacer(),

                        // Posted time and number of applicants - ukuran font sama dengan Rekomendasi AI
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatTimeAgo(widget.lowongan.tanggalPosting),
                              style: TextStyle(
                                color: const Color(0xFF464E5E),
                                fontSize: screenWidth * 0.032,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w400,
                                height: 2,
                              ),
                            ),
                            Text(
                              '${widget.lowongan.jumlahPelamar} pelamar',
                              style: TextStyle(
                                color: const Color(0xFF464E5E),
                                fontSize: screenWidth * 0.032,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w400,
                                height: 2,
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
          ],
        ),
      ),
    );
  }

  String _formatSalaryValue(String gaji) {
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

// Job Card untuk tab Rekomendasi AI
class _RekomendasiJobCard extends StatefulWidget {
  final LokerRekomendasi rekomendasi;
  final bool isUrgent;
  final int daysLeft;
  final bool isApplied;
  final bool isSaved;
  final VoidCallback onTap;
  final Function(String, bool) onBookmarkToggle;

  const _RekomendasiJobCard({
    required this.rekomendasi,
    required this.isUrgent,
    required this.daysLeft,
    required this.isApplied,
    required this.isSaved,
    required this.onTap,
    required this.onBookmarkToggle,
  });

  @override
  State<_RekomendasiJobCard> createState() => __RekomendasiJobCardState();
}

class __RekomendasiJobCardState extends State<_RekomendasiJobCard>
    with SingleTickerProviderStateMixin {
  late bool isSaved;
  late AnimationController _bookmarkController;
  late Animation<double> _bookmarkScale;

  // Tambahkan variabel untuk responsive design
  late double screenWidth;
  late double cardWidth;
  late double cardHeight;

  @override
  void initState() {
    super.initState();
    isSaved = widget.isSaved;
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
    widget.onBookmarkToggle(widget.rekomendasi.lowonganId, !isSaved);
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    cardWidth = screenWidth - 32; // 16 padding kiri + 16 padding kanan
    cardHeight = 235; // Sesuaikan dengan tinggi card yang diinginkan

    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: cardWidth,
        height: cardHeight,
        child: Stack(
          children: [
            // Background
            Container(
              width: cardWidth,
              height: cardHeight,
              decoration: ShapeDecoration(
                color: const Color(0xFFF0F4F9),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color(0xFFC7C7C7)),
                  borderRadius: BorderRadius.circular(cardWidth * 0.102),
                ),
              ),
            ),

            // Main card dengan border biru dan shadow
            Container(
              width: cardWidth,
              height: cardHeight,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 3, color: Color(0xFF0118D8)),
                  borderRadius: BorderRadius.circular(cardWidth * 0.102),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0xFF9FAAFF),
                    blurRadius: 20,
                    offset: Offset(0, 0),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Badge kecocokan AI (kiri atas)
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      width: cardWidth * 0.45,
                      height: cardHeight * 0.119,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0E37EB),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(cardWidth * 0.102),
                          bottomRight: Radius.circular(cardWidth * 0.058),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Color(0xFFFFCC00),
                            size: 14,
                          ),
                          SizedBox(width: cardWidth * 0.012),
                          Text(
                            '${widget.rekomendasi.kecocokan}% cocok',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.029,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Badge sudah dilamar (kanan atas) - hanya jika sudah dilamar
                  if (widget.isApplied)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: cardWidth * 0.45,
                        height: cardHeight * 0.119,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(cardWidth * 0.102),
                            bottomLeft: Radius.circular(cardWidth * 0.058),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 14,
                            ),
                            SizedBox(width: cardWidth * 0.012),
                            const Text(
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

                  // Badge hari tersisa (jika kurang dari 10 hari)
                  // if (widget.isUrgent && !widget.isApplied)
                  //   Positioned(
                  //     right: 0,
                  //     top: 0,
                  //     child: Container(
                  //       width: cardWidth * 0.35,
                  //       height: cardHeight * 0.119,
                  //       decoration: BoxDecoration(
                  //         color: const Color(0xFFFF6B6B),
                  //         borderRadius: BorderRadius.only(
                  //           topRight: Radius.circular(cardWidth * 0.102),
                  //           bottomLeft: Radius.circular(cardWidth * 0.058),
                  //         ),
                  //       ),
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           const Icon(
                  //             Icons.bolt,
                  //             color: Colors.white,
                  //             size: 14,
                  //           ),
                  //           SizedBox(width: cardWidth * 0.012),
                  //           Text(
                  //             widget.daysLeft == 0
                  //                 ? 'Hari terakhir!'
                  //                 : '${widget.daysLeft} hari',
                  //             style: TextStyle(
                  //               color: Colors.white,
                  //               fontSize: screenWidth * 0.029,
                  //               fontFamily: 'Poppins',
                  //               fontWeight: FontWeight.w600,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  Padding(
                    padding: EdgeInsets.all(cardWidth * 0.058),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: cardHeight * 0.119),

                        // Company logo and info
                        Row(
                          children: [
                            Container(
                              width: cardWidth * 0.117,
                              height: cardWidth * 0.105,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: widget.rekomendasi.logo.isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(
                                          widget.rekomendasi.logo,
                                        ),
                                        fit: BoxFit.contain,
                                      )
                                    : const DecorationImage(
                                        image: AssetImage("images/poltek.png"),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            SizedBox(width: cardWidth * 0.058),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.rekomendasi.posisi,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: screenWidth * 0.042,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      height: 1.25,
                                      letterSpacing: -0.24,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.rekomendasi.namaPerusahaan,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: const Color(0x993C3C43),
                                      fontSize: screenWidth * 0.037,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      height: 1.29,
                                      letterSpacing: -0.08,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: _toggleBookmark,
                              child: ScaleTransition(
                                scale: _bookmarkScale,
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 200),
                                    child: isSaved
                                        ? const Icon(
                                            Icons.bookmark,
                                            key: ValueKey('saved'),
                                            color: Color(0xFF0118D8),
                                            size: 20,
                                          )
                                        : Icon(
                                            Icons.bookmark_border,
                                            key: const ValueKey('unsaved'),
                                            color: Colors.black.withOpacity(
                                              0.3,
                                            ),
                                            size: 20,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: cardHeight * 0.085),

                        // Salary
                        Text(
                          _formatSalaryValue(widget.rekomendasi.gaji),
                          style: TextStyle(
                            color: const Color(0xFF40403F),
                            fontSize: screenWidth * 0.047,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            height: 1.11,
                            letterSpacing: -0.24,
                          ),
                        ),

                        SizedBox(height: cardHeight * 0.068),

                        // Tags
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: cardWidth * 0.035,
                                vertical: cardHeight * 0.017,
                              ),
                              decoration: ShapeDecoration(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    width: 1,
                                    color: Color(0xFFC7C7C7),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                widget.rekomendasi.lokasi.length > 20
                                    ? '${widget.rekomendasi.lokasi.substring(0, 20)}...'
                                    : widget.rekomendasi.lokasi,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: screenWidth * 0.032,
                                  fontFamily: 'SF Pro',
                                  fontWeight: FontWeight.w400,
                                  height: 1.43,
                                  letterSpacing: -0.50,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: cardWidth * 0.035,
                                vertical: cardHeight * 0.017,
                              ),
                              decoration: ShapeDecoration(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    width: 1,
                                    color: Color(0xFFC7C7C7),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                widget.rekomendasi.jenisPekerjaan,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: screenWidth * 0.032,
                                  fontFamily: 'SF Pro',
                                  fontWeight: FontWeight.w400,
                                  height: 1.43,
                                  letterSpacing: -0.50,
                                ),
                              ),
                            ),
                            if (widget.rekomendasi.opsiKerjaRemote)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: cardWidth * 0.035,
                                  vertical: cardHeight * 0.017,
                                ),
                                decoration: ShapeDecoration(
                                  color: const Color.fromARGB(
                                    255,
                                    255,
                                    255,
                                    255,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                      width: 1,
                                      color: Color(0xFFC7C7C7),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Remote',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontFamily: 'SF Pro',
                                    fontWeight: FontWeight.w400,
                                    height: 1.43,
                                    letterSpacing: -0.50,
                                  ),
                                ),
                              ),
                          ],
                        ),

                        const Spacer(),

                        // Posted time and number of applicants
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatTimeAgo(widget.rekomendasi.tanggalPosting),
                              style: TextStyle(
                                color: const Color(0xFF464E5E),
                                fontSize: screenWidth * 0.032,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w400,
                                height: 2,
                              ),
                            ),
                            Text(
                              '${widget.rekomendasi.jumlahPelamar} pelamar',
                              style: TextStyle(
                                color: const Color(0xFF464E5E),
                                fontSize: screenWidth * 0.032,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w400,
                                height: 2,
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
          ],
        ),
      ),
    );
  }

  String _formatSalaryValue(String gaji) {
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

// Skeleton loader
class _JobCardSkeleton extends StatelessWidget {
  const _JobCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 32);

    return Stack(
      children: [
        Container(
          width: cardWidth,
          height: 235,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: ShapeDecoration(
            color: const Color(0xFFF0F4F9),
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Color(0xFFC7C7C7)),
              borderRadius: BorderRadius.circular(35),
            ),
          ),
        ),

        Container(
          width: cardWidth,
          height: 235,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Color(0xFFC7C7C7)),
              borderRadius: BorderRadius.circular(35),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 28),
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(width: 20),
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
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  width: 100,
                  height: 18,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      width: 80,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 50,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
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
        ),
      ],
    );
  }
}

// Filter Bottom Sheet (tetap sama seperti kode asli)
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

  // GANTI: Hapus daftar lokasi statik dan ganti dengan variabel untuk data API
  List<String> _lokasiOptions = []; // Data dari API akan disimpan di sini
  bool _isLoadingLocations = false;

  final ScrollController _scrollController = ScrollController();
  final ApiService _apiService = ApiService(); // Tambahkan ApiService

  @override
  void initState() {
    super.initState();
    _selectedFilters = Map<String, dynamic>.from(widget.currentFilters);
    _searchController.text = _selectedFilters['lokasi'] ?? '';

    // GANTI: Panggil fungsi untuk load data lokasi dari API
    _loadLocations();

    _searchFocusNode.addListener(_onFocusChange);
  }

  // TAMBAH: Method untuk reset filter di dalam bottom sheet
  void _resetFilters() {
    setState(() {
      _selectedFilters = {
        'jenisPekerjaan': '',
        'lokasi': '',
        'gaji': '',
        'minimalLulusan': '',
        'remote': null,
      };
      _searchController.text = '';
      _showDropdown = false;
    });

    // Juga panggil reset dari parent
    widget.onResetFilters();

    print("🔄 Filters reset in bottom sheet");
  }

  // TAMBAH: Method untuk load data lokasi dari API
  Future<void> _loadLocations() async {
    setState(() {
      _isLoadingLocations = true;
    });

    try {
      final locations = await _apiService.getLocations();
      setState(() {
        _lokasiOptions = locations;
        _filteredLocations = locations; // Set initial filtered data
      });
      print("✅ Locations loaded from API: ${locations.length} items");
    } catch (e) {
      print("❌ Error loading locations: $e");
      // Fallback ke data lokal jika API error
      _setFallbackLocations();
    } finally {
      setState(() {
        _isLoadingLocations = false;
      });
    }
  }

  // TAMBAH: Fallback data jika API error
  void _setFallbackLocations() {
    setState(() {
      _lokasiOptions = [
        'Batam',
        'Jakarta',
        'Surabaya',
        'Yogyakarta',
        'Semarang',
        'Tanjung Pinang',
        'Medan',
        'Makassar',
        'Palembang',
        'Malang',
        'Solo',
        'Bogor',
        'Tangerang',
        'Bekasi',
        'Depok',
      ];
      _filteredLocations = _lokasiOptions;
    });
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
            .where(
              (location) =>
                  location.toLowerCase().contains(value.toLowerCase()),
            )
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
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
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
                      onPressed: _resetFilters,
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
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Jenis Pekerjaan
                  _buildFilterSection(
                    title: 'Jenis Pekerjaan',
                    options: [
                      'Full Time',
                      'Part Time',
                      'Contract',
                      'Insternship',
                      'Freelance',
                    ],
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

                  // Filter Remote
                  _buildRemoteFilter(),

                  const SizedBox(height: 25),

                  // Tingkat minimalLulusan
                  _buildMinimalLulusanDropdown(),

                  const SizedBox(height: 25),
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

        // TAMBAH: Loading state
        if (_isLoadingLocations)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          )
        else
          Column(
            children: [
              // Input Field dengan Dropdown di bawahnya
              Column(
                children: [
                  // Input Field
                  GestureDetector(
                    onTap: _openDropdown,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _showDropdown
                              ? const Color(0xFF1E40AF)
                              : Colors.grey.shade300,
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
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          suffixIcon:
                              _selectedFilters['lokasi']?.isNotEmpty ?? false
                              ? IconButton(
                                  icon: const Icon(Icons.close, size: 18),
                                  onPressed: _clearLocation,
                                )
                              : Icon(
                                  _showDropdown
                                      ? Icons.arrow_drop_up
                                      : Icons.arrow_drop_down,
                                  color: Colors.grey.shade600,
                                ),
                        ),
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                        ),
                        onTap: _openDropdown,
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
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            visualDensity: const VisualDensity(vertical: -4),
                          );
                        },
                      ),
                    ),
                ],
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

  // ✅ Filter untuk Opsi Kerja - GAYA BUTTON SEPERTI JENIS PEKERJAAN
  Widget _buildRemoteFilter() {
    // Definisikan opsi dengan tipe yang benar
    final List<Map<String, dynamic>> opsiKerjaOptions = [
      {'label': 'Dikantor', 'value': false}, // false = Dikantor
      {'label': 'Remote', 'value': true}, // true = Remote
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Opsi Kerja',
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
          children: opsiKerjaOptions.map((option) {
            // Pastikan tipe data sesuai
            final String label = option['label'] as String;
            final bool value = option['value'] as bool;
            final isSelected = _selectedFilters['remote'] == value;

            return GestureDetector(
              onTap: () {
                setState(() {
                  // Jika opsi yang sama diklik lagi, reset ke null (tidak ada pilihan)
                  if (isSelected) {
                    _selectedFilters['remote'] = null;
                  } else {
                    _selectedFilters['remote'] = value;
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF1E40AF) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF1E40AF)
                        : Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey.shade700,
                    fontFamily: 'Poppins',
                    fontSize: 12,
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        // Selected Filter Chip - HANYA tampil jika user memilih
        const SizedBox(height: 8),
        if (_selectedFilters['remote'] != null)
          _buildSelectedFilterChip(
            _selectedFilters['remote'] == true ? 'Remote' : 'Dikantor',
            onRemove: () {
              setState(() {
                _selectedFilters['remote'] = null;
              });
            },
          ),
      ],
    );
  }

  // ✅ Widget untuk menampilkan chip filter yang dipilih
  Widget _buildSelectedFilterChip(
    String label, {
    required VoidCallback onRemove,
  }) {
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
            child: const Icon(Icons.close, color: Colors.white, size: 14),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF1E40AF) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF1E40AF)
                        : Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey.shade700,
                    fontFamily: 'Poppins',
                    fontSize: 12,
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
      {'label': 'Dibawah Rp 10 juta', 'value': '0-5'}, // below10m
      {'label': 'Rp 10 - 20 juta', 'value': '5-10'}, // 10m-20m
      {'label': 'Diatas Rp 20 juta', 'value': '10+'}, // above20m
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF1E40AF) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF1E40AF)
                        : Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  option['label']!,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey.shade700,
                    fontFamily: 'Poppins',
                    fontSize: 12,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ✅ Dropdown untuk Minimal Lulusan (seperti lokasi tanpa search)
  Widget _buildMinimalLulusanDropdown() {
    final pendidikanOptions = [
      'SMA',
      'SMK',
      'D1',
      'D2',
      'D3',
      'D4',
      'S1',
      'S2',
      'S3',
    ];

    bool _showPendidikanDropdown = false;
    final FocusNode _pendidikanFocusNode = FocusNode();

    return StatefulBuilder(
      builder: (context, setState) {
        void _togglePendidikanDropdown() {
          setState(() {
            _showPendidikanDropdown = !_showPendidikanDropdown;
          });
          if (_showPendidikanDropdown) {
            _pendidikanFocusNode.requestFocus();
          } else {
            _pendidikanFocusNode.unfocus();
          }
        }

        void _selectPendidikan(String pendidikan) {
          setState(() {
            _selectedFilters['minimalLulusan'] = pendidikan;
            _showPendidikanDropdown = false;
            _pendidikanFocusNode.unfocus();
          });
        }

        void _clearPendidikan() {
          setState(() {
            _selectedFilters['minimalLulusan'] = '';
            _showPendidikanDropdown = true;
            _pendidikanFocusNode.requestFocus();
          });
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Minimal Lulusan',
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
                  onTap: _togglePendidikanDropdown,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _showPendidikanDropdown
                            ? const Color(0xFF1E40AF)
                            : Colors.grey.shade300,
                        width: _showPendidikanDropdown ? 2 : 1,
                      ),
                    ),
                    child: TextField(
                      controller: TextEditingController(
                        text: _selectedFilters['minimalLulusan'] ?? '',
                      ),
                      focusNode: _pendidikanFocusNode,
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: 'Pilih minimal lulusan...',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Poppins',
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        suffixIcon:
                            _selectedFilters['minimalLulusan']?.isNotEmpty ??
                                false
                            ? IconButton(
                                icon: const Icon(Icons.close, size: 18),
                                onPressed: _clearPendidikan,
                              )
                            : Icon(
                                _showPendidikanDropdown
                                    ? Icons.arrow_drop_up
                                    : Icons.arrow_drop_down,
                                color: Colors.grey.shade600,
                              ),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                // Dropdown List - TAMPIL LANGSUNG DI BAWAH INPUT
                if (_showPendidikanDropdown && pendidikanOptions.isNotEmpty)
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
                      itemCount: pendidikanOptions.length,
                      itemBuilder: (context, index) {
                        final pendidikan = pendidikanOptions[index];
                        final isSelected =
                            _selectedFilters['minimalLulusan'] == pendidikan;
                        return ListTile(
                          title: Text(
                            pendidikan,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              color: isSelected
                                  ? const Color(0xFF1E40AF)
                                  : Colors.black,
                            ),
                          ),
                          onTap: () => _selectPendidikan(pendidikan),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          visualDensity: const VisualDensity(vertical: -4),
                          trailing: isSelected
                              ? const Icon(
                                  Icons.check,
                                  color: Color(0xFF1E40AF),
                                  size: 16,
                                )
                              : null,
                        );
                      },
                    ),
                  ),
              ],
            ),

            // Selected Filter Chip
            const SizedBox(height: 8),
            if (_selectedFilters['minimalLulusan']?.isNotEmpty ?? false)
              _buildSelectedFilterChip(
                'Minimal Lulusan: ${_selectedFilters['minimalLulusan']}',
                onRemove: _clearPendidikan,
              ),
          ],
        );
      },
    );
  }
}
