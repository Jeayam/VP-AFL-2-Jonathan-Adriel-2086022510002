import 'dart:ui';

import 'package:flutter/material.dart';

class RosterDrawer extends StatelessWidget {
  final VoidCallback? onOpenHistory;
  final VoidCallback? onOpenSettings;

  const RosterDrawer({super.key, this.onOpenHistory, this.onOpenSettings});

  Widget _buildDrawerItem(
    IconData icon,
    String title,
    bool isSelected,
    bool isDark,
    VoidCallback onTap,
  ) {
    const activeColor = Color(0xFFEAB308);
    return Material(
      color: Colors.transparent,
      child: ListTile(
        onTap: onTap,
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        tileColor: isSelected
            ? activeColor.withValues(alpha: 0.2)
            : Colors.transparent,
        leading: Icon(
          icon,
          size: 20,
          color: isSelected
              ? activeColor
              : (isDark ? Colors.white70 : Colors.black87),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
            color: isSelected
                ? activeColor
                : (isDark ? Colors.white : Colors.black87),
          ),
        ),
      ),
    );
  }

  Widget _buildSmallDrawerItem(
    IconData icon,
    String title,
    bool isDark,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        onTap: onTap,
        dense: true,
        visualDensity: VisualDensity.compact,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        leading: Icon(
          icon,
          size: 16,
          color: isDark ? Colors.white54 : Colors.black54,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white60 : Colors.black54,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      child: Drawer(
        width: 280,
        backgroundColor: isDark
            ? const Color(0xFF0F172A).withValues(alpha: 0.85)
            : Colors.white.withValues(alpha: 0.88),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(left: Radius.circular(24)),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAB308).withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFEAB308),
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.shield_rounded,
                        size: 24,
                        color: Color(0xFFEAB308),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CHARACTER CODEX',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                              color: Color(0xFFEAB308),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'ARCHIVES & DATABASE',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey,
                              letterSpacing: 0.8,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Divider(
                  color: (isDark ? Colors.white24 : Colors.black12),
                  thickness: 1,
                ),
                const SizedBox(height: 8),
                _buildDrawerItem(
                  Icons.home_rounded,
                  'Home',
                  true,
                  isDark,
                  () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  Icons.whatshot_rounded,
                  'Trending',
                  false,
                  isDark,
                  () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  Icons.bolt_rounded,
                  'Updates',
                  false,
                  isDark,
                  () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  Icons.bookmark_rounded,
                  'Saved',
                  false,
                  isDark,
                  () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  Icons.history_rounded,
                  'History',
                  false,
                  isDark,
                  () {
                    Navigator.pop(context);
                    if (onOpenHistory != null) onOpenHistory!();
                  },
                ),
                const SizedBox(height: 16),
                Divider(
                  color: (isDark ? Colors.white24 : Colors.black12),
                  thickness: 1,
                ),
                const SizedBox(height: 8),
                _buildSmallDrawerItem(
                  Icons.settings_rounded,
                  'Settings',
                  isDark,
                  () {
                    Navigator.pop(context);
                    if (onOpenSettings != null) onOpenSettings!();
                  },
                ),
                _buildSmallDrawerItem(
                  Icons.info_outline_rounded,
                  'More',
                  isDark,
                  () => Navigator.pop(context),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    'v2.4.0 • RPG Codex Edition',
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark ? Colors.white38 : Colors.black38,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
