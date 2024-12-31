import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';

class PadBox {
  PadBox({
    required this.padPosition,
    required this.padSize,
  });
  final Offset padPosition;
  final Size padSize;

  Offset get padCenter {
    return Offset(
      padPosition.dx + padSize.width / 2,
      padPosition.dy + padSize.height / 2,
    );
  }

  // Offset shiftedCenter(double percentage) {
  //   return Offset(
  //     padPosition.dx + padSize.width * percentage,
  //     padPosition.dx + padSize.width * percentage,
  //   );
  // }
}

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

class NullableVector2Int {
  /// A simple class that holds an integer x and y value
  const NullableVector2Int(this.x, this.y);
  final int? x;
  final int? y;

  List<int?> toList() {
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
    required this.padBox,
    required this.yPercentage,
    required this.xPercentage,
    required this.customPad,
  });
  final double yPercentage;
  final double xPercentage;
  final CustomPad customPad;
  final PadBox padBox;
}

class PadTouchAndScreenData {
  /// Contains a pointer ID with information about the touch location
  /// , as well as information about the touched pad widget size
  PadTouchAndScreenData({
    required this.screenSize,
    required this.pointer,
    required this.customPad,
    required this.yPercentage,
    required this.xPercentage,
    required this.screenTouchPos,
    required this.padBox,
  });
  final int pointer;
  final double yPercentage;
  final double xPercentage;
  final CustomPad customPad;
  final Offset screenTouchPos;
  final Size screenSize;
  final PadBox padBox;
}

class NullableTouchAndScreenData {
  /// Contains a pointer ID with information about the touch location
  /// , as well as information about the touched pad widget size
  NullableTouchAndScreenData({
    required this.pointer,
    required this.customPad,
    required this.yPercentage,
    required this.xPercentage,
    required this.screenTouchPos,
    required this.padBox,
  });
  final int pointer;
  final double? yPercentage;
  final double? xPercentage;
  final CustomPad? customPad;
  final Offset screenTouchPos;
  final PadBox? padBox;
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
