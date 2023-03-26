import 'package:beat_pads/main.dart';
import 'package:beat_pads/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// CHANNEL
final channelSettingProv = StateNotifierProvider<SettingInt, int>((ref) {
  return ref.watch(sharedPrefProvider).settings.channel;
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

final mpeMemberChannelsProv = StateNotifierProvider<SettingInt, int>((ref) {
  return ref.watch(sharedPrefProvider).settings.mpeMemberChannels;
});

final zoneProv = Provider<bool>((ref) {
  int channel = ref.watch(channelSettingProv);
  return channel > 7 ? true : false;
});

// VELOCITY
final velocityProv = StateNotifierProvider<SettingInt, int>((ref) {
  return ref.watch(sharedPrefProvider).settings.velocity;
});

// final randomVelocityProv = StateNotifierProvider<SettingBool, bool>((ref) {
//   return ref.watch(sharedPrefProvider).settings.randomVelocity;
// });

final velocityModeProv =
    StateNotifierProvider<SettingEnum<VelocityMode>, VelocityMode>((ref) {
  return ref.watch(sharedPrefProvider).settings.velocityMode;
});

final velocityMinProv = StateNotifierProvider<SettingInt, int>((ref) {
  return ref.watch(sharedPrefProvider).settings.velocityMin;
});
final velocityMaxProv = StateNotifierProvider<SettingInt, int>((ref) {
  return ref.watch(sharedPrefProvider).settings.velocityMax;
});
final velocityRangeProv = Provider<int>(((ref) {
  return ref.watch(velocityMaxProv) - ref.watch(velocityMinProv);
}));
final velocityCenterProv = Provider<double>(((ref) {
  return (ref.watch(velocityMaxProv) + ref.watch(velocityMinProv)) / 2;
}));
