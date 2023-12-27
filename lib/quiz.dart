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
  int imageAxialNumber = 0;

  List<String> chosenFiles = [];
  List<String> chosenStructs = [];

  bool answerAPressed = false;
  bool answerBPressed = false;
  bool answerCPressed = false;
  bool answerDPressed = false;


  bool learn = false;
  int correctAnswerIndex = 0;

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



  void generateQuestion() {

    // generate 4 choices
    int chosen = 0;
    int total = files.length;
    chosenFiles = [];
    chosenStructs = [];
    // print(total);
    // print(structures.length);
    while (chosen < 4) {
      int index = Random().nextInt(total);
      String currentFile = files[index];
      String currentStruct = structures[index].toString()
            .replaceAll(' left', '')
            .replaceAll(' right', '')
            .trim()
            .toString();
      // print(chosen);
      if (!chosenFiles.contains(currentFile) && !chosenStructs.contains(currentStruct) && !currentStruct.contains("Unknown")) {
        chosenFiles.add(currentFile);
        chosenStructs.add(currentStruct);
        chosen += 1;
      }
    }
    print(chosenFiles);
    print(chosenStructs);
    // print('changed axial image');
    correctAnswerIndex = Random().nextInt(4);
    structure = chosenStructs[correctAnswerIndex];
    lookupstructure = structures[files.indexOf(chosenFiles[correctAnswerIndex])];
    imageAxialNumber = int.parse(chosenFiles[correctAnswerIndex].substring(9,11));

    setState(() {
      print(imageAxialNumber);

      split_image = red_split_json_data[imageAxialNumber][lookupstructure];
      structure = chosenStructs[correctAnswerIndex];
    });
  }

  @override
  void initState() {
    generateQuestion();
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
              child: InteractiveViewer(
                  child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'redlabelsplit/' + chosenFiles[correctAnswerIndex],
                    fit: BoxFit.fitWidth, //cover
                    //height: double.infinity,
                    //width: double.infinity,
                    alignment: Alignment.center,
                  ),
                  InkWell(
                    onTapDown: (details) => onTapDown(context, details),
                    child: Image.asset(
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
                        alignment: Alignment(0.0, 0.8),
                        child: Row(
                          children: [
                            Spacer(),
                            Expanded(
                                child: TextButton(
                            child: Text(chosenStructs[0].toUpperCase(),
                                style: TextStyle(fontSize: 14)),
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    EdgeInsets.all(15)),
                                backgroundColor: MaterialStateProperty.all<Color>(getBackColor(answerAPressed, correctAnswerIndex == 0)),
                                foregroundColor: MaterialStateProperty.all<Color>(getForeColor(answerAPressed, correctAnswerIndex == 0)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        side: BorderSide(
                                            color: Color(0xff5E81AC))))),
                            onPressed: () {
                              if (!learn) {
                                setState(() {
                                  answerAPressed = true;
                                  answerBPressed = false;
                                  answerCPressed = false;
                                  answerDPressed = false;
                                });
                              }

                              // updateAxialImage();
                            })),
                            Spacer(),
                            Expanded(
                                child: TextButton(
                            child: Text(chosenStructs[1].toUpperCase(),
                                style: TextStyle(fontSize: 14)),
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    EdgeInsets.all(15)),
                                backgroundColor: MaterialStateProperty.all<Color>(getBackColor(answerBPressed, correctAnswerIndex == 1)),
                                foregroundColor: MaterialStateProperty.all<Color>(getForeColor(answerBPressed, correctAnswerIndex == 1)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        side: BorderSide(
                                            color: Color(0xff5E81AC))))),
                            onPressed: () {
                              if (!learn) {
                                setState(() {
                                  answerAPressed = false;
                                  answerBPressed = true;
                                  answerCPressed = false;
                                  answerDPressed = false;
                                });
                              }

                              // updateAxialImage();
                            })),
                            Spacer(),
                            Expanded(
                                child: TextButton(
                            child: Text(chosenStructs[2].toUpperCase(),
                                style: TextStyle(fontSize: 14)),
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    EdgeInsets.all(15)),
                                backgroundColor: MaterialStateProperty.all<Color>(getBackColor(answerCPressed, correctAnswerIndex == 2)),
                                foregroundColor: MaterialStateProperty.all<Color>(getForeColor(answerCPressed, correctAnswerIndex == 2)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        side: BorderSide(
                                            color: Color(0xff5E81AC))))),
                            onPressed: () {
                              if (!learn) {
                                setState(() {
                                  answerAPressed = false;
                                  answerBPressed = false;
                                  answerCPressed = true;
                                  answerDPressed = false;
                                });
                              }

                              // updateAxialImage();
                            })),
                            Spacer(),
                            Expanded(
                                child: TextButton(
                            child: Text(chosenStructs[3].toUpperCase(),
                                style: TextStyle(fontSize: 14)),
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    EdgeInsets.all(15)),
                                backgroundColor: MaterialStateProperty.all<Color>(getBackColor(answerDPressed, correctAnswerIndex == 3)),
                                foregroundColor: MaterialStateProperty.all<Color>(getForeColor(answerDPressed, correctAnswerIndex == 3)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        side: BorderSide(
                                            color: Color(0xff5E81AC))))),
                            onPressed: () {
                              if (!learn) {
                                setState(() {
                                  answerAPressed = false;
                                  answerBPressed = false;
                                  answerCPressed = false;
                                  answerDPressed = true;
                                });
                              }

                              // updateAxialImage();
                            })),
                            Spacer(),
                          ],
                        ),
                      ),

                      Align(
                        alignment: Alignment(0.0, 0.9),
                        child: TextButton(
                            child: Text(!learn ? "Submit".toUpperCase() : "Next".toUpperCase(),
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
                              setState(() {
                                if (answerAPressed || answerBPressed || answerCPressed || answerDPressed) {
                                  if (learn) {
                                    generateQuestion();
                                    answerAPressed = false;
                                    answerBPressed = false;
                                    answerCPressed = false;
                                    answerDPressed = false;
                                  }
                                  learn = !learn;
                                }
                                // interpret answer

                              });
                            }),
                      ),

                      Align(
                        alignment: Alignment.bottomRight,
                        child: learn ?
                        FloatingActionButton(
                            heroTag: 'btn3',
                            onPressed: () {
                              setState(() {
                                _isvisible = !_isvisible;
                              });
                            },
                            child: (_isvisible)
                                ? Icon(Icons.label_off)
                                : Icon(Icons.label)) :
                                Container(),
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

  Color getBackColor(bool pressed, bool correct) {
    Color ret = Colors.black;
    if (!learn && pressed) {
      ret = Color(0xff5E81AC);
    } else if (learn && pressed && correct) {
      ret = Colors.green;
    } else if (learn && pressed && !correct) {
      ret = Colors.red;
    }
    return ret;
  }

  Color getForeColor(bool pressed, bool correct) {
    if (pressed) {
      return Colors.white;
    } else {
      return Color(0xff5E81AC);
    }
  }

}

