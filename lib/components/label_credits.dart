import 'package:flutter/material.dart';

class CreditsLabel extends StatelessWidget {
  const CreditsLabel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(8, 30, 8, 8),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("BeatPads v0.1\n      February 2022\n"),
            Text("Made by anzbert\n      [anzgraph.com]\n"),
            Text("Dog Icon by 'catalyststuff'\n      [freepik.com]\n"),
            Text("Logo Animated with Rive\n      [rive.app]"),
          ],
        ),
      ),
    );
  }
}
