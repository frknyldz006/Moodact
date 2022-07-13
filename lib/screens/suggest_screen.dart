import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:moodact/screens/main_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../const.dart';

class SuggestScreen extends StatefulWidget {
  final int mood;

  SuggestScreen({Key? key, required this.mood}) : super(key: key);
  @override
  _SuggestScreenState createState() => _SuggestScreenState(moodInt: mood);
}

class _SuggestScreenState extends State<SuggestScreen> {
  int moodInt;
  _SuggestScreenState({Key? key, required this.moodInt});
  final List<String> moodList = [
    'HAPPY',
    'SAD',
    'ANGRY',
    'TIRED',
  ];
  Future getMovie() async {
    String data =
        await DefaultAssetBundle.of(context).loadString("assets/movies.json");
    final map = jsonDecode(data);

    return map;
  }

  Future getSong() async {
    String data =
        await DefaultAssetBundle.of(context).loadString("assets/songs.json");
    final map = jsonDecode(data);

    return map;
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  int randomSong = Random().nextInt(4);
  int randomMovie = Random().nextInt(4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dark,
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    hoverColor: Colors.black12,
                    splashRadius: 24,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MainScreen()),
                      );
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: ogray,
                      size: 28,
                    )),
                Text(
                  moodList[moodInt],
                  style: TextStyle(fontSize: 24, color: gray),
                ),
                IconButton(
                    hoverColor: Colors.black12,
                    splashRadius: 24,
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (c, a1, a2) =>
                              SuggestScreen(mood: moodInt),
                          transitionsBuilder: (c, anim, a2, child) =>
                              FadeTransition(opacity: anim, child: child),
                          transitionDuration: Duration(milliseconds: 1000),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.refresh_rounded,
                      color: ogray,
                      size: 28,
                    ))
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 12),
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Stack(
                      children: [
                        Container(),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: Container(
                              height: 380,
                              width: 320,
                              decoration: BoxDecoration(
                                  color: dark,
                                  borderRadius: BorderRadius.circular(35),
                                  border: Border.all(color: blue, width: 2),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.16),
                                        blurRadius: 23,
                                        offset: Offset(0, 13))
                                  ]),
                              child: FutureBuilder(
                                  future: getSong(),
                                  builder: (context, snapshot) {
                                    print(randomMovie);
                                    print(randomSong);
                                    if (snapshot.hasError)
                                      print(snapshot.error);
                                    return snapshot.hasData
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Stack(
                                                children: [
                                                  Container(),
                                                  Center(
                                                    child: Container(
                                                        height: 250,
                                                        width: 250,
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: Image.asset((snapshot
                                                                        .data
                                                                    as List<
                                                                        dynamic>)[((moodInt +
                                                                            1) *
                                                                        5) -
                                                                    (randomSong +
                                                                        1)]["image"])
                                                                .image,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(42),
                                                          border: Border.all(
                                                              color: gray,
                                                              width: 2),
                                                        )),
                                                  ),
                                                  Positioned(
                                                    right: 20,
                                                    bottom: 0,
                                                    child: Container(
                                                      height: 48,
                                                      width: 48,
                                                      decoration: BoxDecoration(
                                                        color: blue,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        border: Border.all(
                                                            color: gray,
                                                            width: 2),
                                                      ),
                                                      child: IconButton(
                                                          onPressed: () {
                                                            var url = (snapshot
                                                                        .data
                                                                    as List<
                                                                        dynamic>)[
                                                                ((moodInt + 1) *
                                                                        5) -
                                                                    (randomSong +
                                                                        1)]["link"];
                                                            _launchURL(url);
                                                          },
                                                          icon: Icon(
                                                            Icons.link_rounded,
                                                            color: white,
                                                            size: 28,
                                                          )),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 16,
                                              ),
                                              Center(
                                                child: Text(
                                                  "${(snapshot.data as List<dynamic>)[((moodInt + 1) * 5) - (randomSong + 1)]["song"]}\n${(snapshot.data as List<dynamic>)[(moodInt + 1) * 5 - (randomSong + 1)]["author"]}",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(color: gray),
                                                ),
                                              )
                                            ],
                                          )
                                        : Center(
                                            child: CircularProgressIndicator(
                                            color: ogray,
                                          ));
                                  }),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 64,
                          child: Container(
                            height: 50,
                            width: 120,
                            decoration: BoxDecoration(
                                color: dark,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: blue, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.16),
                                      blurRadius: 23,
                                      offset: Offset(0, 13))
                                ]),
                            child: Center(
                              child: Text("SONG",
                                  style: TextStyle(
                                      fontFamily: "InsaniBurger",
                                      color: white,
                                      fontSize: 24)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Stack(
                      children: [
                        Container(),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: Container(
                              height: 380,
                              width: 320,
                              decoration: BoxDecoration(
                                  color: dark,
                                  borderRadius: BorderRadius.circular(35),
                                  border: Border.all(color: blue, width: 2),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.16),
                                        blurRadius: 23,
                                        offset: Offset(0, 13))
                                  ]),
                              child: FutureBuilder(
                                  future: getMovie(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError)
                                      print(snapshot.error);
                                    return snapshot.hasData
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Stack(
                                                children: [
                                                  Container(),
                                                  Center(
                                                    child: Container(
                                                        height: 250,
                                                        width: 250,
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: Image.asset((snapshot
                                                                        .data
                                                                    as List<
                                                                        dynamic>)[((moodInt +
                                                                            1) *
                                                                        5) -
                                                                    (randomMovie +
                                                                        1)]["image"])
                                                                .image,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(42),
                                                          border: Border.all(
                                                              color: gray,
                                                              width: 2),
                                                        )),
                                                  ),
                                                  Positioned(
                                                    right: 20,
                                                    bottom: 0,
                                                    child: Container(
                                                      height: 48,
                                                      width: 48,
                                                      decoration: BoxDecoration(
                                                        color: blue,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        border: Border.all(
                                                            color: gray,
                                                            width: 2),
                                                      ),
                                                      child: IconButton(
                                                          onPressed: () {
                                                            var url = (snapshot
                                                                        .data
                                                                    as List<
                                                                        dynamic>)[
                                                                ((moodInt + 1) *
                                                                        5) -
                                                                    (randomMovie +
                                                                        1)]["link"];
                                                            _launchURL(url);
                                                          },
                                                          icon: Icon(
                                                            Icons.link_rounded,
                                                            color: white,
                                                            size: 28,
                                                          )),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 16,
                                              ),
                                              Center(
                                                child: Text(
                                                  "${(snapshot.data as List<dynamic>)[((moodInt + 1) * 5) - (randomMovie + 1)]["movie"]}",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(color: gray),
                                                ),
                                              )
                                            ],
                                          )
                                        : Center(
                                            child: CircularProgressIndicator(
                                            color: ogray,
                                          ));
                                  }),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 64,
                          child: Container(
                            height: 50,
                            width: 120,
                            decoration: BoxDecoration(
                                color: dark,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: blue, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.16),
                                      blurRadius: 23,
                                      offset: Offset(0, 13))
                                ]),
                            child: Center(
                              child: Text("Movie",
                                  style: TextStyle(
                                      fontFamily: "InsaniBurger",
                                      color: white,
                                      fontSize: 24)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}
