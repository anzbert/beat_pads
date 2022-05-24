import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaintModPreview extends StatelessWidget {
  const PaintModPreview({
    Key? key,
  }) : super(key: key);

  final double fixedChangeForPreview = 0.5;

  @override
  Widget build(BuildContext context) {
    // Get Renderbox for gloabl to local offset conversion:
    final RenderBox? box = context.findAncestorRenderObjectOfType<RenderBox>();
    if (box == null) return Stack();

    final Size screenSize = MediaQuery.of(context).size;

    return Consumer<Settings>(
      builder: (context, settings, _) {
        if (!settings.modulation2D) {
          return CustomPaint(
            painter: CustomPaintRadius(
              origin: box.globalToLocal(Offset(
                  screenSize.width / 2,
                  screenSize.height /
                      (DeviceUtils.isPortrait(context) ? 2.5 : 2))),
              maxRadius: settings.modulationRadius * screenSize.longestSide,
              deadZone: settings.modulationDeadZone,
              change: fixedChangeForPreview,
              colorBack:
                  Palette.lightPink.withOpacity(fixedChangeForPreview * 0.6),
              colorFront:
                  Palette.laserLemon.withOpacity(fixedChangeForPreview * 0.8),
              colorDeadZone:
                  Palette.laserLemon.withOpacity(fixedChangeForPreview * 0.4),
            ),
          );
        }
        return CustomPaint(
          painter: CustomPaintXYSquare(
            origin: box.globalToLocal(Offset(
                screenSize.width / 2,
                screenSize.height /
                    (DeviceUtils.isPortrait(context) ? 2.5 : 2))),
            maxRadius: settings.modulationRadius * screenSize.longestSide,
            deadZone: settings.modulationDeadZone,
            change: Offset(fixedChangeForPreview, fixedChangeForPreview),
            colorBack:
                Palette.lightPink.withOpacity(fixedChangeForPreview * 0.6),
            colorFront:
                Palette.laserLemon.withOpacity(fixedChangeForPreview * 0.8),
            colorDeadZone:
                Palette.laserLemon.withOpacity(fixedChangeForPreview * 0.4),
          ),
        );
      },
    );
  }
}
