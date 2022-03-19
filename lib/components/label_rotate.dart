import 'package:flutter/material.dart';

class RotateLabel extends StatelessWidget {
  const RotateLabel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Rotate Device to get to the Pads")));
      },
      child: Card(
        margin: EdgeInsets.fromLTRB(8, 30, 8, 8),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.rotate_right),
              Text(
                " : Beat Pads",
                style: TextStyle(
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
