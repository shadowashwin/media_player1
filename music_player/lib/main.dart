import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Screen/audio.dart';
import 'colors.dart';
import 'Screen/home.dart';

void main() {
  runApp(const music_player());
}

class music_player extends StatelessWidget{
  const music_player({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Music Player",
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
        // fontFamily: "logo",
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0
        ),
        primarySwatch: primary,
      ),
      home: const Home(),
    );
  }
}


class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}
