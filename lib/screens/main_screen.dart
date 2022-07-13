import 'dart:convert';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moodact/const.dart';

import 'suggest_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<String> imgList = [
    'assets/img/moods/happy.png',
    'assets/img/moods/crying.png',
    'assets/img/moods/angry.png',
    'assets/img/moods/tired.png',
    'assets/img/moods/rolling eyes.png',
  ];
  final List<String> moodList = [
    'HAPPY',
    'SAD',
    'ANGRY',
    'TIRED',
  ];
  int selectedMood = 0;

  int randomNumber = Random().nextInt(3);
  int randomQuote = Random().nextInt(19);
  Future getQuote() async {
    String data =
        await DefaultAssetBundle.of(context).loadString("assets/quotes.json");
    final map = jsonDecode(data);

    return map;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: dark,
        body: SafeArea(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    "assets/img/t-moodact.png",
                    width: 90,
                    height: 90,
                  ),
                  IconButton(
                      hoverColor: Colors.black12,
                      splashRadius: 24,
                      onPressed: () {
                        final snackBar = SnackBar(
                            backgroundColor: ogray,
                            content: Text(
                              'Made by Furkan Yıldız\n21/11/2021',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: gray),
                            ));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      icon: Icon(
                        Icons.info_outline_rounded,
                        color: ogray,
                        size: 32,
                      ))
                ],
              ),
            ),
            Column(
              children: [
                Center(
                  child: Text(
                    "How do you feel ?",
                    style:
                        TextStyle(color: gray, fontSize: 24, wordSpacing: -6),
                  ),
                ),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 400.0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        selectedMood = index;
                      });
                    },
                  ),
                  items: [0, 1, 2, 3].map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                            padding: EdgeInsets.only(top: 32),
                            width: MediaQuery.of(context).size.width,
                            height: 1,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            color: Colors.transparent,
                            child: Center(
                              child: Column(
                                children: [
                                  Image.asset(
                                    imgList[i],
                                    fit: BoxFit.contain,
                                    width: 256,
                                    height: 256,
                                  ),
                                  SizedBox(
                                    height: 24,
                                  ),
                                  Text(
                                    moodList[i],
                                    style:
                                        TextStyle(fontSize: 28.0, color: gray),
                                  ),
                                ],
                              ),
                            ));
                      },
                    );
                  }).toList(),
                ), //feelings
                Center(
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      print(selectedMood);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SuggestScreen(
                                  mood: selectedMood,
                                )),
                      );
                    },
                    child: Container(
                      width: 264,
                      height: 54,
                      decoration: BoxDecoration(
                          color: blue,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.16),
                                blurRadius: 6,
                                offset: Offset(0, 8))
                          ]),
                      child: Center(
                        child: Text("SELECT",
                            style: TextStyle(
                                fontFamily: "InsaniBurger",
                                color: white,
                                fontSize: 32)),
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Column(
                      children: [
                        Row(children: <Widget>[
                          Expanded(
                            child: new Container(
                                margin: const EdgeInsets.only(
                                    left: 30.0, right: 30.0),
                                child: Divider(
                                  color: ogray,
                                  height: 36,
                                )),
                          ),
                          Text("quote of the day",
                              style: TextStyle(
                                  fontFamily: "Lobster",
                                  color: ogray,
                                  fontSize: 14)),
                          Expanded(
                            child: new Container(
                                margin: const EdgeInsets.only(
                                    left: 30.0, right: 30.0),
                                child: Divider(
                                  color: ogray,
                                  height: 36,
                                )),
                          ),
                        ]),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 20),
                            child: FutureBuilder(
                                future: getQuote(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) print(snapshot.error);

                                  return snapshot.hasData
                                      ? Column(
                                          children: [
                                            Text(
                                                (snapshot.data as List<
                                                        dynamic>)[randomQuote]
                                                    ["quote"],
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontFamily: "Lobster",
                                                    color: gray,
                                                    fontSize: 16)),
                                            SizedBox(
                                              height: 12,
                                            ),
                                            Center(
                                              child: Text(
                                                  "～${(snapshot.data as List<dynamic>)[randomQuote]["author"]} ～",
                                                  style: TextStyle(
                                                      fontFamily: "Lobster",
                                                      color: gray,
                                                      fontSize: 16)),
                                            )
                                          ],
                                        )
                                      : Center(
                                          child: CircularProgressIndicator(
                                          color: ogray,
                                        ));
                                }))
                      ],
                    )),
              ],
            )
          ],
        )));
  }
}
