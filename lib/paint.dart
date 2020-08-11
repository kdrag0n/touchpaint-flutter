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
  Path _curPath;

  void _fingerDown(PointerEvent details) {
    setState(() {
      _fingers++;
      _curPath = Path();
      _curPath.moveTo(details.localPosition.dx, details.localPosition.dy);
      _paths.add(_curPath);
    });

    _fingerMove(details);
  }

  void _fingerMove(PointerEvent details) {
    setState(() {
      _curPath.lineTo(details.localPosition.dx, details.localPosition.dy);
    });
  }

  void _fingerUp(PointerEvent details) {
    setState(() {
      _fingers--;
      _paths.add(_curPath);
      _curPath = null;
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
