import 'package:beat_pads/screen_pads_menu/drop_down_enum.dart';
import 'package:beat_pads/screen_pads_menu/slider_int.dart';
import 'package:beat_pads/screen_pads_menu/slider_int_range.dart';
import 'package:beat_pads/screens_shared_widgets/divider_title.dart';
import 'package:beat_pads/services/services.dart';
import 'package:beat_pads/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuMidi extends ConsumerWidget {
  const MenuMidi({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => ListView(
        padding:
            const EdgeInsets.only(bottom: ThemeConst.listViewBottomPadding),
        children: <Widget>[
          const DividerTitle('Connect'),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 300),
              child: ElevatedButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.lightPink,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.cable,
                    ),
                    Text(
                      'Select Midi Device',
                    ),
                  ],
                ),
              ),
            ),
          ),
          const DividerTitle('Channel'),
          IntSliderTile(
            resetValue: ref.read(channelSettingProv.notifier).reset,
            min: 1,
            max: 16,
            label: 'Midi Channel',
            subtitle: 'In MPE Mode only 1 or 16',
            trailing: Text((ref.watch(channelUsableProv) + 1).toString()),
            setValue: (v) => ref.read(channelSettingProv.notifier).set(v - 1),
            readValue: ref.watch(channelUsableProv) + 1,
            onChangeEnd: ref.read(channelSettingProv.notifier).save,
          ),
          IntSliderTile(
            min: 1,
            max: 15,
            label: 'MPE Member Channels',
            subtitle: 'Number of member channels to allocate in MPE mode',
            trailing: Text(
              ref.watch(zoneProv)
                  ? '${ref.watch(mpeMemberChannelsProv)} (${15 - ref.watch(
                        mpeMemberChannelsProv,
                      )} to 15)'
                  : '${ref.watch(mpeMemberChannelsProv)} (2 to ${ref.watch(mpeMemberChannelsProv) + 1})',
            ),
            setValue: (v) => ref.read(mpeMemberChannelsProv.notifier).set(v),
            readValue: ref.watch(mpeMemberChannelsProv),
            onChangeEnd: ref.read(mpeMemberChannelsProv.notifier).save,
          ),
          const DividerTitle('Velocity'),
          ListTile(
            title: const Text('Velocity Mode'),
            subtitle: const Text('Choose how Velocity values are created'),
            trailing: DropdownEnum(
              values: VelocityMode.values,
              readValue: ref.watch(velocityModeProv),
              setValue: (v) =>
                  ref.read(velocityModeProv.notifier).setAndSave(v),
            ),
          ),
          if (ref.watch(velocityModeProv) == VelocityMode.fixed)
            IntSliderTile(
              min: 10,
              max: 127,
              label: 'Fixed Velocity',
              trailing: Text(ref.watch(velocityProv).toString()),
              readValue: ref.watch(velocityProv),
              setValue: (v) => ref.read(velocityProv.notifier).set(v),
              resetValue: ref.read(velocityProv.notifier).reset,
              onChangeEnd: ref.read(velocityProv.notifier).save,
            ),
          if (ref.watch(velocityModeProv) != VelocityMode.fixed)
            MidiRangeSelectorTile(
              label: 'Velocity Range',
              readMin: ref.watch(velocityMinProv),
              readMax: ref.watch(velocityMaxProv),
              setMin: (v) => ref.read(velocityMinProv.notifier).set(v),
              setMax: (v) => ref.read(velocityMaxProv.notifier).set(v),
              resetFunction: ref.read(velocityMaxProv.notifier).reset,
              onChangeEnd: () async {
                await ref.read(velocityMaxProv.notifier).save();
                await ref.read(velocityMinProv.notifier).save();
              },
            ),
        ],
      );
}
