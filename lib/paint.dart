import 'dart:collection';

import 'package:flutter/material.dart';

class PaintPage extends StatefulWidget {
  PaintPage({Key key}) : super(key: key);

  @override
  _PaintPageState createState() => _PaintPageState();
}

class PaintPainter extends CustomPainter {
  PaintPainter(this.paths);
  
  final List<Path> paths;
  
  @override
  void paint(Canvas canvas, Size size) {
    final brushPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    for (Path path in paths) {
      canvas.drawPath(path, brushPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class _PaintPageState extends State<PaintPage> {
  List<Path> _paths = [];
  int _fingers = 0;
  Map<int, Path> _curPaths = HashMap();

  void _clearCanvas() {
    _paths.clear();
  }

  void _fingerDown(PointerEvent details) {
    Path path = Path();
    path.moveTo(details.localPosition.dx, details.localPosition.dy);

    setState(() {
      _fingers++;

      if (_fingers == 1) {
        _clearCanvas();
      }

      _curPaths[details.pointer] = path;
      _paths.add(path);
    });

    _fingerMove(details);
  }

  void _fingerMove(PointerEvent details) {
    setState(() {
      _curPaths[details.pointer].lineTo(details.localPosition.dx, details.localPosition.dy);
    });
  }

  void _fingerUp(PointerEvent details) {
    setState(() {
      _fingers--;
      _curPaths.remove(details.pointer);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Touchpaint'),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        color: Colors.black,
        child: Listener(
          onPointerDown: _fingerDown,
          onPointerMove: _fingerMove,
          onPointerUp: _fingerUp,
          child: CustomPaint(
            painter: PaintPainter(_paths)
          ),
        ),
      ),
    );
  }
}
