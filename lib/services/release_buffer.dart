import 'package:beat_pads/services/_services.dart';
// import 'package:flutter/material.dart';

class ReleaseBuffer {
  final Settings _settings;
  final MemberChannelProvider _channelProvider;
  bool checkerRunning = false;
  final Function _notifyListenersOfParent;

  /// Data Structure that holds released Events
  ReleaseBuffer(
      this._settings, this._channelProvider, this._notifyListenersOfParent);

  final List<TouchEvent> _buffer = [];
  List<TouchEvent> get buffer => _buffer;

  /// Update note in the released events buffer, by adding it or updating
  /// the timer of the corresponding note
  void updateReleasedEvent(TouchEvent event) {
    int index = _buffer.indexWhere((element) =>
        // element.note == event.note && element.channel == event.channel); // allow multiple channels
        element.noteEvent.note == event.noteEvent.note);

    if (index >= 0) {
      _buffer[index].noteEvent.updateReleaseTime(); // update time
    } else {
      event.noteEvent.updateReleaseTime();
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
            if (DateTime.now().millisecondsSinceEpoch -
                    _buffer[i].noteEvent.releaseTime >
                _settings.sustainTimeUsable) {
              _buffer[i].noteEvent.noteOff();
              if (_settings.playMode == PlayMode.mpe) {
                _channelProvider.releaseChannel(_buffer[i].noteEvent);
              }
              _buffer.removeAt(i); // event gets removed here!
              _notifyListenersOfParent();
            }
          }
        },
      );
    }

    checkerRunning = false;
  }

  void removeReleasedEvent(NoteEvent event) {
    int index = _buffer.indexWhere((element) =>
        // element.note == event.note && element.channel == event.channel); // allow multiple channels
        element.noteEvent.note == event.note);

    if (index >= 0) {
      _buffer.removeAt(index); // update time
    }
  }
}
