import 'package:beat_pads/screen_beat_pads/beat_pad.dart';
import 'package:beat_pads/services/services.dart';
import 'package:beat_pads/shared_components/_shared.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SlidePads extends ConsumerStatefulWidget {
  const SlidePads({required this.preview, super.key});
  final bool preview;

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
          final Offset position = target.globalToLocal(event.position);
          final Size size = target.size;

          return target.customPad.padValue >= 0 &&
                  target.customPad.padValue < 128
              ? PadAndTouchData(
                  customPad: target.customPad,
                  yPercentage: 1 - (position.dy / size.height).clamp(0, 1),
                  xPercentage: (position.dx / size.width).clamp(0, 1),
                  padBox: PadBox(
                    padPosition: target.localToGlobal(Offset.zero),
                    padSize: target.size,
                  ),
                )
              : null;
        }
      }
    }

    return null;
  }

  void down(PointerEvent touch) {
    final PadAndTouchData? result = _detectTappedItem(touch);

    if (mounted && result != null) {
      final PadTouchAndScreenData data = PadTouchAndScreenData(
        pointer: touch.pointer,
        screenTouchPos: touch.position,
        screenSize: MediaQuery.of(context).size,
        customPad: result.customPad,
        yPercentage: result.yPercentage,
        xPercentage: result.xPercentage,
        padBox: result.padBox,
      );

      ref.read<MidiSender>(senderProvider.notifier).handleNewTouch(data);
    }
  }

  void move(PointerEvent touch) {
    if (ref.read(playModeProv) == PlayMode.noSlide) {
      return;
    }

    if (mounted) {
      final PadAndTouchData? data = _detectTappedItem(touch);
      ref.read(senderProvider.notifier).handlePan(
            NullableTouchAndScreenData(
              pointer: touch.pointer,
              customPad: data?.customPad,
              yPercentage: data?.yPercentage,
              xPercentage: data?.xPercentage,
              screenTouchPos: touch.position,
              padBox: data?.padBox,
            ),
          );
    }
  }

  void upAndCancel(PointerEvent touch) {
    if (mounted) {
      ref
          .read(senderProvider.notifier)
          .handleEndTouch(CustomPointer(touch.pointer, touch.position));

      if (ref.read(modReleaseUsable) > 0 &&
          ref.read(playModeProv).modulationOverlay) {
        final TouchEvent? event = ref
            .read(senderProvider.notifier)
            .playModeHandler
            .touchReleaseBuffer
            .getByID(touch.pointer);
        if (event == null || event.newPosition == event.origin) return;

        final ReturnAnimation returnAnim = ReturnAnimation(
          event.uniqueID,
          ref.read(modReleaseUsable),
          tickerProvider: this,
        );

        final double absoluteMaxRadius =
            MediaQuery.of(context).size.longestSide *
                ref.read(modulationRadiusProv);
        final Offset constrainedPosition = ref.read(modulation2DProv)
            ? Utils.limitToSquare(
                event.origin,
                touch.position,
                absoluteMaxRadius,
              )
            : Utils.limitToCircle(
                event.origin,
                touch.position,
                absoluteMaxRadius,
              );

        returnAnim.animation.addListener(() {
          final TouchReleaseBuffer touchReleaseBuffer = ref
              .read(senderProvider.notifier)
              .playModeHandler
              .touchReleaseBuffer;
          final TouchEvent? touchEvent =
              touchReleaseBuffer.getByID(returnAnim.uniqueID);

          if (!mounted || touchEvent == null) {
            returnAnim.markKillAndDisposeController();
            killAllMarkedAnimations();
            return;
          }
          if (returnAnim.isCompleted) {
            touchEvent
              ..hasReturnAnimation = false
              ..markKillIfNoteOffAndNoAnimation();
            touchReleaseBuffer.killAllMarkedReleasedTouchEvents();

            returnAnim.markKillAndDisposeController();
            killAllMarkedAnimations();
            return;
          } else {
            ref.read(senderProvider.notifier).handlePan(
                  NullableTouchAndScreenData(
                    pointer: touch.pointer,
                    customPad: null,
                    yPercentage: null,
                    xPercentage: null,
                    padBox: null,
                    screenTouchPos: Offset.lerp(
                      constrainedPosition,
                      event.origin,
                      returnAnim.value,
                    )!,
                  ),
                );
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
    final List<List<CustomPad>> rows = ref.watch(rowProv);
    return Stack(
      children: [
        Listener(
          onPointerDown: down,
          onPointerMove: move,
          onPointerUp: upAndCancel,
          onPointerCancel: upAndCancel,
          child: Padding(
            padding: EdgeInsets.zero, // !for a future for margin setting!
            child: Column(
              // Hit testing happens on this keyed Widget, which contains all the pads
              key: _padsWidgetKey,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...rows.map(
                  (row) {
                    return Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                                    child: HitTestObject(
                                      customPad: customPad,
                                      child: SlideBeatPad(
                                        pad: customPad,
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
        if (ref.watch(playModeProv).modulationOverlay)
          RepaintBoundary(child: PaintModulation())
        else if (ref.watch(playModeProv) == PlayMode.mpeTargetPb)
          RepaintBoundary(child: PaintPushStyle()),
      ],
    );
  }

  @override
  void dispose() {
    for (final ReturnAnimation anim in _animations) {
      anim.controller.dispose();
    }
    _animations.clear();
    super.dispose();
  }
}
