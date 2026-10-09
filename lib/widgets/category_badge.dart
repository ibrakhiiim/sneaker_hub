import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Маленький бейдж-тег категории (Running, Men, Bestseller…).
/// Используется внутри Wrap, поэтому сам переносится на новую строку.
class CategoryBadge extends StatelessWidget {
  final String label;
  final bool highlighted;

  const CategoryBadge({
    super.key,
    required this.label,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = highlighted ? AppColors.accent : AppColors.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
