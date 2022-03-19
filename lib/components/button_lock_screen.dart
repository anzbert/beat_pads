import 'package:flutter/material.dart';
import '../services/device_utils.dart';

class LockScreenButton extends StatefulWidget {
  const LockScreenButton({Key? key}) : super(key: key);

  @override
  State<LockScreenButton> createState() => _LockScreenButtonState();
}

class _LockScreenButtonState extends State<LockScreenButton> {
  bool screenLocked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onLongPress: () {
          setState(() {
            screenLocked = !screenLocked;
          });
          if (screenLocked) {
            landscapeOnly();
          } else {
            enableRotation();
          }
        },
        child: IconButton(
          onPressed: () {},
          padding: EdgeInsets.all(0),
          color: screenLocked
              ? Colors.red
              : Theme.of(context).secondaryHeaderColor,
          icon: Icon(Icons.lock),
        ));
  }

  @override
  void dispose() {
    enableRotation();
    super.dispose();
  }
}
