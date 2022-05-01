import 'package:beat_pads/services/_services.dart';

import 'package:flutter/material.dart';

class TouchBuffer {
  final double maxRadius;
  final double maxDiameter;

  /// Data Structure that holds Touch Events
  TouchBuffer(this.maxRadius) : maxDiameter = maxRadius * 2;

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
        NoteEvent(channel, note, velocity)));
  }

  void updatePosition(PointerEvent updatedEvent, int? note) {
    int index = _buffer
        .indexWhere((element) => element.uniqueID == updatedEvent.pointer);
    if (index == -1) return;

    _buffer[index].update(updatedEvent.position, note);
  }

  void remove(TouchEvent event) {
    _buffer =
        _buffer.where((element) => element.uniqueID != event.uniqueID).toList();
  }

  // GEOMETRY functions:
  double? radialChange(int uniqueID) {
    TouchEvent? event = getByID(uniqueID);
    if (event == null) return null;

    double distanceFactor =
        Utils.offsetDistance(event.origin, event.newPosition) / maxRadius;

    return distanceFactor.clamp(0, 1);
  }

  Offset? directionalChangeFromCenter(int uniqueID) {
    TouchEvent? event = getByID(uniqueID);
    if (event == null) return null;

    double factorX = (event.newPosition.dx - event.origin.dx) / maxRadius;
    double factorY = (event.newPosition.dy - event.origin.dy) / maxRadius;

    return Offset(factorX.clamp(0, 1), factorY.clamp(0, 1));
  }

  Offset? directionalChangeFromCartesianOrigin(int uniqueID) {
    TouchEvent? event = getByID(uniqueID);
    if (event == null) return null;

    double factorX =
        (event.newPosition.dx - event.origin.dx + maxRadius) / maxDiameter;
    double factorY =
        (event.newPosition.dy - event.origin.dy + maxRadius) / maxDiameter;

    return Offset(factorX.clamp(0, 1), 1 - factorY.clamp(0, 1));
  }
}

class TouchEvent {
  final int uniqueID;
  NoteEvent noteEvent;
  final List<Event> mpeEvents = [];
  final Offset origin; // unique pointer down event
  Offset newPosition;
  // int? hoveringNote; // currently on this note (or not over any)

  TouchEvent(this.uniqueID, this.origin, int hoveringNote, this.noteEvent)
      : newPosition = origin;

  update(Offset newPosition, int? note) {
    newPosition = newPosition;
    note = note;
  }

  bool _dirty = false;
  markDirty() => _dirty = true;
  bool get dirty => _dirty;

  // bool _newInstance = true;
  // bool get isNew {
  //   bool returnValue = _newInstance;
  //   _newInstance = false;
  //   return returnValue;
  // }

  // bool _dying = false;
  // markDying() => _dying = true;
  // bool get isDying => _dying;

  // bool _moved = false;
  // markMoved() => _moved = true;
  // bool get didMove {
  //   bool returnValue = _moved;
  //   _moved = false;
  //   return returnValue;
  // }
}
