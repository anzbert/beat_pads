import 'package:beat_pads/screen_beat_pads/_screen_beat_pads.dart';
import 'package:beat_pads/services/_services.dart';
import 'package:flutter/material.dart';

class Preview extends StatelessWidget {
  const Preview({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Container(
            color: Palette.darkGrey.withOpacity(0.5),
            child: IgnorePointer(
              child: DeviceUtils.isPortrait(context)
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        const AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Padding(
                            padding: EdgeInsets.all(4.0),
                            child: BeatPadsScreen(preview: true),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          width: double.infinity,
                          child: FittedBox(
                            child: Text(
                              "Preview",
                              style: TextStyle(
                                color: Palette.lightGrey.withOpacity(0.4),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        const AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Padding(
                            padding: EdgeInsets.all(4.0),
                            child: BeatPadsScreen(preview: true),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 100),
                          width: double.infinity,
                          child: FittedBox(
                            child: Text(
                              "Preview",
                              style: TextStyle(
                                color: Palette.lightGrey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
