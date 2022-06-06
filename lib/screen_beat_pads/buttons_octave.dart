import 'package:beat_pads/theme.dart';
import 'package:flutter/material.dart';
import 'package:beat_pads/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OctaveButtons extends ConsumerWidget {
  const OctaveButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double width = MediaQuery.of(context).size.width;
    double padSpacing = width * ThemeConst.padSpacingFactor;
    double padRadius = width * ThemeConst.padRadiusFactor;
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, padSpacing, padSpacing, padSpacing),
            child: ElevatedButton(
              onPressed: () {
                ref.read(baseOctaveProv.notifier).increment();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(0),
                alignment: Alignment.center,
                primary: Palette.cadetBlue,
                onPrimary: Palette.darkGrey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(padRadius),
                ),
              ),
              child: const FittedBox(
                fit: BoxFit.contain,
                child: Icon(
                  Icons.add,
                  size: 100,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, padSpacing, padSpacing, padSpacing),
            child: ElevatedButton(
              onPressed: () {
                ref.read(baseOctaveProv.notifier).decrement();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(0),
                alignment: Alignment.center,
                primary: Palette.laserLemon,
                onPrimary: Palette.darkGrey,
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
        ),
      ],
    );
  }
}
