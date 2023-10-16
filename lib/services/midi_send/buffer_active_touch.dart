import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';

class TouchBuffer {
  /// Data Structure that holds Touch Events, which hold notes and perform geometry operations
  TouchBuffer(this.settings);
  final SendSettings settings;

  List<TouchEvent> _buffer = [];
  List<TouchEvent> get buffer => _buffer;

  /// Add touchevent with noteevent to buffer
  void addNoteOn(CustomPointer touch, NoteEvent noteEvent, Size screenSize) {
    _buffer.add(TouchEvent(touch, noteEvent, settings, screenSize));
  }

  /// Find and return a TouchEvent from the buffer by its uniqueID, if possible
  TouchEvent? getByID(int id) {
    for (final TouchEvent event in _buffer) {
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
  /// This is a common method to determine Channel Pressure
  double averageRadialChangeOfActiveNotes() {
    if (buffer.isEmpty) return 0;

    final double total = buffer
        .where((element) => element.noteEvent.noteOnMessage != null)
        .map((e) => e.radialChange())
        .reduce((value, element) => value + element);

    return total / buffer.length;
  }

  /// Get an average directional change from all currently active notes.
  /// This is a common method to determine Channel Pressure
  Offset averageDirectionalChangeOfActiveNotes({bool absolute = false}) {
    if (buffer.isEmpty) return Offset.zero;

    final Offset total = buffer
        .where((element) => element.noteEvent.noteOnMessage != null)
        .map((e) => e.directionalChangeFromCenter())
        .reduce(
          (value, element) => absolute
              ? value + Offset(element.dx.abs(), element.dy.abs())
              : value + element,
        );

    return Offset(total.dx / buffer.length, total.dy / buffer.length);
  }
}
