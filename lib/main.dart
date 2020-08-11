import 'package:flutter/material.dart';
import 'package:touchpaint/paint.dart';

void main() => runApp(PaintApp());

class PaintApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Touchpaint',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Touchpaint'),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        color: Colors.black,
        child: PaintWidget(),
      ),
    );
  }
}
