import 'package:beat_pads/services/services.dart';

class NoteReleaseBuffer {
  final Settings _settings;
  bool checkerRunning = false;
  final Function _notifyListenersOfParent;

  /// Data Structure that holds released Events
  NoteReleaseBuffer(this._settings, this._notifyListenersOfParent);

  List<NoteEvent> _buffer = [];
  List<NoteEvent> get buffer => _buffer;

  // /// Find and return a TouchEvent from the buffer by its uniqueID, if possible
  // NoteEvent? getByNote(int id) {
  //   for (NoteEvent event in _buffer) {
  //     if (event.note == id) {
  //       return event;
  //     }
  //   }
  //   return null;
  // }

  // bool isNoteInBuffer(int? note) {
  //   if (note == null) return false;
  //   for (var event in _buffer) {
  //     if (event.note == note) return true;
  //   }
  //   return false;
  // }

  /// Update note in the released events buffer, by adding it or updating
  /// the timer of the corresponding note
  void updateReleasedNoteEvent(NoteEvent event) {
    int index = _buffer.indexWhere((element) =>
        // element.note == event.note && element.channel == event.channel); // allow multiple channels
        element.note == event.note);

    if (index >= 0) {
      _buffer[index].updateReleaseTime(); // update time
    } else {
      event.updateReleaseTime();
      _buffer.add(event); // or add to buffer
    }
    if (_buffer.isNotEmpty) checkReleasedEvents();
  }

  /// Async function, which checks for expiry of the auto-sustain on all released notes
  void checkReleasedEvents() async {
    if (checkerRunning) return; // only one running instance possible!
    checkerRunning = true;

    while (_buffer.isNotEmpty) {
      await Future.delayed(
        const Duration(milliseconds: 5),
        () {
          for (int i = 0; i < _buffer.length; i++) {
            if (DateTime.now().millisecondsSinceEpoch - _buffer[i].releaseTime >
                _settings.sustainTimeUsable) {
              _buffer[i].noteOff(); // note OFF

              _buffer.removeAt(i); // remove event from buffer
              _notifyListenersOfParent(); // notify listeners so pads get updated
            }
          }
        },
      );
    }

    checkerRunning = false;
  }

  void removeNoteFromReleaseBuffer(int note) {
    _buffer = _buffer.where((element) => element.note != note).toList();
  }
}
