import 'package:flutter/material.dart';

import 'package:beat_pads/services/color_const.dart';
import 'package:beat_pads/screens/screen_pads.dart';

class FloatingButtonPads extends StatelessWidget {
  const FloatingButtonPads({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.large(
      elevation: 20,
      highlightElevation: 0,
      backgroundColor: Palette.cadetBlue.color.withAlpha(90),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Image.asset("assets/logo/logo.png"),
      ),
      onPressed: (() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PadsScreen()),
        );
      }),
    );
  }
}
