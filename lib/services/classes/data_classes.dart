import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';

class Vector2Int {
  /// A simple class that holds an integer x and y value
  const Vector2Int(this.x, this.y);
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
  /// Contains a pointer position with a unique ID
  CustomPointer(this.pointer, this.position);
  final int pointer;
  Offset position;
}

class PadAndTouchData {
  /// Contains a pointer ID with information about the touch location
  /// , as well as information about the touched pad widget size
  PadAndTouchData({
    required this.yPercentage,
    required this.padId,
  });
  final double yPercentage;
  final int padId;
}

class PadTouchAndScreenData {
  /// Contains a pointer ID with information about the touch location
  /// , as well as information about the touched pad widget size
  PadTouchAndScreenData({
    required this.screenSize,
    required this.pointer,
    required this.padNote,
    required this.yPercentage,
    required this.screenTouchPos,
  });
  final int pointer;
  final double yPercentage;
  final int padNote;
  final Offset screenTouchPos;
  final Size screenSize;
}

class NullableTouchAndScreenData {
  /// Contains a pointer ID with information about the touch location
  /// , as well as information about the touched pad widget size
  NullableTouchAndScreenData({
    required this.pointer,
    required this.padNote,
    required this.yPercentage,
    required this.screenTouchPos,
  });
  final int pointer;
  final double? yPercentage;
  final int? padNote;
  final Offset screenTouchPos;
}

class MidiMessagePacket {
  /// Packages a Midi Message with a type definition and byte content
  MidiMessagePacket(this.type, this.content);
  final MidiMessageType type;
  final List<int> content;

  @override
  String toString() {
    return 'Type: $type / Content: $content';
  }
}
