import 'package:flutter/material.dart';

class RosterHeader extends StatefulWidget {
  final String searchQuery;
  final String selectedElement;
  final int totalCount;
  final List<String> elements;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onElementSelected;

  const RosterHeader({
    super.key,
    required this.searchQuery,
    required this.selectedElement,
    required this.totalCount,
    required this.elements,
    required this.onSearchChanged,
    required this.onElementSelected,
  });

  @override
  State<RosterHeader> createState() => _RosterHeaderState();
}

class _RosterHeaderState extends State<RosterHeader> {
  bool _isExpanded = false;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery);
  }

  @override
  void didUpdateWidget(covariant RosterHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchQuery != _searchController.text) {
      _searchController.value = TextEditingValue(
        text: widget.searchQuery,
        selection: TextSelection.collapsed(offset: widget.searchQuery.length),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Color _getElementColor(String element) {
    switch (element.toLowerCase()) {
      case 'fire':
        return const Color(0xFFEF4444);
      case 'water':
        return const Color(0xFF38BDF8);
      case 'lightning':
        return const Color(0xFFFBBF24);
      case 'dark':
        return const Color(0xFFA855F7);
      default:
        return const Color(0xFFEAB308);
    }
  }

  IconData _getElementIcon(String element) {
    switch (element.toLowerCase()) {
      case 'fire':
        return Icons.local_fire_department_rounded;
      case 'water':
        return Icons.water_drop_rounded;
      case 'lightning':
        return Icons.bolt_rounded;
      case 'dark':
        return Icons.dark_mode_rounded;
      default:
        return Icons.grid_view_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeElementColor = _getElementColor(widget.selectedElement);
    final width = MediaQuery.of(context).size.width;
    final isSmallScreen = width <= 360;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 10 : 16,
        vertical: isSmallScreen ? 4 : 8,
      ),
      padding: EdgeInsets.all(isSmallScreen ? 10 : 14),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF101726).withValues(alpha: 0.92)
            : Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF26334D) : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 8,
            runSpacing: 4,
            children: [
              const Text(
                'CHARACTER ARCHIVES',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFEAB308),
                  letterSpacing: 1.2,
                ),
              ),
              Text(
                '${widget.totalCount} HEROES',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              // Search Field
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: widget.onSearchChanged,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search hero name or class...',
                    hintStyle: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? const Color(0xFF64748B)
                          : const Color(0xFF94A3B8),
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: Color(0xFFEAB308),
                      size: 18,
                    ),
                    suffixIcon: widget.searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.cancel_rounded, size: 16),
                            onPressed: () => widget.onSearchChanged(''),
                          )
                        : null,
                    isDense: true,
                    filled: true,
                    fillColor: isDark
                        ? const Color(0xFF1B2436)
                        : const Color(0xFFF8FAFC),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFCBD5E1),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color(0xFFEAB308),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Inline Filter Expand Button (Terisolasi strictly di Dalam Header Frame)
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: activeElementColor.withValues(
                        alpha: isDark ? 0.25 : 0.15,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: activeElementColor, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: activeElementColor.withValues(alpha: 0.25),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getElementIcon(widget.selectedElement),
                          size: 16,
                          color: activeElementColor,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          widget.selectedElement.toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            color: activeElementColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          _isExpanded
                              ? Icons.arrow_drop_up_rounded
                              : Icons.arrow_drop_down_rounded,
                          size: 18,
                          color: activeElementColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Expanded Inline Elemental Affinity Choice Selector
          if (_isExpanded) ...[
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: widget.elements.map((element) {
                  final isSelected = element == widget.selectedElement;
                  final elemColor = _getElementColor(element);
                  final elemIcon = _getElementIcon(element);

                  return Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: ChoiceChip(
                      avatar: Icon(
                        elemIcon,
                        size: 13,
                        color: isSelected ? Colors.white : elemColor,
                      ),
                      label: Text(
                        element.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors.white
                              : (isDark ? Colors.white70 : Colors.black87),
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: elemColor,
                      backgroundColor: isDark
                          ? const Color(0xFF1B2436)
                          : const Color(0xFFF1F5F9),
                      onSelected: (_) {
                        widget.onElementSelected(element);
                        setState(() => _isExpanded = false);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
