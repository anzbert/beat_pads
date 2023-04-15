import 'dart:math';
import 'package:flutter/material.dart';

class RefreshButton extends StatefulWidget {
  const RefreshButton({required this.onPressed, required this.icon, super.key});

  final void Function() onPressed;
  final Icon icon;

  @override
  RefreshButtonState createState() => RefreshButtonState();
}

class RefreshButtonState extends State<RefreshButton>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    final Animation<double> curve = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOut,
    );

    animation = Tween<double>(begin: 0, end: 2 * pi).animate(curve)
      ..addListener(
        () => setState(() {}),
      );
  }

  @override
  Widget build(BuildContext context) => Transform.rotate(
        angle: animation.value,
        child: IconButton(
          onPressed: () {
            widget.onPressed();

            controller
              ..reset()
              ..forward();
          },
          icon: widget.icon,
        ),
      );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
