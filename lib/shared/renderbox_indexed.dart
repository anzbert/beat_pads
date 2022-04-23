import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';

class TestObject extends SingleChildRenderObjectWidget {
  final int index;

  const TestObject({required Widget child, required this.index, Key? key})
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

class TestProxyBox extends RenderProxyBox {
  int index;
  TestProxyBox(this.index);
}
