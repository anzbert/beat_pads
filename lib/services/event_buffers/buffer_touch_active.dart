import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final touchBuffer =
    NotifierProvider.autoDispose<_TouchBuffer, List<TouchEvent>>(
  _TouchBuffer.new,
);

class _TouchBuffer extends TouchBufferBase {
  @override
  List<TouchEvent> build() => [];

  /// Add [TouchEvent] with a [NoteEvent] to the buffers state
  void addNoteOn(CustomPointer touch, NoteEvent noteEvent, Size screenSize) {
    state = [
      ...state,
      TouchEvent(
        touch,
        noteEvent,
        ref.read(modulationDeadZoneProv),
        ref.read(modulationRadiusProv),
        screenSize,
      )
    ];
  }

  /// Remove a [TouchEvent] from the state, by its id number
  void removeById(int id) {
    state = state.where((element) => element.uniqueID != id).toList();
  }

  /// Get an average radial change from all currently active notes.
  /// This is a common method to determine Channel Pressure
  double averageRadialChangeOfActiveNotes() {
    if (state.isEmpty) return 0;

    final total = state
        .where((element) => element.noteEvent.noteOnMessage != null)
        .map((e) => e.radialChange())
        .reduce((value, element) => value + element);

    return total / state.length;
  }

  /// Get an average directional change from all currently active notes.
  /// This is a common method to determine Channel Pressure
  Offset averageDirectionalChangeOfActiveNotes({bool absolute = false}) {
    if (state.isEmpty) return Offset.zero;

    final total = state
        .where((element) => element.noteEvent.noteOnMessage != null)
        .map((e) => e.directionalChangeFromCenter())
        .reduce(
          (value, element) => absolute
              ? value + Offset(element.dx.abs(), element.dy.abs())
              : value + element,
        );

    return Offset(total.dx / state.length, total.dy / state.length);
  }
}
