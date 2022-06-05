import 'package:beat_pads/screen_pads_menu/slider_int.dart';
import 'package:beat_pads/services/state/state.dart';
import 'package:flutter/material.dart';
import 'package:beat_pads/screen_pads_menu/slider_int_range.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuMidi extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: const Divider(),
          trailing: Text(
            "Midi Settings",
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.headline5!.fontSize),
          ),
        ),
        IntSliderTile(
          resetValue: ref.read(channelSettingProv.notifier).reset,
          min: 1,
          max: 16,
          label: "Master Channel",
          subtitle:
              "Midi Channel to send and receive on. Only 1 or 16 with MPE.",
          trailing: Text((ref.watch(channelUsableProv) + 1).toString()),
          setValue: (v) => ref.read(channelSettingProv.notifier).set(v - 1),
          readValue: ref.watch(channelUsableProv) + 1,
          onChangeEnd: ref.read(channelSettingProv.notifier).save,
        ),
        IntSliderTile(
          min: 1,
          max: 15,
          label: "MPE Member Channels",
          subtitle: "Number of member channels to allocate in MPE mode",
          trailing: Text(ref.watch(zoneProv)
              ? "${ref.watch(mpeMemberChannelsProv)} (${15 - ref.watch(mpeMemberChannelsProv)} to 15)"
              : "${ref.watch(mpeMemberChannelsProv)} (2 to ${ref.watch(mpeMemberChannelsProv) + 1})"),
          setValue: (v) => ref.read(mpeMemberChannelsProv.notifier).set(v),
          readValue: ref.watch(mpeMemberChannelsProv),
          onChangeEnd: ref.read(mpeMemberChannelsProv.notifier).save,
        ),
        const Divider(),
        ListTile(
          title: const Text("Random Velocity"),
          subtitle: const Text("Random Velocity within a given Range"),
          trailing: Switch(
              value: ref.watch(randomVelocityProv),
              onChanged: (v) =>
                  ref.read(randomVelocityProv.notifier).setAndSave(v)),
        ),
        if (!ref.watch(randomVelocityProv))
          IntSliderTile(
            min: 10,
            max: 127,
            label: "Fixed Velocity",
            subtitle: "Velocity to send when pressing a Pad",
            trailing: Text(ref.watch(velocityProv).toString()),
            readValue: ref.watch(velocityProv),
            setValue: (v) => ref.read(velocityProv.notifier).set(v),
            resetValue: ref.read(velocityProv.notifier).reset,
            onChangeEnd: ref.read(velocityProv.notifier).save,
          ),
        if (ref.watch(randomVelocityProv))
          MidiRangeSelectorTile(
            label: "Random Velocity Range",
            readMin: ref.watch(velocityMinProv),
            readMax: ref.watch(velocityMaxProv),
            setMin: (v) => ref.read(velocityMinProv.notifier).set(v),
            setMax: (v) => ref.read(velocityMaxProv.notifier).set(v),
            resetFunction: ref.read(velocityMaxProv.notifier).reset,
            onChangeEnd: ref.read(velocityMaxProv.notifier).save,
          ),
      ],
    );
  }
}
