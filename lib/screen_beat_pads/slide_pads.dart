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
  // MidiSender? _sender;

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
    // _sender = MidiSender(Provider.of<Settings>(context, listen: true));

    final List<List<int>> rowsList =
        Provider.of<Settings>(context, listen: true).rows;

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
        return Listener(
          // TODO: weirdness when moving post octave change
          // TODO : move midi logic to midiData provider model!!!!!!

          onPointerDown: (touch) {
            int? result = _detectTappedItem(touch);
            if (mounted && result != null) {
              Provider.of<MidiSender>(context, listen: false)
                  .push(touch, result);
            }
          },
          onPointerMove: (touch) {
            int? result = _detectTappedItem(touch);
            if (mounted && result != null) {
              Provider.of<MidiSender>(context, listen: false)
                  .slide(touch, result);
            }
          },
          onPointerUp: (touch) {
            int? result = _detectTappedItem(touch);
            if (mounted && result != null) {
              Provider.of<MidiSender>(context, listen: false)
                  .lift(touch, result);
            }
          },

          child: Column(
            // Hit testing happens on this keyed Widget, which contains all the pads:
            key: _padsWidgetKey,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...rowsList.map((row) {
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
                              selected:
                                  Provider.of<MidiSender>(context, listen: true)
                                      .isNoteOn(note),
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
