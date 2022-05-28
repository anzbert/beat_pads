import 'package:flutter/material.dart';

class ReturnAnimation {
  final int touch;
  final int returnTime;
  final TickerProvider tickerProvider;

  late AnimationController controller;
  late Animation<double> animation;

  ReturnAnimation(this.touch, this.returnTime, {required this.tickerProvider}) {
    controller = AnimationController(
      duration: Duration(milliseconds: returnTime),
      vsync: tickerProvider,
    );

    Animation<double> curve = CurvedAnimation(
      parent: controller,
      curve: Curves.easeIn,
    );

    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(curve);
  }

  void forward() => controller.forward();
  void dispose() => controller.dispose();

  bool get isCompleted => animation.isCompleted;
  double get value => animation.value;
}
