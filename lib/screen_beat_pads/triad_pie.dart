import 'dart:math';

import 'package:flutter/material.dart';

class TriadPie extends StatelessWidget {
  const TriadPie({
    required this.scalePattern,
    required this.note,
    required this.root,
  }) : normalisedNote = note % 12;

  final int note;
  final int normalisedNote;
  final List<int> scalePattern;
  final int root;

  // List<int> getRootAdjustedScale() {
  //   return scalePattern.map((int step) => (step + (root % 12)) % 12).toList();
  // }

  int get adjustedNote {
    final adjustedNote = (normalisedNote + 12 - root) % 12;
    assert(!adjustedNote.isNegative);
    return adjustedNote;
  }

  List<List<int>> getAllTriads() {
    if (!scalePattern.contains(adjustedNote)) return [];

    List<List<int>> list = [];

    for (int i = 0; i < scalePattern.length; i++) {
      List<int> triad = [];
      for (int x = 0; x < 3; x++) {
        triad.add(scalePattern[(i + x * 2) % scalePattern.length]);
      }
      list.add(triad);
    }

    return list;
  }

  List<Color> getAllColors(int numOfTriads) {
    List<Color> colors = [];

    for (int i = 0; i < numOfTriads; i++) {
      final color = HSLColor.fromAHSL(
        1.0,
        (i * 360 / numOfTriads) % 360,
        .90,
        0.7,
      ).toColor();

      colors.add(color);
    }
    return colors;
  }

  List<double> getStops(int numStops) {
    List<double> stops = [];

    for (int i = 0; i < numStops; i++) {
      stops.add(1 / numStops * i);
      stops.add(min(1 / numStops * (i + 1), 1.0));
    }
    return stops;
  }

  @override
  Widget build(BuildContext context) {
    // get all possible triads:
    final List<List<int>> allTriads = getAllTriads();

    // if the note is not in the scale, there is no triads:
    if (allTriads.isEmpty) return SizedBox.shrink();

    // each triad is assigned a color:
    final List<Color> allColors = getAllColors(allTriads.length);

    // get the three colors, checking for each position which triad it's part of:
    final List<Color> degreeColors = [];
    for (int i = 0; i < 3; i++) {
      final int index = allTriads.indexWhere(
        (List<int> triad) => triad[i] == adjustedNote,
      );
      if (!index.isNegative) degreeColors.add(allColors[index]);
    }

    // print(degreeColors[0]);
    final List<double> stops = getStops(degreeColors.length);

    assert(allColors.length == allTriads.length);
    // assert(stops.length == degreeColors.length * 2);
    // assert(allTriads.length == currentScale.length);

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
          colors: degreeColors.expand((e) => [e, e]).toList(),
          stops: stops,
        ),
      ),
    );
  }
}
