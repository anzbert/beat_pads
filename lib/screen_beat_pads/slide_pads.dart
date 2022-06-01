import 'package:beat_pads/screen_beat_pads/slide_pad.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:provider/provider.dart';
import 'package:beat_pads/shared_components/_shared.dart';
import 'package:beat_pads/services/services.dart';

class SlidePads extends StatefulWidget {
  final bool preview;
  const SlidePads({Key? key, required this.preview}) : super(key: key);

  @override
  State<SlidePads> createState() => _SlidePadsState();
}

class _SlidePadsState extends State<SlidePads> with TickerProviderStateMixin {
  final GlobalKey _padsWidgetKey = GlobalKey();

  final List<ReturnAnimation> _animations = [];
  void killAllMarkedAnimations() {
    _animations.removeWhere((element) => element.kill);
  }

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

  down(PointerEvent touch) {
    int? result = _detectTappedItem(touch);

    if (mounted && result != null) {
      context
          .read<MidiSender>()
          .handleNewTouch(CustomPointer(touch.pointer, touch.position), result);
    }
  }

  move(PointerEvent touch) {
    if (context.read<Settings>().playMode == PlayMode.noSlide) return;

    if (mounted) {
      int? result = _detectTappedItem(touch);
      context
          .read<MidiSender>()
          .handlePan(CustomPointer(touch.pointer, touch.position), result);
    }
  }

  upAndCancel(PointerEvent touch) {
    if (mounted) {
      context
          .read<MidiSender>()
          .handleEndTouch(CustomPointer(touch.pointer, touch.position));

      if (context.read<Settings>().modSustainTimeUsable > 0 &&
          context.read<Settings>().playMode.modulatable) {
        TouchEvent? event = context
            .read<MidiSender>()
            .playMode
            .touchReleaseBuffer
            .getByID(touch.pointer);
        if (event == null || event.newPosition == event.origin) return;

        ReturnAnimation returnAnim = ReturnAnimation(
          event.uniqueID,
          context.read<Settings>().modSustainTimeUsable,
          tickerProvider: this,
        );

        Offset constrainedPosition = context.read<Settings>().modulation2D
            ? Utils.limitToSquare(event.origin, touch.position,
                context.read<Settings>().absoluteRadius(context))
            : Utils.limitToCircle(event.origin, touch.position,
                context.read<Settings>().absoluteRadius(context));

        returnAnim.animation.addListener(() {
          TouchReleaseBuffer touchReleaseBuffer =
              context.read<MidiSender>().playMode.touchReleaseBuffer;
          TouchEvent? touchEvent =
              touchReleaseBuffer.getByID(returnAnim.uniqueID);

          if (!mounted || touchEvent == null) {
            returnAnim.markKillAndDisposeController();
            killAllMarkedAnimations();
            return;
          }
          if (returnAnim.isCompleted) {
            touchEvent.hasReturnAnimation = false;
            touchEvent.markKillIfNoteOffAndNoAnimation();
            touchReleaseBuffer.killAllMarkedReleasedTouchEvents();

            returnAnim.markKillAndDisposeController();
            killAllMarkedAnimations();
            return;
          } else {
            context.read<MidiSender>().handlePan(
                CustomPointer(
                    touch.pointer,
                    Offset.lerp(
                        constrainedPosition, event.origin, returnAnim.value)!),
                null);
            setState(() {});
          }
        });

        event.hasReturnAnimation = true;
        returnAnim.forward();
        _animations.add(returnAnim);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final rows = context.select((Settings settings) => settings.rows);
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
              ...rows.map(
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
                                // not sure about this boundary, seems to work though:
                                child: RepaintBoundary(
                                    child: SlideBeatPad(
                                  note: note,
                                  preview: widget.preview,
                                )),
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
        if (context
            .select((Settings settings) => settings.playMode)
            .modulatable)
          RepaintBoundary(child: PaintModulation()),
      ],
    );
  }

  @override
  void dispose() {
    for (ReturnAnimation anim in _animations) {
      anim.controller.dispose();
    }
    _animations.clear();
    super.dispose();
  }
}
