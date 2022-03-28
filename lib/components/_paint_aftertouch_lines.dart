import 'package:beat_pads/components/_paint_line.dart';
import 'package:beat_pads/state/_paint_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaintAfterTouchLines extends StatelessWidget {
  const PaintAfterTouchLines({Key? key}) : super(key: key);

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
