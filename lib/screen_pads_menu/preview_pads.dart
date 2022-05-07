import 'package:beat_pads/screen_beat_pads/_screen_beat_pads.dart';
import 'package:beat_pads/shared/_shared.dart';
import 'package:flutter/material.dart';

class Preview extends StatelessWidget {
  const Preview({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        color: Palette.darkGrey.color.withOpacity(0.5),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: IgnorePointer(
            child: Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6.0),
                      child: BeatPadsScreen(preview: true),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  width: double.infinity,
                  child: FittedBox(
                    child: Text(
                      "Preview",
                      style: TextStyle(
                        color: Palette.lightGrey.color.withOpacity(0.4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
