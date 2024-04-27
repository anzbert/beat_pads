// NOTES
/*
 the x and y menu have to be aware of each other,
 only one of each ModGroup can be used at a time, or else the midi signals would mess with each other.
 
 some modulation is only available in one dimension, some in both
 
 available modulation factors in these modes:
 1D: R = 1 to 0 to 1 // -1 to 0 to -1                          
 2D: X,Y = -1 to 0 to 1 // 1 to 0 to 1 // -1 to 0 to -1
 
 input from geometry:
 - center is always 0 !
 - maxRadius is always 1 or -1, which can be turned to 1D by converting to absolute 1/0/1 or -1/0/-1!
*/

import 'package:beat_pads/services/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_midi_command/flutter_midi_command_messages.dart';

class SendMpe {
  SendMpe(this.xMod, this.yMod, this.rMod);
  final Mod xMod;
  final Mod yMod;
  final Mod rMod;
}

class ModPitchBendToNote extends Mod {
  ModPitchBendToNote();

  @override
  void send(int channel, int note, double distance) {
    final int pitchChange = (distance * 0x3FFF).toInt();

    if (!listEquals<num>([channel, pitchChange], lastSentValues)) {
      PitchBendMessage(
        channel: channel,
        bend: distance,
      ).send();

      lastSentValues = [channel, pitchChange];
    }
  }
}

class ModPitchBend extends Mod {
  ModPitchBend(this.pitchBendMax, this.range);
  final int pitchBendMax;
  final Range range;

  double dist(double input) {
    if (range == Range.up) return input.abs();
    if (range == Range.down) return -input.abs();
    return input;
  }

  @override
  void send(int channel, int note, double distance) {
    final int pitchChange = (distance * 0x3FFF).toInt();

    if (!listEquals<num>([channel, pitchChange], lastSentValues)) {
      PitchBendMessage(
        channel: channel,
        bend: dist(distance) * pitchBendMax / 48,
      ).send();

      lastSentValues = [channel, pitchChange];
    }
  }
}

class ModChannelAftertouch1D extends Mod {
  @override
  void send(int channel, int note, double distance) {
    final int atChange = (distance.abs() * 127).toInt();

    if (!listEquals<num>([channel, atChange], lastSentValues)) {
      ATMessage(channel: channel, pressure: atChange).send();
      lastSentValues = [channel, atChange];
    }
  }
}

class ModChannelAftertouch642D extends Mod {
  @override
  void send(int channel, int note, double distance) {
    final int atChange = ((distance + 1) / 2 * 127).toInt();

    if (!listEquals<num>([channel, atChange], lastSentValues)) {
      ATMessage(channel: channel, pressure: atChange).send();
      lastSentValues = [channel, atChange];
    }
  }
}

class ModCC1D extends Mod {
  ModCC1D(this.cc);
  final CC cc;

  @override
  void send(int channel, int note, double distance) {
    final int ccChange = (distance.abs() * 127).toInt();

    if (!listEquals<num>([channel, note, ccChange], lastSentValues)) {
      CCMessage(channel: channel, controller: cc.value, value: ccChange).send();
      lastSentValues = [channel, note, ccChange];
    }
  }
}

class ModCC642D extends Mod {
  ModCC642D(this.cc);
  final CC cc;

  @override
  void send(int channel, int note, double distance) {
    final int ccChange = ((distance + 1) / 2 * 127).toInt();

    if (!listEquals<num>([channel, note, ccChange], lastSentValues)) {
      CCMessage(channel: channel, controller: cc.value, value: ccChange).send();
      lastSentValues = [channel, note, ccChange];
    }
  }
}

class ModNull extends Mod {
  @override
  void send(int channel, int note, double distance) {
    // Utils.logd('Sending debug placeholder: $channel / $note / $distance');
  }
}

// for dropdown menu
enum MPEmods {
  pitchbend('Pitch Bend Up & Down', Dims.two, Group.pitch),
  pitchbendUp('Pitch Bend Up', Dims.one, Group.pitch),
  pitchbendDown('Pitch Bend Down', Dims.one, Group.pitch),
  mpeAftertouch('AT Pressure', Dims.one, Group.at),
  mpeAftertouch64('AT Pressure Center 64', Dims.two, Group.at),
  slide('Slide [74]', Dims.one, Group.slide),
  slide64('Slide [74] Center 64', Dims.two, Group.slide),
  pan('Pan [10]', Dims.one, Group.pan),
  pan64('Pan [10] Center 64', Dims.two, Group.pan),
  gain('Gain [7]', Dims.one, Group.gain),
  gain64('Gain [7] Center 64', Dims.two, Group.gain),

  none('None', Dims.one, Group.none);

  const MPEmods(this.title, this.dimensions, this.exclusiveGroup);
  @override
  String toString() => title;

  final String title;
  final Dims dimensions;
  final Group exclusiveGroup;

  Mod getMod(int pitchBendMax) {
    if (this == MPEmods.mpeAftertouch) return ModChannelAftertouch1D();
    if (this == MPEmods.mpeAftertouch64) return ModChannelAftertouch642D();
    if (this == MPEmods.slide) return ModCC1D(CC.slide);
    if (this == MPEmods.slide64) return ModCC642D(CC.slide);
    if (this == MPEmods.pan) return ModCC1D(CC.pan);
    if (this == MPEmods.pan64) return ModCC642D(CC.pan);
    if (this == MPEmods.gain) return ModCC1D(CC.gain);
    if (this == MPEmods.gain64) return ModCC642D(CC.gain);

    if (this == MPEmods.pitchbend) {
      return ModPitchBend(
        pitchBendMax,
        Range.full,
      );
    }
    if (this == MPEmods.pitchbendUp) {
      return ModPitchBend(
        pitchBendMax,
        Range.up,
      );
    }
    if (this == MPEmods.pitchbendDown) {
      return ModPitchBend(
        pitchBendMax,
        Range.down,
      );
    }

    return ModNull();
  }
}

/// Exclusive modulation groups. Only one of each is allowed at a time on X and Y.
enum Group {
  pitch,
  slide,
  at,
  pan,
  gain,
  none;
}

/// Dimensions
enum Dims {
  one,
  two,
  three;
}

/// Pitchbend Range
enum Range {
  up,
  down,
  full;
}

// for dropdown menu
enum MPEpushStyleYAxisMods {
  mpeAftertouch64('AT Pressure Center 64', Dims.two, Group.at),
  // slide('Slide [74]', Dims.one, Group.slide),
  slide64('Slide [74] Center 64', Dims.two, Group.slide),
  // pan('Pan [10]', Dims.one, Group.pan),
  pan64('Pan [10] Center 64', Dims.two, Group.pan),
  // gain('Gain [7]', Dims.one, Group.gain),
  gain64('Gain [7] Center 64', Dims.two, Group.gain),

  none('None', Dims.one, Group.none);

  const MPEpushStyleYAxisMods(this.title, this.dimensions, this.exclusiveGroup);
  @override
  String toString() => title;

  final String title;
  final Dims dimensions;
  final Group exclusiveGroup;

  Mod getMod() {
    //  if (this == MPEpushStyleYAxisMods.mpeAftertouch) return ModChannelAftertouch1D();
    if (this == MPEpushStyleYAxisMods.mpeAftertouch64) {
      return ModChannelAftertouch642D();
    }
    // if (this == MPEpushStyleYAxisMods.slide) return ModCC1D(CC.slide);
    if (this == MPEpushStyleYAxisMods.slide64) return ModCC642D(CC.slide);
    // if (this == MPEpushStyleYAxisMods.pan) return ModCC1D(CC.pan);
    if (this == MPEpushStyleYAxisMods.pan64) return ModCC642D(CC.pan);
    // if (this == MPEpushStyleYAxisMods.gain) return ModCC1D(CC.gain);
    if (this == MPEpushStyleYAxisMods.gain64) return ModCC642D(CC.gain);

    return ModNull();
  }
}
