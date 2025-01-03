import 'package:beat_pads/services/services.dart';
import 'package:beat_pads/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OctaveButtons extends ConsumerWidget {
  const OctaveButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double width = MediaQuery.of(context).size.width;
    final double padSpacing = width * ThemeConst.padSpacingFactor;
    final double padRadius = width * ThemeConst.padRadiusFactor;
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, padSpacing, padSpacing, padSpacing),
            child: ElevatedButton(
              onPressed: () {
                ref.read(baseOctaveProv.notifier).increment();
                ref.read(baseOctaveProv.notifier).save();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Palette.darkGrey,
                backgroundColor: Palette.cadetBlue,
                padding: EdgeInsets.zero,
                alignment: Alignment.center,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(padRadius),
                ),
              ),
              child: FittedBox(
                child: Icon(
                  color: Palette.darkGrey,
                  Icons.add,
                  size: 100,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, padSpacing, padSpacing, padSpacing),
            child: ElevatedButton(
              onPressed: () {
                ref.read(baseOctaveProv.notifier).decrement();
                ref.read(baseOctaveProv.notifier).save();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Palette.darkGrey,
                backgroundColor: Palette.laserLemon,
                padding: EdgeInsets.zero,
                alignment: Alignment.center,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(padRadius),
                ),
              ),
              child: FittedBox(
                child: Icon(
                  color: Palette.darkGrey,
                  Icons.remove,
                  size: 100,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
