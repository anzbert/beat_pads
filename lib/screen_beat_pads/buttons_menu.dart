import 'package:beat_pads/screen_pads_menu/_screen_pads_menu.dart';
import 'package:beat_pads/shared/_shared.dart';
import 'package:beat_pads/theme.dart';
import 'package:flutter/material.dart';

import 'package:beat_pads/services/_services.dart';
import 'package:provider/provider.dart';

class ReturnToMenuButton extends StatelessWidget {
  const ReturnToMenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double padSpacing =
        context.watch<Settings>().padArea.width * ThemeConst.padSpacingFactor;

    return LayoutBuilder(
      builder: ((context, constraints) {
        return Padding(
          padding: EdgeInsets.fromLTRB(0, padSpacing, padSpacing, padSpacing),
          child: GestureDetector(
            onLongPress: () {
              Navigator.push(
                context,
                TransitionUtils.fade(PadMenuScreen()),
              );
            },
            child: ElevatedButton(
              onPressed: () {},
              child: Tooltip(
                message: "Long-Press for Menu",
                triggerMode: TooltipTriggerMode.tap,
                padding: EdgeInsets.all(5),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Icon(
                    Icons.menu_rounded,
                    size: 100,
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(0),
                alignment: Alignment.center,
                primary: Palette.cadetBlue.color,
                onPrimary: Palette.darkGrey.color,
              ),
            ),
          ),
        );
      }),
    );
  }
}
