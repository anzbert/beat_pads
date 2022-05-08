import 'package:beat_pads/services/_services.dart';
import 'package:beat_pads/services/paint_circle.dart';
import 'package:beat_pads/services/paint_square.dart';
import 'package:beat_pads/services/paint_xy_lines.dart';
import 'package:beat_pads/shared/colors.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaintAfterTouchCircle extends StatelessWidget {
  const PaintAfterTouchCircle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get Renderbox for gloabl to local offset conversion:
    final RenderBox? box = context.findAncestorRenderObjectOfType<RenderBox>();
    if (box == null) return Stack();

    return Consumer<MidiSender>(
      builder: (context, midiSender, child) {
        final buffer = midiSender.touchBuffer.buffer;

        return Stack(
          children: [
            ...buffer.map(
              (touchEvent) {
                return context.watch<Settings>().modulationXandY == false
                    ? Stack(
                        children: [
                          PaintCircle(
                            box.globalToLocal(touchEvent.origin),
                            touchEvent.maxRadius,
                            Palette.lightPink.color.withOpacity(
                                touchEvent.radialChange(curve: Curves.easeOut) *
                                    0.6),
                            stroke: false,
                          ),
                          PaintCircle(
                            box.globalToLocal(touchEvent.origin),
                            touchEvent.radialChange() * touchEvent.maxRadius,
                            Palette.laserLemon.color.withOpacity(
                                touchEvent.radialChange(curve: Curves.easeOut) *
                                    0.8),
                            stroke: true,
                          ),
                        ],
                      )
                    : Stack(
                        children: [
                          PaintSquare(
                            box.globalToLocal(touchEvent.origin),
                            touchEvent.maxRadius,
                            Palette.lightPink.color.withOpacity(
                                touchEvent.radialChange(curve: Curves.easeOut) *
                                    0.6),
                            stroke: false,
                          ),
                          PaintXYLines(
                            box.globalToLocal(touchEvent.origin),
                            touchEvent.directionalChangeFromCenter(
                                    curve: Curves.linear, deadZone: true) *
                                touchEvent.maxRadius,
                            touchEvent.maxRadius,
                            touchEvent.deadZone,
                            Palette.laserLemon.color.withOpacity(
                                touchEvent.radialChange(curve: Curves.easeOut) *
                                    0.8),
                            stroke: true,
                          ),
                        ],
                      );
              },
            ),
          ],
        );
      },
    );
  }
}
