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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      elevation: 20,
      highlightElevation: 0,
      backgroundColor: Palette.whiteLike.color.withAlpha(60),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Image.asset("assets/logo/logo_noframe.png"),
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
