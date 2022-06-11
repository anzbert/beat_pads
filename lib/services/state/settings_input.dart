import 'package:beat_pads/main.dart';
import 'package:beat_pads/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// PLAYMODE
final playModeProv =
    StateNotifierProvider<SettingEnum<PlayMode>, PlayMode>((ref) {
  return ref.watch(sharedPrefProvider).settings.playMode;
});

// MOD VISUALISATION
final modulationRadiusProv =
    StateNotifierProvider<SettingDouble, double>((ref) {
  return ref.watch(sharedPrefProvider).settings.modulationRadius;
});
final modulationDeadZoneProv =
    StateNotifierProvider<SettingDouble, double>((ref) {
  return ref.watch(sharedPrefProvider).settings.modulationDeadZone;
});

// MODULATION SELECTION
final modulation2DProv = StateNotifierProvider<SettingBool, bool>((ref) {
  return ref.watch(sharedPrefProvider).settings.modulation2D;
});
final mpe2DXProv = StateNotifierProvider<SettingEnum<MPEmods>, MPEmods>((ref) {
  return ref.watch(sharedPrefProvider).settings.mpe2DX;
});
final mpe2DYProv = StateNotifierProvider<SettingEnum<MPEmods>, MPEmods>((ref) {
  return ref.watch(sharedPrefProvider).settings.mpe2DY;
});
final mpe1DRadiusProv =
    StateNotifierProvider<SettingEnum<MPEmods>, MPEmods>((ref) {
  return ref.watch(sharedPrefProvider).settings.mpe1DRadius;
});

// OTHER SETTINGS
final mpePitchbendRangeProv = StateNotifierProvider<SettingInt, int>((ref) {
  return ref.watch(sharedPrefProvider).settings.mpePitchBendRange;
});
final sendCCProv = StateNotifierProvider<SettingBool, bool>((ref) {
  return ref.watch(sharedPrefProvider).settings.sendCC;
});

// RELEASE TIMES
final noteReleaseStepProv = StateNotifierProvider<SettingInt, int>((ref) {
  return ref.watch(sharedPrefProvider).settings.noteSustainTimeStep;
});

final noteReleaseUsable = Provider<int>(
  (ref) {
    return Timing.releaseDelayTimes[ref
        .watch(noteReleaseStepProv)
        .clamp(0, Timing.releaseDelayTimes.length - 1)];
  },
);

final modReleaseStepProv = StateNotifierProvider<SettingInt, int>((ref) {
  return ref.watch(sharedPrefProvider).settings.modSustainTimeStep;
});

final modReleaseUsable = Provider<int>(
  (ref) {
    return Timing.releaseDelayTimes[ref
        .watch(modReleaseStepProv)
        .clamp(0, Timing.releaseDelayTimes.length - 1)];
  },
);
