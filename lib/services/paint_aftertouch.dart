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

    return Consumer<MidiSender>(
      builder: (context, midiSender, child) {
        print(midiSender.touchBuffer.buffer);
        midiSender.touchBuffer.buffer.forEach((element) {
          // print(element.radialChange());
        });
        final buffer = midiSender.touchBuffer.buffer.where((e) {
          return e.radialChange() > 0.1;
        });
        print(buffer);
        return Stack(
          children: [
            ...buffer.map(
              (atCircle) {
                return Stack(
                  children: [
                    PaintCircle(
                      box.globalToLocal(atCircle.origin),
                      midiSender.touchBuffer.maxRadius,
                      Palette.lightPink.color
                          .withOpacity(atCircle.radialChange() * 0.5),
                      stroke: false,
                    ),
                    PaintCircle(
                      box.globalToLocal(atCircle.origin),
                      atCircle.radialChange() *
                          midiSender.touchBuffer.maxRadius,
                      Palette.laserLemon.color
                          .withOpacity(atCircle.radialChange() * 0.7),
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
