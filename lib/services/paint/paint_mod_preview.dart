import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaintModPreview extends ConsumerWidget {
  const PaintModPreview({
    Key? key,
  }) : super(key: key);

  final double fixedChangeForPreview = 1;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get Renderbox for gloabl to local offset conversion:
    final RenderBox? box = context.findAncestorRenderObjectOfType<RenderBox>();
    if (box == null) return const Stack();

    final Size screenSize = MediaQuery.of(context).size;

    if (!ref.watch(modulation2DProv) ||
        ref.watch(playModeProv).oneDimensional) {
      return CustomPaint(
        foregroundPainter: CustomPaintRadius(
          dirty: false,
          origin: box.globalToLocal(Offset(screenSize.width / 2,
              screenSize.height / (DeviceUtils.isPortrait(context) ? 2.5 : 2))),
          maxRadius: ref.watch(modulationRadiusProv) * screenSize.longestSide,
          deadZone: ref.watch(modulationDeadZoneProv),
          change: fixedChangeForPreview,
          colorBack: Palette.lightPink.withOpacity(fixedChangeForPreview * 0.6),
          colorFront:
              Palette.laserLemon.withOpacity(fixedChangeForPreview * 0.8),
          colorDeadZone:
              Palette.laserLemon.withOpacity(fixedChangeForPreview * 0.4),
        ),
      );
    } else {
      return CustomPaint(
        foregroundPainter: CustomPaintXYSquare(
          dirty: false,
          origin: box.globalToLocal(Offset(screenSize.width / 2,
              screenSize.height / (DeviceUtils.isPortrait(context) ? 2.5 : 2))),
          maxRadius: ref.watch(modulationRadiusProv) * screenSize.longestSide,
          deadZone: ref.watch(modulationDeadZoneProv),
          change: const Offset(0, 0),
          radialChange: fixedChangeForPreview,
          colorBack: Palette.lightPink.withOpacity(fixedChangeForPreview * 0.6),
          colorFront:
              Palette.laserLemon.withOpacity(fixedChangeForPreview * 0.8),
          colorDeadZone:
              Palette.laserLemon.withOpacity(fixedChangeForPreview * 0.4),
        ),
      );
    }
  }
}
