import 'package:beat_pads/screen_pads_menu/_screen_pads_menu.dart';

import 'package:beat_pads/theme.dart';
import 'package:flutter/material.dart';

import 'package:beat_pads/services/services.dart';

class ReturnToMenuButton extends StatelessWidget {
  const ReturnToMenuButton({Key? key, required this.transparent})
      : super(key: key);

  final bool transparent;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    double padSpacing = width * ThemeConst.padSpacingFactor;
    double padRadius = width * ThemeConst.padRadiusFactor;
    return Padding(
      padding: EdgeInsets.fromLTRB(0, padSpacing, padSpacing, padSpacing),
      child: GestureDetector(
        onLongPress: () {
          // using replacement to trigger dispose on pad screen
          Navigator.pushReplacement(
            context,
            TransitionUtils.fade(const PadMenuScreen()),
          );
        },
        child: AspectRatio(
          aspectRatio: 1,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(0),
              alignment: Alignment.center,
              primary: Palette.tan.withOpacity(transparent ? 0.8 : 1),
              onPrimary: Palette.darkGrey.withOpacity(transparent ? 0.8 : 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(padRadius),
              ),
            ),
            child: Tooltip(
              decoration: BoxDecoration(
                  color: Palette.cadetBlue.withOpacity(0.7),
                  boxShadow: kElevationToShadow[6],
                  borderRadius: BorderRadius.circular(3)),
              richMessage: const TextSpan(
                text: "Long-Press for Menu",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              triggerMode: TooltipTriggerMode.tap,
              showDuration: const Duration(milliseconds: 1000),
              padding: const EdgeInsets.all(5),
              child: const FittedBox(
                fit: BoxFit.contain,
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
