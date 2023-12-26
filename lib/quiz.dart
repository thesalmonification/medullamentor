import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'main.dart';

class BrainstemQuiz extends StatefulWidget {
  BrainstemQuiz({super.key});
  //So will try async function here...

  @override
  State<BrainstemQuiz> createState() => _BrainstemQuizState();
}



class _BrainstemQuizState extends State<BrainstemQuiz> {
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



  

  // void updateAxialImage(double dy) {
  //   print('changed axial image');
  //   setState(() {
  //     //Random.nextInt(n) returns random integer from 0 to n-1
  //     if (dy > 0) {
  //       imageAxialNumber = (imageAxialNumber + 1) % 30;
  //       split_image = red_split_json_data[imageAxialNumber]["Unknown Tissue"];
  //       structure = "";
  //     }
  //     if (dy < 0) {
  //       imageAxialNumber = (imageAxialNumber - 1) % 30;
  //       split_image = red_split_json_data[imageAxialNumber]["Unknown Tissue"];
  //       structure = "";
  //     }
  //   });
  // }

    void updateAxialImage() {
    print('changed axial image');
    setState(() {
      imageAxialNumber = Random().nextInt(30);
      split_image = red_split_json_data[imageAxialNumber]["Unknown Tissue"];
      structure = "";

    });
  }

  

  

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('UNDER CONSTRUCTION'),
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

  

  bool answerAPressed = false;
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
          title: Text('Quiz Mode'),
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
                      // 'assets/redlabels/image_${formatter.format(imageAxialNumber)}.png',
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
                  // Align(
                  //   alignment: Alignment.centerLeft,
                  //   child: FloatingActionButton(
                  //       heroTag: "btn1",
                  //       onPressed: () {
                  //         updateAxialImage(-1);
                  //       },
                  //       child: const Icon(Icons.navigate_before)),
                  // ),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            answerAPressed = !answerAPressed;
                          });
                          updateAxialImage();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: (answerAPressed ? Colors.blue : Colors.green),
                        ),
                      child: Text('Answer'))),
                      Expanded(child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            answerAPressed = !answerAPressed;
                          });
                          updateAxialImage();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: (answerAPressed ? Colors.blue : Colors.green),
                        ),
                      child: Text('Answer'))),
                      Expanded(child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            answerAPressed = !answerAPressed;
                          });
                          updateAxialImage();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: (answerAPressed ? Colors.blue : Colors.green),
                        ),
                      child: Text('Answer'))),
                      Expanded(child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            answerAPressed = !answerAPressed;
                          });
                          updateAxialImage();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: (answerAPressed ? Colors.blue : Colors.green),
                        ),
                      child: Text('Answer'))),
                      ],
                    ),
                  ),
                  ),
                  

                  
                  Align(
                    alignment: Alignment.topCenter,
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            answerAPressed = !answerAPressed;
                          });
                          updateAxialImage();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: (answerAPressed ? Colors.green : Colors.blue),
                        ),
                      child: Text('Submit')),
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
  
  // MaterialStateProperty<Color> getColor(Color color, Color colorPressed) {
  //   getColor(Set<MaterialState> states) {
  //     if (answerAPressed) {
  //       return colorPressed;
  //     } else {
  //       return color;
  //     }
  //   }
  //   return MaterialStateProperty.resolveWith(getColor);

  // }
}
