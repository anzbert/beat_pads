import 'package:beat_pads/screen_beat_pads/button_presets.dart';
import 'package:beat_pads/screen_pads_menu/_screen_pads_menu.dart';
import 'package:beat_pads/services/services.dart';
import 'package:beat_pads/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReturnToMenuButton extends ConsumerWidget {
  const ReturnToMenuButton({required this.transparent, super.key});

  final bool transparent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double width = MediaQuery.of(context).size.width;

    final double padSpacing = width * ThemeConst.padSpacingFactor;
    final double padRadius = width * ThemeConst.padRadiusFactor;
    return Padding(
      padding: EdgeInsets.fromLTRB(0, padSpacing, padSpacing, padSpacing),
      child: GestureDetector(
        onDoubleTap: () {
          // using pushReplacement to trigger dispose on pad screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute<PadMenuScreen>(
              builder: (context) => PadMenuScreen(),
            ),
          );
        },
        child: AspectRatio(
          aspectRatio: 1,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              shadowColor: Palette.lightGrey.withValues(
                alpha: transparent ? 0.15 : 1,
              ),
              foregroundColor: Palette.lightGrey.withValues(
                alpha: transparent ? 0.15 : 1,
              ),
              backgroundColor: transparent
                  ? Palette.darkGrey.withValues(alpha: 0.4)
                  : Palette.darkGrey,
              padding: EdgeInsets.zero,
              alignment: Alignment.center,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(padRadius),
              ),
            ),
            child: Tooltip(
              decoration: BoxDecoration(
                color: Palette.cadetBlue.withValues(alpha: 0.5),
                boxShadow: kElevationToShadow[6],
                borderRadius: BorderRadius.circular(3),
              ),
              richMessage: const TextSpan(text: 'Double-Tap for Menu'),
              triggerMode: TooltipTriggerMode.tap,
              showDuration: const Duration(milliseconds: 1000),
              padding: const EdgeInsets.all(5),
              child: FittedBox(
                child: RotatedBox(
                  quarterTurns: 2,
                  child: Icon(
                    // color: Palette.whiteLike.withAlpha(200),
                    color: PresetButtons
                        .backgoundColors[ref.watch(presetNotifierProvider) - 1]
                        .withAlpha(200),
                    Icons.play_arrow,
                    size: 50,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
