import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'quantity_selector.dart';

/// Липкая нижняя панель: [счётчик] [ Add to Cart ··· на всю ширину ].
/// Кнопка обёрнута в Expanded → занимает всё оставшееся место
/// на любом экране, и Row не переполняется.
class BottomActionBar extends StatelessWidget {
  final double totalPrice;
  final int quantity;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;
  final VoidCallback onAddToCart;

  const BottomActionBar({
    super.key,
    required this.totalPrice,
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      // SafeArea — чтобы кнопка не залезала под системную полоску жестов
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            children: [
              QuantitySelector(
                quantity: quantity,
                onDecrement: onDecrement,
                onIncrement: onIncrement,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: FilledButton.icon(
                    onPressed: onAddToCart,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: const Icon(Icons.shopping_bag_outlined, size: 20),
                    label: Text(
                      'Add to Cart · \$${totalPrice.toStringAsFixed(2)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
