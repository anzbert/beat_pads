import 'package:beat_pads/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final noteReleaseBuffer =
    NotifierProvider.autoDispose<NoteReleaseBuffer, List<NoteEvent>>(
  NoteReleaseBuffer.new,
);

/// Buffer for [NoteEvent]s that are no longer associated with a [TouchEvent]
class NoteReleaseBuffer extends AutoDisposeNotifier<List<NoteEvent>> {
  bool checkerRunning = false;

  @override
  List<NoteEvent> build() {
    return [];
  }

  /// Update note in the released events buffer, by adding it or updating
  /// the timer of the corresponding note
  void updateReleasedNoteEvent(NoteEvent event) {
    final int index = state.indexWhere((element) => element.note == event.note);

    if (index >= 0) {
      state[index].updateReleaseTime(); // update time
      state = [...state];
    } else {
      event.updateReleaseTime();
      state = [...state, event];
    }
    if (state.isNotEmpty) _checkReleasedNoteEvents();
  }

  Future<void> _checkReleasedNoteEvents() async {
    if (checkerRunning) return; // only one running instance possible!
    checkerRunning = true;

    while (state.isNotEmpty) {
      await Future.delayed(
        const Duration(milliseconds: 5),
        () {
          for (int i = 0; i < state.length; i++) {
            if (DateTime.now().millisecondsSinceEpoch - state[i].releaseTime >
                ref.read(noteReleaseUsable)) {
              state[i].noteOff(); // note OFF
              state[i].markKill();
            }
          }
          state.removeWhere((element) => element.kill);
          state = [...state];
        },
      );
    }
    checkerRunning = false;
  }

  void removeNoteFromReleaseBuffer(int note) {
    state = state.where((element) => element.note != note).toList();
  }

  void allNotesOff() {
    bool refresh = false;
    for (final note in state) {
      if (note.isPlaying) note.noteOff();
      refresh = true;
    }
    if (refresh) state = [...state];
  }

  int isNoteOn(int note) {
    for (final NoteEvent noteEvent in state) {
      if (noteEvent.note == note && noteEvent.isPlaying) {
        return noteEvent.velocity;
      }
    }
    return 0;
  }
}
