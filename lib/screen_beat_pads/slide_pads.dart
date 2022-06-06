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
    if (ref.read(playModeProv) == PlayMode.noSlide) {
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

      if (ref.read(modReleaseUsable) > 0 &&
          ref.read(playModeProv).modulatable) {
        TouchEvent? event = ref
            .read(senderProvider.notifier)
            .playMode
            .touchReleaseBuffer
            .getByID(touch.pointer);
        if (event == null || event.newPosition == event.origin) return;

        ReturnAnimation returnAnim = ReturnAnimation(
          event.uniqueID,
          ref.read(modReleaseUsable),
          tickerProvider: this,
        );

        double absoluteMaxRadius = MediaQuery.of(context).size.longestSide *
            ref.read(modulationRadiusProv);
        Offset constrainedPosition = ref.read(modulation2DProv)
            ? Utils.limitToSquare(
                event.origin, touch.position, absoluteMaxRadius)
            : Utils.limitToCircle(
                event.origin, touch.position, absoluteMaxRadius);

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
    final List<List<int>> rows = ref.watch(rowProv);
    return Stack(
      children: [
        Listener(
          onPointerDown: down,
          onPointerMove: move,
          onPointerUp: upAndCancel,
          onPointerCancel: upAndCancel,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 0), // !for a future for margin setting!
            child: Column(
              // Hit testing happens on this keyed Widget, which contains all the pads
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
                                  child: SlideBeatPad(
                                    note: note,
                                    preview: widget.preview,
                                  ),
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
        ),
        if (ref.watch(playModeProv).modulatable)
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
