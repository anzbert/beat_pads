import 'package:flutter/material.dart';

class CustomPaintRadius extends CustomPainter {
  CustomPaintRadius({
    required this.origin,
    required this.maxRadius,
    required this.deadZone,
    required this.change,
    required this.dirty,
    required this.colorBack,
    required this.colorFront,
    required this.colorDeadZone,
  }) : changeAbsolute = change * maxRadius;

  final Offset origin;
  final double maxRadius;
  final double deadZone;
  final Color colorBack;
  final Color colorFront;
  final Color colorDeadZone;
  final double change;
  final double changeAbsolute;
  final bool dirty;

  @override
  void paint(Canvas canvas, Size size) {
    // BACK
    final Paint brushBack = Paint()
      ..color = colorBack
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    final pathBack = Path()
      ..addOval(
        Rect.fromCircle(
          center: origin,
          radius: maxRadius,
        ),
      );

    if (!dirty) {
      canvas.drawShadow(
          pathBack, Colors.black.withValues(alpha: change), 6, true);
    }
    canvas.drawPath(pathBack, brushBack);
    // canvas.drawCircle(origin, maxRadius, brushBack); // background

    // FRONT
    final Paint brush = Paint()
      ..color = colorFront
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(origin, changeAbsolute, brush); // radius
    // var pathFront = Path()
    //   ..addOval(Rect.fromCircle(
    //     center: origin,
    //     radius: changeAbsolute,
    //   ));

    // canvas.drawShadow(pathFront, const Color(0xff000000), 3, true);
    // canvas.drawPath(pathFront, brush);

    brush
      ..style = PaintingStyle.fill
      ..color = colorDeadZone;
    if (change > deadZone) {
      canvas.drawCircle(origin, maxRadius * deadZone, brush); // deadZone
    }
  }

  @override
  bool shouldRepaint(CustomPaintRadius oldDelegate) {
    return oldDelegate.change != change ||
        oldDelegate.deadZone != deadZone ||
        oldDelegate.colorDeadZone != colorDeadZone ||
        oldDelegate.maxRadius != maxRadius;
  }
}
