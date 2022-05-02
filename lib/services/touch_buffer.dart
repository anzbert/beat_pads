import 'package:beat_pads/services/_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command_messages.dart';

class TouchBuffer {
  final Settings _settings;
  final Size _screenSize;

  /// Data Structure that holds Touch Events, which hold notes and perform geometry operations
  TouchBuffer(this._settings, this._screenSize);

  List<TouchEvent> _buffer = [];
  List<TouchEvent> get buffer => _buffer;

  TouchEvent? getByID(int id) {
    for (TouchEvent event in _buffer) {
      if (event.uniqueID == id) {
        return event;
      }
    }
    return null;
  }

  /// Add touchevent with noteevent to buffer
  void addNoteOn(PointerEvent touch, NoteEvent noteEvent) {
    _buffer.add(TouchEvent(touch, noteEvent, _settings, _screenSize));
  }

  /// Remove touchevent from buffer
  void remove(TouchEvent event) {
    _buffer =
        _buffer.where((element) => element.uniqueID != event.uniqueID).toList();
  }

  /// Get an average radial change from all currently active notes
  double getAverageRadialChangeOfAllPads() {
    if (buffer.isEmpty) return 0;

    double total = buffer
        .where((element) => element.noteEvent.noteOnMessage != null)
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
  final double threshold;
  Offset newPosition;

  /// Holds geometry, note and modulation information this.uniqueID, this.origin,
  TouchEvent(
      PointerEvent touch, this.noteEvent, Settings _settings, Size _screenSize)
      : origin = touch.position,
        newPosition = touch.position,
        uniqueID = touch.pointer,
        maxDiameter = _screenSize.width * 2 * 0.15,
        threshold = 0.2,
        maxRadius = _screenSize.width * 0.15;

  /// Prevents touchevent from receiving further position updates in move()
  void markDirty() => _dirty = true;
  bool _dirty = false;
  bool get dirty => _dirty;

  /// updates stored touch event with latest touch position. Used for geometry
  void updatePosition(Offset updatedPosition) {
    newPosition = updatedPosition;
  }

  // GEOMETRY functions:
  double radialChange() {
    double distanceFactor =
        (Utils.offsetDistance(origin, newPosition) / maxRadius).clamp(0, 1);

    return limitValue(distanceFactor);
  }

  Offset absoluteDirectionalChangeFromCenter() {
    double factorX = ((newPosition.dx - origin.dx) / maxRadius).clamp(-1, 1);
    double factorY = ((newPosition.dy - origin.dy) / maxRadius).clamp(-1, 1);

    return Offset(limitValue(factorX.abs()), limitValue(factorY.abs()));
  }

  // broken
  Offset directionalChangeFromCenter() {
    double factorX = ((newPosition.dx - origin.dx) / maxRadius).clamp(-1, 1);
    double factorY = ((-newPosition.dy + origin.dy) / maxRadius).clamp(-1, 1);

    return Offset(limitValue(factorX), limitValue(factorY));
  }

  /// only return value when above threshhold. also remap range to start past threshold at 0.
  double limitValue(double input) {
    if (input.isNegative) {
      if (input > -threshold) return 0;
      return Utils.mapValueToTargetRange(input, -1, -threshold, -1, 0);
    }
    if (input < threshold) return 0;
    return Utils.mapValueToTargetRange(input, threshold, 1, 0, 1);
  }
}

class ModMapping {
  PolyATMessage? polyAT;
  CCMessage? cc;
  CCMessage? cc2;
  ATMessage? at;
  PitchBendMessage? pitchBend;

  /// Modulation possible on a pad
  ModMapping({this.polyAT, this.cc, this.at, this.pitchBend});
}
