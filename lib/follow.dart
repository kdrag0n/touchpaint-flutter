import 'dart:collection';
import 'dart:ui';

import 'package:flutter/material.dart';

class FollowPainter extends CustomPainter {
  FollowPainter(this.points);

  final Map<int, Offset> points;

  @override
  void paint(Canvas canvas, Size size) {
    final boxPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 115
      ..strokeCap = StrokeCap.square
      ..isAntiAlias = true;

    canvas.drawPoints(PointMode.points, points.values.toList(growable: false), boxPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class FollowWidget extends StatefulWidget {
  FollowWidget({Key key}) : super(key: key);

  @override
  _FollowWidgetState createState() => _FollowWidgetState();
}

class _FollowWidgetState extends State<FollowWidget> {
  Map<int, Offset> _points = HashMap();

  void _fingerMove(PointerEvent details) {
    setState(() {
      _points[details.pointer] = details.localPosition;
    });
  }

  void _fingerUp(PointerEvent details) {
    setState(() {
      _points.remove(details.pointer);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _fingerMove,
      onPointerMove: _fingerMove,
      onPointerUp: _fingerUp,
      child: CustomPaint(
        painter: FollowPainter(_points)
      ),
    );
  }
}
