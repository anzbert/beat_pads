import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';

class Vector2D {
  /// A simple class that holds an integer x and y value
  const Vector2D(this.x, this.y);

  final int x;
  final int y;

  int get area {
    return x * y;
  }

  List<int> toList() {
    return [x, y];
  }
}

class CustomPointer {
  final int pointer;
  Offset position;

  CustomPointer(this.pointer, this.position);
}

class MidiMessagePacket {
  final MidiMessageType type;
  final List<int> content;

  MidiMessagePacket(this.type, this.content);

  @override
  String toString() {
    return "Type: $type / Content: $content";
  }
}
