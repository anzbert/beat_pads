import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HitTestObject extends SingleChildRenderObjectWidget {
  const HitTestObject({
    required Widget super.child,
    required this.index,
    super.key,
  });
  final int index;

  @override
  TestProxyBox createRenderObject(BuildContext context) => TestProxyBox(index);

  @override
  void updateRenderObject(BuildContext context, TestProxyBox renderObject) {
    renderObject.index = index;
  }
}

// should have get size function here or just layoutbuilder instead?
// https://www.woolha.com/tutorials/flutter-get-widget-size-and-position
class TestProxyBox extends RenderProxyBox {
  TestProxyBox(this.index);
  int index;
}
