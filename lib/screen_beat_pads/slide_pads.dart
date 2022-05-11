import 'package:beat_pads/screen_beat_pads/slide_pad.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:provider/provider.dart';
import 'package:beat_pads/shared_components/_shared.dart';
import 'package:beat_pads/services/_services.dart';

class SlidePads extends StatefulWidget {
  const SlidePads({Key? key, this.preview = false}) : super(key: key);

  final bool preview;

  @override
  State<SlidePads> createState() => _SlidePadsState();
}

class _SlidePadsState extends State<SlidePads> {
  final GlobalKey _padsWidgetKey = GlobalKey();

  PlayMode? disposeMode;

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
          return target.index >= 0 && target.index < 128 ? target.index : null;
        }
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return MultiProvider(
      providers: [
        // proxyproviders, to update all other models, when Settings change:
        ChangeNotifierProxyProvider<Settings, MidiReceiver>(
          create: (context) => MidiReceiver(context.read<Settings>()),
          update: (_, settings, midiReceiver) => midiReceiver!.update(settings),
        ),
        ChangeNotifierProxyProvider<Settings, MidiSender>(
          create: (context) => MidiSender(context.read<Settings>(), screenSize,
              preview: widget.preview),
          update: (_, settings, midiSender) =>
              midiSender!.update(settings, screenSize),
        ),
      ],
      builder: (context, child) {
        return Consumer(
          builder: (BuildContext context, Settings settings, _) {
            down(PointerEvent touch) {
              int? result = _detectTappedItem(touch);

              if (mounted && result != null) {
                context.read<MidiSender>().handleNewTouch(touch, result);
              }
            }

            move(PointerEvent touch) {
              if (settings.playMode == PlayMode.noSlide) return;

              if (mounted) {
                int? result = _detectTappedItem(touch);
                context.read<MidiSender>().handlePan(touch, result);
              }
            }

            upAndCancel(PointerEvent touch) {
              if (mounted) {
                context.read<MidiSender>().handleEndTouch(touch);
              }
            }

            return Stack(
              children: [
                Listener(
                  onPointerDown: down,
                  onPointerMove: move,
                  onPointerUp: upAndCancel,
                  onPointerCancel: upAndCancel,
                  child: Column(
                    // Hit testing happens on this keyed Widget, which contains all the pads:
                    key: _padsWidgetKey,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...settings.rows.map(
                        (row) {
                          return Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ...row.map(
                                  (note) {
                                    return Expanded(
                                      flex: 1,
                                      child: HitTestObject(
                                        index: note,
                                        child: SlideBeatPad(note: note),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                if (settings.playMode.modulatable) PaintAfterTouchCircle(),
              ],
            );
          },
        );
      },
    );
  }
}
