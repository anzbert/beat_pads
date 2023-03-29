import 'package:beat_pads/main.dart';
import 'package:beat_pads/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// PLAYMODE
final playModeProv = NotifierProvider<SettingEnum<PlayMode>, PlayMode>(() {
  return SettingEnum<PlayMode>(
      key: 'playMode',
      defaultValue: PlayMode.slide,
      fromName: PlayMode.fromName);
});

// MOD VISUALISATION
final modulationRadiusProv = NotifierProvider<SettingDouble, double>(() {
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

final mpe2DXProv = NotifierProvider<SettingEnum<MPEmods>, MPEmods>(() {
  return SettingEnum<MPEmods>(
    fromName: MPEmods.fromName,
    key: 'mpe2DX',
    defaultValue: MPEmods.slide,
  );
});

final mpe2DYProv = NotifierProvider<SettingEnum<MPEmods>, MPEmods>(() {
  return SettingEnum<MPEmods>(
    fromName: MPEmods.fromName,
    key: 'mpe2DY',
    defaultValue: MPEmods.pitchbend,
  );
});

final mpe1DRadiusProv = NotifierProvider<SettingEnum<MPEmods>, MPEmods>(() {
  return SettingEnum<MPEmods>(
    fromName: MPEmods.fromName,
    key: 'mpe1DRadius',
    defaultValue: MPEmods.mpeAftertouch,
  );
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
