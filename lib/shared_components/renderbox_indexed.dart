import 'package:beat_pads/services/layout/pad_type.dart';
import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HitTestObject extends SingleChildRenderObjectWidget {
  const HitTestObject({
    required Widget super.child,
    required this.customPad,
    super.key,
  });

  /// the pad that is currently detected in the hitboxtest
  final CustomPad customPad;

  @override
  TestProxyBox createRenderObject(BuildContext context) {
    return TestProxyBox(customPad);
  }

  @override
  void updateRenderObject(BuildContext context, TestProxyBox renderObject) {
    renderObject.customPad = customPad;
  }
}

// should have get size function here or just layoutbuilder instead?
// https://www.woolha.com/tutorials/flutter-get-widget-size-and-position
class TestProxyBox extends RenderProxyBox {
  TestProxyBox(this.customPad);
  CustomPad customPad;
}
