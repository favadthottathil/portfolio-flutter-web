import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/shell/portfolio_shell.dart';

void main() {
  runApp(const PortfolioApp());
}

/// Lets the page be dragged with a mouse or trackpad, not just the wheel.
class _AppScrollBehavior extends MaterialScrollBehavior {
  const _AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };

  // The page draws its own progress bar in the nav.
  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) =>
      child;

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const ClampingScrollPhysics();
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Favad T - Portfolio',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(context),
      scrollBehavior: const _AppScrollBehavior(),
      home: const PortfolioShell(),
    );
  }
}
