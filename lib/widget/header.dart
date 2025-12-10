import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jobfair/api/route.dart'; 
import 'package:jobfair/screens/halaman_notifikasi.dart';
import 'package:jobfair/screens/halaman_bookmark.dart';

class HeaderWidget extends StatefulWidget {
  final bool showNotification;
  final bool showFilter;
  final bool showBookmark;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onFilterTap;
  final VoidCallback? onBookmarkTap;
  final Function(String)? onSearch; // Untuk real-time search
  final TextEditingController? externalSearchController;
  final bool enableNavigation; // TAMBAH: Enable navigation ke halaman cari loker
  final String? searchRoute; // TAMBAH: Route untuk navigasi search
  final Map<String, dynamic>? navigationArguments; // TAMBAH: Arguments untuk navigation

  const HeaderWidget({
    super.key,
    this.showNotification = true,
    this.showFilter = false,
    this.showBookmark = true,
    this.onNotificationTap,
    this.onFilterTap,
    this.onBookmarkTap,
    this.onSearch,
    this.externalSearchController,
    this.enableNavigation = false, // TAMBAH
    this.searchRoute, // TAMBAH
    this.navigationArguments, // TAMBAH
  });

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  late TextEditingController _searchController;
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearching = false;
  List<String> _searchHistory = [];
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    
    _searchController = widget.externalSearchController ?? TextEditingController();
    _loadSearchHistory();
    _searchFocusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(HeaderWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.externalSearchController != oldWidget.externalSearchController) {
      _searchController.dispose();
      _searchController = widget.externalSearchController ?? TextEditingController();
    }
  }

  @override
  void dispose() {
    if (widget.externalSearchController == null) {
      _searchController.dispose();
    }
    _searchFocusNode.removeListener(_onFocusChange);
    _searchFocusNode.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onFocusChange() {
    if (_searchFocusNode.hasFocus) {
      setState(() {
        _isSearching = true;
      });
    } else {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          setState(() {
            _isSearching = false;
          });
        }
      });
    }
  }

  void _loadSearchHistory() {
    setState(() {
      _searchHistory = [];
    });
  }

  void _saveSearchHistory(String query) {
    if (query.trim().isNotEmpty) {
      setState(() {
        _searchHistory.removeWhere((item) => item.toLowerCase() == query.toLowerCase());
        _searchHistory.insert(0, query);
        if (_searchHistory.length > 5) {
          _searchHistory = _searchHistory.sublist(0, 5);
        }
      });
    }
  }

  void _handleSearchSubmitted(String query) {
    if (query.trim().isNotEmpty) {
      _saveSearchHistory(query);
      
      // Jika ada callback onSearch, panggil
      if (widget.onSearch != null) {
        widget.onSearch!(query.trim());
      }
      
      // TAMBAH: Jika enableNavigation true, navigate ke halaman cari loker
      if (widget.enableNavigation) {
        _navigateToSearchPage(query.trim());
      }
      
      _searchFocusNode.unfocus();
      setState(() {
        _isSearching = false;
      });
    }
  }

  // TAMBAH: Method untuk navigate ke halaman cari loker
  void _navigateToSearchPage(String query) {
    final route = widget.searchRoute ?? AppRoutes.cariLoker; // Default route
    
    // Siapkan arguments
    final arguments = {
      'initialSearchQuery': query,
      ...?widget.navigationArguments, // Gabungkan dengan arguments tambahan
    };
    
    // Navigate ke halaman search
    Navigator.pushNamed(
      context,
      route,
      arguments: arguments,
    );
    
    // Clear search controller jika diperlukan
    _searchController.clear();
  }

  void _clearSearch() {
    _searchController.clear();
    
    // Jika ada callback onSearch, beritahu bahwa search di-clear
    if (widget.onSearch != null) {
      widget.onSearch!('');
    }
    
    _searchFocusNode.unfocus();
  }

  void _onSearchChanged(String value) {
    _debounceTimer?.cancel();
    
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (widget.onSearch != null) {
        widget.onSearch!(value.trim());
      }
    });
  }

  void _handleBookmarkTap() {
    if (widget.onBookmarkTap != null) {
      widget.onBookmarkTap!();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HalamanBookmark(),
        ),
      );
    }
  }

  void _handleNotificationTap() {
    if (widget.onNotificationTap != null) {
      widget.onNotificationTap!();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const NotificationPage(),
        ),
      );
    }
  }

  void _handleFilterTap() {
    widget.onFilterTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1B56FD), Color(0xFF0118D8)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 12,
            bottom: 16,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  // Search bar
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(50),
                        border: _searchFocusNode.hasFocus 
                            ? Border.all(
                                color: Colors.white,
                                width: 1.0,
                              )
                            : null,
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 20),
                          const Icon(Icons.search, color: Colors.white, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              focusNode: _searchFocusNode,
                              cursorColor: Colors.white,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                                isDense: true,
                                hintText: 'Cari lowongan kerja...',
                                hintStyle: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                              onSubmitted: _handleSearchSubmitted,
                              onChanged: _onSearchChanged,
                            ),
                          ),
                          if (_searchController.text.isNotEmpty)
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.white, size: 18),
                              onPressed: _clearSearch,
                            ),
                          const SizedBox(width: 12),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // BOOKMARK ICON
                  if (widget.showBookmark)
                    GestureDetector(
                      onTap: _handleBookmarkTap,
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.bookmark_border,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  
                  if (widget.showBookmark && widget.showNotification) const SizedBox(width: 12),
                  
                  // Notification button
                  if (widget.showNotification)
                    GestureDetector(
                      onTap: _handleNotificationTap,
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.notifications_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  
                  if (widget.showNotification && widget.showFilter) const SizedBox(width: 12),
                  
                  // Filter button
                  if (widget.showFilter)
                    GestureDetector(
                      onTap: _handleFilterTap,
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.tune,
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
    );
  }
}