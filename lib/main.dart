import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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

class _MyHomePageState extends State<MyHomePage> {
  NumberFormat formatter = NumberFormat("00000");

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
      x = details.position.dx;
      y = details.position.dy;
    });
    print(x);
    print(y);
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
        title: Text(widget.title),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Image.network(
            'assets/red/image_${formatter.format(imageAxialNumber)}.png',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
          ),
          Visibility(
            visible: _isvisible,
            child: Image.network(
              'assets/redlabels/image_${formatter.format(imageAxialNumber)}.png',
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
            ),
          ),
          MouseRegion(
              onHover: _updateLocation,
              child: GestureDetector(
                  onTap: () => updateAxialImage(1.0),
                  onVerticalDragStart: (details) => {},
                  onVerticalDragUpdate: (details) => {
                        if (details.delta.distance > 0)
                          {updateAxialImage(details.delta.dy)}
                      },
                  //updateImage(details.delta.dy),
                  child: Container(color: Colors.blue.withOpacity(0)))),
          // Front image
          Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.bottomLeft,
                child: FloatingActionButton(
                    onPressed: () {}, child: const Icon(Icons.navigate_before)),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                    onPressed: () {}, child: const Icon(Icons.navigate_next)),
              ),
            ],
          )
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
    );
  }
}
