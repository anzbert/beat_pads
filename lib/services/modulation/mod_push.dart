import 'package:beat_pads/services/services.dart';

enum MPEpushStyleYAxisMods {
  mpeAftertouch64('AT Pressure Center 64', Dims.two, Group.at),
  slide64('Slide [74] Center 64', Dims.two, Group.slide),
  pan64('Pan [10] Center 64', Dims.two, Group.pan),
  gain64('Gain [7] Center 64', Dims.two, Group.gain),
  none('None', Dims.one, Group.none);

  const MPEpushStyleYAxisMods(this.title, this.dimensions, this.exclusiveGroup);
  @override
  String toString() => title;

  final String title;
  final Dims dimensions;
  final Group exclusiveGroup;

  Mod getMod() {
    switch (this) {
      case MPEpushStyleYAxisMods.mpeAftertouch64:
        return ModChannelAftertouch642D();
      case MPEpushStyleYAxisMods.slide64:
        return ModCC642D(CC.slide);
      case MPEpushStyleYAxisMods.pan64:
        return ModCC642D(CC.pan);
      case MPEpushStyleYAxisMods.gain64:
        return ModCC642D(CC.gain);
      case MPEpushStyleYAxisMods.none:
        return ModNull();
    }
  }
}
