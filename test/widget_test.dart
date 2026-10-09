import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sneaker_hub/data/mock_products.dart';
import 'package:sneaker_hub/main.dart';
import 'package:sneaker_hub/screens/product_detail_screen.dart';
import 'package:sneaker_hub/theme/app_theme.dart';

/// Размеры экранов: маленький телефон, обычный телефон, планшет.
const _screenSizes = <String, Size>{
  'small phone 320x568': Size(320, 568),
  'phone 390x844': Size(390, 844),
  'tablet 1024x768': Size(1024, 768),
};

void _setScreenSize(WidgetTester tester, Size size) {
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = size;
  addTearDown(tester.view.reset);
}

void main() {
  // Если где-то будет RenderFlex overflow, Flutter выбросит исключение,
  // и takeException() вернёт его → тест упадёт.
  for (final entry in _screenSizes.entries) {
    testWidgets('Home screen has no overflow on ${entry.key}', (tester) async {
      _setScreenSize(tester, entry.value);
      await tester.pumpWidget(const SneakerHubApp());
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('Detail screen has no overflow on ${entry.key}',
        (tester) async {
      _setScreenSize(tester, entry.value);
      // Проверяем каждый товар (у одного очень длинное название)
      for (final product in kMockProducts) {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light,
            home: ProductDetailScreen(product: product),
          ),
        );
        await tester.pump();
        expect(tester.takeException(), isNull, reason: product.title);
      }
    });
  }

  testWidgets('Bookmark, size and quantity react to taps', (tester) async {
    _setScreenSize(tester, const Size(390, 844));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: ProductDetailScreen(product: kMockProducts.first),
      ),
    );

    // Закладка
    expect(find.byIcon(Icons.bookmark_border_rounded), findsOneWidget);
    await tester.tap(find.byIcon(Icons.bookmark_border_rounded));
    // pump с паузой, а не pumpAndSettle: картинка-заглушка с индикатором
    // загрузки анимируется бесконечно
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byIcon(Icons.bookmark_rounded), findsOneWidget);

    // Количество 1 → 2
    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pump();
    expect(find.text('2'), findsOneWidget);

    // Выбор размера
    await tester.ensureVisible(find.text('42'));
    await tester.pump();
    await tester.tap(find.text('42'));
    await tester.pump();
    expect(find.text('EU 42'), findsOneWidget);
  });
}
