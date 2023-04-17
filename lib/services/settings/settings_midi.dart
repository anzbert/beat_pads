import 'package:beat_pads/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// CHANNEL
final channelSettingProv = NotifierProvider<SettingIntNotifier, int>(
  () => SettingIntNotifier(
    key: 'channel',
    defaultValue: 0,
    max: 15,
  ),
);

final channelUsableProv = Provider<int>(
  (ref) {
    final channel = ref.watch(channelSettingProv);
    final playMode = ref.watch(playModeProv);
    final upperZone = channel > 7;

    if (playMode == PlayMode.mpe) {
      return upperZone ? 15 : 0;
    }

    return channel;
  },
);

final mpeMemberChannelsProv = NotifierProvider<SettingIntNotifier, int>(
  () => SettingIntNotifier(
    key: 'mpeMemberChannels',
    defaultValue: 8,
    min: 1,
    max: 15,
  ),
);

final zoneProv = Provider<bool>((ref) {
  final channel = ref.watch(channelSettingProv);
  return channel > 7;
});

// VELOCITY
final velocityProv = NotifierProvider<SettingIntNotifier, int>(
  () => SettingIntNotifier(
    key: 'velocity',
    defaultValue: 110,
    max: 127,
  ),
);

final velocityModeProv =
    NotifierProvider<SettingEnumNotifier<VelocityMode>, VelocityMode>(
  () => SettingEnumNotifier<VelocityMode>(
    nameMap: VelocityMode.values.asNameMap(),
    key: 'velocityMode',
    defaultValue: VelocityMode.fixed,
  ),
);

final velocityMinProv = NotifierProvider<SettingIntNotifier, int>(
  () => SettingIntNotifier(
    key: 'velocityMin',
    defaultValue: 100,
    max: 126,
  ),
);

final velocityMaxProv = NotifierProvider<SettingIntNotifier, int>(
  () => SettingIntNotifier(
    key: 'velocityMax',
    defaultValue: 110,
    max: 127,
  ),
);
