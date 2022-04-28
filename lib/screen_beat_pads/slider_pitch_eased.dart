import 'package:flutter/material.dart';

class PitchSliderEased extends StatefulWidget {
  const PitchSliderEased({
    Key? key,
  }) : super(key: key);

  @override
  _PitchSliderEased createState() => _PitchSliderEased();
}

class _PitchSliderEased extends State<PitchSliderEased> {
  double _pitch = 0;
  bool reseting = false;

  CurveTween curve = CurveTween(curve: Curves.easeOut);

  void reset() async {}

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 1,
      child: Slider(
        min: 0,
        max: 1,
        value: _pitch,
        onChanged: (val) {
          setState(() => _pitch = val);
        },
        onChangeEnd: (_) {
          reseting = true;
          reset();
        },
      ),
    );
  }

  @override
  void dispose() {
    reseting = false;
    _pitch = 0;
    super.dispose();
  }
}
