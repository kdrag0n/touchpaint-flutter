import 'package:flutter/material.dart';
import 'package:touchpaint/blank.dart';
import 'package:touchpaint/fill.dart';
import 'package:touchpaint/follow.dart';
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

enum Mode {
  PAINT,
  FILL,
  FOLLOW,
  BLANK
}

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Mode _mode = Mode.PAINT;
  bool _showEventRate = false;
  double _paintBrushSize = 2;
  int _paintClearDelay = 0;

  Future<void> _changeMode() async {
    Mode newMode = await showDialog(
        context: context,
        builder: (context) => SimpleDialog(
            title: const Text('Select mode'),
            children: <Widget>[
              SimpleDialogOption(
                child: const Text('Paint'),
                onPressed: () { Navigator.pop(context, Mode.PAINT); },
              ),
              SimpleDialogOption(
                child: const Text('Fill'),
                onPressed: () { Navigator.pop(context, Mode.FILL); },
              ),
              SimpleDialogOption(
                child: const Text('Follow'),
                onPressed: () { Navigator.pop(context, Mode.FOLLOW); },
              ),
              SimpleDialogOption(
                child: const Text('Blank redraw'),
                onPressed: () { Navigator.pop(context, Mode.BLANK); },
              ),
            ],
        ),
    );

    setState(() {
      _mode = newMode;
    });
  }

  Future<void> _changeBrushSize() async {
    double newSize = await showDialog(
        context: context,
        builder: (context) => SimpleDialog(
            title: const Text('Select brush size'),
            children: <Widget>[
              SimpleDialogOption(
                child: const Text('1 physical pixel'),
                onPressed: () { Navigator.pop(context, 1 / MediaQuery.of(context).devicePixelRatio); },
              ),
              SimpleDialogOption(
                child: const Text('1 px'),
                onPressed: () { Navigator.pop(context, 1.0); },
              ),
              SimpleDialogOption(
                child: const Text('2 px'),
                onPressed: () { Navigator.pop(context, 2.0); },
              ),
              SimpleDialogOption(
                child: const Text('3 px'),
                onPressed: () { Navigator.pop(context, 3.0); },
              ),
              SimpleDialogOption(
                child: const Text('5 px'),
                onPressed: () { Navigator.pop(context, 5.0); },
              ),
              SimpleDialogOption(
                child: const Text('10 px'),
                onPressed: () { Navigator.pop(context, 10.0); },
              ),
              SimpleDialogOption(
                child: const Text('15 px'),
                onPressed: () { Navigator.pop(context, 15.0); },
              ),
              SimpleDialogOption(
                child: const Text('50 px'),
                onPressed: () { Navigator.pop(context, 50.0); },
              ),
              SimpleDialogOption(
                child: const Text('150 px'),
                onPressed: () { Navigator.pop(context, 150.0); },
              ),
            ],
        ),
    );

    setState(() {
      _paintBrushSize = newSize;
    });
  }

  Future<void> _changeClearDelay() async {
    int newDelay = await showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select paint clear delay'),
        children: <Widget>[
          SimpleDialogOption(
            child: const Text('On next stroke'),
            onPressed: () { Navigator.pop(context, 0); },
          ),
          SimpleDialogOption(
            child: const Text('100 ms'),
            onPressed: () { Navigator.pop(context, 100); },
          ),
          SimpleDialogOption(
            child: const Text('250 ms'),
            onPressed: () { Navigator.pop(context, 250); },
          ),
          SimpleDialogOption(
            child: const Text('500 ms'),
            onPressed: () { Navigator.pop(context, 500); },
          ),
          SimpleDialogOption(
            child: const Text('1 second'),
            onPressed: () { Navigator.pop(context, 1000); },
          ),
          SimpleDialogOption(
            child: const Text('2 seconds'),
            onPressed: () { Navigator.pop(context, 2000); },
          ),
          SimpleDialogOption(
            child: const Text('5 seconds'),
            onPressed: () { Navigator.pop(context, 5000); },
          ),
          SimpleDialogOption(
            child: const Text('Never'),
            onPressed: () { Navigator.pop(context, -1); },
          ),
        ],
      ),
    );

    setState(() {
      _paintClearDelay = newDelay;
    });
  }

  void selectMenuItem(String item) {
    switch (item) {
      case 'Show event rate':
        setState(() {
          _showEventRate = !_showEventRate;
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyWidget;

    switch (_mode) {
      case Mode.PAINT:
        bodyWidget = PaintWidget(brushSize: _paintBrushSize);
        break;
      case Mode.FILL:
        bodyWidget = FillWidget();
        break;
      case Mode.FOLLOW:
        bodyWidget = FollowWidget();
        break;
      case Mode.BLANK:
        bodyWidget = BlankWidget();
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Touchpaint'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            tooltip: 'Mode',
            onPressed: _changeMode,
          ),
          IconButton(
            icon: Icon(Icons.brush),
            tooltip: 'Brush size',
            onPressed: _changeBrushSize,
          ),
          IconButton(
            icon: Icon(Icons.access_time),
            tooltip: 'Clear delay',
            onPressed: _changeClearDelay,
          ),
          PopupMenuButton<String>(
            onSelected: selectMenuItem,
            itemBuilder: (context) => <PopupMenuEntry<String>>[
              CheckedPopupMenuItem<String>(
                checked: _showEventRate,
                value: 'Show event rate',
                child: const Text('Show event rate'),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        color: Colors.black,
        child: bodyWidget,
      ),
    );
  }
}
