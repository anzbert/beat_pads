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

class PadAndTouchData {
  final double yPercentage;
  final int padId;

  /// Contains a pointer ID with information about the touch location
  /// , as well as information about the touched pad widget size
  PadAndTouchData({
    required this.yPercentage,
    required this.padId,
  });
}

class PadTouchAndScreenData {
  final int pointer;
  final double yPercentage;
  final int padNote;
  final Offset screenTouchPos;
  final Size screenSize;

  /// Contains a pointer ID with information about the touch location
  /// , as well as information about the touched pad widget size
  PadTouchAndScreenData(
      {required this.screenSize,
      required this.pointer,
      required this.padNote,
      required this.yPercentage,
      required this.screenTouchPos});
}

class NullableTouchAndScreenData {
  final int pointer;
  final double? yPercentage;
  final int? padNote;
  final Offset screenTouchPos;

  /// Contains a pointer ID with information about the touch location
  /// , as well as information about the touched pad widget size
  NullableTouchAndScreenData(
      {required this.pointer,
      required this.padNote,
      required this.yPercentage,
      required this.screenTouchPos});
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
