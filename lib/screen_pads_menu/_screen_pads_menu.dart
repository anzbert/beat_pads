import 'package:beat_pads/screen_pads_menu/menu.dart';
import 'package:flutter/material.dart';

class PadMenuScreen extends StatelessWidget {
  const PadMenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pad Settings"),
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(child: PadsMenu()),
    );
  }
}
