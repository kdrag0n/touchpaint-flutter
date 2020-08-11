import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          color: Color(0xff2b2b2b),
        ),
        snackBarTheme: SnackBarThemeData(
          contentTextStyle: TextStyle(
            color: ColorScheme.dark().onSurface,
          ),
          backgroundColor: ColorScheme.dark().surface,
        )
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
  SharedPreferences _prefs;

  loadPrefs() async {
    _prefs = await SharedPreferences.getInstance();

    setState(() {
      _mode = Mode.values[_prefs.getInt('mode') ?? 0];
      _showEventRate = _prefs.getBool('show_event_rate') ?? false;
      _paintBrushSize = _prefs.getDouble('paint_brush_size') ?? 2;
      _paintClearDelay = _prefs.getInt('paint_clear_delay') ?? 0;
    });
  }

  @override
  void initState() {
    super.initState();
    loadPrefs();
  }

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

    if (newMode != null) {
      setState(() {
        _mode = newMode;
        _prefs?.setInt('mode', newMode.index);
      });
    }
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

    if (newSize != null) {
      setState(() {
        _paintBrushSize = newSize;
        _prefs?.setDouble('paint_brush_size', newSize);
      });
    }
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

    if (newDelay != null) {
      setState(() {
        _paintClearDelay = newDelay;
        _prefs?.setInt('paint_clear_delay', newDelay);
      });
    }
  }

  void selectMenuItem(String item) {
    switch (item) {
      case 'Show event rate':
        setState(() {
          _showEventRate = true;
          _prefs?.setBool('show_event_rate', true);
        });
        break;
      case 'Hide event rate':
        setState(() {
          _showEventRate = false;
          _prefs?.setBool('hide_event_rate', false);
        });
        break;
      case 'About':
        showAboutDialog(
          context: context,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyWidget;

    switch (_mode) {
      case Mode.PAINT:
        bodyWidget = PaintWidget(
          brushSize: _paintBrushSize,
          clearDelay: _paintClearDelay,
          showEventRate: _showEventRate,
        );
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

    final eventRateText = _showEventRate ? 'Hide event rate' : 'Show event rate';

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
              PopupMenuItem<String>(
                value: eventRateText,
                child: Text(eventRateText),
              ),
              PopupMenuItem<String>(
                value: 'About',
                child: const Text('About'),
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
