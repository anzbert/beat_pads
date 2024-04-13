import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaintPushStyle extends ConsumerWidget {
  PaintPushStyle({super.key});

  final dirtyColor = Palette.dirtyTranslucent;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get Renderbox for gloabl to local offset conversion:
    final RenderBox? box = context.findAncestorRenderObjectOfType<RenderBox>();
    if (box == null) return const Stack();

    final midiSender = ref.watch(senderProvider);

    return Stack(
      children: [
        ...[
          ...midiSender.playModeHandler.touchReleaseBuffer.buffer,
          ...midiSender.playModeHandler.touchBuffer.buffer,
        ]
            .where(
          (element) =>
              element.isModulating, // filter smaller than deadzone events
        )
            .map(
          (touchEvent) {
            return CustomPaint(
              painter: CustomPaintLine(
                dirty: touchEvent.dirty,
                origin: box.globalToLocal(touchEvent.origin),
                originPadBox: PadBox(
                    padPosition:
                        box.globalToLocal(touchEvent.originPadBox.padPosition),
                    padSize: touchEvent.originPadBox.padSize),
                padBox: PadBox(
                    padPosition:
                        box.globalToLocal(touchEvent.newPadBox.padPosition),
                    padSize: touchEvent.newPadBox.padSize),
                change: box.globalToLocal(touchEvent.newPosition),
                colorFront: touchEvent.dirty
                    ? dirtyColor
                    : Palette.laserLemon.withOpacity(
                        touchEvent.radialChange(curve: Curves.easeOut) * 0.8,
                      ),
              ),
            );
          },
        ),
      ],
    );
  }
}
