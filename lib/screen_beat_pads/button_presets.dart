import 'package:beat_pads/theme.dart';
import 'package:flutter/material.dart';
import 'package:beat_pads/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ClickType {
  double,
  long,
  tap,
}

class PresetButtons extends ConsumerWidget {
  static final backgoundColors = [
    Palette.laserLemon,
    Palette.lightPink,
    Palette.cadetBlue,
    Palette.yellowGreen,
    Palette.tan
  ];

  const PresetButtons({required this.clickType, this.row = false, Key? key})
      : super(key: key);

  final bool row;
  final ClickType clickType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Flex(
      mainAxisAlignment: MainAxisAlignment.center,
      // mainAxisSize: MainAxisSize.min,
      direction: row ? Axis.horizontal : Axis.vertical,
      children: [
        for (int i = 1; i <= backgoundColors.length; i++)
          _PresetButton(
            i,
            backgoundColors[i - 1],
            clickType: clickType,
          )
      ],
    );
  }
}

class _PresetButton extends ConsumerWidget {
  const _PresetButton(
    this.preset,
    this.color, {
    required this.clickType,
  });

  final ClickType clickType;
  final int preset;
  final Color color;

  void setPreset(WidgetRef ref) =>
      ref.read(presetNotifierProvider.notifier).set(preset);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double width = MediaQuery.of(context).size.width;
    double padSpacing = width * ThemeConst.padSpacingFactor;
    double padRadius = width * ThemeConst.padRadiusFactor;
    return Expanded(
      flex: 1,
      child: Padding(
          padding: EdgeInsets.fromLTRB(padSpacing, padSpacing, 0, padSpacing),
          child: GestureDetector(
            onDoubleTap:
                clickType == ClickType.double ? () => setPreset(ref) : null,
            onLongPress:
                clickType == ClickType.long ? () => setPreset(ref) : null,
            child: _ElevatedPresetButton(
                clickType: clickType,
                preset: preset,
                color: color,
                padRadius: padRadius),
          )),
    );
  }
}

class _ElevatedPresetButton extends ConsumerWidget {
  const _ElevatedPresetButton({
    required this.preset,
    required this.color,
    required this.padRadius,
    required this.clickType,
  });

  final ClickType clickType;
  final int preset;
  final Color color;
  final double padRadius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        if (clickType == ClickType.tap) {
          ref.read(presetNotifierProvider.notifier).set(preset);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.all(0),
        alignment: Alignment.center,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(padRadius),
        ),
      ),
      child: Text(
        preset.toString(),
        style: TextStyle(
            fontSize: 32,
            color: ref.watch(presetNotifierProvider) == preset
                ? Palette.darkGrey
                : Palette.darkGrey.withOpacity(0.1)),
      ),
    );
  }
}
