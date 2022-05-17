import 'package:flutter/material.dart';
import 'package:beat_pads/services/_services.dart';

class RotateLabel extends StatelessWidget {
  const RotateLabel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Rotate 90 degrees to Landscape to play the Pads")));
      },
      child: Card(
        color: Palette.laserLemon,
        // margin: EdgeInsets.fromLTRB(8, 30, 8, 8),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.rotate_right,
                color: Palette.darkGrey,
              ),
              Text(
                " Rotate Device To Play",
                style: TextStyle(
                  color: Palette.darkGrey,
                  fontSize: 20,
                  // decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
