import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => Theme.of(this).textTheme;

  double get screenHeight => mediaQuery.size.height;

  double get screenWidth => mediaQuery.size.width;

  void pushScreen(Widget screen) => Navigator.of(this).push(
        MaterialPageRoute(
          builder: (_) => screen,
        ),
      );

  void popScreen() => Navigator.of(this).pop();
}
