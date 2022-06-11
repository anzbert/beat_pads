import 'package:beat_pads/screen_pads_menu/drop_down_enum.dart';
import 'package:beat_pads/screen_pads_menu/drop_down_modulation.dart';
import 'package:beat_pads/screen_pads_menu/slider_int.dart';
import 'package:beat_pads/screen_pads_menu/slider_modulation_size.dart';
import 'package:beat_pads/screen_pads_menu/slider_non_linear.dart';
import 'package:flutter/material.dart';
import 'package:beat_pads/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuInput extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: const Divider(),
          trailing: Text(
            "Input Settings",
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.headline5!.fontSize),
          ),
        ),
        ListTile(
          title: const Text("Input Mode"),
          subtitle: const Text("Slide behavior, Polyphonic Aftertouch and MPE"),
          trailing: DropdownEnum(
            values: PlayMode.values,
            readValue: ref.watch(playModeProv),
            setValue: (v) => ref.read(playModeProv.notifier).setAndSave(v),
          ),
        ),
        const Divider(),
        if (ref.watch(playModeProv) == PlayMode.mpe)
          ListTile(
            title: const Text("2-D Modulation"),
            subtitle: const Text(
                "Modulate 2 values on the X and Y axis or 1 value by radius"),
            trailing: Switch(
                value: ref.watch(modulation2DProv),
                onChanged: (v) =>
                    ref.read(modulation2DProv.notifier).setAndSave(v)),
          ),
        if (ref.watch(playModeProv) == PlayMode.mpe &&
            ref.watch(modulation2DProv))
          ListTile(
            title: const Text("X-Axis"),
            trailing: DropdownModulation(
              readValue: ref.watch(mpe2DXProv),
              setValue: (v) => ref.read(mpe2DXProv.notifier).setAndSave(v),
              otherValue: ref.watch(mpe2DYProv),
            ),
          ),
        if (ref.watch(playModeProv) == PlayMode.mpe &&
            ref.watch(modulation2DProv))
          ListTile(
            title: const Text("Y-Axis"),
            trailing: DropdownModulation(
              readValue: ref.watch(mpe2DYProv),
              setValue: (v) => ref.read(mpe2DYProv.notifier).setAndSave(v),
              otherValue: ref.watch(mpe2DXProv),
            ),
          ),
        if (ref.watch(playModeProv) == PlayMode.mpe &&
            ref.watch(modulation2DProv) == false)
          ListTile(
            title: const Text("Radius"),
            trailing: DropdownModulation(
              dimensions: Dims.one,
              readValue: ref.watch(mpe1DRadiusProv),
              setValue: (v) => ref.read(mpe1DRadiusProv.notifier).setAndSave(v),
            ),
          ),
        if (ref.watch(playModeProv) == PlayMode.mpe) const Divider(),
        NonLinearSliderTile(
          label: "Note Release Delay",
          subtitle: "NoteOff delay after release in milliseconds",
          readValue: ref.watch(noteReleaseStepProv),
          setValue: (v) => ref.read(noteReleaseStepProv.notifier).set(v),
          resetFunction: ref.read(noteReleaseStepProv.notifier).reset,
          displayValue: ref.watch(noteReleaseUsable) == 0
              ? "Off"
              : ref.watch(noteReleaseUsable) < 1000
                  ? "${ref.watch(noteReleaseUsable)} ms"
                  : "${ref.watch(noteReleaseUsable) / 1000} s",
          start: 0,
          steps: Timing.timingSteps.length ~/ 1.5,
          onChangeEnd: ref.read(noteReleaseStepProv.notifier).save,
        ),
        if (ref.watch(playModeProv).modulatable)
          NonLinearSliderTile(
            label: "Modulation Ease Back",
            subtitle:
                "Modulation returning to Zero after release in milliseconds",
            readValue: ref.watch(modReleaseStepProv),
            setValue: (v) => ref.read(modReleaseStepProv.notifier).set(v),
            resetFunction: ref.read(modReleaseStepProv.notifier).reset,
            displayValue: ref.watch(modReleaseUsable) == 0
                ? "Off"
                : ref.watch(modReleaseUsable) < 1000
                    ? "${ref.watch(modReleaseUsable)} ms"
                    : "${ref.watch(modReleaseUsable) / 1000} s",
            start: 0,
            steps: Timing.timingSteps.length ~/ 1.5,
            onChangeEnd: ref.read(modReleaseStepProv.notifier).save,
          ),
        if (ref.watch(playModeProv) == PlayMode.mpe)
          if (ref.watch(mpe1DRadiusProv).exclusiveGroup == Group.pitch ||
              ref.watch(mpe2DXProv).exclusiveGroup == Group.pitch ||
              ref.watch(mpe2DYProv).exclusiveGroup == Group.pitch)
            IntSliderTile(
              min: 1,
              max: 48,
              label: "Pitch Bend Range",
              subtitle: "Maximum MPE Pitch Bend in semitones",
              trailing: Text("${ref.watch(mpePitchbendRangeProv)} st"),
              readValue: ref.watch(mpePitchbendRangeProv),
              setValue: (v) => ref.read(mpePitchbendRangeProv.notifier).set(v),
              resetValue: ref.read(mpePitchbendRangeProv.notifier).reset,
              onChangeEnd: ref.read(mpePitchbendRangeProv.notifier).save,
            ),
        if (ref.watch(playModeProv).modulatable) const Divider(),
        if (ref.watch(playModeProv).modulatable)
          ModSizeSliderTile(
            min: ref.watch(modulationRadiusProv.notifier).min,
            max: ref.watch(modulationRadiusProv.notifier).max,
            label: "Modulation Size",
            subtitle:
                "Modulation field radius, relative to the pad screen width",
            trailing:
                Text("${(ref.watch(modulationRadiusProv) * 100).toInt()}%"),
            readValue: ref.watch(modulationRadiusProv).clamp(
                ref.watch(modulationRadiusProv.notifier).min,
                ref.watch(modulationRadiusProv.notifier).max),
            setValue: (v) => ref.read(modulationRadiusProv.notifier).set(v),
            resetValue: ref.read(modulationRadiusProv.notifier).reset,
            onChangeEnd: ref.read(modulationRadiusProv.notifier).save,
          ),
        if (ref.watch(playModeProv).modulatable)
          ModSizeSliderTile(
            min: ref.watch(modulationDeadZoneProv.notifier).min,
            max: ref.watch(modulationDeadZoneProv.notifier).max,
            label: "Modulation Dead Zone",
            subtitle:
                "Size of the non-reactive center of the modulation field, relative to the field size",
            trailing:
                Text("${(ref.watch(modulationDeadZoneProv) * 100).toInt()}%"),
            readValue: ref.watch(modulationDeadZoneProv).clamp(
                ref.watch(modulationDeadZoneProv.notifier).min,
                ref.watch(modulationDeadZoneProv.notifier).max),
            setValue: (v) => ref.read(modulationDeadZoneProv.notifier).set(v),
            resetValue: ref.read(modulationDeadZoneProv.notifier).reset,
            onChangeEnd: ref.read(modulationDeadZoneProv.notifier).save,
          ),
        if (ref.watch(playModeProv).singleChannel) const Divider(),
        if (ref.watch(playModeProv).singleChannel)
          ListTile(
            title: const Text("Send CC"),
            subtitle: const Text(
                "Send Control Change along with Note, one Midi channel above"),
            trailing: Switch(
                value: ref.watch(sendCCProv),
                onChanged: (v) => ref.read(sendCCProv.notifier).setAndSave(v)),
          ),
      ],
    );
  }
}
