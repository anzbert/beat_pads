import 'package:beat_pads/screen_pads_menu/drop_down_enum.dart';
import 'package:beat_pads/screen_pads_menu/drop_down_modulation.dart';
import 'package:beat_pads/screen_pads_menu/slider_int.dart';
import 'package:beat_pads/screen_pads_menu/slider_modulation_size.dart';
import 'package:beat_pads/screen_pads_menu/slider_non_linear.dart';
import 'package:beat_pads/services/services.dart';
import 'package:beat_pads/shared_components/_shared.dart';
import 'package:beat_pads/shared_components/divider_title.dart';
import 'package:beat_pads/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final showModPreview = StateProvider<bool>((ref) => false);

class MenuInput extends ConsumerWidget {
  const MenuInput();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        ListView(
          padding:
              const EdgeInsets.only(bottom: ThemeConst.listViewBottomPadding),
          children: <Widget>[
            const DividerTitle('Input'),
            ListTile(
              title: const Text('Pan Mode'),
              subtitle: const Text(
                'Choose how the grid reacts to finger X and Y movement',
              ),
              trailing: DropdownEnum(
                values: PlayMode.values,
                readValue: ref.watch(playModeProv),
                setValue: (PlayMode v) =>
                    ref.read(playModeProv.notifier).setAndSave(v),
              ),
            ),
            if (ref.watch(playModeProv) == PlayMode.mpeTargetPb)
              const StringInfoBox(
                header: 'Push Style MPE',
                body: [
                  'Slide your finger to other pads and bend the pitch towards them.',
                  'Send a modulation on the pad Y-Axis (Default: Slide / CC 74).',
                  'Note: Set your instrument to the max range of MPE Pitchbend (48 semitones), to produce the expected pitches.',
                  'This mode is still new and feedback on the GitHub page is very welcome!',
                ],
              ),
            if (ref.watch(playModeProv) == PlayMode.channelMod)
              const StringInfoBox(
                header: 'Channel Aftertouch',
                body: [
                  'Slide your finger to send monophonic Aftertouch data for all notes on the current channel.',
                  'Note: Only one modulation can be sent at a time, which means further touch slides are ignored while a modulation is already in process.',
                ],
              ),
            if (ref.watch(playModeProv) == PlayMode.polyAT)
              const StringInfoBox(
                header: 'Polyphonic Aftertouch',
                body: [
                  'Slide your finger to send polyphonic Aftertouch data for the current note.',
                  'Every Note can handle its own Aftertouch modulation in this mode.',
                ],
              ),
            if (ref.watch(playModeProv) == PlayMode.mpe)
              const StringInfoBox(
                header: 'MPE',
                body: [
                  'Slide your finger to send custom modulation data for any activated note on the grid. An overlay will appear, showing the current modulation state.',
                  'You can choose one-dimensional modulation to control one paramter by the distance to where the movement started. Or two-dimensional modulation along an X and Y Axis, centered on the initial touch.',
                ],
              ),
            if (ref.watch(playModeProv) == PlayMode.slide)
              const StringInfoBox(
                header: 'Trigger Notes',
                body: [
                  'Any note you slide your finger over gets triggered after the initial touch.',
                ],
              ),
            if (ref.watch(playModeProv) == PlayMode.mpeTargetPb)
              ListTile(
                title: const Text('Y-Axis'),
                trailing: DropdownEnum(
                  values: MPEpushStyleYAxisMods.values,
                  readValue: ref.watch(mpePushYAxisModeProv),
                  setValue: (MPEpushStyleYAxisMods v) =>
                      ref.read(mpePushYAxisModeProv.notifier).setAndSave(v),
                ),
              ),
            if (ref.watch(playModeProv) == PlayMode.mpeTargetPb)
              ListTile(
                title: const Text('Row Pads only'),
                subtitle: const Text(
                    'Ignore modulation on pads below or above the current Row'),
                trailing: Switch(
                  value: ref.watch(mpeOnlyOnRowProv),
                  onChanged: (bool v) =>
                      ref.read(mpeOnlyOnRowProv.notifier).setAndSave(v),
                ),
              ),
            if (ref.watch(playModeProv) == PlayMode.mpeTargetPb)
              IntSliderTile(
                min: 0,
                max: 75,
                label: 'In-Tune Zone',
                subtitle:
                    'Set the size of the pad center with stable pitch, in percent of the pad width',
                trailing: Text(ref.watch(pitchDeadzoneProv).toString()),
                readValue: ref.watch(pitchDeadzoneProv),
                setValue: (int v) =>
                    ref.read(pitchDeadzoneProv.notifier).set(v),
                resetValue: ref.read(pitchDeadzoneProv.notifier).reset,
                onChangeEnd: ref.read(pitchDeadzoneProv.notifier).save,
              ),
            if (ref.watch(playModeProv) == PlayMode.mpeTargetPb)
              ListTile(
                title: const Text('Relative Mode'),
                subtitle: const Text(
                    "The initial touch position becomes the Pitch and Slide center for that pad"),
                trailing: Switch(
                  value: ref.watch(mpeRelativeModeProv),
                  onChanged: (bool v) =>
                      ref.read(mpeRelativeModeProv.notifier).setAndSave(v),
                ),
              ),
            if (ref.watch(playModeProv).modulationOverlay)
              ModSizeSliderTile(
                min: ref.watch(modulationRadiusProv.notifier).min,
                max: ref.watch(modulationRadiusProv.notifier).max,
                label: 'Input Size',
                subtitle: 'Modulation field width, relative to the pad screen',
                trailing:
                    Text('${(ref.watch(modulationRadiusProv) * 100).toInt()}%'),
                readValue: ref.watch(modulationRadiusProv).clamp(
                      ref.watch(modulationRadiusProv.notifier).min,
                      ref.watch(modulationRadiusProv.notifier).max,
                    ),
                setValue: (double v) =>
                    ref.read(modulationRadiusProv.notifier).set(v),
                resetValue: ref.read(modulationRadiusProv.notifier).reset,
                onChangeEnd: ref.read(modulationRadiusProv.notifier).save,
              ),
            if (ref.watch(playModeProv).modulationOverlay)
              ModSizeSliderTile(
                min: ref.watch(modulationDeadZoneProv.notifier).min,
                max: ref.watch(modulationDeadZoneProv.notifier).max,
                label: 'Dead Zone',
                subtitle:
                    'Size of the non-reactive center of the modulation field',
                trailing: Text(
                  '${(ref.watch(modulationDeadZoneProv) * 100).toInt()}%',
                ),
                readValue: ref.watch(modulationDeadZoneProv).clamp(
                      ref.watch(modulationDeadZoneProv.notifier).min,
                      ref.watch(modulationDeadZoneProv.notifier).max,
                    ),
                setValue: (double v) =>
                    ref.read(modulationDeadZoneProv.notifier).set(v),
                resetValue: ref.read(modulationDeadZoneProv.notifier).reset,
                onChangeEnd: ref.read(modulationDeadZoneProv.notifier).save,
              ),
            if (ref.watch(playModeProv) == PlayMode.mpe)
              const DividerTitle('MPE'),
            if (ref.watch(playModeProv) == PlayMode.mpe)
              ListTile(
                title: const Text('2-D Modulation'),
                subtitle: const Text(
                  'Modulate 2 controls on the X and Y axis, or just 1 by Radius [CC in brackets]',
                ),
                trailing: Switch(
                  value: ref.watch(modulation2DProv),
                  onChanged: (v) =>
                      ref.read(modulation2DProv.notifier).setAndSave(v),
                ),
              ),
            if (ref.watch(playModeProv) == PlayMode.mpe &&
                ref.watch(modulation2DProv))
              ListTile(
                title: const Text('X-Axis'),
                trailing: DropdownModulation(
                  readValue: ref.watch(mpe2DXProv),
                  setValue: (MPEmods v) =>
                      ref.read(mpe2DXProv.notifier).setAndSave(v),
                  otherValue: ref.watch(mpe2DYProv),
                ),
              ),
            if (ref.watch(playModeProv) == PlayMode.mpe &&
                ref.watch(modulation2DProv))
              ListTile(
                title: const Text('Y-Axis'),
                trailing: DropdownModulation(
                  readValue: ref.watch(mpe2DYProv),
                  setValue: (MPEmods v) =>
                      ref.read(mpe2DYProv.notifier).setAndSave(v),
                  otherValue: ref.watch(mpe2DXProv),
                ),
              ),
            if (ref.watch(playModeProv) == PlayMode.mpe &&
                ref.watch(modulation2DProv) == false)
              ListTile(
                title: const Text('Radius'),
                trailing: DropdownModulation(
                  dimensions: Dims.one,
                  readValue: ref.watch(mpe1DRadiusProv),
                  setValue: (MPEmods v) =>
                      ref.read(mpe1DRadiusProv.notifier).setAndSave(v),
                ),
              ),
            if (ref.watch(playModeProv) == PlayMode.mpe)
              if (ref.watch(mpe1DRadiusProv).exclusiveGroup == Group.pitch ||
                  ref.watch(mpe2DXProv).exclusiveGroup == Group.pitch ||
                  ref.watch(mpe2DYProv).exclusiveGroup == Group.pitch)
                IntSliderTile(
                  min: 1,
                  max: 48,
                  label: 'Pitch Bend Range',
                  subtitle: 'Maximum MPE Pitch Bend in semitones',
                  trailing: Text('${ref.watch(mpePitchbendRangeProv)} st'),
                  readValue: ref.watch(mpePitchbendRangeProv),
                  setValue: (int v) =>
                      ref.read(mpePitchbendRangeProv.notifier).set(v),
                  resetValue: ref.read(mpePitchbendRangeProv.notifier).reset,
                  onChangeEnd: ref.read(mpePitchbendRangeProv.notifier).save,
                ),
            const DividerTitle('Release'),
            NonLinearSliderTile(
              label: 'Note Release Delay',
              subtitle: 'NoteOff delay after pad release in milliseconds',
              readValue: ref.watch(noteReleaseStepProv),
              setValue: (int v) =>
                  ref.read(noteReleaseStepProv.notifier).set(v),
              resetFunction: ref.read(noteReleaseStepProv.notifier).reset,
              displayValue: ref.watch(noteReleaseUsable) == 0
                  ? 'Off'
                  : ref.watch(noteReleaseUsable) < 1000
                      ? '${ref.watch(noteReleaseUsable)} ms'
                      : '${ref.watch(noteReleaseUsable) / 1000} s',
              steps: Timing.releaseDelayTimes.length ~/ 1.5,
              onChangeEnd: ref.read(noteReleaseStepProv.notifier).save,
            ),
            if (ref.watch(playModeProv).modulationOverlay)
              NonLinearSliderTile(
                label: 'Modulation Ease Back',
                subtitle:
                    'Modulation returning to Zero after pad release in milliseconds',
                readValue: ref.watch(modReleaseStepProv),
                setValue: (int v) =>
                    ref.read(modReleaseStepProv.notifier).set(v),
                resetFunction: ref.read(modReleaseStepProv.notifier).reset,
                displayValue: ref.watch(modReleaseUsable) == 0
                    ? 'Off'
                    : ref.watch(modReleaseUsable) < 1000
                        ? '${ref.watch(modReleaseUsable)} ms'
                        : '${ref.watch(modReleaseUsable) / 1000} s',
                steps: Timing.releaseDelayTimes.length ~/ 1.5,
                onChangeEnd: ref.read(modReleaseStepProv.notifier).save,
              ),
            if (ref.watch(playModeProv).singleChannel) const DividerTitle('CC'),
            if (ref.watch(playModeProv).singleChannel)
              ListTile(
                title: const Text('Control Change'),
                subtitle: const Text(
                  'Send CC Message along with Note, one Midi channel higher',
                ),
                trailing: Switch(
                  value: ref.watch(sendCCProv),
                  onChanged: (v) => ref.read(sendCCProv.notifier).setAndSave(v),
                ),
              ),
          ],
        ),
        if (ref.watch(showModPreview)) const PaintModPreview(),
        if (ref.watch(layoutProv) == Layout.progrChange)
          Container(
            padding: const EdgeInsets.all(24),
            color: Palette.darkGrey.withOpacity(0.86),
            child: Center(
              child: Text(
                'Advanced settings disabled when using the Program Change layout',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Palette.whiteLike,
                    fontSize:
                        Theme.of(context).textTheme.headlineSmall!.fontSize),
              ),
            ),
          )
      ],
    );
  }
}
