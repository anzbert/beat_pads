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

  double getAverageATRadiusOfAllPads() {
    if (atCircleBuffer.buffer.isEmpty) return 0;

    double total = atCircleBuffer.buffer.values
        .map((e) => e.radius)
        .reduce(((value, element) => value + element));

    return total / atCircleBuffer.buffer.values.length;
  }

  // TOUCH HANDLIMG
  void push(PointerEvent touch, int note) {
    atCircleBuffer.add(touch.pointer, touch.position, note);
    outlineBuffer.add(touch.pointer, touch.position, note);

    // if (_settings.playMode == PlayMode.polyAT) {
    //   PolyATMessage(
    //     channel: _settings.channel,
    //     note: atCircleBuffer.buffer[touch.pointer]!.note,
    //     pressure: 0,
    //   ).send();
    // }
    // if (_settings.playMode == PlayMode.cc) {
    //   CCMessage(
    //     channel: (_settings.channel + 2) % 16,
    //     controller: 0,
    //     value: 0,
    //   ).send();
    // }
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

    if (_settings.playMode == PlayMode.mpe) {
      // print("x:${atCircleBuffer.buffer[touch.pointer]!.dx}");
      // print("y:${atCircleBuffer.buffer[touch.pointer]!.dy}");
      // print(
      //     "f :${atCircleBuffer.buffer[touch.pointer]!.dx / atCircleBuffer.maxRadius / 2}");
      // print("max: ${atCircleBuffer.maxRadius}");

      int channel = atCircleBuffer.buffer[touch.pointer]!.note % 15 + 1;
      CCMessage(
        channel: channel,
        controller: 74, // SLIDE
        value:
            (atCircleBuffer.buffer[touch.pointer]!.distancefromCenterX.abs() /
                    atCircleBuffer.maxRadius *
                    127)
                .toInt(),
      ).send();
      PitchBendMessage(
        channel: channel,
        bend: (atCircleBuffer.buffer[touch.pointer]!.positionOnWholeFieldAxisY -
                atCircleBuffer.maxRadius) /
            atCircleBuffer.maxRadius,
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

  double get distancefromCenterX {
    double rx = pointer.dx - center.dx;
    if (rx >= maxRadius) return maxRadius;
    return rx;
  }

  double get positionOnWholeFieldAxisX {
    double dx = pointer.dx - center.dx + maxRadius;
    if (dx >= maxRadius * 2) return maxRadius * 2;
    if (dx <= 0) return 0;
    return dx;
  }

  double get positionOnWholeFieldAxisY {
    double dy = pointer.dy - center.dy + maxRadius;
    if (dy >= maxRadius * 2) return 0;
    if (dy <= 0) return maxRadius * 2;
    return maxRadius * 2 - dy;
  }
}
