import 'dart:async';

import 'package:flutter/material.dart';

const clearDelay = const Duration(milliseconds: 250);

class FillPainter extends CustomPainter {
  FillPainter(this.down);

  final bool down;

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..color = down ? Colors.white : Colors.black
      ..style = PaintingStyle.fill;

    canvas.drawPaint(fillPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class FillWidget extends StatefulWidget {
  FillWidget({Key key}) : super(key: key);

  @override
  _FillWidgetState createState() => _FillWidgetState();
}

class _FillWidgetState extends State<FillWidget> {
  int _fingers = 0;
  bool _down = false;
  Timer _clearTimer;

  void _clear() {
    setState(() {
      _down = false;
    });
  }

  void _fingerDown(PointerEvent details) {
    setState(() {
      _fingers++;

      if (_clearTimer != null) {
        _clearTimer.cancel();
      }

      _down = true;
    });
  }

  void _fingerUp(PointerEvent details) {
    setState(() {
      _fingers--;
      _clearTimer = Timer(clearDelay, _clear);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _fingerDown,
      onPointerUp: _fingerUp,
      child: CustomPaint(
        painter: FillPainter(_down)
      ),
    );
  }
}
