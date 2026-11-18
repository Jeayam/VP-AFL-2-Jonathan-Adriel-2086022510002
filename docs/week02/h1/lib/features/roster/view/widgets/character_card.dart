import 'package:flutter/material.dart';

import '../../domain/models/character.dart';

class CharacterCard extends StatefulWidget {
  final Character character;
  final VoidCallback onTap;

  const CharacterCard({
    super.key,
    required this.character,
    required this.onTap,
  });

  @override
  State<CharacterCard> createState() => _CharacterCardState();
}

class _CharacterCardState extends State<CharacterCard> {
  bool _isHovered = false;

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
        return Icons.auto_awesome_rounded;
    }
  }

  Color _getElementColor(String element, bool isDark) {
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
        return const Color(0xFFA78BFA);
    }
  }

  List<Color> _getElementGradient(String element, bool isDark) {
    switch (element.toLowerCase()) {
      case 'fire':
        return [const Color(0xFF7F1D1D), const Color(0xFFDC2626)];
      case 'water':
        return [const Color(0xFF0C4A6E), const Color(0xFF0284C7)];
      case 'lightning':
        return [const Color(0xFF78350F), const Color(0xFFD97706)];
      case 'dark':
        return [const Color(0xFF4C1D95), const Color(0xFF7E22CE)];
      default:
        return [const Color(0xFF312E81), const Color(0xFF4F46E5)];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final element = widget.character.element.name;
    final role = widget.character.role.name;
    final name = widget.character.name;

    final dpr = MediaQuery.of(context).devicePixelRatio;
    final dynamicCacheWidth = (350 * dpr).round().clamp(600, 1200);

    final elementColor = _getElementColor(element, isDark);
    final elementGradient = _getElementGradient(element, isDark);
    final elementIcon = _getElementIcon(element);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        transform: _isHovered
            ? Matrix4.translationValues(0.0, -4.0, 0.0)
            : Matrix4.identity(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? elementColor.withValues(alpha: 0.5)
                  : (isDark
                        ? Colors.black.withValues(alpha: 0.4)
                        : Colors.black.withValues(alpha: 0.08)),
              blurRadius: _isHovered ? 14 : 6,
              offset: Offset(0, _isHovered ? 6 : 3),
            ),
          ],
        ),
        child: Card(
          elevation: _isHovered ? 6 : 2,
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: _isHovered
                  ? elementColor
                  : (isDark
                        ? const Color(0xFF2A344B)
                        : const Color(0xFFE2D9C5)),
              width: _isHovered ? 1.5 : 1.0,
            ),
          ),
          child: InkWell(
            onTap: widget.onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Image Area with Rarity & Element Header
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Character Artwork
                      Image.asset(
                        widget.character.imageUrl,
                        fit: BoxFit.cover,
                        cacheWidth: dynamicCacheWidth,
                        errorBuilder: (context, error, stackTrace) => Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: elementGradient,
                            ),
                          ),
                          child: const Icon(
                            Icons.shield,
                            size: 36,
                            color: Colors.white60,
                          ),
                        ),
                      ),
                      // Vignette Darkening Overlay
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.2),
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.85),
                              ],
                              stops: const [0.0, 0.4, 1.0],
                            ),
                          ),
                        ),
                      ),
                      // Top Left: 5-Star Mythic Rating Badge
                      Positioned(
                        top: 4,
                        left: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 1.5,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFD97706), Color(0xFFFBBF24)],
                            ),
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.4),
                                blurRadius: 3,
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star, size: 8, color: Colors.white),
                              SizedBox(width: 1),
                              Text(
                                '5★',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Top Right: Elemental Icon Badge with Metallic Border
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F172A)
                                .withValues(alpha: 0.85),
                            shape: BoxShape.circle,
                            border: Border.all(color: elementColor, width: 1.0),
                            boxShadow: [
                              BoxShadow(
                                color: elementColor.withValues(alpha: 0.4),
                                blurRadius: 3,
                              ),
                            ],
                          ),
                          child: Icon(
                            elementIcon,
                            size: 9,
                            color: elementColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Bottom Card Information Section
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF131927)
                        : const Color(0xFFFAFAFA),
                    border: Border(
                      top: BorderSide(
                        color: elementColor.withValues(alpha: 0.3),
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Character Name
                      Text(
                        name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 10.5,
                          letterSpacing: 0.1,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      // Element & Role Pill
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 1.5,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              elementGradient[0].withValues(
                                alpha: isDark ? 0.6 : 0.15,
                              ),
                              elementGradient[1].withValues(
                                alpha: isDark ? 0.4 : 0.10,
                              ),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: elementColor.withValues(alpha: 0.4),
                            width: 0.8,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(elementIcon, size: 8, color: elementColor),
                            const SizedBox(width: 2),
                            Flexible(
                              child: Text(
                                '${element.toUpperCase()} • $role',
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w800,
                                  color: isDark
                                      ? elementColor
                                      : elementGradient[0],
                                  letterSpacing: 0.2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
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
        ),
      ),
    );
  }
}
