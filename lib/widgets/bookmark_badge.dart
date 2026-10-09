import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Круглая кнопка-закладка поверх обложки (часть Stack).
class BookmarkBadge extends StatelessWidget {
  final bool isBookmarked;
  final VoidCallback onTap;
  final double size;

  const BookmarkBadge({
    super.key,
    required this.isBookmarked,
    required this.onTap,
    this.size = 44,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 3,
      shadowColor: Colors.black26,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: size,
          height: size,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: Icon(
              isBookmarked
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
              // key нужен, чтобы AnimatedSwitcher понял, что иконка сменилась
              key: ValueKey(isBookmarked),
              color: isBookmarked ? AppColors.accent : AppColors.primary,
              size: size * 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
