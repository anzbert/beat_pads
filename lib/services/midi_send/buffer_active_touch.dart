import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TouchBuffer extends Notifier<List<TouchEvent>> {
  @override
  List<TouchEvent> build() {
    return [];
  }

  /// Add touchevent with noteevent to state
  void addNoteOn(CustomPointer touch, NoteEvent noteEvent, Size screenSize) {
    state = [
      ...state,
      TouchEvent(touch, noteEvent, ref.read(modulationDeadZoneProv),
          ref.read(modulationRadiusProv), screenSize)
    ];
  }

  /// Remove touchevent from state
  void remove(TouchEvent event) {
    state =
        state.where((element) => element.uniqueID != event.uniqueID).toList();
  }

  /// Find and return a TouchEvent from the state by its uniqueID, if possible
  TouchEvent? getByID(int id) {
    for (TouchEvent event in state) {
      if (event.uniqueID == id) {
        return event;
      }
    }
    return null;
  }

  /// Get an average radial change from all currently active notes.
  /// This is a common method to determine Channel Pressure
  double averageRadialChangeOfActiveNotes() {
    if (state.isEmpty) return 0;

    double total = state
        .where((element) => element.noteEvent.noteOnMessage != null)
        .map((e) => e.radialChange())
        .reduce(((value, element) => value + element));

    return total / state.length;
  }

  /// Get an average directional change from all currently active notes.
  /// This is a common method to determine Channel Pressure
  Offset averageDirectionalChangeOfActiveNotes({bool absolute = false}) {
    if (state.isEmpty) return const Offset(0, 0);

    Offset total = state
        .where((element) => element.noteEvent.noteOnMessage != null)
        .map((e) => e.directionalChangeFromCenter())
        .reduce(((value, element) => absolute
            ? value + Offset(element.dx.abs(), element.dy.abs())
            : value + element));

    return Offset(total.dx / state.length, total.dy / state.length);
  }
}
