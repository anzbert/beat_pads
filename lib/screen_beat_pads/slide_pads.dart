import 'package:beat_pads/screen_beat_pads/slide_pad.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:beat_pads/shared/_shared.dart';
import 'package:beat_pads/services/_services.dart';

class SlidePads extends StatefulWidget {
  const SlidePads({Key? key}) : super(key: key);
  @override
  State<SlidePads> createState() => _SlidePadsState();
}

class _SlidePadsState extends State<SlidePads> {
  final GlobalKey _padsWidgetKey = GlobalKey();

  int? _detectTappedItem(PointerEvent event) {
    final BuildContext? context = _padsWidgetKey.currentContext;
    if (context == null) return null;

    final RenderBox? box = context.findAncestorRenderObjectOfType<RenderBox>();
    if (box == null) return null;

    final Offset localOffset = box.globalToLocal(event.position);
    final BoxHitTestResult results = BoxHitTestResult();

    if (box.hitTest(results, position: localOffset)) {
      for (final HitTestEntry<HitTestTarget> hit in results.path) {
        final HitTestTarget target = hit.target;
        if (target is TestProxyBox) {
          return target.index;
        }
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) =>
                MidiReceiver(Provider.of<Settings>(context, listen: false))),
        ChangeNotifierProvider(
            create: (context) =>
                MidiSender(Provider.of<Settings>(context, listen: false))),
      ],
      builder: (context, child) {
        MidiSender sender = Provider.of<MidiSender>(context, listen: false);
        return Listener(
          onPointerDown: (touch) {
            int? result = _detectTappedItem(touch);
            if (mounted && result != null) {
              sender.push(touch, result);
            }
          },
          onPointerMove: (touch) {
            int? result = _detectTappedItem(touch);
            if (mounted) {
              sender.slide(touch, result);
            }
          },
          onPointerUp: (touch) {
            int? result = _detectTappedItem(touch);
            if (mounted && result != null) {
              sender.lift(touch, result);
            }
          },
          child: Column(
            // Hit testing happens on this keyed Widget, which contains all the pads:
            key: _padsWidgetKey,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...Provider.of<Settings>(context, listen: true).rows.map((row) {
                return Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ...row.map((note) {
                        return Expanded(
                          flex: 1,
                          child: HitTestObject(
                            index: note,
                            child: SlideBeatPad(
                              note: note,
                            ),
                          ),
                        );
                      }).toList()
                    ],
                  ),
                );
              }).toList()
            ],
          ),
        );
      },
    );
  }
}
