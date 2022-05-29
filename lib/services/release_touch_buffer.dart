import 'package:beat_pads/services/services.dart';

class TouchReleaseBuffer {
  final Settings _settings;
  final Function releaseChannel;
  bool checkerRunning = false;
  final Function _notifyListenersOfParent;

  /// Data Structure that holds released Touch Events
  TouchReleaseBuffer(
      this._settings, this.releaseChannel, this._notifyListenersOfParent) {
    // Utils.debugLog("touch release buffer:", _buffer, 1);
  }

  final List<TouchEvent> _buffer = [];
  List<TouchEvent> get buffer => _buffer;

  /// Find and return a TouchEvent from the buffer by its uniqueID, if possible
  TouchEvent? getByID(int id) {
    for (TouchEvent event in _buffer) {
      if (event.uniqueID == id) {
        return event;
      }
    }
    return null;
  }

  bool isNoteInBuffer(int? note) {
    if (note == null) return false;
    for (var event in _buffer) {
      if (event.noteEvent.note == note) return true;
    }
    return false;
  }

  bool get hasActiveNotes {
    return _buffer.any((element) => element.noteEvent.noteOnMessage != null);
  }

  /// Update note in the released events buffer, by adding it or updating
  /// the timer of the corresponding note
  void updateReleasedEvent(TouchEvent event) {
    int index = _buffer.indexWhere(
        (element) => element.noteEvent.note == event.noteEvent.note);

    if (index >= 0) {
      _buffer[index].noteEvent.updateReleaseTime(); // update time
    } else {
      event.noteEvent.updateReleaseTime();
      _buffer.add(event); // or add to buffer
    }
    if (_buffer.isNotEmpty) checkReleasedEvents();
  }

  void checkReleasedEvents() async {
    if (checkerRunning) return; // only one running instance possible!
    checkerRunning = true;

    while (hasActiveNotes) {
      await Future.delayed(
        const Duration(milliseconds: 5),
        () {
          for (int i = 0; i < _buffer.length; i++) {
            if (DateTime.now().millisecondsSinceEpoch -
                    _buffer[i].noteEvent.releaseTime >
                _settings.noteSustainTimeUsable) {
              _buffer[i].noteEvent.noteOff(); // note OFF

              releaseChannel(
                  _buffer[i].noteEvent.channel); // release MPE channel

              _buffer[i].markKillIfNoteOffAndNoAnimation();
              _notifyListenersOfParent(); // notify to update pads
            }
          }
          killAllMarkedReleasedTouchEvents();
        },
      );
    }
    checkerRunning = false;
  }

  void removeNoteFromReleaseBuffer(int note) {
    _buffer.removeWhere((element) => element.noteEvent.note == note);
  }

  void killAllMarkedReleasedTouchEvents() {
    _buffer.removeWhere((element) => element.kill);
    _notifyListenersOfParent();
  }
}
