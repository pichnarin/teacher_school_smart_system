import 'package:flutter/material.dart';

class Header extends StatefulWidget implements PreferredSizeWidget {
  final String? logoPath;
  final VoidCallback onNotificationPressed;

  const Header({super.key, this.logoPath, required this.onNotificationPressed});

  @override
  State<Header> createState() => _HeaderState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _HeaderState extends State<Header> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) _searchController.clear();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;

    return AppBar(
      backgroundColor: colorScheme.surfaceContainerHighest,
      elevation: 0,
      scrolledUnderElevation: 3,
      titleSpacing: 16,
      title: Row(
        children: [
          // Logo or placeholder icon
          Container(
            height: kToolbarHeight * 0.7,
            width: kToolbarHeight * 0.7,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                widget.logoPath != null
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(widget.logoPath!, fit: BoxFit.cover),
                    )
                    : Icon(
                      Icons.school_rounded,
                      color: colorScheme.onPrimaryContainer,
                    ),
          ),
          const SizedBox(width: 16),

          // Animated Search Field
          Expanded(
            child: ClipRect(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: kToolbarHeight * 0.7,
                width: _isSearching ? screenWidth - 100 : 0, // Bounded width
                child:
                    _isSearching
                        ? TextField(
                          controller: _searchController,
                          autofocus: true,
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            prefixIcon: Icon(
                              Icons.search,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.close,
                                color: colorScheme.onSurfaceVariant,
                              ),
                              onPressed: _toggleSearch,
                            ),
                            filled: true,
                            fillColor: colorScheme.surfaceContainerLow,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                          ),
                          style: TextStyle(color: colorScheme.onSurface),
                        )
                        : null,
              ),
            ),
          ),

          if (!_isSearching) const SizedBox(width: 16),

          // Search Icon Button (toggle)
          if (!_isSearching)
            IconButton(
              icon: Icon(Icons.search, color: colorScheme.onSurfaceVariant),
              onPressed: _toggleSearch,
              tooltip: 'Search',
            ),

          // Notification Icon
          IconButton(
            icon: Icon(Icons.notifications_rounded, color: colorScheme.primary),
            onPressed: widget.onNotificationPressed,
            tooltip: 'Notifications',
          ),
        ],
      ),
    );
  }
}
