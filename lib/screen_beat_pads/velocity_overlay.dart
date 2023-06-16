import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';

class VelocityOverlay extends StatelessWidget {
  /// Shows the velocity as a colored proportional overlay
  /// over a pad
  const VelocityOverlay({
    required int velocity,
    required BorderRadius padRadius,
    super.key,
  })  : _velocity = velocity,
        _padRadius = padRadius;

  final int _velocity;
  final BorderRadius _padRadius;

  @override
  Widget build(BuildContext context) {
    var size = Size.infinite;
    final box = context.findRenderObject() as RenderBox?;
    if (box != null) size = box.size;

    print('rebuilding');
    print(_velocity);

    return Container(
      margin: EdgeInsets.only(
        top: size.height * (1 - _velocity / 127),
      ),
      decoration: BoxDecoration(
        borderRadius: _padRadius,
        color: Palette.dirtyTranslucent,
      ),
      alignment: Alignment.bottomCenter,
    );
  }
}
