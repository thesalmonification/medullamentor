import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_cube/flutter_cube.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

List<Map> red_json_data = [];
List<Map> green_json_data = [];
List<Map> yellow_json_data = [];

// Fetch content from the json file
Future<void> readJson() async {
  NumberFormat formatter = NumberFormat("00000");

  for (var i = 0; i < 31; i++) {
    String red_response = await rootBundle
        .loadString('redjson/image_${formatter.format(i)}.json');
    String green_response = await rootBundle
        .loadString('greenjson/image_${formatter.format(i)}.json');
    String yellow_response = await rootBundle
        .loadString('yellowjson/image_${formatter.format(i)}.json');
    final red_data = await json.decode(red_response);
    final green_data = await json.decode(green_response);
    final yellow_data = await json.decode(yellow_response);
    green_json_data.add(green_data);
    red_json_data.add(red_data);
    yellow_json_data.add(yellow_data);
  }

  //print(red_json_data[0]["648"]["23"]);
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  readJson();
  runApp(const MyApp());
}

const MaterialColor primaryBlack = MaterialColor(
  _blackPrimaryValue,
  <int, Color>{
    50: Color(0xFF000000),
    100: Color(0xFF000000),
    200: Color(0xFF000000),
    300: Color(0xFF000000),
    400: Color(0xFF000000),
    500: Color(_blackPrimaryValue),
    600: Color(0xFF000000),
    700: Color(0xFF000000),
    800: Color(0xFF000000),
    900: Color(0xFF000000),
  },
);
const int _blackPrimaryValue = 0xFF000000;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RadiQuiz',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: primaryBlack,
      ),
      home: const MyHomePage(
          title: 'RadiQuiz - Visualize Radiology Datasets on the Web'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int _counter = 0;

  late Scene _scene;
  late AnimationController _controller;
  Object? _skull;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    void _onSceneCreated(Scene scene) {
      _scene = scene;
      _scene.camera.zoom = 50;
      _scene.camera.position.z = 20;

      _scene.camera.position.y = -50;

      _skull = Object(fileName: 'Segmentations/skull.obj');
      //_skull = Object(fileName: 'CTChestSegmentation/skull.obj');
      _scene.world.add(_skull!);
    }

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Container(
                color: Colors.black,
                child: Center(
                  child: FractionallySizedBox(
                    widthFactor: 1.0,
                    alignment: Alignment.topCenter,
                    child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: [
                          TextSpan(
                              text: 'RadiQuiz\n',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 90,
                                  fontStyle: FontStyle.italic)),
                          TextSpan(
                              text: 'Explore Radiological Dasets\n',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 50)),
                          TextSpan(
                              text: 'Get Started\n',
                              style: TextStyle(
                                  //background: paint,
                                  backgroundColor: Colors.yellow,
                                  fontSize: 34,
                                  color: Colors.black),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AxialBrainstem()),
                                  );
                                }),
                        ])),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.black,
                child: Cube(
                  onSceneCreated: _onSceneCreated,
                ),
              ),
            ),
          ]),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Center(
                  child: Text(
                'RadiQuiz',
                style: TextStyle(color: Colors.white, fontSize: 20),
              )),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            Divider(),
            ListTile(
              title: const Text('Axial Brainstem'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AxialBrainstem()),
                );
              },
            ),
            Divider(),
            ListTile(
              title: const Text('Coronal Brainstem'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CoronalBrainstem()),
                );
              },
            ),
            Divider(),
            ListTile(
              title: const Text('Saggital Brainstem'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SaggitalBrainstem()),
                );
              },
            ),
            Divider(),
          ],
        ),
      ),
// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class AxialBrainstem extends StatefulWidget {
  AxialBrainstem({super.key});
  //So will try async function here...

  @override
  State<AxialBrainstem> createState() => _AxialBrainstemState();
}

class _AxialBrainstemState extends State<AxialBrainstem> {
  NumberFormat formatter = NumberFormat("00000");

  String structure = "";

  bool _isvisible = true;
  double x = 0.0;
  double y = 0.0;
  int imageAxialNumber = 15;

  void updateAxialImage(double dy) {
    setState(() {
      //Random.nextInt(n) returns random integer from 0 to n-1
      if (dy > 0) {
        imageAxialNumber = (imageAxialNumber + 1) % 30;
      }
      if (dy < 0) {
        imageAxialNumber = (imageAxialNumber - 1) % 30;
      }
    });
  }

  void _updateLocation(PointerEvent details) {
    setState(() {
      x = details.localPosition.dx; // MediaQuery.of(context).size.height * 652;
      y = details.localPosition.dy; // MediaQuery.of(context).size.width * 456;

      //print([x, y]);

      if (red_json_data[imageAxialNumber][x.toInt().toString()]
              [y.toInt().toString()] ==
          "Material93") {
        structure = "";
      } else {
        structure = red_json_data[imageAxialNumber][x.toInt().toString()]
            [y.toInt().toString()];
      }
      ;
    });
    //print([x, y]);
    //print(red_json_data[imageAxialNumber][x.toInt().toString()]
    //    [y.toInt().toString()]);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text('Axial Brainstem'),
        ),
        body: SizedBox.expand(
            child: Container(
          color: Colors.black,
          child: Stack(
            alignment: Alignment.center,
            children: [
              MouseRegion(
                  onHover: _updateLocation,
                  child: Image.network(
                    'assets/red/image_${formatter.format(imageAxialNumber)}.png',
                    fit: BoxFit.fitWidth, //cover
                    //height: double.infinity,
                    //width: double.infinity,
                    alignment: Alignment.center,
                  )),
              MouseRegion(
                  onHover: _updateLocation,
                  child: Visibility(
                    visible: _isvisible,
                    child: Image.network(
                      'assets/redlabels/image_${formatter.format(imageAxialNumber)}.png',
                      fit: BoxFit.fitWidth,
                      //height: double.infinity,
                      //width: double.infinity,
                      alignment: Alignment.center,
                    ),
                  )),
              /*MouseRegion(
              onHover: _updateLocation,
              child: GestureDetector(
                  onTap: () => _updateLocation,

                  //updateImage(details.delta.dy),
                  child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.blue.withOpacity(0)))),*/
              // Front image
              Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FloatingActionButton(
                        heroTag: "btn1",
                        onPressed: () {
                          updateAxialImage(-1);
                        },
                        child: const Icon(Icons.navigate_before)),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FloatingActionButton(
                        heroTag: 'btn2',
                        onPressed: () {
                          updateAxialImage(1);
                        },
                        child: const Icon(Icons.navigate_next)),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                        heroTag: 'btn3',
                        onPressed: () {
                          setState(() {
                            _isvisible = !_isvisible;
                          });
                        },
                        child: (_isvisible)
                            ? Icon(Icons.hide_image)
                            : Icon(Icons.image)),
                  ),
                ],
              ),
              Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                      padding: EdgeInsets.all(50),
                      child: Text(
                        structure,
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      )))
            ],
          ),

          /*
      floatingActionButton: FloatingActionButton(
        onPressed: (() {
          setState(() {
            _isvisible = !_isvisible;
          });
        }),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),*/ // This trailing comma makes auto-formatting nicer for build methods.
        )));
  }
}

class CoronalBrainstem extends StatefulWidget {
  CoronalBrainstem({super.key});
  //So will try async function here...

  @override
  State<CoronalBrainstem> createState() => _CoronalBrainstemState();
}

class _CoronalBrainstemState extends State<CoronalBrainstem> {
  NumberFormat formatter = NumberFormat("00000");

  String structure = "";

  bool _isvisible = true;
  double x = 0.0;
  double y = 0.0;
  int imageAxialNumber = 15;

  void updateAxialImage(double dy) {
    setState(() {
      //Random.nextInt(n) returns random integer from 0 to n-1
      if (dy > 0) {
        imageAxialNumber = (imageAxialNumber + 1) % 30;
      }
      if (dy < 0) {
        imageAxialNumber = (imageAxialNumber - 1) % 30;
      }
    });
  }

  void _updateLocation(PointerEvent details) {
    setState(() {
      x = details.localPosition.dx; // MediaQuery.of(context).size.height * 652;
      y = details.localPosition.dy; // MediaQuery.of(context).size.width * 456;

      //print([x, y]);

      if (green_json_data[imageAxialNumber][x.toInt().toString()]
              [y.toInt().toString()] ==
          "Material93") {
        structure = "";
      } else {
        structure = green_json_data[imageAxialNumber][x.toInt().toString()]
            [y.toInt().toString()];
      }
      ;
    });
    //print([x, y]);
    //print(red_json_data[imageAxialNumber][x.toInt().toString()]
    //    [y.toInt().toString()]);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text('Coronal Brainstem'),
        ),
        body: SizedBox.expand(
            child: Container(
          color: Colors.black,
          child: Stack(
            alignment: Alignment.center,
            children: [
              MouseRegion(
                  onHover: _updateLocation,
                  child: Image.network(
                    'assets/green/image_${formatter.format(imageAxialNumber)}.png',
                    fit: BoxFit.fitWidth, //cover
                    //height: double.infinity,
                    //width: double.infinity,
                    alignment: Alignment.center,
                  )),
              MouseRegion(
                  onHover: _updateLocation,
                  child: Visibility(
                    visible: _isvisible,
                    child: Image.network(
                      'assets/greenlabels/image_${formatter.format(imageAxialNumber)}.png',
                      fit: BoxFit.fitWidth,
                      //height: double.infinity,
                      //width: double.infinity,
                      alignment: Alignment.center,
                    ),
                  )),
              /*MouseRegion(
              onHover: _updateLocation,
              child: GestureDetector(
                  onTap: () => _updateLocation,

                  //updateImage(details.delta.dy),
                  child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.blue.withOpacity(0)))),*/
              // Front image
              Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FloatingActionButton(
                        heroTag: "btn1",
                        onPressed: () {
                          updateAxialImage(-1);
                        },
                        child: const Icon(Icons.navigate_before)),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FloatingActionButton(
                        heroTag: 'btn2',
                        onPressed: () {
                          updateAxialImage(1);
                        },
                        child: const Icon(Icons.navigate_next)),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                        heroTag: 'btn3',
                        onPressed: () {
                          setState(() {
                            _isvisible = !_isvisible;
                          });
                        },
                        child: (_isvisible)
                            ? Icon(Icons.hide_image)
                            : Icon(Icons.image)),
                  ),
                ],
              ),
              Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                      padding: EdgeInsets.all(50),
                      child: Text(
                        structure,
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      )))
            ],
          ),

          /*
      floatingActionButton: FloatingActionButton(
        onPressed: (() {
          setState(() {
            _isvisible = !_isvisible;
          });
        }),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),*/ // This trailing comma makes auto-formatting nicer for build methods.
        )));
  }
}

class SaggitalBrainstem extends StatefulWidget {
  SaggitalBrainstem({super.key});
  //So will try async function here...

  @override
  State<SaggitalBrainstem> createState() => _SaggitalBrainstemState();
}

class _SaggitalBrainstemState extends State<SaggitalBrainstem> {
  NumberFormat formatter = NumberFormat("00000");

  String structure = "";

  bool _isvisible = true;
  double x = 0.0;
  double y = 0.0;
  int imageAxialNumber = 15;

  void updateAxialImage(double dy) {
    setState(() {
      //Random.nextInt(n) returns random integer from 0 to n-1
      if (dy > 0) {
        imageAxialNumber = (imageAxialNumber + 1) % 30;
      }
      if (dy < 0) {
        imageAxialNumber = (imageAxialNumber - 1) % 30;
      }
    });
  }

  void _updateLocation(PointerEvent details) {
    setState(() {
      x = details.localPosition.dx; // MediaQuery.of(context).size.height * 652;
      y = details.localPosition.dy; // MediaQuery.of(context).size.width * 456;

      //print([x, y]);

      if (yellow_json_data[imageAxialNumber][x.toInt().toString()]
              [y.toInt().toString()] ==
          "Material93") {
        structure = "";
      } else {
        structure = yellow_json_data[imageAxialNumber][x.toInt().toString()]
            [y.toInt().toString()];
      }
      ;
    });
    //print([x, y]);
    //print(red_json_data[imageAxialNumber][x.toInt().toString()]
    //    [y.toInt().toString()]);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text('Saggital Brainstem'),
        ),
        body: SizedBox.expand(
            child: Container(
          color: Colors.black,
          child: Stack(
            alignment: Alignment.center,
            children: [
              MouseRegion(
                  onHover: _updateLocation,
                  child: Image.network(
                    'assets/yellow/image_${formatter.format(imageAxialNumber)}.png',
                    fit: BoxFit.fitWidth, //cover
                    //height: double.infinity,
                    //width: double.infinity,
                    alignment: Alignment.center,
                  )),
              MouseRegion(
                  onHover: _updateLocation,
                  child: Visibility(
                    visible: _isvisible,
                    child: Image.network(
                      'assets/yellowlabels/image_${formatter.format(imageAxialNumber)}.png',
                      fit: BoxFit.fitWidth,
                      //height: double.infinity,
                      //width: double.infinity,
                      alignment: Alignment.center,
                    ),
                  )),
              /*MouseRegion(
              onHover: _updateLocation,
              child: GestureDetector(
                  onTap: () => _updateLocation,

                  //updateImage(details.delta.dy),
                  child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.blue.withOpacity(0)))),*/
              // Front image
              Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FloatingActionButton(
                        heroTag: "btn1",
                        onPressed: () {
                          updateAxialImage(-1);
                        },
                        child: const Icon(Icons.navigate_before)),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FloatingActionButton(
                        heroTag: 'btn2',
                        onPressed: () {
                          updateAxialImage(1);
                        },
                        child: const Icon(Icons.navigate_next)),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                        heroTag: 'btn3',
                        onPressed: () {
                          setState(() {
                            _isvisible = !_isvisible;
                          });
                        },
                        child: (_isvisible)
                            ? Icon(Icons.hide_image)
                            : Icon(Icons.image)),
                  ),
                ],
              ),
              Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                      padding: EdgeInsets.all(50),
                      child: Text(
                        structure,
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      )))
            ],
          ),

          /*
      floatingActionButton: FloatingActionButton(
        onPressed: (() {
          setState(() {
            _isvisible = !_isvisible;
          });
        }),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),*/ // This trailing comma makes auto-formatting nicer for build methods.
        )));
  }
}
