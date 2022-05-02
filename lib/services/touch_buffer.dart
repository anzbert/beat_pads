import 'package:beat_pads/services/_services.dart';

import 'package:flutter/material.dart';

class TouchBuffer {
  double maxRadius;
  double threshold;

  /// Data Structure that holds Touch Events
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

  void updateGeometry(double maxR, double thresh) {
    maxRadius = maxR;
    threshold = thresh;
  }

  void addNoteOn(PointerEvent touch, int note, int channel, int velocity) {
    _buffer.add(TouchEvent(touch.pointer, touch.position,
        NoteEvent(channel, note, velocity), maxRadius, threshold));
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
  final double maxDiameter;
  final int uniqueID;
  NoteEvent noteEvent;
  final List<Event> mpeEvents = [];
  final Offset origin; // unique pointer down event
  Offset newPosition;
  final double maxRadius;
  final double threshold;

  TouchEvent(this.uniqueID, this.origin, this.noteEvent, this.maxRadius,
      this.threshold)
      : newPosition = origin,
        maxDiameter = maxRadius * 2;

  void updatePosition(Offset updatedPosition) {
    newPosition = updatedPosition;
  }

  bool _dirty = false;
  void markDirty() => _dirty = true;
  bool get dirty => _dirty;

  // GEOMETRY functions:
  double radialChange() {
    double distanceFactor =
        Utils.offsetDistance(origin, newPosition) / maxRadius;

    return limitValue(distanceFactor.clamp(0, 1));
  }

  Offset directionalChangeFromCenter() {
    double factorX = (newPosition.dx - origin.dx) / maxRadius;
    double factorY = (newPosition.dy - origin.dy) / maxRadius;

    return Offset(
        limitValue(factorX).clamp(0, 1), limitValue(factorY).clamp(0, 1));
  }

  Offset directionalChangeFromCartesianOrigin(int uniqueID) {
    double factorX = (newPosition.dx - origin.dx + maxRadius) / maxDiameter;
    double factorY = (newPosition.dy - origin.dy + maxRadius) / maxDiameter;

    return Offset(
        limitValue(factorX).clamp(0, 1), 1 - limitValue(factorY).clamp(0, 1));
  }

  double limitValue(double input) {
    double limited = input > threshold ? input : 0;
    return Utils.mapValueToTargetRange(limited, threshold, 1, 0, 1);
  }
}
