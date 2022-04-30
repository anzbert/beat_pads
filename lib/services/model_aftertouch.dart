import 'package:beat_pads/services/_services.dart';

import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command_messages.dart';

class AftertouchModel extends ChangeNotifier {
  Settings _settings;
  Size screenSize;
  AftertouchModel(this._settings, this.screenSize)
      : atCircleBuffer = CircleBuffer(screenSize.width * 0.17),
        outlineBuffer = CircleBuffer(screenSize.width * 0.17);

  AftertouchModel update(Settings settings) {
    _settings = settings;
    return this;
  }

  final CircleBuffer atCircleBuffer;
  final CircleBuffer outlineBuffer;

  final curve = Curves.easeIn;

  double getOpacity(double radius, {double scale = 1}) {
    double fraction =
        radius.clamp(0, atCircleBuffer.maxRadius) / atCircleBuffer.maxRadius;
    double transformed = curve.transform(fraction);
    double scaled = transformed * scale.clamp(0, 1);
    return scaled;
  }

  int getValue(double radius) =>
      (curve.transform(radius.clamp(0, atCircleBuffer.maxRadius) /
                  atCircleBuffer.maxRadius) *
              127)
          .toInt();

  // TOUCH HANDLIMG
  void push(PointerEvent touch, int note) {
    atCircleBuffer.add(touch.pointer, touch.position, note);
    outlineBuffer.add(touch.pointer, touch.position, note);

    if (_settings.playMode == PlayMode.polyAT) {
      PolyATMessage(
        channel: _settings.channel,
        note: atCircleBuffer.buffer[touch.pointer]!.note,
        pressure: 0,
      ).send();
    }
    if (_settings.playMode == PlayMode.cc) {
      CCMessage(
        channel: (_settings.channel + 2) % 16,
        controller: atCircleBuffer.buffer[touch.pointer]!.note,
        value: 0,
      ).send();
    }
    notifyListeners();
  }

  void move(PointerEvent touch) {
    if (atCircleBuffer.buffer[touch.pointer] == null) return;

    atCircleBuffer.updatePointer(touch.pointer, touch.position);
    outlineBuffer.updatePointer(touch.pointer, touch.position);

    if (_settings.playMode == PlayMode.polyAT) {
      PolyATMessage(
        channel: _settings.channel,
        note: atCircleBuffer.buffer[touch.pointer]!.note,
        pressure: getValue(atCircleBuffer.buffer[touch.pointer]!.radius),
      ).send();
    }
    if (_settings.playMode == PlayMode.cc) {
      CCMessage(
        channel: (_settings.channel + 2) % 16,
        controller: atCircleBuffer.buffer[touch.pointer]!.note,
        value: getValue(atCircleBuffer.buffer[touch.pointer]!.radius),
      ).send();
    }

    notifyListeners();
  }

  void lift(PointerEvent touch) {
    if (atCircleBuffer.buffer[touch.pointer] == null) return;

    atCircleBuffer.remove(touch.pointer);
    outlineBuffer.remove(touch.pointer);
    notifyListeners();
  }
}

class CircleBuffer {
  final double maxRadius;
  CircleBuffer(this.maxRadius);

  final Map<int, ATCircle> buffer = {};

  Iterable<ATCircle> get values => buffer.values;

  void add(int key, Offset center, int note) {
    buffer[key] = ATCircle(center, center, note, maxRadius);
  }

  void updatePointer(int key, Offset newPointer) {
    if (buffer[key] != null) {
      buffer[key]!.pointer = newPointer;
    }
  }

  void remove(int key) {
    // TODO: MAYBE ADD ANIMATION HERE
    if (buffer[key] != null) {
      buffer.remove(key);
    }
  }
}

class ATCircle {
  final int note;
  final Offset center;
  final double maxRadius;
  Offset pointer;

  ATCircle(this.center, this.pointer, this.note, this.maxRadius);

  double get radius {
    double newRadius = Utils.offsetDistance(center, pointer);
    if (newRadius > maxRadius) return maxRadius;
    return newRadius;
  }

  // EXPERIMENTAL STUFF:
  double get dx => pointer.dx - center.dx;
  double get dy => pointer.dx - center.dy;

  double get2DValue() {
    if (dx.abs() > dy.abs()) {
      return dx;
    } else {
      return dy;
    }
  }
}
