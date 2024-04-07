import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HitTestObject extends SingleChildRenderObjectWidget {
  const HitTestObject({
    required Widget super.child,
    required this.value,
    super.key,
  });
  final int value;

  @override
  TestProxyBox createRenderObject(BuildContext context) {
    return TestProxyBox(value);
  }

  @override
  void updateRenderObject(BuildContext context, TestProxyBox renderObject) {
    renderObject.value = value;
  }
}

// should have get size function here or just layoutbuilder instead?
// https://www.woolha.com/tutorials/flutter-get-widget-size-and-position
class TestProxyBox extends RenderProxyBox {
  TestProxyBox(this.value);
  int value;
}
