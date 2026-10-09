# 👟 SneakerHub

Мобильное приложение-магазин кроссовок на Flutter.
Капстоун-проект курса по мобильной разработке (Milestone 1 + LAB 5).

## Проблема и пользователь

Выбирать кроссовки в соцсетях и на маркетплейсах неудобно: нет нормальных фильтров по типу,
трудно сравнить цены и отзывы. **SneakerHub** — простой каталог, где покупатель (студенты,
бегуны, любители уличной моды) быстро находит модель по категории, смотрит рейтинг, выбирает
размер и добавляет в корзину.

## Экраны

| Экран | Что показано |
|---|---|
| **Home (Discovery)** | Поиск, категории-табы, промо-баннер (Card + Row), адаптивная сетка карточек |
| **Product Detail (LAB 5)** | Stack-обложка с кнопкой «назад» и закладкой, рейтинг и цена в Row, категории и размеры в Wrap, липкая панель «Add to Cart» с Expanded |

## Интерактив (StatefulWidget + setState)

- ❤️ избранное на карточке и закладка на детальном экране (синхронизируются)
- 🏷️ переключение категорий и фильтр «только избранное»
- 🔍 живой поиск по названию и бренду
- 👟 выбор размера, счётчик количества, «Read more» у описания
- 🛒 счётчик корзины в AppBar

## Адаптивность и защита от overflow

- `LayoutBuilder`: на ширине ≥ 720 px детальный экран делится на две колонки
- `SliverGridDelegateWithMaxCrossAxisExtent`: 2 колонки на телефоне, 3–5 на планшете
- `Expanded` / `Flexible` + `maxLines` + `TextOverflow.ellipsis` для длинных текстов
- `Wrap` для тегов и размеров, `SafeArea` для системных отступов
- ограничение системного масштаба шрифта до 1.3×
- widget-тесты проверяют отсутствие RenderFlex overflow на 320×568, 390×844 и 1024×768

## Структура

```
lib/
├── main.dart                   # точка входа, тема
├── theme/app_theme.dart        # цвета и ThemeData
├── models/product.dart         # модель товара
├── data/mock_products.dart     # временные данные (потом → REST API)
├── screens/
│   ├── home_screen.dart
│   └── product_detail_screen.dart
└── widgets/
    ├── bookmark_badge.dart
    ├── bottom_action_bar.dart
    ├── category_badge.dart
    ├── circle_icon_button.dart
    ├── product_card.dart
    ├── product_image.dart
    ├── quantity_selector.dart
    └── rating_stars.dart
test/widget_test.dart           # тесты на overflow и интерактив
```

## Запуск

```bash
flutter pub get
flutter run
flutter test
```

## Roadmap

- [x] Milestone 1 — UI MVP (Weeks 5–7)
- [ ] REST API вместо mock-данных
- [ ] Локальная база данных (корзина, избранное)
- [ ] BLoC-архитектура
