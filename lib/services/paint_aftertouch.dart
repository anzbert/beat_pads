import 'package:beat_pads/services/_services.dart';
import 'package:beat_pads/services/paint_circle.dart';
import 'package:beat_pads/shared/colors.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaintAfterTouchCircle extends StatelessWidget {
  const PaintAfterTouchCircle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RenderBox? box = context.findAncestorRenderObjectOfType<RenderBox>();
    if (box == null) return Stack();

    return Consumer<AftertouchModel>(
      builder: (context, paintModel, child) {
        return Stack(
          children: [
            ...paintModel.outlineBuffer.values.map(
              (circle2) {
                return PaintCircle(
                  box.globalToLocal(circle2.center),
                  paintModel.outlineBuffer.maxRadius,
                  Palette.lightPink.color.withOpacity(
                      paintModel.getOpacity(circle2.radius, scale: 0.6)),
                  stroke: false,
                );
              },
            ),
            ...paintModel.circleBuffer.values.map(
              (circle1) {
                return PaintCircle(
                  box.globalToLocal(circle1.center),
                  circle1.radius,
                  Palette.laserLemon.color.withOpacity(
                      paintModel.getOpacity(circle1.radius, scale: 0.8)),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
