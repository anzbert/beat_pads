import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beat_pads/home/home.dart';

class ResetButton extends StatelessWidget {
  const ResetButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Provider.of<MidiData>(context, listen: false).rxNotesReset();
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Received Midi Buffer has been reset")));
        },
        child: Text("Clear Received Midi Buffer"),
      ),
    );
  }
}
