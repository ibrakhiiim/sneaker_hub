import 'package:flutter/material.dart';

import '../models/product.dart';
import '../theme/app_theme.dart';
import '../widgets/bookmark_badge.dart';
import '../widgets/bottom_action_bar.dart';
import '../widgets/category_badge.dart';
import '../widgets/circle_icon_button.dart';
import '../widgets/product_image.dart';
import '../widgets/rating_stars.dart';

/// LAB 5 — Adaptive E-Commerce Item Detail Screen.
///
/// • Stack: обложка + кнопка «назад» + закладка + бейдж скидки
/// • Row / Wrap: название, рейтинг, цена, категории, размеры
/// • Липкая нижняя панель с кнопкой Add to Cart в Expanded
/// • Адаптивность: телефон — колонка, планшет/широкий экран — две колонки
class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;
  final void Function(int quantity, int size)? onAddToCart;

  const ProductDetailScreen({
    super.key,
    required this.product,
    this.isFavorite = false,
    this.onFavoriteToggle,
    this.onAddToCart,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  static const double _wideBreakpoint = 720;
  static const int _maxQuantity = 10;

  late bool _isBookmarked;
  int _quantity = 1;
  int? _selectedSize;
  bool _isDescriptionExpanded = false;

  Product get _product => widget.product;

  @override
  void initState() {
    super.initState();
    _isBookmarked = widget.isFavorite;
  }

  // ───────────────────────── setState-логика ─────────────────────────

  void _toggleBookmark() {
    setState(() => _isBookmarked = !_isBookmarked);
    widget.onFavoriteToggle?.call();
  }

  void _increment() {
    if (_quantity < _maxQuantity) setState(() => _quantity++);
  }

  void _decrement() {
    if (_quantity > 1) setState(() => _quantity--);
  }

  void _selectSize(int size) {
    setState(() => _selectedSize = size);
  }

  void _toggleDescription() {
    setState(() => _isDescriptionExpanded = !_isDescriptionExpanded);
  }

  void _addToCart() {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();

    if (_selectedSize == null) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Please choose a size first 👟')),
      );
      return;
    }

    widget.onAddToCart?.call(_quantity, _selectedSize!);
    messenger.showSnackBar(
      SnackBar(
        backgroundColor: AppColors.success,
        content: Text(
          'Added $_quantity × ${_product.title} (EU $_selectedSize) to cart',
        ),
      ),
    );
  }

  // ───────────────────────────── UI ─────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // bottomNavigationBar не скроллится вместе с контентом → «sticky»
      bottomNavigationBar: BottomActionBar(
        totalPrice: _product.price * _quantity,
        quantity: _quantity,
        onDecrement: _quantity > 1 ? _decrement : null,
        onIncrement: _quantity < _maxQuantity ? _increment : null,
        onAddToCart: _addToCart,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= _wideBreakpoint;
          return isWide
              ? _buildWideLayout(constraints)
              : _buildNarrowLayout(constraints);
        },
      ),
    );
  }

  /// Телефон: обложка сверху, детали снизу, всё скроллится.
  Widget _buildNarrowLayout(BoxConstraints constraints) {
    // Высота обложки зависит от ширины экрана, но в разумных пределах
    final coverHeight = (constraints.maxWidth * 0.95).clamp(260.0, 440.0);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: coverHeight, child: _buildCover(rounded: false)),
          _buildDetails(),
        ],
      ),
    );
  }

  /// Планшет / ландшафт / web: две колонки.
  Widget _buildWideLayout(BoxConstraints constraints) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: _buildCover(rounded: true)),
            const SizedBox(width: 24),
            Expanded(
              child: SingleChildScrollView(child: _buildDetails()),
            ),
          ],
        ),
      ),
    );
  }

  /// STACK: картинка + градиент + кнопки + бейдж скидки.
  Widget _buildCover({required bool rounded}) {
    final cover = Stack(
      children: [
        // 1. Сама картинка на весь Stack
        Positioned.fill(
          child: Hero(
            tag: 'product-${_product.id}',
            child: ProductImage(url: _product.imageUrl),
          ),
        ),
        // 2. Затемнение сверху, чтобы кнопки читались на светлом фото
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 120,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x55000000), Color(0x00000000)],
              ),
            ),
          ),
        ),
        // 3. Верхняя панель: «назад» слева, закладка справа
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  if (Navigator.of(context).canPop())
                    CircleIconButton(
                      icon: Icons.arrow_back_ios_new_rounded,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                  const Spacer(),
                  BookmarkBadge(
                    isBookmarked: _isBookmarked,
                    onTap: _toggleBookmark,
                  ),
                ],
              ),
            ),
          ),
        ),
        // 4. Бейдж скидки снизу слева
        if (_product.hasDiscount)
          Positioned(
            left: 16,
            bottom: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '-${_product.discountPercent}% OFF',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
      ],
    );

    if (!rounded) return cover;
    return ClipRRect(borderRadius: BorderRadius.circular(28), child: cover);
  }

  /// Блок с информацией о товаре.
  Widget _buildDetails() {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ROW: бренд + «в наличии»
          Row(
            children: [
              Expanded(
                child: Text(
                  _product.brand.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Icon(Icons.check_circle_rounded,
                  size: 16, color: AppColors.success),
              const SizedBox(width: 4),
              const Text(
                'In stock',
                style: TextStyle(
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Название (может быть длинным → maxLines + ellipsis)
          Text(
            _product.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 10),

          // ROW: звёзды + оценка + число отзывов
          Row(
            children: [
              RatingStars(rating: _product.rating),
              const SizedBox(width: 8),
              Text(
                _product.rating.toStringAsFixed(1),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  '(${_product.reviewCount} reviews)',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ROW: цена + старая цена (зачёркнутая)
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '\$${_product.price.toStringAsFixed(2)}',
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              if (_product.hasDiscount)
                Flexible(
                  child: Text(
                    '\$${_product.oldPrice!.toStringAsFixed(2)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // WRAP: бейджи категорий сами переносятся на новую строку
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final (index, category) in _product.categories.indexed)
                CategoryBadge(label: category, highlighted: index == 0),
            ],
          ),
          const SizedBox(height: 24),

          // ROW: заголовок секции размеров
          Row(
            children: [
              Expanded(
                child: Text(
                  'Select size (EU)',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (_selectedSize != null)
                Text(
                  'EU $_selectedSize',
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),

          // WRAP: выбор размера (интерактив через setState)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final size in _product.sizes)
                ChoiceChip(
                  label: Text('$size'),
                  selected: _selectedSize == size,
                  onSelected: (_) => _selectSize(size),
                  showCheckmark: false,
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: _selectedSize == size
                        ? Colors.white
                        : AppColors.primary,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),

          // Описание с «Read more»
          Text(
            'Description',
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            alignment: Alignment.topCenter,
            child: Text(
              _product.description,
              maxLines: _isDescriptionExpanded ? null : 3,
              overflow: _isDescriptionExpanded
                  ? TextOverflow.visible
                  : TextOverflow.ellipsis,
              style: const TextStyle(
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: _toggleDescription,
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            child: Text(_isDescriptionExpanded ? 'Show less' : 'Read more'),
          ),
        ],
      ),
    );
  }
}
