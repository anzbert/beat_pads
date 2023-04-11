import 'package:beat_pads/services/classes/event_touch.dart';
import 'package:beat_pads/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class TouchBufferBase extends AutoDisposeNotifier<List<TouchEvent>> {
  // Find and return a TouchEvent from the buffer by its uniqueID, if possible
  bool eventInBuffer(int id) {
    for (TouchEvent event in state) {
      if (event.uniqueID == id) {
        return true;
      }
    }
    return false;
  }

  /// Find and return a TouchEvent from the state by its uniqueID, if possible
  bool modifyEvent(int id, void Function(TouchEvent eventInBuffer) modify) {
    for (TouchEvent event in state) {
      if (event.uniqueID == id) {
        modify(event);
        state = [...state];
        return true;
      }
    }
    return false;
  }

  int isNoteOn(int note) {
    for (TouchEvent touch in state) {
      if (touch.noteEvent.note == note && touch.noteEvent.isPlaying) {
        return touch.noteEvent.velocity;
      }
    }
    return 0;
  }

  void markDirty() {
    for (var touch in state) {
      touch.markDirty();
    }
  }

  void allNotesOff() {
    bool refresh = false;
    for (var touch in state) {
      if (touch.noteEvent.isPlaying) touch.noteEvent.noteOff();
      refresh = true;
    }
    if (refresh) state = [...state];
  }
}
