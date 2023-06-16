import 'package:beat_pads/screen_beat_pads/velocity_overlay.dart';
import 'package:beat_pads/services/services.dart';
import 'package:beat_pads/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BeatPad extends ConsumerStatefulWidget {
  const BeatPad({
    required int note,
    required bool preview,
    super.key,
  })  : _note = note,
        _preview = preview;

  final bool _preview;
  final int _note;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BeatPadState();
}

class _BeatPadState extends ConsumerState<BeatPad> {
  int _padVelocity = 0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    void setStateIfNoteVelocityChanged(_, next) {
      final queryNoteVelocity =
          ref.watch(senderProvider).isNoteOn(widget._note);

      if (queryNoteVelocity != _padVelocity) {
        setState(() => _padVelocity = queryNoteVelocity);
      }
    }

    ref
      ..listen(touchBuffer, setStateIfNoteVelocityChanged)
      ..listen(touchReleaseBuffer, setStateIfNoteVelocityChanged)
      ..listen(noteReleaseBuffer, setStateIfNoteVelocityChanged);

    final color = ref.watch(padColorsProv).colorize(
          ref.watch(scaleProv).intervals,
          ref.watch(baseHueProv),
          ref.watch(rootProv),
          widget._note,
          widget._preview ? 0 : ref.watch(rxNoteProvider)[widget._note],
          noteOn: _padVelocity != 0,
        );

    final splashColor = Palette.splashColor;

    final padRadius = BorderRadius.all(
      Radius.circular(screenWidth * ThemeConst.padRadiusFactor),
    );
    final padSpacing = screenWidth * ThemeConst.padSpacingFactor;

    final label = PadLabels.getLabel(
      ref.watch(padLabelsProv),
      ref.watch(layoutProv),
      widget._note,
    );
    final fontSize = screenWidth * 0.021;
    final padTextColor = Palette.darkGrey;

    return Container(
      padding: EdgeInsets.all(padSpacing),
      height: double.infinity,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Material(
            elevation: 3,
            color: color,
            borderRadius: padRadius,
            shadowColor: Colors.black,
            child: widget._note > 127 || widget._note < 0
                ?
                // OUT OF MIDI RANGE
                InkWell(
                    borderRadius: padRadius,
                    child: Padding(
                      padding: EdgeInsets.all(padSpacing),
                      child: Text(
                        widget._note.toString(),
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Palette.lightGrey,
                          fontSize: fontSize * 0.8,
                        ),
                      ),
                    ),
                  )
                :
                // WITHIN MIDI RANGE
                InkWell(
                    onTapDown: (_) {},
                    borderRadius: padRadius,
                    highlightColor: color,
                    splashColor: splashColor,
                    child: Padding(
                      padding: EdgeInsets.all(padSpacing),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (label.subtitle != null)
                            Flexible(
                              child: Text(
                                label.subtitle!,
                                style: TextStyle(
                                  color: padTextColor,
                                  fontSize: fontSize * 0.6,
                                ),
                              ),
                            ),
                          if (label.title != null)
                            Flexible(
                              child: Text(
                                label.title!,
                                style: TextStyle(
                                  color: padTextColor,
                                  fontSize: fontSize,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
          ),
          if (ref.watch(velocityVisualProv) && widget._preview == false)
            VelocityOverlay(
              velocity: _padVelocity,
              padRadius: padRadius,
            ),
        ],
      ),
    );
  }
}
