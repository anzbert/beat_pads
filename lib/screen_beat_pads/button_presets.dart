import 'package:beat_pads/theme.dart';
import 'package:flutter/material.dart';
import 'package:beat_pads/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PresetButtons extends ConsumerWidget {
  const PresetButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // double width = MediaQuery.of(context).size.width;
    // double padSpacing = width * ThemeConst.padSpacingFactor;
    // double padRadius = width * ThemeConst.padRadiusFactor;
    return Column(
      children: [
        _PresetButton(1, Palette.laserLemon),
        _PresetButton(2, Palette.darkGrey),
        _PresetButton(3, Palette.darkGrey),
        _PresetButton(4, Palette.darkGrey),
        _PresetButton(5, Palette.darkGrey),
      ],
    );
  }
}

class _PresetButton extends ConsumerWidget {
  const _PresetButton(
    this.preset,
    this.color,
  );

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
        child: ElevatedButton(
          onPressed: () {
            // ref.read(baseOctaveProv.notifier).decrement();
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Palette.darkGrey,
            backgroundColor: color,
            padding: const EdgeInsets.all(0),
            alignment: Alignment.center,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(padRadius),
            ),
          ),
          child: const FittedBox(
            fit: BoxFit.contain,
            child: Icon(
              Icons.remove,
              size: 100,
            ),
          ),
        ),
      ),
    );
  }
}
