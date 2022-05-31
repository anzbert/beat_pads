import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaintModulation extends StatelessWidget {
  PaintModulation({Key? key}) : super(key: key);

  final dirtyColor = Palette.dirtyTranslucent;
  @override
  Widget build(BuildContext context) {
    // Get Renderbox for gloabl to local offset conversion:
    final RenderBox? box = context.findAncestorRenderObjectOfType<RenderBox>();
    if (box == null) return Stack();

    return Consumer<MidiSender>(
      builder: (context, MidiSender midiSender, _) {
        return Stack(
          children: [
            ...[
              ...midiSender.playMode.touchReleaseBuffer.buffer,
              ...midiSender.playMode.touchBuffer.buffer
            ]
                .where(
              (element) =>
                  element.isModulating, // filter smaller than deadzone events
            )
                .map(
              (touchEvent) {
                return context.select(
                                (Settings settings) => settings.modulation2D) ==
                            false ||
                        context.select((Settings settings) =>
                            settings.playMode.oneDimensional)
                    // CIRCLE / RADIUS
                    ? CustomPaint(
                        painter: CustomPaintRadius(
                          origin: box.globalToLocal(touchEvent.origin),
                          maxRadius: touchEvent.maxRadius,
                          deadZone: touchEvent.deadZone,
                          change: touchEvent.radialChange(
                              curve: Curves.linear, deadZone: false),
                          colorBack: touchEvent.dirty
                              ? dirtyColor
                              : Palette.lightPink.withOpacity(touchEvent
                                      .radialChange(curve: Curves.easeOut) *
                                  0.6),
                          colorFront: touchEvent.dirty
                              ? dirtyColor
                              : Palette.laserLemon.withOpacity(touchEvent
                                      .radialChange(curve: Curves.easeOut) *
                                  0.8),
                          colorDeadZone: touchEvent.dirty
                              ? dirtyColor
                              : Palette.laserLemon.withOpacity(touchEvent
                                      .radialChange(curve: Curves.easeOut) *
                                  0.4),
                        ),
                      )
                    // SQUARE / X AND Y
                    : CustomPaint(
                        painter: CustomPaintXYSquare(
                          origin: box.globalToLocal(touchEvent.origin),
                          maxRadius: touchEvent.maxRadius,
                          deadZone: touchEvent.deadZone,
                          change: touchEvent.directionalChangeFromCenter(
                              curve: Curves.linear, deadZone: false),
                          radialChange:
                              touchEvent.radialChange(curve: Curves.linear),
                          colorBack: touchEvent.dirty
                              ? dirtyColor
                              : Palette.lightPink.withOpacity(touchEvent
                                      .radialChange(curve: Curves.easeOut) *
                                  0.6),
                          colorFront: touchEvent.dirty
                              ? dirtyColor
                              : Palette.laserLemon.withOpacity(touchEvent
                                      .radialChange(curve: Curves.easeOut) *
                                  0.8),
                          colorDeadZone: touchEvent.dirty
                              ? dirtyColor
                              : Palette.laserLemon.withOpacity(touchEvent
                                      .radialChange(curve: Curves.easeOut) *
                                  0.4),
                        ),
                      );
              },
            ),
          ],
        );
      },
    );
  }
}
