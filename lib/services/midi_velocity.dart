import 'package:beat_pads/services/services.dart';
import 'dart:math';

class VelocityProvider {
  final Settings _settings;
  final Function _notifyParent;
  final Random _random;
  int _velocityFixed;

  double _velocityRandomCenter;
  final int velocityRange;

  VelocityProvider(this._settings, this._notifyParent)
      : _random = Random(),
        velocityRange = _settings.velocityRange,
        _velocityFixed = _settings.velocity,
        _velocityRandomCenter = _settings.velocityCenter.clamp(
            9 + _settings.velocityRange / 2, 128 - _settings.velocityRange / 2);

  // this is what the midi sender grabs:
  int get velocity {
    if (!_settings.randomVelocity) {
      return velocityFixed.clamp(10, 127); // fixed velocity
    }

    // random velocity based on center value, to use with single-value slider
    double randVelocity = _random.nextInt(velocityRange) +
        (_velocityRandomCenter - velocityRange / 2);
    return randVelocity.round().clamp(10, 127);
  }

  // For Velocity Slider on pads screen:
  int get velocityFixed => _velocityFixed;
  set velocityFixed(int vel) {
    _velocityFixed = vel;
    _notifyParent();
  }

  // For Random Velocity Slider on pads screen:
  double get velocityRandomCenter => _velocityRandomCenter;
  set velocityRandomCenter(double velDouble) {
    _velocityRandomCenter =
        velDouble.clamp(9 + velocityRange / 2, 128 - velocityRange / 2);
    _notifyParent();
  }
}
