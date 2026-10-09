import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Белая круглая кнопка (например, «Назад» поверх картинки).
class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;

  const CircleIconButton({
    super.key,
    required this.icon,
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
          child: Icon(icon, color: AppColors.primary, size: size * 0.45),
        ),
      ),
    );
  }
}
