import 'package:beat_pads/services/services.dart';
import 'package:beat_pads/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OctaveButtons extends ConsumerWidget {
  const OctaveButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final padSpacing = width * ThemeConst.padSpacingFactor;
    final padRadius = width * ThemeConst.padRadiusFactor;
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, padSpacing, padSpacing, padSpacing),
            child: ElevatedButton(
              onPressed: () async {
                ref.read(baseOctaveProv.notifier).increment();
                await ref.read(baseOctaveProv.notifier).save();
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
              child: const FittedBox(
                child: Icon(
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
              onPressed: () async {
                ref.read(baseOctaveProv.notifier).decrement();
                await ref.read(baseOctaveProv.notifier).save();
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
              child: const FittedBox(
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
