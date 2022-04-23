import 'package:beat_pads/services/_services.dart';
import 'package:beat_pads/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SustainButtonRect extends StatefulWidget {
  const SustainButtonRect({Key? key}) : super(key: key);

  @override
  State<SustainButtonRect> createState() => _SustainButtonRectState();
}

class _SustainButtonRectState extends State<SustainButtonRect> {
  final key = GlobalKey();
  bool sustainState = false;
  int? disposeChannel;

  bool notOnButtonRect(Offset touchPosition) {
    final RenderBox childRenderBox =
        key.currentContext!.findRenderObject() as RenderBox;
    final Size childSize = childRenderBox.size;
    final Offset childPosition = childRenderBox.localToGlobal(Offset.zero);

    return touchPosition.dx < childPosition.dx ||
        touchPosition.dx > childPosition.dx + childSize.width ||
        touchPosition.dy < childPosition.dy ||
        touchPosition.dy > childPosition.dy + childSize.height;
  }

  @override
  void dispose() {
    if (disposeChannel != null && sustainState == true) {
      MidiUtils.sustainMessage(disposeChannel!, false);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int channel = Provider.of<Settings>(context, listen: true).channel;
    disposeChannel = channel;
    double padSize = MediaQuery.of(context).size.width * 0.005;
    return Padding(
      padding: EdgeInsets.fromLTRB(0, padSize, padSize, padSize),
      child: Listener(
        onPointerDown: (_) {
          MidiUtils.sustainMessage(channel, true);
          setState(() {
            sustainState = true;
          });
        },
        onPointerUp: (touch) {
          if (!notOnButtonRect(touch.position)) {
            MidiUtils.sustainMessage(channel, false);
            if (mounted) {
              setState(() {
                sustainState = false;
              });
            }
          }
        },
        child: ElevatedButton(
          key: key,
          onPressed: () {},
          child: RotatedBox(
            quarterTurns: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                'Sustain',
                style: TextStyle(
                  fontSize: 100,
                ),
              ),
            ),
          ),
          style: ElevatedButton.styleFrom(
            alignment: Alignment.center,
            padding: EdgeInsets.all(0),
            primary: sustainState
                ? Palette.lightPink.color
                : Palette.yellowGreen.color,
            onPrimary: Palette.darkGrey.color,
          ),
        ),
      ),
    );
  }
}
