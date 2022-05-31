import 'package:beat_pads/services/services.dart';

class NoteReleaseBuffer {
  final Settings _settings;
  bool checkerRunning = false;
  final Function _notifyListenersOfParent;

  /// Data Structure that holds released Note Events. Only used by slide playmode!
  NoteReleaseBuffer(this._settings, this._notifyListenersOfParent) {
    // Utils.debugLog("note release buffer:", _buffer, 1);
  }

  List<NoteEvent> _buffer = [];
  List<NoteEvent> get buffer => _buffer;

  /// Update note in the released events buffer, by adding it or updating
  /// the timer of the corresponding note
  void updateReleasedNoteEvent(NoteEvent event) {
    int index = _buffer.indexWhere((element) => element.note == event.note);

    if (index >= 0) {
      _buffer[index].updateReleaseTime(); // update time
    } else {
      event.updateReleaseTime();
      _buffer.add(event); // or add to buffer
    }
    if (_buffer.isNotEmpty) checkReleasedNoteEvents();
  }

  void checkReleasedNoteEvents() async {
    if (checkerRunning) return; // only one running instance possible!
    checkerRunning = true;

    while (_buffer.isNotEmpty) {
      await Future.delayed(
        const Duration(milliseconds: 5),
        () {
          for (int i = 0; i < _buffer.length; i++) {
            if (DateTime.now().millisecondsSinceEpoch - _buffer[i].releaseTime >
                _settings.noteSustainTimeUsable) {
              _buffer[i].noteOff(); // note OFF
              _buffer[i].markKill();
              _notifyListenersOfParent(); // notify to update pads
            }
          }
          _buffer.removeWhere((element) => element.kill);
        },
      );
    }
    checkerRunning = false;
  }

  void removeNoteFromReleaseBuffer(int note) {
    _buffer = _buffer.where((element) => element.note != note).toList();
  }
}
