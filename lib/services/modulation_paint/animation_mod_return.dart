import 'package:flutter/material.dart';

class ReturnAnimation {
  ReturnAnimation(
    this.uniqueID,
    this.returnTime, {
    required this.tickerProvider,
  }) : controller = AnimationController(
          duration: Duration(milliseconds: returnTime),
          vsync: tickerProvider,
        ) {
    final Animation<double> curve = CurvedAnimation(
      parent: controller,
      curve: Curves.easeIn,
    );
    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(curve);
  }
  final int uniqueID;
  final int returnTime;
  final TickerProvider tickerProvider;
  final AnimationController controller;

  late Animation<double> animation;

  bool _kill = false;
  bool get kill => _kill;
  void markKillAndDisposeController() {
    controller.dispose();
    _kill = true;
  }

  void forward() => controller.forward();
  bool get isCompleted => animation.isCompleted;
  double get value => animation.value;
}
