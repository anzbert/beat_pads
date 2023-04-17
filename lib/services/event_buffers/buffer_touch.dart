import 'package:beat_pads/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Base Class used for the active and released touch buffer
abstract class TouchBufferBase extends AutoDisposeNotifier<List<TouchEvent>> {
  /// Use to find and read an event in the buffer, don't use it to modify
  /// this event, but use [modifyEvent] instead.
  TouchEvent? getByID(int id) {
    for (final event in state) {
      if (event.uniqueID == id) {
        return event;
      }
    }
    return null;
  }

  // Find and return a TouchEvent from the buffer by its uniqueID, if possible
  bool eventInBuffer(int id) {
    for (final event in state) {
      if (event.uniqueID == id) {
        return true;
      }
    }
    return false;
  }

  /// Get an event and modify it, if it is available in the buffer
  bool modifyEvent(int id, void Function(TouchEvent eventInBuffer) modify) {
    for (final event in state) {
      if (event.uniqueID == id) {
        modify(event);
        state = [...state];
        return true;
      }
    }
    return false;
  }

  /// Get the Velocity of a note in the buffer. Returns 0 if the note is off
  int isNoteOn(int note) {
    for (final touch in state) {
      if (touch.noteEvent.note == note && touch.noteEvent.isPlaying) {
        return touch.noteEvent.velocity;
      }
    }
    return 0;
  }

  /// Prevents all touchevents in the buffer from receiving further position
  /// updates in ```handlePan```. Irreversible!
  void markDirty() {
    for (final touch in state) {
      touch.markDirty();
    }
  }

  /// Send a NoteOff to all playing notes in the buffer
  void allNotesOff() {
    var refresh = false;
    for (final touch in state) {
      if (touch.noteEvent.isPlaying) touch.noteEvent.noteOff();
      refresh = true;
    }
    if (refresh) state = [...state];
  }
}
