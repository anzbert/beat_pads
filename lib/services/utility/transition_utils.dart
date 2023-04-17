import 'package:flutter/material.dart';

abstract class TransitionUtils {
  /// A Vertical slide transition Route builder
  static Route<Widget> verticalSlide(Widget destinationPage) =>
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            destinationPage,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0, 1);
          const end = Offset.zero;
          const Curve curve = Curves.ease;

          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        // transitionDuration: const Duration(milliseconds: 250),
      );

  /// A Fade transition Route builder
  static Route<Widget> fade(Widget destinationPage) => PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            destinationPage,
        transitionsBuilder: (
          context,
          animation,
          secondaryAnimation,
          child,
        ) =>
            FadeTransition(
          opacity: animation,
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 250),
      );
}
