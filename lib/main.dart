import 'package:brainstem/quiz.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'quiz.dart';

List<Map> red_json_data = [];
List<Map> green_json_data = [];
List<Map> yellow_json_data = [];

List<Map> red_split_json_data = [];
List<Map> green_split_json_data = [];
List<Map> yellow_split_json_data = [];

List<String> files = [];
List<dynamic> structures = [];


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

Future<void> readJsonSplits() async {
  NumberFormat formatter = NumberFormat("00000");

  for (var i = 0; i < 31; i++) {
    String red_split_response = await rootBundle.loadString(
        'redlabelsplitjson/image_${formatter.format(i)}_splits.json');
    String green_split_response = await rootBundle.loadString(
        'greenlabelsplitjson/image_${formatter.format(i)}_splits.json');
    String yellow_split_response = await rootBundle.loadString(
        'yellowlabelsplitjson/image_${formatter.format(i)}_splits.json');
    final red_split_data = await json.decode(red_split_response);
    final green_split_data = await json.decode(green_split_response);
    final yellow_split_data = await json.decode(yellow_split_response);
    green_split_json_data.add(green_split_data);
    red_split_json_data.add(red_split_data);
    yellow_split_json_data.add(yellow_split_data);


  }


  //print(red_json_data[0]["648"]["23"]);
}

void readCorrectedJson() async {
  Map<String, dynamic> jsonData = await loadJsonData();
  
  // Extract keys and mappings
  jsonData.forEach((key, value) {
    files.add(key);
    structures.add(value);
  });

  // print("Keys: $files");
  // print("Mappings: $structures");
}

Future<Map<String, dynamic>> loadJsonData() async {
  String jsonData = await rootBundle.loadString('redLabelSplitMerged.json');
  return json.decode(jsonData);
}

_launchURL() async {
  final Uri url = Uri.parse('https://pubmed.ncbi.nlm.nih.gov/33951517/');
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  readJson();
  readJsonSplits();
  readCorrectedJson();

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
      title: 'Medulla Mentor',
      theme: new ThemeData(
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
        //scaffoldBackgroundColor: const Color(0xFFEFEFEF)
      ),
      home: const MyHomePage(
          title: 'Medulla Mentor - Explore the Human Brainstem'),
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Creative Commons CC By-NC-SA 3.0 Notice'),
            content: const Text(
                'Brainstem Data courtesy of the Duke Center for in Vivo Microscopy\n'
                'First published by Adil et. al 2021\n'
                '(https://doi.org/10.1016/j.neuroimage.2021.118135)\n'
                '\nThis website utilizes the data under the creative commons license.'),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Learn More'),
                onPressed: () {
                  _launchURL();
                  //Navigator.of(context).pop();
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }));
  }

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
      body: SafeArea(
          child: SizedBox.expand(
              child: Container(
                  color: Colors.black,
                  child: Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        TextButton(
                            child: Text("Axial Brainstem".toUpperCase(),
                                style: TextStyle(fontSize: 14)),
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    EdgeInsets.all(15)),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color(0xff5E81AC)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        side: BorderSide(
                                            color: Color(0xff5E81AC))))),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AxialBrainstem()),
                              );
                            }),
                        SizedBox(height: 50),
                        TextButton(
                            child: Text(
                                "Coronal Brainstem (Under Repair)".toUpperCase(),
                                style: TextStyle(fontSize: 14)),
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    EdgeInsets.all(15)),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color(0xff5E81AC)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        side: BorderSide(
                                            color: Color(0xff5E81AC))))),
                            onPressed: () {
                              //Navigator.push(
                              //  context,
                              //  MaterialPageRoute(
                              //      builder: (context) => CoronalBrainstem()),
                              //);
                            }),
                        SizedBox(height: 50),
                        TextButton(
                            child: Text(
                                "Saggital Brainstem (Under Repair)"
                                    .toUpperCase(),
                                style: TextStyle(fontSize: 14)),
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    EdgeInsets.all(15)),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color(0xff5E81AC)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        side: BorderSide(color: Color(0xff5E81AC))))),
                            onPressed: () {
                              //Navigator.push(
                              //  context,
                              //  MaterialPageRoute(
                              //      builder: (context) => SaggitalBrainstem()),
                              //);
                            }),
                        SizedBox(height: 50),
                        TextButton(
                            child: Text("Quiz Mode (Coming Soon)".toUpperCase(),
                                style: TextStyle(fontSize: 14)),
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    EdgeInsets.all(15)),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color(0xff5E81AC)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        side: BorderSide(
                                            color: Color(0xff5E81AC))))),
                            onPressed: () {
                              generateQuestion();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BrainstemQuiz()),
                              );
                            }),
                        SizedBox(height: 50),
                      ]))))),
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
                'Medulla Mentor',
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
              title: const Text('Coronal Brainstem (Under Repair)'),
              onTap: () {
               // Navigator.push(
               //   context,
               //   MaterialPageRoute(builder: (context) => CoronalBrainstem()),
               // );
              },
            ),
            Divider(),
            ListTile(
              title: const Text('Saggital Brainstem (Under Repair)'),
              onTap: () {
                //Navigator.push(
                //  context,
                //  MaterialPageRoute(builder: (context) => SaggitalBrainstem()),
                //);
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
  List<String> incorrect_structures = [];

  String structure = ""; //this is the string shown at the top of the screen...
  String lookupstructure =
      ""; //this string is specifically for finding the image that highlights a single structure
  String split_image = red_split_json_data[15]['Unknown Tissue'];
  int lastindex = 0;

  bool _isvisible = true;
  double x = 0.0;
  double y = 0.0;
  int imageAxialNumber = 15;


  NumberFormat formatter = NumberFormat("00000");

  ///////////////////////////////////////////////////////

  void onTapDown(BuildContext context, TapDownDetails details) {

    setState(() {


      x = details.localPosition.dx;
      y = details.localPosition.dy;


      if (red_json_data[imageAxialNumber][x.toInt().toString()]
              [y.toInt().toString()] ==
          "Material93") {

        lookupstructure = "Unknown Tissue";
        structure =
            ""; //Don't bother showing any text if it's not an important structure.
      } else {

        //structure = red_json_data[imageAxialNumber][x.toInt().toString()]
        //    [y.toInt().toString()];

        //Here I get the structure in the raw form for a lookup
        lookupstructure = red_json_data[imageAxialNumber][x.toInt().toString()]
            [y.toInt().toString()];

        //This is the text shown on screen. I remove any "left" or "right" from the string.
        structure = red_json_data[imageAxialNumber][x.toInt().toString()]
                [y.toInt().toString()]
            .toString()
            .replaceAll(' left', '')
            .replaceAll(' right', '')
            .trim()
            .toString();

        if (incorrect_structures.contains(structure)) {
          structure = 'To Be Labeled';
        }
      }

      //Attempting to add in the split json reference here.
      split_image = red_split_json_data[imageAxialNumber][lookupstructure];
      //split_image = red_split_json_data[00006];

      ////////////WTF IS GOING ON IN LIFE FUCK MY LIFE SO MUCH

    //print([x, y]);
    //print(red_json_data[imageAxialNumber][x.toInt().toString()]
    //    [y.toInt().toString()]);
    });
  }
  ////////////////////////////////////////////////////////




  //I'm adding a list of strings to account for the inccorectly labeled structures...
  /*List<String> incorrect_structures = [
    'optic chiasm',
    'motor trigeminal nucleus',
    'inferior colliculus',
    'principal sensory trigeminal nucleus',
    'cuneate nucleus',
    'corticospinal tract',
    'pulvinar nuclei',
    'hypoglossal nucleus',
    'abducens nucleus',
    'obex',
    'mesencephalic trigeminal tract',
    'cerebral aqueduct',
    'motor trigeminal nucleus',
    'principal sensory trigeminal nucleus',
    'spinal trigeminal nucleus interpolaris',
    'middle cerebellar peduncle',
    'pulvinar nuclei',
    'hypoglossal nucleus',
    'abducens nucleus',
    'abducens nerve',
    'superior colliculus',
    'trigeminal nerve',
    'trigeminal nerve',
    'anterior commissure',
    'inferior colliculus',
    'decussation superior cerebellar peduncles',
    'inferior cerebellar peduncle',
    'inferior cerebellar peduncle',
    'red nucleus',
    'red nucleus',
    'facial nerve',
    'pyramidal decussation',
    'thalamus excluding pulvinar',
    'cuneate fasciculus',
    'cuneate fasciculus'
  ];*/



  

  void updateAxialImage(double dy) {
    print('changed axial image');
    setState(() {
      //Random.nextInt(n) returns random integer from 0 to n-1
      if (dy > 0) {
        imageAxialNumber = (imageAxialNumber + 1) % 30;
        split_image = red_split_json_data[imageAxialNumber]["Unknown Tissue"];
        structure = "";
      }
      if (dy < 0) {
        imageAxialNumber = (imageAxialNumber - 1) % 30;
        split_image = red_split_json_data[imageAxialNumber]["Unknown Tissue"];
        structure = "";
      }
    });
  }

  

  

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('How to Use'),
            content: const Text(
                '1. Click the arrow on the left/right sides to scroll through the brainstem.\n'
                '2. Click the bottom right button to toggle color labels.\n'
                '3. Hover your mouse over the brainstem to see anatomic labels.\n'),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }));
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
          child: InteractiveViewer(child: Stack(
            alignment: Alignment.center,
            children: [

                  Image.asset(
                    'red/image_${formatter.format(imageAxialNumber)}.png',
                    fit: BoxFit.fitWidth, //cover
                    //height: double.infinity,
                    //width: double.infinity,
                    alignment: Alignment.center,
                  ),

              InkWell(
                onTapDown: (details) => onTapDown(context, details),
                child: 
                    Image.asset(
                  _isvisible == true
                      ?
                      //'assets/redlabels/image_${formatter.format(imageAxialNumber)}.png',
                      'redlabelsplit/' + split_image
                      : 'redlabels/image_${formatter.format(imageAxialNumber)}.png',
                  fit: BoxFit.fitWidth,
                  //height: double.infinity,
                  //width: double.infinity,
                  alignment: Alignment.center,
                ),
              ),


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
                            ? Icon(Icons.label_off)
                            : Icon(Icons.label)),
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
          ))),


        ));
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
  //I'm adding a list of strings to account for the inccorectly labeled structures...
  /*List<String> incorrect_structures = ['optic chiasm',
'motor trigeminal nucleus',
'inferior colliculus',
'principal sensory trigeminal nucleus',
'cuneate nucleus',
'corticospinal tract',
'pulvinar nuclei',
'hypoglossal nucleus',
'abducens nucleus',
'obex',
'mesencephalic trigeminal tract',
'cerebral aqueduct',
'motor trigeminal nucleus',
'principal sensory trigeminal nucleus',
'spinal trigeminal nucleus interpolaris',
'middle cerebellar peduncle',
'pulvinar nuclei',
'hypoglossal nucleus',
'abducens nucleus',
'abducens nerve',
'superior colliculus',
'trigeminal nerve',
'trigeminal nerve',
'anterior commissure',
'inferior colliculus',
'decussation superior cerebellar peduncles',
'inferior cerebellar peduncle',
'inferior cerebellar peduncle',
'red nucleus',
'red nucleus',
'facial nerve',
'pyramidal decussation',
'thalamus excluding pulvinar',
'cuneate fasciculus',
'cuneate fasciculus'];*/

  List<String> incorrect_structures = [];

  String structure = "";
  String lookupstructure = "";
  String split_image = green_split_json_data[15]['Unknown Tissue'];

  bool _isvisible = true;
  double x = 0.0;
  double y = 0.0;
  int imageAxialNumber = 15;

  ///////////////////////////////////////////////////////

  void onTapDown(BuildContext context, TapDownDetails details) {

    setState(() {


      x = details.localPosition.dx;
      y = details.localPosition.dy;


      if (green_json_data[imageAxialNumber][x.toInt().toString()]
              [y.toInt().toString()] ==
          "Material93") {

        lookupstructure = "Unknown Tissue";
        structure =
            ""; //Don't bother showing any text if it's not an important structure.
      } else {

        //structure = red_json_data[imageAxialNumber][x.toInt().toString()]
        //    [y.toInt().toString()];

        //Here I get the structure in the raw form for a lookup
        lookupstructure = green_json_data[imageAxialNumber][x.toInt().toString()]
            [y.toInt().toString()];

        //This is the text shown on screen. I remove any "left" or "right" from the string.
        structure = green_json_data[imageAxialNumber][x.toInt().toString()]
                [y.toInt().toString()]
            .toString()
            .replaceAll(' left', '')
            .replaceAll(' right', '')
            .trim()
            .toString();

        if (incorrect_structures.contains(structure)) {
          structure = 'To Be Labeled';
        }
      }

      //Attempting to add in the split json reference here.
      split_image = green_split_json_data[imageAxialNumber][lookupstructure];
      //split_image = red_split_json_data[00006];

      ////////////WTF IS GOING ON IN LIFE FUCK MY LIFE SO MUCH

    //print([x, y]);
    //print(red_json_data[imageAxialNumber][x.toInt().toString()]
    //    [y.toInt().toString()]);
    });
  }
  ////////////////////////////////////////////////////////

  void updateAxialImage(double dy) {
    setState(() {
      //Random.nextInt(n) returns random integer from 0 to n-1
      if (dy > 0) {
        imageAxialNumber = (imageAxialNumber + 1) % 30;
        split_image = green_split_json_data[imageAxialNumber]["Unknown Tissue"];
        structure = "";
      }
      if (dy < 0) {
        imageAxialNumber = (imageAxialNumber - 1) % 30;
        split_image = green_split_json_data[imageAxialNumber]["Unknown Tissue"];
        structure = "";
      }
    });
  }

  

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('How to Use'),
            content: const Text(
                '1. Click the arrow on the left/right sides to scroll through the brainstem.\n'
                '2. Click the bottom right button to toggle color labels.\n'
                '3. Hover your mouse over the brainstem to see anatomic labels.\n'),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }));
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
          child: InteractiveViewer(child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                    'green/image_${formatter.format(imageAxialNumber)}.png',
                    fit: BoxFit.fitWidth, //cover
                    //height: double.infinity,
                    //width: double.infinity,
                    alignment: Alignment.center,
                  ),
              InkWell(
                onTapDown: (details) => onTapDown(context, details),
                child: 
                    Image.asset(
                  _isvisible == true
                      ?
                      //'assets/redlabels/image_${formatter.format(imageAxialNumber)}.png',
                      'greenlabelsplit/' + split_image
                      : 'greenlabels/image_${formatter.format(imageAxialNumber)}.png',
                  fit: BoxFit.fitWidth,
                  //height: double.infinity,
                  //width: double.infinity,
                  alignment: Alignment.center,
                ),
              ),

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
                            ? Icon(Icons.label_off)
                            : Icon(Icons.label)),
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
          )),

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
  //I'm adding a list of strings to account for the inccorectly labeled structures...
  List<String> incorrect_structures = [];
  /*List<String> incorrect_structures = [
    'optic chiasm',
    'motor trigeminal nucleus',
    'inferior colliculus',
    'principal sensory trigeminal nucleus',
    'cuneate nucleus',
    'corticospinal tract',
    'pulvinar nuclei',
    'hypoglossal nucleus',
    'abducens nucleus',
    'obex',
    'mesencephalic trigeminal tract',
    'cerebral aqueduct',
    'motor trigeminal nucleus',
    'principal sensory trigeminal nucleus',
    'spinal trigeminal nucleus interpolaris',
    'middle cerebellar peduncle',
    'pulvinar nuclei',
    'hypoglossal nucleus',
    'abducens nucleus',
    'abducens nerve',
    'superior colliculus',
    'trigeminal nerve',
    'trigeminal nerve',
    'anterior commissure',
    'inferior colliculus',
    'decussation superior cerebellar peduncles',
    'inferior cerebellar peduncle',
    'inferior cerebellar peduncle',
    'red nucleus',
    'red nucleus',
    'facial nerve',
    'pyramidal decussation',
    'thalamus excluding pulvinar',
    'cuneate fasciculus',
    'cuneate fasciculus'
  ];*/


  ///////////////////////////////////////////////////////

  void onTapDown(BuildContext context, TapDownDetails details) {

    setState(() {


      x = details.localPosition.dx;
      y = details.localPosition.dy;


      if (yellow_json_data[imageAxialNumber][x.toInt().toString()]
              [y.toInt().toString()] ==
          "Material93") {

        lookupstructure = "Unknown Tissue";
        structure =
            ""; //Don't bother showing any text if it's not an important structure.
      } else {

        //structure = red_json_data[imageAxialNumber][x.toInt().toString()]
        //    [y.toInt().toString()];

        //Here I get the structure in the raw form for a lookup
        lookupstructure = yellow_json_data[imageAxialNumber][x.toInt().toString()]
            [y.toInt().toString()];

        //This is the text shown on screen. I remove any "left" or "right" from the string.
        structure = yellow_json_data[imageAxialNumber][x.toInt().toString()]
                [y.toInt().toString()]
            .toString()
            .replaceAll(' left', '')
            .replaceAll(' right', '')
            .trim()
            .toString();

        if (incorrect_structures.contains(structure)) {
          structure = 'To Be Labeled';
        }
      }

      //Attempting to add in the split json reference here.
      split_image = yellow_split_json_data[imageAxialNumber][lookupstructure];

    });
  }
  ////////////////////////////////////////////////////////

  String structure = "";
  String lookupstructure = "";
  String split_image = yellow_split_json_data[15]['Unknown Tissue'];

  bool _isvisible = true;
  double x = 0.0;
  double y = 0.0;
  int imageAxialNumber = 15;

  void updateAxialImage(double dy) {
    setState(() {
      //Random.nextInt(n) returns random integer from 0 to n-1
      if (dy > 0) {
        imageAxialNumber = (imageAxialNumber + 1) % 30;
        split_image = yellow_split_json_data[imageAxialNumber]["Unknown Tissue"];
        structure = "";
      }
      if (dy < 0) {
        imageAxialNumber = (imageAxialNumber - 1) % 30;
        split_image = yellow_split_json_data[imageAxialNumber]["Unknown Tissue"];
        structure = "";
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
        lookupstructure = "Unknown Tissue";
        structure = "";
      } else {
        //Here I get the structure in the raw form for a lookup
        lookupstructure = yellow_json_data[imageAxialNumber]
            [x.toInt().toString()][y.toInt().toString()];

        //This is the text shown on screen. I remove any "left" or "right" from the string.
        structure = yellow_json_data[imageAxialNumber][x.toInt().toString()]
                [y.toInt().toString()]
            .toString()
            .replaceAll(' left', '')
            .replaceAll(' right', '')
            .trim()
            .toString();

        if (incorrect_structures.contains(structure)) {
          structure = 'To Be Labeled';
        }
      }
      ;

      split_image = yellow_split_json_data[imageAxialNumber][lookupstructure];
    });
    //print([x, y]);
    //print(red_json_data[imageAxialNumber][x.toInt().toString()]
    //    [y.toInt().toString()]);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('How to Use'),
            content: const Text(
                '1. Click the arrow on the left/right sides to scroll through the brainstem.\n'
                '2. Click the bottom right button to toggle color labels.\n'
                '3. Hover your mouse over the brainstem to see anatomic labels.\n'),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }));
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
          child: InteractiveViewer(child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                    'yellow/image_${formatter.format(imageAxialNumber)}.png',
                    fit: BoxFit.fitWidth, //cover
                    //height: double.infinity,
                    //width: double.infinity,
                    alignment: Alignment.center,
                  ),
              InkWell(
                onTapDown: (details) => onTapDown(context, details),
                child: 
                    Image.asset(
                  _isvisible == true
                      ?
                      //'assets/redlabels/image_${formatter.format(imageAxialNumber)}.png',
                      'yellowlabelsplit/' + split_image
                      : 'yellowlabels/image_${formatter.format(imageAxialNumber)}.png',
                  fit: BoxFit.fitWidth,
                  //height: double.infinity,
                  //width: double.infinity,
                  alignment: Alignment.center,
                ),
              ),

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
                            ? Icon(Icons.label_off)
                            : Icon(Icons.label)),
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
          )),

        )));
  }
}
