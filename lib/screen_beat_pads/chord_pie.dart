import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChordPie extends ConsumerWidget {
  ChordPie();

  final int amount = 12;
  final List<int> degrees = [0, 3, 5];

  List<Color> getColors(int numColors) {
    List<Color> colors = [];
    for (int i = 0; i < numColors; i++) {
      // final color = HSLColor.fromAHSL(1, i * 360 / amount, .95, .8).toColor();
      final color = HSLColor.fromAHSL(
        1,
        (i * 360 / amount) % 360,
        .95,
        0.7,
      ).toColor();
      colors.add(color);
      colors.add(color);
    }
    return colors;
  }

  // List<Color> getDegreeColors(List<int> degrees) {
  //   final bla = getColors(12);

  // }

  List<double> getStops(int numStops) {
    List<double> stops = [];

    for (int i = 0; i < numStops; i++) {
      stops.add(1 / numStops * i);
      stops.add(min(1 / numStops * (i + 1), 1.0));
    }

    return stops;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: SweepGradient(
          center: Alignment.center,
          transform: GradientRotation(
            pi / 2 * 3,
          ), // rotate 3/4 turn to start at 12 o'clock
          startAngle: 0,
          endAngle: pi * 2,
          colors: getColors(amount),
          stops: getStops(amount),
          // colors: [
          //   Colors.red,
          //   Colors.red,
          //   Colors.yellow,
          //   Colors.yellow,
          //   Colors.blue,
          //   Colors.blue,
          // ],
          // stops: [
          //   0,
          //   1 / 3,
          //   1 / 3,
          //   2 / 3,
          //   2 / 3,
          //   1.0,
          // ], // split in thirds with no gradient
        ),
      ),
    );
  }
}
