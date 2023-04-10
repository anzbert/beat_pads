import 'package:beat_pads/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final touchReleaseBuffer =
    NotifierProvider.autoDispose<TouchReleaseBuffer, List<TouchEvent>>(
        () => TouchReleaseBuffer(releaseMPEChannel));

/// Data Structure that holds released Touch Events
class TouchReleaseBuffer extends AutoDisposeNotifier<List<TouchEvent>> {
  final Function releaseMPEChannel;
  bool checkerRunning = false;

  TouchReleaseBuffer(this.releaseMPEChannel);

  @override
  List<TouchEvent> build() {
    return [];
  }

  /// Find and return a TouchEvent from the buffer by its uniqueID, if possible
  TouchEvent? getByID(int id) {
    for (TouchEvent event in state) {
      if (event.uniqueID == id) {
        return event;
      }
    }
    return null;
  }

  bool isNoteInBuffer(int? note) {
    if (note == null) return false;
    for (var event in state) {
      if (event.noteEvent.note == note) return true;
    }
    return false;
  }

  bool get hasActiveNotes {
    return state.any((element) => element.noteEvent.noteOnMessage != null);
  }

  void allNotesOff() {
    bool refresh = false;
    for (var touch in state) {
      if (touch.noteEvent.isPlaying) touch.noteEvent.noteOff();
      refresh = true;
    }
    if (refresh) state = [...state];
  }

  /// Update note in the released events buffer, by adding it or updating
  /// the timer of the corresponding note
  void updateReleasedEvent(TouchEvent event) {
    int index = state.indexWhere(
        (element) => element.noteEvent.note == event.noteEvent.note);

    if (index >= 0) {
      state[index].noteEvent.updateReleaseTime(); // update time
      releaseMPEChannel(state[index].noteEvent.channel);
      state[index].noteEvent.updateMPEchannel(event.noteEvent.channel);
      state = [...state];
    } else {
      event.noteEvent.updateReleaseTime();
      state = [...state, event];
    }
    if (state.isNotEmpty) checkReleasedEvents();
  }

  void checkReleasedEvents() async {
    if (checkerRunning) return; // only one running instance possible!
    checkerRunning = true;

    while (hasActiveNotes) {
      await Future.delayed(
        const Duration(milliseconds: 5),
        () {
          for (int i = 0; i < state.length; i++) {
            if (DateTime.now().millisecondsSinceEpoch -
                    state[i].noteEvent.releaseTime >
                ref.read(noteReleaseUsable)) {
              state[i].noteEvent.noteOff(); // note OFF

              releaseMPEChannel(
                  state[i].noteEvent.channel); // release MPE channel

              state[i]
                  .markKillIfNoteOffAndNoAnimation(); // mark to remove from buffer
              state = [...state];
            }
          }
          killAllMarkedReleasedTouchEvents();
        },
      );
    }
    checkerRunning = false;
  }

  void removeNoteFromReleaseBuffer(int note) {
    for (var element in state) {
      if (element.noteEvent.note == note) {
        releaseMPEChannel(element.noteEvent.channel);
      }
    }
    if (state.any((element) => element.noteEvent.note == note)) {
      state = state.where((element) => element.noteEvent.note != note).toList();
    }
  }

  void killAllMarkedReleasedTouchEvents() {
    // state.removeWhere((element) => element.kill);
    if (state.any((element) => element.kill)) {
      state = state.where((element) => !element.kill).toList();
    }
  }
}
