import 'package:beat_pads/services/services.dart';

// for dropdown menu
enum MonoMods {
  pitchbend('Pitch Bend Up & Down', Dims.two, Group.pitch),
  pitchbendUp('Pitch Bend Up', Dims.one, Group.pitch),
  pitchbendDown('Pitch Bend Down', Dims.one, Group.pitch),
  mpeAftertouch('AT Pressure', Dims.one, Group.at),
  mpeAftertouch64('AT Pressure Center 64', Dims.two, Group.at),
  modWheel('Mod Wheel [1]', Dims.one, Group.slide),
  modWheel64('Mod Wheel [1] Center 64', Dims.two, Group.slide),
  pan('Pan [10]', Dims.one, Group.pan),
  pan64('Pan [10] Center 64', Dims.two, Group.pan),
  gain('Gain [7]', Dims.one, Group.gain),
  gain64('Gain [7] Center 64', Dims.two, Group.gain),

  none('None', Dims.one, Group.none);

  const MonoMods(this.title, this.dimensions, this.exclusiveGroup);
  @override
  String toString() => title;

  final String title;
  final Dims dimensions;
  final Group exclusiveGroup;

  Mod getMod(int pitchBendMax) {
    switch (this) {
      case MonoMods.pitchbend:
        return ModPitchBend(
          pitchBendMax,
          Range.full,
        );
      case MonoMods.pitchbendUp:
        return ModPitchBend(
          pitchBendMax,
          Range.up,
        );
      case MonoMods.pitchbendDown:
        return ModPitchBend(
          pitchBendMax,
          Range.down,
        );
      case MonoMods.mpeAftertouch:
        return ModChannelAftertouch1D();
      case MonoMods.mpeAftertouch64:
        return ModChannelAftertouch642D();
      case MonoMods.modWheel:
        return ModCC1D(CC.modWheel);
      case MonoMods.modWheel64:
        return ModCC642D(CC.modWheel);
      case MonoMods.pan:
        return ModCC1D(CC.pan);
      case MonoMods.pan64:
        return ModCC642D(CC.pan);
      case MonoMods.gain:
        return ModCC1D(CC.gain);
      case MonoMods.gain64:
        return ModCC642D(CC.gain);
      case MonoMods.none:
        return ModNull();
    }
  }
}
