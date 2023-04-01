import 'package:beat_pads/theme.dart';
import 'package:flutter/material.dart';
import 'package:beat_pads/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PresetButtons extends ConsumerWidget {
  static final backgoundColors = [
    Palette.laserLemon,
    Palette.lightPink,
    Palette.cadetBlue,
    Palette.yellowGreen,
    Palette.tan
  ];

  const PresetButtons({this.doubleClick = true, this.row = false, Key? key})
      : super(key: key);

  final bool row;
  final bool doubleClick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Flex(
      direction: row ? Axis.horizontal : Axis.vertical,
      children: [
        for (int i = 1; i <= backgoundColors.length; i++)
          _PresetButton(i, backgoundColors[i - 1], doubleClick: doubleClick)
      ],
    );
  }
}

class _PresetButton extends ConsumerWidget {
  const _PresetButton(
    this.preset,
    this.color, {
    this.doubleClick = true,
  });

  final bool doubleClick;
  final int preset;
  final Color color;

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
          onDoubleTap: () {
            if (doubleClick) {
              ref.read(presetNotifierProvider.notifier).set(preset);
            }
          },
          child: ElevatedButton(
            onPressed: () {
              if (!doubleClick) {
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
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                preset.toString(),
                style: TextStyle(
                    fontSize: 50,
                    color: ref.watch(presetNotifierProvider) == preset
                        ? Palette.darkGrey
                        : Palette.darkGrey.withOpacity(0.1)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
