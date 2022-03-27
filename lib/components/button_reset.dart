import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beat_pads/state/midi.dart';

class ResetButton extends StatelessWidget {
  const ResetButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Provider.of<MidiData>(context, listen: false).rxNotesReset();
        },
        child: Text("Clear Received Midi Buffer"),
      ),
    );
  }
}
