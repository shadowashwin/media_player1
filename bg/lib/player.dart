import 'package:flutter/material.dart';
import 'package:on_audio_query_platform_interface/src/models/song_model.dart';

class player extends StatefulWidget {
  const player({Key? key, required List<SongModel> data}) : super(key: key);

  @override
  State<player> createState() => _playerState();
}

class _playerState extends State<player> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
