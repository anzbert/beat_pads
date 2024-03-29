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
              builder: (context) => const PadMenuScreen(),
            ),
          );
        },
        child: AspectRatio(
          aspectRatio: 1,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              shadowColor:
                  Palette.lightGrey.withOpacity(transparent ? 0.15 : 1),
              foregroundColor:
                  Palette.lightGrey.withOpacity(transparent ? 0.5 : 1),
              backgroundColor: transparent
                  ? Colors.transparent
                  : Palette.darker(Palette.cadetBlue, 0.3),
              padding: EdgeInsets.zero,
              alignment: Alignment.center,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(padRadius),
              ),
            ),
            child: Tooltip(
              decoration: BoxDecoration(
                color: Palette.cadetBlue.withOpacity(0.7),
                boxShadow: kElevationToShadow[6],
                borderRadius: BorderRadius.circular(3),
              ),
              richMessage: const TextSpan(
                text: 'Double-Tap for Menu',
              ),
              triggerMode: TooltipTriggerMode.tap,
              showDuration: const Duration(milliseconds: 1000),
              padding: const EdgeInsets.all(5),
              child: const FittedBox(
                child: Icon(
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
