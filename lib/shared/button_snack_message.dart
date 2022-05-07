import '_shared.dart';

import 'package:flutter/material.dart';

class SnackMessageButton extends StatelessWidget {
  const SnackMessageButton(
      {required this.label,
      required this.message,
      required this.onPressed,
      Key? key})
      : super(key: key);

  final Function onPressed;
  final String message;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      },
      child: Text(
        label,
        style: TextStyle(
          color: Palette.darkGrey.color,
        ),
      ),
    );
  }
}
