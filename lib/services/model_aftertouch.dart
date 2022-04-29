import 'package:beat_pads/services/_services.dart';

import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command_messages.dart';

class AftertouchModel extends ChangeNotifier {
  Settings _settings;
  AftertouchModel(this._settings);

  AftertouchModel update(Settings settings) {
    _settings = settings;
    return this;
  }

  final CircleBuffer atCircleBuffer = CircleBuffer(127);
  final CircleBuffer outlineBuffer = CircleBuffer(127);

  final curve = Curves.easeIn;

  double getOpacity(double radius, {double scale = 1}) {
    double fraction =
        radius.clamp(0, atCircleBuffer.maxRadius) / atCircleBuffer.maxRadius;
    double transformed = curve.transform(fraction);
    double scaled = transformed * scale.clamp(0, 1);
    return scaled;
  }

  int getPressure(double radius) =>
      (curve.transform(radius.clamp(0, atCircleBuffer.maxRadius) /
                  atCircleBuffer.maxRadius) *
              127)
          .toInt();

  // TOUCH HANDLIMG
  void push(PointerEvent touch, int note) {
    atCircleBuffer.add(touch.pointer, ATCircle(touch.position, 0, note));
    outlineBuffer.add(touch.pointer, ATCircle(touch.position, 0, note));

    notifyListeners();
  }

  void move(PointerEvent touch) {
    if (atCircleBuffer.buffer[touch.pointer] == null) return;

    double distance = Utils.offsetDistance(
        atCircleBuffer.buffer[touch.pointer]!.center, touch.position);

    atCircleBuffer.updateRadiusWithinLimit(touch.pointer, distance);
    outlineBuffer.updateRadiusWithinLimit(touch.pointer, distance);

    PolyATMessage(
      channel: _settings.channel,
      note: atCircleBuffer.buffer[touch.pointer]!.note,
      pressure: getPressure(atCircleBuffer.buffer[touch.pointer]!.radius),
    ).send();

    notifyListeners();
  }

  void lift(PointerEvent touch) {
    if (atCircleBuffer.buffer[touch.pointer] == null) return;

    PolyATMessage(
      channel: _settings.channel,
      note: atCircleBuffer.buffer[touch.pointer]!.note,
      pressure: 0,
    ).send();

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

  void add(int key, ATCircle circle) {
    buffer[key] = circle;
  }

  void updateRadiusWithinLimit(int key, double newRadius) {
    if (buffer[key] != null) {
      if (newRadius > maxRadius) {
        buffer[key]!.radius = maxRadius;
      } else {
        buffer[key]!.radius = newRadius;
      }
    }
  }

  void remove(int key) {
    if (buffer[key] != null) {
      buffer.remove(key);
    }
  }
}

class ATCircle {
  final int note;
  final Offset center;
  double radius;

  ATCircle(this.center, this.radius, this.note);
}
