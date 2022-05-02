import 'package:beat_pads/services/_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command_messages.dart';

class TouchBuffer {
  double maxRadius;
  double threshold;

  /// Data Structure that holds Touch Events, which hold notes and perform geometry operations
  TouchBuffer(this.maxRadius, this.threshold);

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

  void updateGeometryParameters(double maxR, double thresh) {
    maxRadius = maxR;
    threshold = thresh;
  }

  void addNoteOn(PointerEvent touch, NoteEvent noteEvent) {
    _buffer.add(TouchEvent(
        touch.pointer, touch.position, noteEvent, maxRadius, threshold));
  }

  void updatePosition(PointerEvent updatedEvent) {
    int index = _buffer
        .indexWhere((element) => element.uniqueID == updatedEvent.pointer);
    if (index == -1) return;

    _buffer[index].updatePosition(updatedEvent.position);
  }

  void remove(TouchEvent event) {
    _buffer =
        _buffer.where((element) => element.uniqueID != event.uniqueID).toList();
  }

  double getAverageChangeOfAllPads() {
    if (buffer.isEmpty) return 0;

    double total = buffer
        .where((element) => element.noteEvent.currentNoteOn != null)
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

  /// Holds geometry, note and modulation information
  TouchEvent(this.uniqueID, this.origin, this.noteEvent, this.maxRadius,
      this.threshold)
      : newPosition = origin,
        maxDiameter = maxRadius * 2;

  bool _dirty = false;
  void markDirty() => _dirty = true;
  bool get dirty => _dirty;

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

  // TODO remove middle with threshold?
  Offset directionalChangeFromCartesianOrigin() {
    double factorX = (newPosition.dx - origin.dx + maxRadius) / maxDiameter;
    double factorY = (newPosition.dy - origin.dy + maxRadius) / maxDiameter;

    return Offset(factorX.clamp(0, 1), 1 - factorY.clamp(0, 1));
  }

  double limitValue(double input) {
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
