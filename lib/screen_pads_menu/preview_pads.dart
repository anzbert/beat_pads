import 'package:beat_pads/screen_beat_pads/_screen_beat_pads.dart';
import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Preview extends ConsumerWidget {
  const Preview();
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
                        padding: EdgeInsets.all(4.0),
                        child: BeatPadsScreen(
                          preview: true,
                        ),
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
                        child: BeatPadsScreen(
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
