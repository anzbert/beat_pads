import 'package:beat_pads/services/services.dart';

class SendMod {
  SendMod(this.xMod, this.yMod, this.rMod);
  final Mod xMod;
  final Mod yMod;
  final Mod rMod;
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
