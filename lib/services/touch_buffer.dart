import 'package:beat_pads/services/_services.dart';
import 'package:flutter/material.dart';

class TouchBuffer {
  final Settings settings;
  final Size screenSize;

  /// Data Structure that holds Touch Events, which hold notes and perform geometry operations
  TouchBuffer(this.settings, this.screenSize);

  List<TouchEvent> _buffer = [];
  List<TouchEvent> get buffer => _buffer;

  /// Add touchevent with noteevent to buffer
  void addNoteOn(PointerEvent touch, NoteEvent noteEvent) {
    _buffer.add(TouchEvent(touch, noteEvent, settings, screenSize));
  }

  /// Find and return a TouchEvent from the buffer by its uniqueID, if possible
  TouchEvent? getByID(int id) {
    for (TouchEvent event in _buffer) {
      if (event.uniqueID == id) {
        return event;
      }
    }
    return null;
  }

  /// Remove touchevent from buffer
  void remove(TouchEvent event) {
    _buffer =
        _buffer.where((element) => element.uniqueID != event.uniqueID).toList();
  }

  /// Get an average radial change from all currently active notes.
  /// For example, this is a common method to determine Channel Pressure
  double getAverageRadialChangeOfAllPads([int? channel]) {
    if (buffer.isEmpty) return 0;

    double total = buffer
        .where((element) {
          if (channel == null) {
            return element.noteEvent.noteOnMessage != null;
          } else {
            return element.noteEvent.noteOnMessage != null &&
                element.noteEvent.channel == channel;
          }
        })
        .map((e) => e.radialChange())
        .reduce(((value, element) => value + element));

    return total / buffer.length;
  }
}

class TouchEvent {
  final int uniqueID;

  // Note and modulation parameters:
  NoteEvent noteEvent;
  ModMapping modMapping = ModMapping();

  // Geometry parameters:
  final Offset origin;
  final double maxRadius;
  final double maxDiameter;
  final double deadZone;
  Offset newPosition;

  /// Holds geometry, note and modulation information this.uniqueID, this.origin,
  TouchEvent(
      PointerEvent touch, this.noteEvent, Settings settings, Size screenSize)
      : origin = touch.position,
        newPosition = touch.position,
        uniqueID = touch.pointer,
        maxDiameter = screenSize.longestSide * settings.modulationRadius * 2,
        deadZone = settings.modulationDeadZone,
        maxRadius = screenSize.longestSide * settings.modulationRadius;

  /// Prevents touchevent from receiving further position updates in move(). Irreversible!
  void markDirty() => _dirty = true;
  bool _dirty = false;
  bool get dirty => _dirty;

  /// Updates stored touch event with latest touch position. Used for geometry
  void updatePosition(Offset updatedPosition) {
    newPosition = updatedPosition;
  }

  /// Get the radial change factor from the origin of the
  /// touch to the current position in the context of the maximum Radius.
  /// Produces values from 0 to 1 from center to maxium Radius.
  double radialChange({Curve curve = Curves.easeIn, bool deadZone = true}) {
    double distanceFactor =
        (Utils.offsetDistance(origin, newPosition) / maxRadius).clamp(0, 1);

    return Utils.curveTransform(
      deadZone ? applyDeadZone(distanceFactor) : distanceFactor,
      curve,
    );
  }

  /// Get the directional change factor from the origin of the
  /// touch to the current position in the context of the maximum Radius.
  /// Produced values from -1 to 1 on X and Y Axis within the maximum Diameter.
  Offset directionalChangeFromCenter(
      {Curve curve = Curves.easeIn, bool deadZone = true}) {
    double factorX = ((newPosition.dx - origin.dx) / maxRadius).clamp(-1, 1);
    double factorY = ((-newPosition.dy + origin.dy) / maxRadius).clamp(-1, 1);

    return Offset(
      Utils.curveTransform(
        deadZone ? applyDeadZone(factorX) : factorX,
        curve,
      ),
      Utils.curveTransform(
        deadZone ? applyDeadZone(factorY) : factorY,
        curve,
      ),
    );
  }

  /// Applies a deadZone to an input value, which means that the function
  /// only returns a value when it is above the given threshhold.
  /// Then remaps range **from** 0 to 1.0 **to** deadZone to 1.0.
  double applyDeadZone(double input) {
    if (input.isNegative) {
      if (input > -deadZone) return 0;
      return Utils.mapValueToTargetRange(input, -1, -deadZone, -1, 0);
    }
    if (input < deadZone) return 0;
    return Utils.mapValueToTargetRange(input, deadZone, 1, 0, 1);
  }
}
