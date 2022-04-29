import 'package:beat_pads/services/_services.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaintAfterTouchLines extends StatelessWidget {
  const PaintAfterTouchLines({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AftertouchModel>(
      builder: (context, paintModel, child) {
        return Stack(
          children: [
            ...paintModel.linesIterable.map((line) {
              return PaintLine(line[0], line[1]);
            })
          ],
        );
      },
    );
  }
}
