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
              (outlineCircle) {
                return PaintCircle(
                  box.globalToLocal(outlineCircle.center),
                  paintModel.outlineBuffer.maxRadius,
                  Palette.lightPink.color.withOpacity(
                      paintModel.getOpacity(outlineCircle.radius, scale: 0.5)),
                  stroke: false,
                );
              },
            ),
            ...paintModel.atCircleBuffer.values.map(
              (atCircle) {
                return PaintCircle(
                  box.globalToLocal(atCircle.center),
                  atCircle.radius,
                  Palette.laserLemon.color.withOpacity(
                      paintModel.getOpacity(atCircle.radius, scale: 0.7)),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
