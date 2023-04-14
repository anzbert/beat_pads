import 'package:beat_pads/screen_beat_pads/pads_and_controls.dart';
import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Preview extends ConsumerWidget {
  const Preview({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: IgnorePointer(
          child: DeviceUtils.isPortrait(context)
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    const AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Padding(
                        padding: EdgeInsets.all(4),
                        child: BeatPadsAndControls(
                          preview: true,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      width: double.infinity,
                      child: FittedBox(
                        child: Stack(
                          children: [
                            // Text Fill
                            Text(
                              "Preview",
                              style: TextStyle(
                                color: Palette.lightGrey.withOpacity(0.4),
                              ),
                            ),
                            // Text Outline
                            Text(
                              "Preview",
                              style: TextStyle(
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 0.15
                                  ..color = Palette.darkGrey,
                              ),
                            ),
                          ],
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
                        padding: EdgeInsets.all(4),
                        child: BeatPadsAndControls(
                          preview: true,
                        ),
                      ),
                    ),
                    const Divider(
                      thickness: 3,
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
    );
  }
}
