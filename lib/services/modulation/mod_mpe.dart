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
    switch (this) {
      case MPEmods.pitchbend:
        return ModPitchBend(pitchBendMax, Range.full);
      case MPEmods.pitchbendUp:
        return ModPitchBend(pitchBendMax, Range.up);
      case MPEmods.pitchbendDown:
        return ModPitchBend(pitchBendMax, Range.down);
      case MPEmods.mpeAftertouch:
        return ModChannelAftertouch1D();
      case MPEmods.mpeAftertouch64:
        return ModChannelAftertouch642D();
      case MPEmods.slide:
        return ModCC1D(CC.slide);
      case MPEmods.slide64:
        return ModCC642D(CC.slide);
      case MPEmods.pan:
        return ModCC1D(CC.pan);
      case MPEmods.pan64:
        return ModCC642D(CC.pan);
      case MPEmods.gain:
        return ModCC1D(CC.gain);
      case MPEmods.gain64:
        return ModCC642D(CC.gain);
      case MPEmods.none:
        return ModNull();
    }
  }
}
