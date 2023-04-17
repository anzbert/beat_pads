import 'package:beat_pads/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// PLAYMODE
final playModeProv = NotifierProvider<SettingEnumNotifier<PlayMode>, PlayMode>(
  () => SettingEnumNotifier<PlayMode>(
    key: 'playMode',
    defaultValue: PlayMode.noPan,
    nameMap: PlayMode.values.asNameMap(),
  ),
);

// MOD VISUALISATION
final modulationRadiusProv = NotifierProvider<SettingDoubleNotifier, double>(
  () => SettingDoubleNotifier(
    key: 'modulationRadius',
    defaultValue: .12,
    min: .05,
    max: .25,
  ),
);

final modulationDeadZoneProv = NotifierProvider<SettingDoubleNotifier, double>(
  () => SettingDoubleNotifier(
    key: 'modulationDeadZone',
    defaultValue: .20,
    max: .50,
  ),
);

// MODULATION SELECTION
final modulation2DProv = NotifierProvider<SettingBoolNotifier, bool>(
  () => SettingBoolNotifier(
    key: 'modulation2D',
    defaultValue: true,
  ),
);

final mpe2DXProv = NotifierProvider<SettingEnumNotifier<MPEmods>, MPEmods>(
  () => SettingEnumNotifier<MPEmods>(
    nameMap: MPEmods.values.asNameMap(),
    key: 'mpe2DX',
    defaultValue: MPEmods.slide,
  ),
);

final mpe2DYProv = NotifierProvider<SettingEnumNotifier<MPEmods>, MPEmods>(
  () => SettingEnumNotifier<MPEmods>(
    nameMap: MPEmods.values.asNameMap(),
    key: 'mpe2DY',
    defaultValue: MPEmods.pitchbend,
  ),
);

final mpe1DRadiusProv = NotifierProvider<SettingEnumNotifier<MPEmods>, MPEmods>(
  () => SettingEnumNotifier<MPEmods>(
    nameMap: MPEmods.values.asNameMap(),
    key: 'mpe1DRadius',
    defaultValue: MPEmods.mpeAftertouch,
  ),
);

// OTHER SETTINGS
final mpePitchbendRangeProv = NotifierProvider<SettingIntNotifier, int>(
  () => SettingIntNotifier(
    key: 'mpePitchBendRange',
    defaultValue: 48,
    min: 1,
    max: 48,
  ),
);

final sendCCProv = NotifierProvider<SettingBoolNotifier, bool>(
  () => SettingBoolNotifier(
    key: 'sendCC',
    defaultValue: false,
  ),
);

// RELEASE TIMES
final noteReleaseStepProv = NotifierProvider<SettingIntNotifier, int>(
  () => SettingIntNotifier(
    key: 'noteReleaseTimeStep',
    defaultValue: 0,
    max: Timing.releaseDelayTimes.length - 1,
  ),
);

final noteReleaseUsable = Provider<int>(
  (ref) => Timing.releaseDelayTimes[ref
      .watch(noteReleaseStepProv)
      .clamp(0, Timing.releaseDelayTimes.length - 1)],
);

final modReleaseStepProv = NotifierProvider<SettingIntNotifier, int>(
  () => SettingIntNotifier(
    key: 'modReleaseTimeStep',
    defaultValue: 0,
    max: Timing.releaseDelayTimes.length - 1,
  ),
);

final modReleaseUsable = Provider<int>(
  (ref) => Timing.releaseDelayTimes[ref
      .watch(modReleaseStepProv)
      .clamp(0, Timing.releaseDelayTimes.length - 1)],
);
