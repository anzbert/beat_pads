import 'dart:math';
import 'package:beat_pads/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum VelocityMode {
  random('Random'),
  fixed('Fixed'),
  yAxis('Y-Axis');

  const VelocityMode(this.title);
  final String title;

  @override
  String toString() => title;
}

final velocityRangeProv = Provider<int>(
  (ref) => ref.watch(velocityMaxProv) - ref.watch(velocityMinProv),
);

final velocitySliderValueProv = NotifierProvider<VelocityProvider, double>(
  VelocityProvider.new,
);

class VelocityProvider extends Notifier<double> {
  /// Provides working velocity values for sending midi
  /// notes in random, y-axis and fixed velocity mode and stores values
  /// for the slider on the pad screen in its state
  VelocityProvider() : _randomGenerator = Random();
  final Random _randomGenerator;

  @override
  double build() {
    if (ref.read(velocityModeProv) == VelocityMode.fixed) {
      return ref.read(velocityProv).toDouble();
    } else {
      return (ref.watch(velocityMaxProv) + ref.watch(velocityMinProv)) / 2;
    }
  }

  /// Use this value to send notes.
  /// Random velocity is based on a center-of-range value, usable with a
  /// single-value slider.
  int velocity(double percentage) {
    switch (ref.read(velocityModeProv)) {
      case VelocityMode.random:
        final randVelocity =
            _randomGenerator.nextInt(ref.read(velocityRangeProv)) +
                (state - ref.read(velocityRangeProv) / 2);
        return randVelocity.round().clamp(10, 127);

      case VelocityMode.fixed:
        return state.round().clamp(10, 127);

      case VelocityMode.yAxis:
        final min = state - ref.read(velocityRangeProv) / 2;
        return (min + ref.read(velocityRangeProv) * percentage)
            .round()
            .clamp(0, 127);
    }
  }

  /// For Velocity Slider on pads screen:
  void set(double vel) {
    if (ref.read(velocityModeProv) == VelocityMode.fixed) {
      state = vel;
    } else {
      // set to velocity center
      state = vel.clamp(
        9 + ref.read(velocityRangeProv) / 2,
        128 - ref.read(velocityRangeProv) / 2,
      );
    }
  }

  int get asInt => state.round().clamp(0, 127);
}
