import 'package:beat_pads/screen_beat_pads/beat_pad.dart';
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
  late PlayMode playmode;
  late bool upperzone;

  @override
  void initState() {
    super.initState();
    playmode = ref.read(playModeProv);
    upperzone = ref.read(zoneProv);
    if (playmode == PlayMode.mpe && !widget.preview) {
      MPEinitMessage(
              memberChannels: ref.read(mpeMemberChannelsProv),
              upperZone: upperzone)
          .send();
    }
  }

  final GlobalKey _padsWidgetKey = GlobalKey();

  final List<ReturnAnimation> _animations = [];
  void killAllMarkedAnimations() {
    _animations.removeWhere((element) => element.kill);
  }

  /// Returns a CustomPointer with the index of the clicked pad and the position Offset within the pad surface
  PadAndTouchData? _detectTappedItem(PointerEvent event) {
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
          // final Offset position = target.globalToLocal(event.position);

          double yPos = target.globalToLocal(event.position).dy;
          double ySize = target.size.height;

          const double yDeadZone = 20; // pixels

          if (yPos < yDeadZone) {
            yPos = 0;
          } else if (yPos > ySize - yDeadZone) {
            yPos = ySize;
          } else {
            yPos = Utils.mapValueToTargetRange(
                yPos, yDeadZone, ySize - yDeadZone, 0, ySize - yDeadZone * 2);
            ySize = ySize - yDeadZone * 2;
          }

          return target.index >= 0 && target.index < 128
              ? PadAndTouchData(
                  padId: target.index, // = Note
                  yPercentage: 1 - (yPos / ySize).clamp(0, 1),
                )
              : null;
        }
      }
    }

    return null;
  }

  down(PointerEvent touch) {
    PadAndTouchData? result = _detectTappedItem(touch);

    if (mounted && result != null) {
      PadTouchAndScreenData data = PadTouchAndScreenData(
          pointer: touch.pointer,
          screenTouchPos: touch.position,
          screenSize: MediaQuery.of(context).size,
          padNote: result.padId,
          yPercentage: result.yPercentage);

      ref.read(senderProvider).handleNewTouch(data);
    }
  }

  move(PointerEvent touch) {
    if (ref.read(playModeProv) == PlayMode.noSlide) {
      return;
    }

    if (mounted) {
      PadAndTouchData? data = _detectTappedItem(touch);
      ref.read(senderProvider).handlePan(NullableTouchAndScreenData(
          pointer: touch.pointer,
          padNote: data?.padId,
          yPercentage: data?.yPercentage,
          screenTouchPos: touch.position));
    }
  }

  upAndCancel(PointerEvent touch) {
    if (mounted) {
      ref
          .read(senderProvider)
          .handleEndTouch(CustomPointer(touch.pointer, touch.position));

      if (ref.read(modReleaseUsable) > 0 &&
          ref.read(playModeProv).modulatable) {
        TouchEvent? event =
            ref.read(touchReleaseBuffer.notifier).getByID(touch.pointer);
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
          TouchEvent? touchEvent = ref
              .read(touchReleaseBuffer.notifier)
              .getByID(returnAnim.uniqueID);

          if (!mounted || touchEvent == null) {
            returnAnim.markKillAndDisposeController();
            killAllMarkedAnimations();
            return;
          }
          if (returnAnim.isCompleted) {
            ref
                .read(touchReleaseBuffer.notifier)
                .modifyEvent(returnAnim.uniqueID, (releasedTouchEvent) {
              releasedTouchEvent.hasReturnAnimation = false;
              releasedTouchEvent.markKillIfNoteOffAndNoAnimation();
            });
            ref
                .read(touchReleaseBuffer.notifier)
                .killAllMarkedReleasedTouchEvents();

            returnAnim.markKillAndDisposeController();
            killAllMarkedAnimations();
            return;
          } else {
            ref.read(senderProvider).handlePan(NullableTouchAndScreenData(
                pointer: touch.pointer,
                padNote: null,
                yPercentage: null,
                screenTouchPos: Offset.lerp(
                    constrainedPosition, event.origin, returnAnim.value)!));
            setState(() {});
          }
        });

        ref.read(touchReleaseBuffer.notifier).modifyEvent(touch.pointer,
            (activeEvent) {
          activeEvent.hasReturnAnimation = true;
        });
        returnAnim.forward();
        _animations.add(returnAnim);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<List<CustomPad>> rows = ref.watch(rowProv);
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
                            (customPad) {
                              switch (customPad.padType) {
                                case PadType.encoder:
                                  // Case not implemented...
                                  return const SizedBox.expand();
                                case PadType.chord:
                                  // Case not implemented...
                                  return const SizedBox.expand();
                                case PadType.note:
                                  return Expanded(
                                    flex: 1,
                                    child: HitTestObject(
                                      index: customPad.padValue,
                                      child: SlideBeatPad(
                                        note: customPad.padValue,
                                        preview: widget.preview,
                                      ),
                                    ),
                                  );
                              }
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
    if (playmode == PlayMode.mpe && !widget.preview) {
      MPEinitMessage(memberChannels: 0, upperZone: upperzone).send();
    }

    for (ReturnAnimation anim in _animations) {
      anim.controller.dispose();
    }
    _animations.clear();

    super.dispose();
  }
}
