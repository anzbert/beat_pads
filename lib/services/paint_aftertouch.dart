import 'package:beat_pads/services/_services.dart';
import 'package:beat_pads/services/paint_radius.dart';
import 'package:beat_pads/services/paint_xy.dart';
import 'package:beat_pads/services/paint_circle.dart';
import 'package:beat_pads/services/paint_square.dart';
import 'package:beat_pads/shared/_shared.dart';
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
                          CustomPaint(
                            painter: CustomPaintCircle(
                              box.globalToLocal(touchEvent.origin),
                              touchEvent,
                              Palette.lightPink.color.withOpacity(touchEvent
                                      .radialChange(curve: Curves.easeOut) *
                                  0.6),
                            ),
                          ),
                          CustomPaint(
                            painter: CustomPaintRadius(
                              box.globalToLocal(touchEvent.origin),
                              touchEvent,
                              Palette.laserLemon.color.withOpacity(touchEvent
                                      .radialChange(curve: Curves.easeOut) *
                                  0.8),
                            ),
                          ),
                        ],
                      )
                    : Stack(
                        children: [
                          CustomPaint(
                            painter: CustomPaintSquare(
                              box.globalToLocal(touchEvent.origin),
                              touchEvent,
                              Palette.lightPink.color.withOpacity(touchEvent
                                      .radialChange(curve: Curves.easeOut) *
                                  0.6),
                            ),
                          ),
                          CustomPaint(
                            painter: CustomPaintXYSquare(
                              box.globalToLocal(touchEvent.origin),
                              touchEvent,
                              Palette.laserLemon.color.withOpacity(touchEvent
                                      .radialChange(curve: Curves.easeOut) *
                                  0.8),
                            ),
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
