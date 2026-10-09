/// Модель товара. Позже (REST API) сюда добавится fromJson().
class Product {
  final String id;
  final String title;
  final String brand;
  final String description;
  final String imageUrl;
  final double price;
  final double? oldPrice;
  final double rating;
  final int reviewCount;
  final List<String> categories;
  final List<int> sizes;

  const Product({
    required this.id,
    required this.title,
    required this.brand,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.oldPrice,
    required this.rating,
    required this.reviewCount,
    required this.categories,
    required this.sizes,
  });

  bool get hasDiscount => oldPrice != null && oldPrice! > price;

  int get discountPercent =>
      hasDiscount ? ((1 - price / oldPrice!) * 100).round() : 0;
}
