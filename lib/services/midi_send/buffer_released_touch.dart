import 'package:beat_pads/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final touchReleaseBuffer =
    NotifierProvider.autoDispose<TouchReleaseBuffer, List<TouchEvent>>(
        () => TouchReleaseBuffer());

/// Data Structure that holds released Touch Events
class TouchReleaseBuffer extends TouchBufferBase {
  bool checkerRunning = false;

  @override
  List<TouchEvent> build() {
    return [];
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

  /// Update note in the released events buffer, by adding it or updating
  /// the timer of the corresponding note
  void updateReleasedEvent(TouchEvent event) {
    int index = state.indexWhere(
        (element) => element.noteEvent.note == event.noteEvent.note);

    if (index >= 0) {
      state[index].noteEvent.updateReleaseTime(); // update time
      ref
          .read(mpeChannelProv.notifier)
          .releaseMPEChannel(state[index].noteEvent.channel);
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

              ref.read(mpeChannelProv.notifier).releaseMPEChannel(
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
        ref
            .read(mpeChannelProv.notifier)
            .releaseMPEChannel(element.noteEvent.channel);
      }
    }
    if (state.any((element) => element.noteEvent.note == note)) {
      state = state.where((element) => element.noteEvent.note != note).toList();
    }
  }

  void killAllMarkedReleasedTouchEvents() {
    if (state.any((element) => element.kill)) {
      state = state.where((element) => !element.kill).toList();
    }
  }
}
