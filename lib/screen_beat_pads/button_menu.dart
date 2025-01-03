import 'package:beat_pads/screen_pads_menu/_screen_pads_menu.dart';
import 'package:beat_pads/services/services.dart';
import 'package:beat_pads/theme.dart';
import 'package:flutter/material.dart';

class ReturnToMenuButton extends StatelessWidget {
  const ReturnToMenuButton({required this.transparent, super.key});

  final bool transparent;

  @override
  Widget build(BuildContext context) {
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
              shadowColor:
                  Palette.lightGrey.withValues(alpha: transparent ? 0.15 : 1),
              foregroundColor:
                  Palette.lightGrey.withValues(alpha: transparent ? 0.15 : 1),
              backgroundColor: transparent
                  ? Palette.darker(Palette.cadetBlue, 0.3)
                      .withValues(alpha: 0.4)
                  : Palette.darker(Palette.cadetBlue, 0.3),
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
              richMessage: const TextSpan(
                text: 'Double-Tap for Menu',
              ),
              triggerMode: TooltipTriggerMode.tap,
              showDuration: const Duration(milliseconds: 1000),
              padding: const EdgeInsets.all(5),
              child: FittedBox(
                child: Icon(
                  color: Palette.lightGrey,
                  Icons.menu_rounded,
                  size: 100,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
