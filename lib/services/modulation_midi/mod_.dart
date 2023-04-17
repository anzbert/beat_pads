abstract class Mod {
  /// Stores last sent value. Used to prevent unnecessary Midi messages
  List<int> lastSentValues = [];

  /// input distance should always be: (-)1 to 0 to (-)1
  void send(int channel, int note, double distance);
}
