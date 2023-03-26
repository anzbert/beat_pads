import 'dart:math';

import 'package:beat_pads/services/state/midi_send.dart';

enum VelocityMode {
  random("Random"),
  fixed("Fixed"),
  yAxis("Y-Axis");

  const VelocityMode(this.title);
  final String title;

  @override
  String toString() => title;

  static VelocityMode? fromName(String key) {
    for (VelocityMode mode in VelocityMode.values) {
      if (mode.name == key) return mode;
    }
    return null;
  }
}

class VelocityProvider {
  final SendSettings _settings;
  final Function _notifyParent;
  final Random _random;
  final int velocityRange;
  double _velocityRandomCenter;
  int _velocityFixed;

  /// Provides and stores working velocity values for sending midi
  /// notes in random, y-axis and fixed velocity mode
  VelocityProvider(this._settings, this._notifyParent)
      : _random = Random(),
        velocityRange = _settings.velocityRange,
        _velocityFixed = _settings.velocity,
        _velocityRandomCenter = _settings.velocityCenter.clamp(
            9 + _settings.velocityRange / 2, 128 - _settings.velocityRange / 2);

  /// Use this value to send notes.
  /// Random velocity is based on a center-of-range value, usable with a single-value slider.
  int velocity(double percentage) {
    switch (_settings.velocityMode) {
      case VelocityMode.random:
        double randVelocity = _random.nextInt(velocityRange) +
            (_velocityRandomCenter - velocityRange / 2);
        return randVelocity.round().clamp(10, 127);
      case VelocityMode.fixed:
        return velocityFixed.clamp(10, 127);
      case VelocityMode.yAxis:
        double min = _velocityRandomCenter - velocityRange / 2;
        return (min + velocityRange * percentage).round().clamp(0, 127);
    }
  }

  /// For Velocity Slider on pads screen:
  int get velocityFixed => _velocityFixed;
  set velocityFixed(int vel) {
    _velocityFixed = vel;
    _notifyParent();
  }

  /// For Random Velocity Slider on pads screen:
  double get velocityRandomCenter => _velocityRandomCenter;
  set velocityRandomCenter(double velDouble) {
    _velocityRandomCenter =
        velDouble.clamp(9 + velocityRange / 2, 128 - velocityRange / 2);
    _notifyParent();
  }
}
