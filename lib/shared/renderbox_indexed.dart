import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';

class HitTestObject extends SingleChildRenderObjectWidget {
  final int index;

  const HitTestObject({required Widget child, required this.index, Key? key})
      : super(child: child, key: key);

  @override
  TestProxyBox createRenderObject(BuildContext context) {
    return TestProxyBox(index);
  }

  @override
  void updateRenderObject(BuildContext context, TestProxyBox renderObject) {
    renderObject.index = index;
  }
}

// TODO: get size?
// https://www.woolha.com/tutorials/flutter-get-widget-size-and-position
class TestProxyBox extends RenderProxyBox {
  int index;
  TestProxyBox(this.index);
}
