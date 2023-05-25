import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:music_player/colors.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../player.dart';
import '../text_style.dart';
import 'audio.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    var p = 0.4;
    var mq = MediaQuery.of(context);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.2],
          colors: [white, Colors.black],
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search, color: Colors.white))
            ],
            leading: InkWell(
              child: const Icon(
                Icons.sort_rounded,
                color: Colors.white,
              ),
              onTap: () {},
            ),
            title: const Text("Shadow Beats",
                style: TextStyle(
                    color: Colors.white, fontFamily: logo, fontSize: 20))),
        body: Center(
          child: Column(
            children: [
              Container(
                child: CircularPercentIndicator(
                  radius: mq.size.width * 0.25,
                  lineWidth: 10,
                  percent: p,
                  progressColor: green,
                  backgroundColor: Colors.white30,
                  circularStrokeCap: CircularStrokeCap.round,
                  center: Text(
                    p.toString() + "%",
                    style: TextStyle(color: green, fontSize: 20),
                  ),
                ),
              ),
              Container(
                child: CircularPercentIndicator(
                  radius: mq.size.width * 0.25,
                  lineWidth: 10,
                  percent: p,
                  progressColor: bhagva,
                  backgroundColor: Colors.white30,
                  circularStrokeCap: CircularStrokeCap.round,
                  center: Text(
                    p.toString() + "%",
                    style: TextStyle(color: bhagva, fontSize: 20),
                  ),
                ),
              ),
              Container(
                child: CircularPercentIndicator(
                  radius: mq.size.width * 0.25,
                  lineWidth: 10,
                  percent: p,
                  progressColor: purple,
                  backgroundColor: Colors.white30,
                  circularStrokeCap: CircularStrokeCap.round,
                  center: Text(
                    p.toString() + "%",
                    style: TextStyle(color: purple, fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            // width: 40,
            // height: 40,
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.fromLTRB(mq.size.width * 0.05, 0,
                mq.size.width * 0.05, mq.size.width * 0.05),
            decoration: BoxDecoration(
              color: green,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: white,
                  spreadRadius: 1,
                  blurRadius: 15,
                  offset: Offset(5, 5),
                ),
                BoxShadow(
                    color: white,
                    offset: Offset(-5, -5),
                    blurRadius: 15,
                    spreadRadius: 1),
              ],
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white30,
                  Colors.white54,
                  Colors.white60,
                  Colors.white70,
                ],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  // margin: EdgeInsets.only(bottom: mq.size.height * 0.001),
                  // padding: EdgeInsets.only(bottom: mq.size.height * 0.05),
                  child: Icon(
                    Icons.home,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
                Container(
                  // margin: EdgeInsets.only(bottom: mq.size.height * 0.001),
                  // padding: EdgeInsets.only(bottom: mq.size.height * 0.05),
                  child: InkWell(
                      child: Icon(
                    Icons.audiotrack_outlined,
                    color: Colors.black,
                    size: 30,
                  ),
                    onTap: () {
                      Get.to(
                              () => HomeScreeen());
                    },
                  ),
                ),
                Container(
                  // margin: EdgeInsets.only(bottom: mq.size.height * 0.001),
                  // padding: EdgeInsets.only(bottom: mq.size.height * 0.05),
                  child: Icon(
                    Icons.video_camera_back_outlined,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
                Container(
                  // margin: EdgeInsets.only(bottom: mq.size.height * 0.001),
                  // padding: EdgeInsets.only(bottom: mq.size.height * 0.05),
                  child: Icon(
                    Icons.image_outlined,
                    color: Colors.black,
                    size: 30,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
