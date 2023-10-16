import 'package:flutter/material.dart';

abstract class TransitionUtils {
  /// A Vertical slide transition Route builder
  static PageRouteBuilder<Widget> verticalSlide(Widget destinationPage) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => destinationPage,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const Offset begin = Offset(0, 1);
        const Offset end = Offset.zero;
        const Curve curve = Curves.ease;

        final Animatable<Offset> tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      // transitionDuration: const Duration(milliseconds: 250),
    );
  }

  /// A Fade transition Route builder
  static PageRouteBuilder<Widget> fade(Widget destinationPage) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => destinationPage,
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 250),
    );
  }
}
