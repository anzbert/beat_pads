import 'package:beat_pads/main.dart';
import 'package:beat_pads/screen_beat_pads/_screen_beat_pads.dart';
import 'package:beat_pads/screen_beat_pads/slide_pad.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:beat_pads/shared_components/_shared.dart';
import 'package:beat_pads/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SlidePads extends ConsumerStatefulWidget {
  final bool preview;
  const SlidePads({Key? key, required this.preview}) : super(key: key);

  @override
  ConsumerState<SlidePads> createState() => _SlidePadsState();
}

class _SlidePadsState extends ConsumerState<SlidePads>
    with TickerProviderStateMixin {
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
      ref.read<MidiSender>(senderProvider.notifier).handleNewTouch(
            CustomPointer(touch.pointer, touch.position),
            result,
            MediaQuery.of(context).size,
          );
    }
  }

  move(PointerEvent touch) {
    if (ref.read(settingsProvider.notifier).playMode == PlayMode.noSlide) {
      return;
    }

    if (mounted) {
      int? result = _detectTappedItem(touch);
      ref
          .read(senderProvider.notifier)
          .handlePan(CustomPointer(touch.pointer, touch.position), result);
    }
  }

  upAndCancel(PointerEvent touch) {
    if (mounted) {
      ref
          .read(senderProvider.notifier)
          .handleEndTouch(CustomPointer(touch.pointer, touch.position));

      if (ref.read(settingsProvider.notifier).modSustainTimeUsable > 0 &&
          ref.read(settingsProvider.notifier).playMode.modulatable) {
        TouchEvent? event = ref
            .read(senderProvider.notifier)
            .playMode
            .touchReleaseBuffer
            .getByID(touch.pointer);
        if (event == null || event.newPosition == event.origin) return;

        ReturnAnimation returnAnim = ReturnAnimation(
          event.uniqueID,
          ref.read(settingsProvider.notifier).modSustainTimeUsable,
          tickerProvider: this,
        );

        Offset constrainedPosition = ref
                .read(settingsProvider.notifier)
                .modulation2D
            ? Utils.limitToSquare(event.origin, touch.position,
                ref.read(settingsProvider.notifier).absoluteRadius(context))
            : Utils.limitToCircle(event.origin, touch.position,
                ref.read(settingsProvider.notifier).absoluteRadius(context));

        returnAnim.animation.addListener(() {
          TouchReleaseBuffer touchReleaseBuffer =
              ref.read(senderProvider.notifier).playMode.touchReleaseBuffer;
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
            ref.read(senderProvider.notifier).handlePan(
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
    final List<List<int>> rows =
        ref.watch(settingsProvider.select((value) => value.rows));
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
        if (ref
            .watch(settingsProvider.select((value) => value.playMode))
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
