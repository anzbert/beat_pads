import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';

class PlayModePolyAT extends PlayModeHandler {
  final ModPolyAfterTouch1D polyATMod;
  PlayModePolyAT(super.screenSize, super.notifyParent)
      : polyATMod = ModPolyAfterTouch1D();

  @override
  void handleNewTouch(CustomPointer touch, int noteTapped, Size screenSize) {
    polyATMod.send(settings.channel, noteTapped, 0);
    super.handleNewTouch(touch, noteTapped, screenSize);
  }

  @override
  void handlePan(CustomPointer touch, int? note) {
    TouchEvent? eventInBuffer = touchBuffer.getByID(touch.pointer) ??
        touchReleaseBuffer.getByID(touch.pointer);
    if (eventInBuffer == null) return;

    eventInBuffer.updatePosition(touch.position);
    notifyParent(); // for circle drawing

    polyATMod.send(
      settings.channel,
      eventInBuffer.noteEvent.note,
      eventInBuffer.radialChange(),
    );
  }
}
