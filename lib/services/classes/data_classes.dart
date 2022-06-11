import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';

class Vector2Int {
  final int x;
  final int y;

  /// A simple class that holds an integer x and y value
  const Vector2Int(this.x, this.y);

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

  /// Contains a pointer position with a unique ID
  CustomPointer(this.pointer, this.position);
}

class MidiMessagePacket {
  final MidiMessageType type;
  final List<int> content;

  /// Packages a Midi Message with a type definition and byte content
  MidiMessagePacket(this.type, this.content);

  @override
  String toString() {
    return "Type: $type / Content: $content";
  }
}
