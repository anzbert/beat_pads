import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';

class VelocityOverlay extends StatelessWidget {
  const VelocityOverlay(
      {required this.percentage, required this.radius, super.key});

  final double percentage;
  final BorderRadius radius;

  @override
  Widget build(BuildContext context) {
    Size size = Size.infinite;

    final box = context.findRenderObject();
    if (box != null) {
      final temp = box as RenderBox;
      size = temp.size;
    }

    return Container(
      margin: EdgeInsets.only(
        top: size.height * percentage,
      ),
      decoration: BoxDecoration(
        borderRadius: radius,
        color: Palette.dirtyTranslucent,
      ),
      alignment: Alignment.bottomCenter,
    );
  }
}
