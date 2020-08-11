import 'package:flutter/material.dart';

class BlankPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final blankPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    canvas.drawPaint(blankPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class BlankWidget extends StatefulWidget {
  BlankWidget({Key key}) : super(key: key);

  @override
  _BlankWidgetState createState() => _BlankWidgetState();
}

class _BlankWidgetState extends State<BlankWidget> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {

      });
    });

    return CustomPaint(
      painter: BlankPainter(),
    );
  }
}
