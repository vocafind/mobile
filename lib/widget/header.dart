import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:jobfair/screens/halaman_notifikasi.dart';
import 'package:jobfair/screens/halaman_bookmark.dart';

class HeaderWidget extends StatefulWidget {
  final bool showNotification;
  final bool showFilter;
  final bool showBookmark;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onFilterTap;
  final VoidCallback? onBookmarkTap;
  final Function(String)? onSearch;

  const HeaderWidget({
    super.key,
    this.showNotification = true,
    this.showFilter = false,
    this.showBookmark = true,
    this.onNotificationTap,
    this.onFilterTap,
    this.onBookmarkTap,
    this.onSearch,
  });

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearching = false;
  List<String> _searchHistory = [];
  final LayerLink _layerLink = LayerLink();

  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
    _searchFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.removeListener(_onFocusChange);
    _searchFocusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onFocusChange() {
    if (_searchFocusNode.hasFocus) {
      setState(() {
        _isSearching = true;
      });
      _showSearchOverlay();
    } else {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          setState(() {
            _isSearching = false;
          });
          _removeOverlay();
        }
      });
    }
  }

  void _loadSearchHistory() {
    // Untuk simulasi, kita mulai dengan list kosong
    // Nanti akan terisi setelah user melakukan pencarian
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

  void _handleSearch(String query) {
    if (query.trim().isNotEmpty) {
      _saveSearchHistory(query);
      if (widget.onSearch != null) {
        widget.onSearch!(query);
      }
      _searchFocusNode.unfocus();
      setState(() {
        _isSearching = false;
      });
      _removeOverlay();
    }
  }

  void _clearSearch() {
    _searchController.clear();
    if (widget.onSearch != null) {
      widget.onSearch!('');
    }
    _removeOverlay();
  }

  // ✅ Method untuk menampilkan overlay
  void _showSearchOverlay() {
    // ✅ Jangan tampilkan overlay jika tidak ada riwayat pencarian
    if (_searchHistory.isEmpty) {
      return;
    }

    _removeOverlay(); // Hapus overlay sebelumnya jika ada
    
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx + 20,
        top: offset.dy + size.height - 12,
        width: size.width - 40,
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Pencarian Terakhir',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF666666),
                    ),
                  ),
                ),
                ..._searchHistory.map((history) => ListTile(
                  leading: const Icon(Icons.history, color: Color(0xFF999999), size: 20),
                  title: Text(
                    history,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    _searchController.text = history;
                    _handleSearch(history);
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.close, size: 16, color: Color(0xFF999999)),
                    onPressed: () {
                      setState(() {
                        _searchHistory.remove(history);
                      });
                      // Jika ini adalah item terakhir, hapus overlay
                      if (_searchHistory.isEmpty) {
                        _removeOverlay();
                      }
                    },
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  minLeadingWidth: 0,
                )).toList(),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  // ✅ Method untuk handle bookmark tap
  void _handleBookmarkTap() {
    _removeOverlay();
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

  // ✅ Method untuk handle notification tap
  void _handleNotificationTap() {
    _removeOverlay();
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

  // ✅ Method untuk handle filter tap
  void _handleFilterTap() {
    _removeOverlay();
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

    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
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
                                  disabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  focusedErrorBorder: InputBorder.none,
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
                                onSubmitted: _handleSearch,
                                onTap: () {
                                  setState(() {
                                    _isSearching = true;
                                  });
                                  _showSearchOverlay();
                                },
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
      ),
    );
  }
}