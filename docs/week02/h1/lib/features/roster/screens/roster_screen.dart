import 'package:flutter/material.dart';
import 'package:h1/features/history/screens/history_screen.dart';
import 'package:h1/features/history/services/history_service.dart';
import 'package:h1/features/roster/models/character.dart';
import 'package:h1/features/roster/widgets/character_card.dart';
import 'package:h1/features/roster/widgets/character_detail_dialog.dart';
import 'package:h1/features/roster/widgets/emptystate.dart';
import 'package:h1/features/roster/widgets/roster_drawer.dart';
import 'package:h1/features/roster/widgets/roster_header.dart';
import 'package:h1/features/settings/screens/settings_screen.dart';

enum HarnessScreenPreset { smallPhone, largePhone, tablet }
enum HarnessOrientation { portrait, landscape }
enum HarnessDataPreset { normal, longTitle, zeroItems, items500 }
enum ActiveScreenView { roster, history, settings }

class RosterScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  final bool isDarkMode;

  const RosterScreen({
    super.key,
    this.onToggleTheme,
    this.isDarkMode = true,
  });

  @override
  State<RosterScreen> createState() => _RosterScreenState();
}

class _RosterScreenState extends State<RosterScreen> {
  String _searchQuery = '';
  String _selectedElement = 'All';

  // Device Harness State
  HarnessScreenPreset _screenPreset = HarnessScreenPreset.smallPhone;
  HarnessOrientation _orientation = HarnessOrientation.portrait;
  HarnessDataPreset _dataPreset = HarnessDataPreset.normal;
  ActiveScreenView _activeView = ActiveScreenView.roster;

  bool _keyboardOpen = false;
  late bool _darkMode = widget.isDarkMode;
  bool _notchGestureBar = false;

  Map<String, String>? _selectedCharacterForDetail;
  final List<String> _elements = ['All', 'Fire', 'Water', 'Lightning', 'Dark'];
  final String _bgImagePath = 'assets/charactercard/background.jpg';

  @override
  void initState() {
    super.initState();
    _darkMode = widget.isDarkMode;
  }

  List<Map<String, String>> get _activeSourceList {
    switch (_dataPreset) {
      case HarnessDataPreset.normal:
        return CharacterModel.standardCharacters;
      case HarnessDataPreset.items500:
        return CharacterModel.characters500;
      case HarnessDataPreset.longTitle:
        return CharacterModel.longTextCharacters;
      case HarnessDataPreset.zeroItems:
        return const [];
    }
  }

  List<Map<String, String>> get _filteredCharacters {
    return _activeSourceList.where((char) {
      final matchesSearch = char['name']!.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesElement = _selectedElement == 'All' || char['element'] == _selectedElement;
      return matchesSearch && matchesElement;
    }).toList();
  }

  void _showCharacterDetail(Map<String, String> char) {
    HistoryService.addCharacter(char);
    setState(() {
      _selectedCharacterForDetail = char;
    });
  }

  Widget _buildChoicePill<T>({
    required String label,
    required T value,
    required T groupValue,
    required ValueChanged<T> onSelected,
    bool isDark = false,
  }) {
    final isSelected = value == groupValue;
    final activeBg = isDark ? const Color(0xFF1E3A8A) : const Color(0xFFDCEBFA);
    final activeBorder = isDark ? const Color(0xFF3B82F6) : const Color(0xFF93C5FD);
    final activeText = isDark ? const Color(0xFF93C5FD) : const Color(0xFF1E3A8A);

    final inactiveBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final inactiveBorder = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final inactiveText = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155);

    return InkWell(
      onTap: () => onSelected(value),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? activeBg : inactiveBg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? activeBorder : inactiveBorder,
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              Icon(Icons.check, size: 14, color: activeText),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? activeText : inactiveText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTogglePill({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isDark = false,
  }) {
    final isSelected = value;
    final activeBg = isDark ? const Color(0xFF1E3A8A) : const Color(0xFFDCEBFA);
    final activeBorder = isDark ? const Color(0xFF3B82F6) : const Color(0xFF93C5FD);
    final activeText = isDark ? const Color(0xFF93C5FD) : const Color(0xFF1E3A8A);

    final inactiveBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final inactiveBorder = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final inactiveText = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155);

    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? activeBg : inactiveBg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? activeBorder : inactiveBorder,
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              Icon(Icons.check, size: 14, color: activeText),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? activeText : inactiveText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Left Control Panel (device harness)
  Widget _buildLeftHarnessPanel(bool isDark, double width, double height) {
    return SizedBox(
      width: 290,
      child: Container(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hero Codex · device harness',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Coba semua kombinasi. Buka debug console: pesan "A RenderFlex overflowed by ... pixels" menyebut widget, sumbu, dan jumlah pixel-nya.',
                style: TextStyle(
                  fontSize: 10,
                  color: isDark ? Colors.white60 : Colors.black54,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 16),

              // Screen
              Text('Screen', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isDark ? Colors.white70 : Colors.black87)),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  _buildChoicePill(label: 'Small phone', value: HarnessScreenPreset.smallPhone, groupValue: _screenPreset, onSelected: (v) => setState(() => _screenPreset = v), isDark: isDark),
                  _buildChoicePill(label: 'Large phone', value: HarnessScreenPreset.largePhone, groupValue: _screenPreset, onSelected: (v) => setState(() => _screenPreset = v), isDark: isDark),
                  _buildChoicePill(label: 'Tablet', value: HarnessScreenPreset.tablet, groupValue: _screenPreset, onSelected: (v) => setState(() => _screenPreset = v), isDark: isDark),
                ],
              ),
              const SizedBox(height: 16),

              // Orientation
              Text('Orientation', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isDark ? Colors.white70 : Colors.black87)),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  _buildChoicePill(label: 'Portrait', value: HarnessOrientation.portrait, groupValue: _orientation, onSelected: (v) => setState(() => _orientation = v), isDark: isDark),
                  _buildChoicePill(label: 'Landscape', value: HarnessOrientation.landscape, groupValue: _orientation, onSelected: (v) => setState(() => _orientation = v), isDark: isDark),
                ],
              ),
              const SizedBox(height: 16),

              // Data
              Text('Data', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isDark ? Colors.white70 : Colors.black87)),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  _buildChoicePill(label: 'Normal', value: HarnessDataPreset.normal, groupValue: _dataPreset, onSelected: (v) => setState(() => _dataPreset = v), isDark: isDark),
                  _buildChoicePill(label: '200-char title', value: HarnessDataPreset.longTitle, groupValue: _dataPreset, onSelected: (v) => setState(() => _dataPreset = v), isDark: isDark),
                  _buildChoicePill(label: 'Zero items', value: HarnessDataPreset.zeroItems, groupValue: _dataPreset, onSelected: (v) => setState(() => _dataPreset = v), isDark: isDark),
                  _buildChoicePill(label: '500 items', value: HarnessDataPreset.items500, groupValue: _dataPreset, onSelected: (v) => setState(() => _dataPreset = v), isDark: isDark),
                ],
              ),
              const SizedBox(height: 16),

              // Conditions
              Text('Conditions', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isDark ? Colors.white70 : Colors.black87)),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  _buildTogglePill(label: 'Keyboard open', value: _keyboardOpen, onChanged: (v) => setState(() => _keyboardOpen = v), isDark: isDark),
                  _buildTogglePill(label: 'Dark mode', value: _darkMode, onChanged: (v) {
                    setState(() => _darkMode = v);
                    if (widget.onToggleTheme != null) widget.onToggleTheme!();
                  }, isDark: isDark),
                  _buildTogglePill(label: 'Notch + gesture bar', value: _notchGestureBar, onChanged: (v) => setState(() => _notchGestureBar = v), isDark: isDark),
                ],
              ),
              const SizedBox(height: 24),

              // Realtime Dimension Label
              Text(
                'Screen: ${width.toInt()} × ${height.toInt()} dp',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white54 : Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Inner Application Content View switching dynamically between Roster, History, and Settings
  Widget _buildMainContentView(bool isDark, List<Map<String, String>> filtered) {
    if (_activeView == ActiveScreenView.history) {
      return HistoryScreen(
        onBack: () => setState(() => _activeView = ActiveScreenView.roster),
      );
    }

    if (_activeView == ActiveScreenView.settings) {
      return SettingsScreen(
        isDarkMode: _darkMode,
        onToggleTheme: () {
          if (widget.onToggleTheme != null) widget.onToggleTheme!();
          setState(() => _darkMode = !_darkMode);
        },
        onBack: () => setState(() => _activeView = ActiveScreenView.roster),
      );
    }

    // Default Roster View
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shield_rounded, size: 20, color: Color(0xFFEAB308)),
            SizedBox(width: 8),
            Text(
              'HERO CODEX',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
                fontSize: 16,
              ),
            ),
          ],
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu_rounded, color: Color(0xFFEAB308), size: 24),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      endDrawer: RosterDrawer(
        onOpenHistory: () {
          setState(() => _activeView = ActiveScreenView.history);
        },
        onOpenSettings: () {
          setState(() => _activeView = ActiveScreenView.settings);
        },
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              _bgImagePath,
              fit: BoxFit.cover,
              alignment: Alignment.center,
              errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
            ),
          ),
          // Overlay
          Positioned.fill(
            child: Container(
              color: isDark
                  ? const Color(0xFF090C15).withValues(alpha: 0.45)
                  : const Color(0xFFF6F3EC).withValues(alpha: 0.50),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final crossAxisCount = width <= 360
                    ? 2
                    : (width <= 480
                        ? 3
                        : (width <= 750 ? 4 : 5));
                final childAspectRatio = width <= 360 ? 0.72 : 0.68;

                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: RosterHeader(
                        searchQuery: _searchQuery,
                        selectedElement: _selectedElement,
                        totalCount: filtered.length,
                        elements: _elements,
                        onSearchChanged: (val) => setState(() => _searchQuery = val),
                        onElementSelected: (elem) => setState(() => _selectedElement = elem),
                      ),
                    ),
                    if (filtered.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: RosterEmptyState(
                          onReset: () => setState(() {
                            _searchQuery = '';
                            _selectedElement = 'All';
                            _dataPreset = HarnessDataPreset.normal;
                          }),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                        sliver: SliverGrid(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            childAspectRatio: childAspectRatio,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 10,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final isOdd = index % 2 == 1;
                              final tiltAngle = (index % 4 == 0)
                                  ? -0.025
                                  : ((index % 4 == 1)
                                      ? 0.020
                                      : ((index % 4 == 2) ? -0.015 : 0.025));
                              final verticalOffset = isOdd ? 8.0 : -4.0;

                              return Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.translationValues(0.0, verticalOffset, 0.0)
                                  ..rotateZ(tiltAngle),
                                child: CharacterCard(
                                  character: filtered[index],
                                  onTap: () => _showCharacterDetail(filtered[index]),
                                ),
                              );
                            },
                            childCount: filtered.length,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),

          // Modal Detail Dialog Terisolasi strictly di Dalam Bingkai Frame Perangkat
          if (_selectedCharacterForDetail != null)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => setState(() => _selectedCharacterForDetail = null),
                child: Container(
                  color: Colors.black.withValues(alpha: 0.70),
                  padding: const EdgeInsets.all(12),
                  child: Center(
                    child: SingleChildScrollView(
                      child: GestureDetector(
                        onTap: () {},
                        child: CharacterDetailDialog(
                          character: _selectedCharacterForDetail!,
                          onClose: () => setState(() => _selectedCharacterForDetail = null),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredCharacters;
    final isDark = _darkMode;

    // Calculation of Target Width & Height
    double targetWidth = 320;
    double targetHeight = 568;

    switch (_screenPreset) {
      case HarnessScreenPreset.smallPhone:
        targetWidth = 320;
        targetHeight = 568;
        break;
      case HarnessScreenPreset.largePhone:
        targetWidth = 430;
        targetHeight = 800;
        break;
      case HarnessScreenPreset.tablet:
        targetWidth = 800;
        targetHeight = 850;
        break;
    }

    if (_orientation == HarnessOrientation.landscape) {
      final temp = targetWidth;
      targetWidth = targetHeight;
      targetHeight = temp;
    }

    return Scaffold(
      body: Row(
        children: [
          // 1. LEFT PANEL (device harness)
          _buildLeftHarnessPanel(isDark, targetWidth, targetHeight),

          // 2. RIGHT CANVAS AREA (Centered Device Emulator)
          Expanded(
            child: Container(
              color: isDark ? const Color(0xFF020617) : const Color(0xFFE2E8F0),
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Container(
                    width: targetWidth,
                    height: targetHeight,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF090C15) : const Color(0xFFF6F3EC),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.black, width: 6),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Top Notch Bar
                        if (_notchGestureBar)
                          Container(
                            height: 28,
                            color: Colors.black,
                            child: Center(
                              child: Container(
                                width: 90,
                                height: 12,
                                decoration: const BoxDecoration(
                                  color: Colors.white24,
                                  borderRadius: BorderRadius.all(Radius.circular(6)),
                                ),
                              ),
                            ),
                          ),

                        // Embedded Application View
                        Expanded(
                          child: _buildMainContentView(isDark, filtered),
                        ),

                        // Bottom Keyboard Simulation Box
                        if (_keyboardOpen)
                          Container(
                            height: 200,
                            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFCBD5E1),
                            child: const Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.keyboard, color: Color(0xFFEAB308)),
                                  SizedBox(width: 8),
                                  Text(
                                    'SIMULASI KEYBOARD TERBUKA (200dp)',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        // Bottom Gesture Navigation Bar
                        if (_notchGestureBar)
                          Container(
                            height: 16,
                            color: Colors.black,
                            child: Center(
                              child: Container(
                                width: 120,
                                height: 4,
                                color: Colors.white54,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
