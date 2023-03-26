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
    final RenderBox? box = context.findRenderObject() as RenderBox?;
    if (box != null) size = box.size;

    return Container(
      margin: EdgeInsets.only(
        top: size.height * (1 - velocity / 127),
      ),
      decoration: BoxDecoration(
        borderRadius: padRadius,
        color: Palette.dirtyTranslucent,
      ),
      alignment: Alignment.bottomCenter,
    );
  }
}
