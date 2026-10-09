import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const SneakerHubApp());
}

class SneakerHubApp extends StatelessWidget {
  const SneakerHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SneakerHub',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      // Ограничиваем системный масштаб шрифта, чтобы огромный шрифт
      // в настройках телефона не ломал вёрстку (защита от overflow).
      builder: (context, child) {
        final mq = MediaQuery.of(context);
        return MediaQuery(
          data: mq.copyWith(
            textScaler: mq.textScaler.clamp(maxScaleFactor: 1.3),
          ),
          child: child!,
        );
      },
      home: const HomeScreen(),
    );
  }
}
