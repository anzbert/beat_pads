import 'package:beat_pads/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// CHANNEL
final channelSettingProv = NotifierProvider<SettingIntNotifier, int>(() {
  return SettingIntNotifier(
    key: 'channel',
    defaultValue: 0,
    max: 15,
  );
});

final channelUsableProv = Provider<int>(
  ((ref) {
    int channel = ref.watch(channelSettingProv);
    PlayMode playMode = ref.watch(playModeProv);
    bool upperZone = channel > 7 ? true : false;

    if (playMode == PlayMode.mpe) {
      return upperZone ? 15 : 0;
    }

    return channel;
  }),
);

final mpeMemberChannelsProv = NotifierProvider<SettingIntNotifier, int>(() {
  return SettingIntNotifier(
    key: 'mpeMemberChannels',
    defaultValue: 8,
    min: 1,
    max: 15,
  );
});

final zoneProv = Provider<bool>((ref) {
  int channel = ref.watch(channelSettingProv);
  return channel > 7 ? true : false;
});

// VELOCITY
final velocityProv = NotifierProvider<SettingIntNotifier, int>(() {
  return SettingIntNotifier(
    key: 'velocity',
    defaultValue: 110,
    max: 127,
  );
});

final velocityModeProv =
    NotifierProvider<SettingEnumNotifier<VelocityMode>, VelocityMode>(() {
  return SettingEnumNotifier<VelocityMode>(
    fromName: VelocityMode.fromName,
    key: 'velocityMode',
    defaultValue: VelocityMode.fixed,
  );
});

final velocityMinProv = NotifierProvider<SettingIntNotifier, int>(() {
  return SettingIntNotifier(
    key: 'velocityMin',
    defaultValue: 100,
    max: 126,
  );
});

final velocityMaxProv = NotifierProvider<SettingIntNotifier, int>(() {
  return SettingIntNotifier(
    key: 'velocityMax',
    defaultValue: 110,
    max: 127,
  );
});

final velocityRangeProv = Provider<int>(((ref) {
  return ref.watch(velocityMaxProv) - ref.watch(velocityMinProv);
}));
final velocityCenterProv = Provider<double>(((ref) {
  return (ref.watch(velocityMaxProv) + ref.watch(velocityMinProv)) / 2;
}));
