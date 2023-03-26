import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';

class VelocityOverlay extends StatelessWidget {
  const VelocityOverlay({
    required this.velocity,
    required this.padRadius,
    super.key,
  });

  final int velocity;

  final BorderRadius padRadius;

  @override
  Widget build(BuildContext context) {
    Size size = Size.infinite;

    final box = context.findRenderObject();
    if (box != null) {
      final temp = box as RenderBox;
      size = temp.size;
    }

    final double percentage = 1 - velocity / 127;

    return Container(
      margin: EdgeInsets.only(
        top: size.height * percentage,
      ),
      decoration: BoxDecoration(
        borderRadius: padRadius,
        color: Palette.dirtyTranslucent,
      ),
      alignment: Alignment.bottomCenter,
    );
  }
}
