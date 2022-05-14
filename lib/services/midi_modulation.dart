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

// void main() {
// //   on drop down change , get new mpe object
//   SendMpe mpe = SendMpe(
//       Mods.pitchbend.getMod(), Mods.slide.getMod(), Mods.aftertouch.getMod());

//   mpe.xMod.send(0, 5, .3);
//   mpe.yMod.send(5, 35, -.4);
//   mpe.rMod.send(4, 3, .66);
// }

class SendMpe {
  final Mod xMod;
  final Mod yMod;
  final Mod rMod;

  SendMpe(this.xMod, this.yMod, this.rMod);
}

abstract class Mod {
  /// value is -1 to 1
  void send(int channel, int note, double distance);
}

class ModPitchBendFull2D implements Mod {
  @override
  void send(int channel, int note, double distance) {
    // here note won't be used, but doesnt matter
    print("sending pitchbend $channel / $note / $distance");
  }
}

class ModAftertouch1D implements Mod {
  @override
  void send(int channel, int note, double distance) {
    print("sending aftertouch $channel / $note / $distance");
  }
}

class ModPlaceholder implements Mod {
  @override
  void send(int channel, int note, double distance) {
    print("sending placeholder $channel / $note / $distance");
  }
}

// pick those from dropdown -> return constructors
enum Mods {
  pitchbend("Pitch Bend Full Range (2D)", Dims.two, Group.pitch),
  aftertouch("Aftertouch (1D)", Dims.one, Group.at),
  slide("Slide (1D)", Dims.one, Group.slide),
  slide64("Slide 64 (2D)", Dims.two, Group.slide);

  final String title;
  final Dims dimensions;
  final Group exclusiveGroup;

  const Mods(this.title, this.dimensions, this.exclusiveGroup);

  Mod getMod() {
    switch (this) {
      case Mods.pitchbend:
        return ModPitchBendFull2D();
      case Mods.aftertouch:
        return ModAftertouch1D();
      case Mods.slide:
        return ModPlaceholder();
      case Mods.slide64:
        return ModPlaceholder();
    }
  }

  Mods? fromName(String key) {
    for (Mods mod in Mods.values) {
      if (mod.name == key) return mod;
    }
    return null;
  }
}

// sort into groups so only one of each is allowed at a time:
enum Group {
  pitch,
  slide,
  at,
}

enum Dims {
  one,
  two,
}
