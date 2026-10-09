import 'package:flutter/material.dart';

/// Картинка из сети с заглушкой на время загрузки и при ошибке
/// (на защите может не быть интернета — экран всё равно не сломается).
class ProductImage extends StatelessWidget {
  final String url;
  final BoxFit fit;

  const ProductImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: fit,
      width: double.infinity,
      height: double.infinity,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const _ImagePlaceholder(isLoading: true);
      },
      errorBuilder: (context, error, stackTrace) =>
          const _ImagePlaceholder(isLoading: false),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  final bool isLoading;

  const _ImagePlaceholder({required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE9E9F0),
      alignment: Alignment.center,
      child: isLoading
          ? const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            )
          : const Icon(
              Icons.directions_run_rounded,
              size: 56,
              color: Color(0xFFB5B5C3),
            ),
    );
  }
}
