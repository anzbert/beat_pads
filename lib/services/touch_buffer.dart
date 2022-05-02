import 'package:beat_pads/services/_services.dart';

import 'package:flutter/material.dart';

class TouchBuffer {
  final double maxRadius;

  /// Data Structure that holds Touch Events
  TouchBuffer(this.maxRadius);

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

  void addNoteOn(PointerEvent touch, int note, int channel, int velocity) {
    _buffer.add(TouchEvent(touch.pointer, touch.position, note,
        NoteEvent(channel, note, velocity), maxRadius));
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

  TouchEvent(this.uniqueID, this.origin, int hoveringNote, this.noteEvent,
      this.maxRadius)
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

    return distanceFactor.clamp(0, 1);
  }

  Offset directionalChangeFromCenter() {
    double factorX = (newPosition.dx - origin.dx) / maxRadius;
    double factorY = (newPosition.dy - origin.dy) / maxRadius;

    return Offset(factorX.clamp(0, 1), factorY.clamp(0, 1));
  }

  Offset directionalChangeFromCartesianOrigin(int uniqueID) {
    double factorX = (newPosition.dx - origin.dx + maxRadius) / maxDiameter;
    double factorY = (newPosition.dy - origin.dy + maxRadius) / maxDiameter;

    return Offset(factorX.clamp(0, 1), 1 - factorY.clamp(0, 1));
  }
}
