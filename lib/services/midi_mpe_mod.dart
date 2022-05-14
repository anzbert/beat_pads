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
import 'package:flutter_midi_command/flutter_midi_command_messages.dart';

class SendMpe {
  final Mod xMod;
  final Mod yMod;
  final Mod rMod;

  SendMpe(this.xMod, this.yMod, this.rMod);
}

class ModPitchBendFull2D extends Mod {
  @override
  void send(int channel, int note, double distance) {
    double pitchChange = distance * 0x3FFF;
    if (lastSentValue != pitchChange) {
      PitchBendMessage(channel: channel, bend: distance).send();

      lastSentValue = pitchChange;
    }
  }
}

class ModPitchBendUp1D extends Mod {
  @override
  void send(int channel, int note, double distance) {
    double pitchChange = distance * 0x3FFF;
    if (lastSentValue != pitchChange) {
      PitchBendMessage(channel: channel, bend: distance.abs()).send();

      lastSentValue = pitchChange;
    }
  }
}

class ModPitchBendDown1D extends Mod {
  @override
  void send(int channel, int note, double distance) {
    double pitchChange = distance * 0x3FFF;
    if (lastSentValue != pitchChange) {
      PitchBendMessage(channel: channel, bend: -distance.abs()).send();

      lastSentValue = pitchChange;
    }
  }
}

class ModMPEAftertouch1D extends Mod {
  @override
  void send(int channel, int note, double distance) {
    int atChange = (distance.abs() * 127).toInt();
    if (atChange != lastSentValue) {
      ATMessage(channel: channel, pressure: atChange).send();
      lastSentValue = atChange;
    }
  }
}

class ModSlide1D extends Mod {
  @override
  void send(int channel, int note, double distance) {
    int slideChange = (distance.abs() * 127).toInt();
    if (slideChange != lastSentValue) {
      CCMessage(
              channel: channel, controller: CC.slide.value, value: slideChange)
          .send();
      lastSentValue = slideChange;
    }
  }
}

class ModSlide642D extends Mod {
  @override
  void send(int channel, int note, double distance) {
    int slideChange = ((distance + 1) / 2 * 127).toInt();
    if (slideChange != lastSentValue) {
      CCMessage(
              channel: channel, controller: CC.slide.value, value: slideChange)
          .send();
      lastSentValue = slideChange;
    }
  }
}

class ModPlaceholder extends Mod {
  @override
  void send(int channel, int note, double distance) {
    Utils.logd("Sending debug placeholder: $channel / $note / $distance");
  }
}

// pick those from dropdown -> return constructors
enum MPEmods {
  pitchbend("Pitch Bend Full Range (2D)", Dims.two, Group.pitch),
  pitchbendUp("Pitch Bend Up (1D)", Dims.one, Group.pitch),
  pitchbendDown("Pitch Bend Down (1D)", Dims.one, Group.pitch),
  mpeAftertouch("Aftertouch (1D)", Dims.one, Group.at),
  slide("Slide (1D)", Dims.one, Group.slide),
  slide64("Slide 64 (2D)", Dims.two, Group.slide),
  ;

  final String title;
  final Dims dimensions;
  final Group exclusiveGroup;

  const MPEmods(this.title, this.dimensions, this.exclusiveGroup);

  Mod getMod() {
    if (this == MPEmods.pitchbend) return ModPitchBendFull2D();
    if (this == MPEmods.pitchbendUp) return ModPitchBendUp1D();
    if (this == MPEmods.pitchbendDown) return ModPitchBendDown1D();
    if (this == MPEmods.mpeAftertouch) return ModMPEAftertouch1D();
    if (this == MPEmods.slide) return ModSlide1D();
    if (this == MPEmods.slide64) return ModSlide642D();

    return ModPlaceholder();
  }

  MPEmods? fromName(String key) {
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
  cc;
}

/// Dimensions
enum Dims {
  one,
  two,
}