import 'dart:async';
import 'dart:collection';
import 'dart:ui';

import 'package:flutter/material.dart';

class PaintPainter extends CustomPainter {
  PaintPainter(this.paths, this.strokeWidth, this.points);

  final List<Path> paths;
  final List<Offset> points;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final brushPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    final pointPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 1.5
      ..strokeCap = StrokeCap.square
      ..isAntiAlias = true;

    for (Path path in paths) {
      canvas.drawPath(path, brushPaint);
    }

    if (points != null) {
      canvas.drawPoints(PointMode.points, points, pointPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class PaintWidget extends StatefulWidget {
  PaintWidget({Key key, this.brushSize, this.clearDelay, this.showEventRate, this.showEventPoints}) : super(key: key);

  final double brushSize;
  final int clearDelay;
  final bool showEventRate;
  final bool showEventPoints;

  @override
  _PaintWidgetState createState() => _PaintWidgetState();
}

class _PaintWidgetState extends State<PaintWidget> {
  List<Path> _paths = [];
  List<Offset> _points = [];
  int _fingers = 0;
  Map<int, Path> _curPaths = HashMap();
  Timer _clearTimer;
  Timer _eventRateTimer;
  int _eventCount = 0;

  void _clearCanvas() {
    _paths.clear();
    _points.clear();
  }

  void _scheduleClear() {
    _clearTimer = Timer(Duration(milliseconds: widget.clearDelay), () {
      setState(() {
        _clearCanvas();
      });
    });
  }

  void _eventRateCallback(Timer timer) {
    final snackBar = SnackBar(content: Text('Touch event rate: $_eventCount Hz'));
    _eventCount = 0;

    final scaffold = Scaffold.of(context);
    scaffold.hideCurrentSnackBar();
    scaffold.showSnackBar(snackBar);
  }

  void _scheduleEventRate() {
    _eventCount = 0;
    _eventRateTimer = Timer.periodic(Duration(seconds: 1), _eventRateCallback);
  }

  void _fingerDown(PointerEvent details) {
    Path path = Path();
    path.moveTo(details.localPosition.dx, details.localPosition.dy);

    setState(() {
      _fingers++;

      if (_fingers == 1) {
        if (widget.clearDelay > 0) {
          _clearTimer?.cancel();
        } else if (widget.clearDelay == 0) {
          _clearCanvas();
        }

        if (widget.showEventRate) {
          _scheduleEventRate();
        }
      }

      _curPaths[details.pointer] = path;
      _paths.add(path);
    });

    _fingerMove(details);
  }

  void _fingerMove(PointerEvent details) {
    setState(() {
      _curPaths[details.pointer].lineTo(details.localPosition.dx, details.localPosition.dy);

      if (widget.showEventRate) {
        _eventCount++;
      }

      if (widget.showEventPoints) {
        _points.add(details.localPosition);
      }
    });
  }

  void _fingerUp(PointerEvent details) {
    setState(() {
      _fingers--;
      _curPaths.remove(details.pointer);

      if (_fingers == 0) {
        if (widget.clearDelay > 0) {
          _scheduleClear();
        }

        _eventRateTimer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _fingerDown,
      onPointerMove: _fingerMove,
      onPointerUp: _fingerUp,
      onPointerCancel: _fingerUp,
      child: CustomPaint(
        painter: PaintPainter(_paths, widget.brushSize, widget.showEventPoints ? _points : null),
      ),
    );
  }
}
