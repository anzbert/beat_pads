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
 

// void main() {
// //   on drop down change , get new mpe object
//   SendMpe mpe = SendMpe(
//       MPEmods.pitchbend.getMod(), MPEmods.slide.getMod(), MPEmods.aftertouch.getMod());

//   mpe.xMod.send(0, 5, .3);
//   mpe.yMod.send(5, 35, -.4);
//   mpe.rMod.send(4, 3, .66);
// }
*/

import 'package:beat_pads/services/_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_midi_command/flutter_midi_command_messages.dart';

class SendMpe {
  final Mod xMod;
  final Mod yMod;
  final Mod rMod;

  SendMpe(this.xMod, this.yMod, this.rMod);
}

class ModPitchBendFull2D extends Mod {
  final int pitchBendMax;
  ModPitchBendFull2D(this.pitchBendMax);

  @override
  void send(int channel, int note, double distance) {
    int pitchChange = (distance * 0x3FFF).toInt();
    if (!listEquals<num>([channel, pitchChange], lastSentValues)) {
      PitchBendMessage(channel: channel, bend: distance * pitchBendMax / 48)
          .send();

      lastSentValues = [channel, pitchChange];
    }
  }
}

class ModPitchBendUp1D extends Mod {
  final int pitchBendMax;
  ModPitchBendUp1D(this.pitchBendMax);
  @override
  void send(int channel, int note, double distance) {
    int pitchChange = (distance.abs() * 0x3FFF).toInt();

    if (!listEquals<num>([channel, pitchChange], lastSentValues)) {
      PitchBendMessage(
              channel: channel, bend: distance.abs() * pitchBendMax / 48)
          .send();

      lastSentValues = [channel, pitchChange];
    }
  }
}

class ModPitchBendDown1D extends Mod {
  final int pitchBendMax;
  ModPitchBendDown1D(this.pitchBendMax);
  @override
  void send(int channel, int note, double distance) {
    int pitchChange = (distance.abs() * 0x3FFF).toInt();

    if (!listEquals<num>([channel, pitchChange], lastSentValues)) {
      PitchBendMessage(
              channel: channel, bend: -distance.abs() * pitchBendMax / 48)
          .send();

      lastSentValues = [channel, pitchChange];
    }
  }
}

class ModMPEAftertouch1D extends Mod {
  @override
  void send(int channel, int note, double distance) {
    int atChange = (distance.abs() * 127).toInt();

    if (!listEquals<num>([channel, atChange], lastSentValues)) {
      ATMessage(channel: channel, pressure: atChange).send();
      lastSentValues = [channel, atChange];
    }
  }
}

class ModCC1D extends Mod {
  final CC cc;
  ModCC1D(this.cc);

  @override
  void send(int channel, int note, double distance) {
    int ccChange = (distance.abs() * 127).toInt();

    if (!listEquals<num>([channel, note, ccChange], lastSentValues)) {
      CCMessage(channel: channel, controller: cc.value, value: ccChange).send();
      lastSentValues = [channel, note, ccChange];
    }
  }
}

class ModCC642D extends Mod {
  final CC cc;
  ModCC642D(this.cc);

  @override
  void send(int channel, int note, double distance) {
    int ccChange = ((distance + 1) / 2 * 127).toInt();

    if (!listEquals<num>([channel, note, ccChange], lastSentValues)) {
      CCMessage(channel: channel, controller: cc.value, value: ccChange).send();
      lastSentValues = [channel, note, ccChange];
    }
  }
}

class ModNull extends Mod {
  @override
  void send(int channel, int note, double distance) {
    Utils.logd("Sending debug placeholder: $channel / $note / $distance");
  }
}

// for dropdown menu
enum MPEmods {
  pitchbend("Pitch Bend", Dims.two, Group.pitch),
  pitchbendUp("Pitch Bend Up only", Dims.one, Group.pitch),
  pitchbendDown("Pitch Bend Down only", Dims.one, Group.pitch),
  mpeAftertouch("Aftertouch", Dims.one, Group.at),
  slide("Slide", Dims.one, Group.slide),
  slide64("Slide (center 64)", Dims.two, Group.slide),
  pan64("Pan (center 64)", Dims.two, Group.pan),
  none("None", Dims.two, Group.none),
  ;

  final String title;
  final Dims dimensions;
  final Group exclusiveGroup;

  const MPEmods(this.title, this.dimensions, this.exclusiveGroup);

  Mod getMod(int pitchBendMax) {
    if (this == MPEmods.pitchbend) return ModPitchBendFull2D(pitchBendMax);
    if (this == MPEmods.pitchbendUp) return ModPitchBendUp1D(pitchBendMax);
    if (this == MPEmods.pitchbendDown) return ModPitchBendDown1D(pitchBendMax);
    if (this == MPEmods.mpeAftertouch) return ModMPEAftertouch1D();
    if (this == MPEmods.slide) return ModCC1D(CC.slide);
    if (this == MPEmods.slide64) return ModCC642D(CC.slide);
    if (this == MPEmods.pan64) return ModCC642D(CC.pan);

    return ModNull();
  }

  static MPEmods? fromName(String key) {
    for (MPEmods mod in MPEmods.values) {
      if (mod.name == key) return mod;
    }
    return null;
  }
}

/// Exclusive modulation groups. Only one of each is allowed at a time on X and Y.
enum Group {
  pitch,
  slide,
  at,
  cc,
  pan,
  volume,
  none;
}

/// Dimensions
enum Dims {
  one,
  two,
}
