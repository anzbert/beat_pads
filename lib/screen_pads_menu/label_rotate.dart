import 'package:beat_pads/shared/_shared.dart';
import 'package:flutter/material.dart';

class RotateLabel extends StatelessWidget {
  const RotateLabel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Rotate 90 degrees to Landscape to play the Pads")));
      },
      child: Card(
        color: Palette.cadetBlue.color,
        margin: EdgeInsets.fromLTRB(8, 30, 8, 8),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.rotate_right,
                color: Palette.darkGrey.color,
              ),
              Text(
                " Rotate Device To Play",
                style: TextStyle(
                  color: Palette.darkGrey.color,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
