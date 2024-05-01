import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';

class IntCounterTile extends StatelessWidget {
  const IntCounterTile({
    required this.readValue,
    required this.setValue,
    this.subtitle,
    this.modDisplay,
    this.label = '#label',
    this.resetFunction,
    super.key,
  });

  final String label;
  final int readValue;
  final String Function(int)? modDisplay;
  final void Function(int) setValue;
  final void Function()? resetFunction;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Text(label),
          if (resetFunction != null)
            TextButton(
              onPressed: () => resetFunction!(),
              child: const Text('Reset'),
            ),
        ],
      ),
      subtitle: subtitle == null ? null : Text(subtitle!),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () {
              if (readValue - 1 >= 0) setValue(readValue - 1); // no negatives
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Palette.darkGrey,
              backgroundColor: Palette.laserLemon,
              shape: const CircleBorder(),
            ),
            child: const Icon(Icons.remove),
          ),
          SizedBox(
            width: 40,
            child: Text(
              modDisplay == null
                  ? readValue.toString()
                  : modDisplay!(readValue),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.titleMedium!.fontSize,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setValue(readValue + 1);
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Palette.darkGrey,
              backgroundColor: Palette.cadetBlue,
              shape: const CircleBorder(),
            ),
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
