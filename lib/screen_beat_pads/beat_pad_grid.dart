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
              yPos,
              yDeadZone,
              ySize - yDeadZone,
              0,
              ySize - yDeadZone * 2,
            );
            ySize = ySize - yDeadZone * 2;
          }

          double xPos = target.globalToLocal(event.position).dx;
          double xSize = target.size.width;

          const double xDeadZone = 20; // pixels

          if (xPos < xDeadZone) {
            xPos = 0;
          } else if (xPos > xSize - xDeadZone) {
            xPos = xSize;
          } else {
            xPos = Utils.mapValueToTargetRange(
              xPos,
              xDeadZone,
              xSize - xDeadZone,
              0,
              xSize - xDeadZone * 2,
            );
            xSize = xSize - xDeadZone * 2;
          }

          return target.index >= 0 && target.index < 128
              ? PadAndTouchData(
                  padId: target.index, // = Note
                  yPercentage: 1 - (yPos / ySize).clamp(0, 1),
                  xPercentage: (xPos / xSize).clamp(0, 1),
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
        padNote: result.padId,
        yPercentage: result.yPercentage,
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
              padNote: data?.padId,
              yPercentage: data?.yPercentage,
              xPercentage: data?.xPercentage,
              screenTouchPos: touch.position,
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
                    padNote: null,
                    yPercentage: null,
                    xPercentage: null,
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
        if (ref.watch(playModeProv).modulationOverlay)
          RepaintBoundary(child: PaintModulation()),
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
