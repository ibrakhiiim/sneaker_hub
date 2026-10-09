import '../models/product.dart';

/// Категории для фильтра на главном экране.
const List<String> kCategories = [
  'All',
  'Running',
  'Lifestyle',
  'Basketball',
  'Training',
];

/// Временные данные. На следующих этапах их заменит REST API.
const List<Product> kMockProducts = [
  Product(
    id: 'p1',
    title: 'Air Runner Pro Red Edition',
    brand: 'Stride',
    description:
        'Лёгкие беговые кроссовки с амортизирующей подошвой и дышащим '
        'сетчатым верхом. Подходят для ежедневных пробежек и длинных '
        'дистанций. Усиленная пятка держит стопу, а рельефный протектор '
        'даёт хорошее сцепление на асфальте и в зале.',
    imageUrl:
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800',
    price: 129.99,
    oldPrice: 159.99,
    rating: 4.7,
    reviewCount: 1240,
    categories: ['Running', 'Men', 'Bestseller', 'Breathable'],
    sizes: [39, 40, 41, 42, 43, 44, 45],
  ),
  Product(
    id: 'p2',
    title: 'Urban Classic Low',
    brand: 'Metro',
    description:
        'Классические низкие кеды на каждый день. Натуральная кожа, '
        'мягкая стелька и универсальный дизайн, который подойдёт к '
        'джинсам и к брюкам.',
    imageUrl:
        'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=800',
    price: 89.0,
    rating: 4.4,
    reviewCount: 532,
    categories: ['Lifestyle', 'Unisex', 'Leather'],
    sizes: [36, 37, 38, 39, 40, 41, 42, 43],
  ),
  Product(
    id: 'p3',
    title: 'Court King High-Top',
    brand: 'Dunkline',
    description:
        'Высокие баскетбольные кроссовки с фиксацией голеностопа и '
        'подошвой, которая гасит удар при прыжках.',
    imageUrl:
        'https://images.unsplash.com/photo-1600185365483-26d7a4cc7519?w=800',
    price: 149.5,
    oldPrice: 179.0,
    rating: 4.8,
    reviewCount: 876,
    categories: ['Basketball', 'Men', 'High-top'],
    sizes: [40, 41, 42, 43, 44, 45, 46],
  ),
  Product(
    id: 'p4',
    title: 'FlexFit Trainer',
    brand: 'Pulse',
    description:
        'Кроссовки для тренировок в зале: устойчивая плоская подошва для '
        'приседаний и гибкая передняя часть для кардио.',
    imageUrl:
        'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=800',
    price: 99.99,
    rating: 4.3,
    reviewCount: 214,
    categories: ['Training', 'Women', 'Gym'],
    sizes: [36, 37, 38, 39, 40, 41],
  ),
  Product(
    id: 'p5',
    title: 'Cloud Walk Everyday Comfort Sneaker',
    brand: 'Stride',
    description:
        'Очень мягкие кроссовки для прогулок. Пена с эффектом памяти и '
        'бесшовный верх — удобно весь день.',
    imageUrl:
        'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=800',
    price: 109.0,
    oldPrice: 119.0,
    rating: 4.5,
    reviewCount: 689,
    categories: ['Lifestyle', 'Women', 'Comfort'],
    sizes: [36, 37, 38, 39, 40, 41, 42],
  ),
  Product(
    id: 'p6',
    title: 'Trail Blazer GTX',
    brand: 'Peak',
    description:
        'Кроссовки для бега по пересечённой местности: водоотталкивающий '
        'верх, агрессивный протектор и защитный носок.',
    imageUrl:
        'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=800',
    price: 169.0,
    rating: 4.6,
    reviewCount: 398,
    categories: ['Running', 'Training', 'Waterproof'],
    sizes: [40, 41, 42, 43, 44],
  ),
];
