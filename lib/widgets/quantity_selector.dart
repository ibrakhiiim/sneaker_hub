import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Счётчик количества: [ − ]  2  [ + ]
class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepButton(icon: Icons.remove_rounded, onTap: onDecrement),
          SizedBox(
            width: 28,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          _StepButton(icon: Icons.add_rounded, onTap: onIncrement),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _StepButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: SizedBox(
        width: 40,
        height: 52,
        child: Icon(
          icon,
          size: 20,
          color: onTap == null ? AppColors.textSecondary : AppColors.primary,
        ),
      ),
    );
  }
}
