import 'package:beat_pads/services/gen_utils.dart';
import 'package:flutter/material.dart';

class TouchBuffer {
  TouchBuffer();

  List<TouchEvent> _buffer = [];
  List<TouchEvent> get buffer => _buffer;

  TouchEvent? findByPointer(int searchPointer) {
    for (TouchEvent event in _buffer) {
      if (event.touch.pointer == searchPointer) {
        return event;
      }
    }
    return null;
  }

  debug() {
    for (var event in _buffer) {
      Utils.logd(event.touch);
    }
  }

  clear() => _buffer = [];

  void add(TouchEvent event) => buffer.add(event);

  bool updateWith(TouchEvent updatedEvent) {
    int index = _buffer.indexWhere(
        (element) => element.touch.pointer == updatedEvent.touch.pointer);
    if (index == -1) return false;

    _buffer[index] = updatedEvent;
    return true;
  }

  void remove(int searchID) {
    _buffer =
        _buffer.where((element) => element.touch.pointer != searchID).toList();
  }
}

class TouchEvent {
  TouchEvent(this.touch, this.note);

  final PointerEvent touch; // unique pointer down event

  int? note;
  bool blockSlide = false;
}
