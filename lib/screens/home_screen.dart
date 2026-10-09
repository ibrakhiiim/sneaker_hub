import 'package:flutter/material.dart';

import '../data/mock_products.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';

/// Главный экран (Discovery / Feed):
/// поиск, фильтр категорий, промо-баннер, сетка карточек.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategoryIndex = 0;
  String _searchQuery = '';
  bool _showOnlyFavorites = false;
  int _cartCount = 0;
  final Set<String> _favoriteIds = {};

  // Отфильтрованный список считается при каждом build()
  List<Product> get _visibleProducts {
    final category = kCategories[_selectedCategoryIndex];
    final query = _searchQuery.trim().toLowerCase();

    return kMockProducts.where((p) {
      final matchesCategory =
          category == 'All' || p.categories.contains(category);
      final matchesQuery = query.isEmpty ||
          p.title.toLowerCase().contains(query) ||
          p.brand.toLowerCase().contains(query);
      final matchesFavorite = !_showOnlyFavorites || _favoriteIds.contains(p.id);
      return matchesCategory && matchesQuery && matchesFavorite;
    }).toList();
  }

  void _toggleFavorite(String productId) {
    setState(() {
      if (!_favoriteIds.remove(productId)) {
        _favoriteIds.add(productId);
      }
    });
  }

  void _openDetails(Product product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProductDetailScreen(
          product: product,
          isFavorite: _favoriteIds.contains(product.id),
          onFavoriteToggle: () => _toggleFavorite(product.id),
          onAddToCart: (quantity, size) =>
              setState(() => _cartCount += quantity),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final products = _visibleProducts;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello 👋',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            Text(
              'Find your sneakers',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Favorites only',
            onPressed: () =>
                setState(() => _showOnlyFavorites = !_showOnlyFavorites),
            icon: Icon(
              _showOnlyFavorites
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: _showOnlyFavorites ? AppColors.accent : null,
            ),
          ),
          IconButton(
            tooltip: 'Cart',
            onPressed: () {},
            icon: Badge(
              isLabelVisible: _cartCount > 0,
              label: Text('$_cartCount'),
              backgroundColor: AppColors.accent,
              child: const Icon(Icons.shopping_bag_outlined),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildSearchField()),
          SliverToBoxAdapter(child: _buildCategoryTabs()),
          const SliverToBoxAdapter(child: _PromoBanner()),
          SliverToBoxAdapter(child: _buildSectionHeader(products.length)),
          if (products.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: _EmptyState(),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverGrid(
                // Ширина карточки ≤ 220 → на телефоне 2 колонки,
                // на планшете 3–5. Высота фиксирована → нет overflow.
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 220,
                  mainAxisExtent: 270,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                delegate: SliverChildBuilderDelegate(
                  childCount: products.length,
                  (context, index) {
                    final product = products[index];
                    return ProductCard(
                      product: product,
                      isFavorite: _favoriteIds.contains(product.id),
                      onTap: () => _openDetails(product),
                      onFavoriteTap: () => _toggleFavorite(product.id),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: TextField(
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: InputDecoration(
          hintText: 'Search sneakers or brands',
          prefixIcon: const Icon(Icons.search_rounded),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  /// Горизонтальный список категорий — «tab toggle» через setState.
  Widget _buildCategoryTabs() {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: kCategories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = index == _selectedCategoryIndex;
          return ChoiceChip(
            label: Text(kCategories[index]),
            selected: isSelected,
            showCheckmark: false,
            onSelected: (_) => setState(() => _selectedCategoryIndex = index),
            selectedColor: AppColors.primary,
            backgroundColor: Colors.white,
            side: BorderSide.none,
            labelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : AppColors.primary,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _showOnlyFavorites ? 'Your favorites' : 'Popular',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
          ),
          Text(
            '$count items',
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

/// Промо-баннер: Card → Row → [Expanded(Column текста), иконка].
class _PromoBanner extends StatelessWidget {
  const _PromoBanner();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Card(
        color: AppColors.primary,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Autumn Sale',
                      style: TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Up to 30% off on running shoes',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.local_offer_rounded,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 56, color: AppColors.textSecondary),
          SizedBox(height: 12),
          Text(
            'Nothing found',
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
