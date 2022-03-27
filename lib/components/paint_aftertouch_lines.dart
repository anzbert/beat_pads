import 'package:beat_pads/components/paint_line.dart';
import 'package:beat_pads/state/paint_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AfterTouchLines extends StatelessWidget {
  const AfterTouchLines({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PaintState>(
      builder: (context, paintState, child) {
        return Stack(
          children: [
            ...paintState.linesIterable.map((line) {
              return PaintLine(line[0], line[1]);
            }).toList()
          ],
        );
      },
    );
  }
}
