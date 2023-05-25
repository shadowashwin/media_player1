import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:music_player/colors.dart';
import 'package:music_player/text_style.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'controller/play_controller.dart';

class player extends StatelessWidget {
  final List<SongModel> data;
  const player({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context);
    var controller = Get.find<PlayerController>();
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        stops: [0.45, 1.0],
        begin: FractionalOffset.topCenter,
        end: FractionalOffset.bottomCenter,
        tileMode: TileMode.repeated,
        colors: [Colors.black, green],
        // tileMode: TileMode.repeated
      )),
      child: Obx(()=>Scaffold(
          // backgroundColor: ,
          appBar: AppBar(),
          body: Column(
            children: [
              Expanded(
                  child: Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                height: mq.size.height * 0.35,
                width: mq.size.height * 0.35,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.white38),
                child: QueryArtworkWidget(
                  id: data[controller.playindex.value].id,
                  type: ArtworkType.AUDIO,
                  artworkHeight: double.infinity,
                  artworkWidth: double.infinity,
                  nullArtworkWidget:
                      Icon(Icons.music_note, size: mq.size.width * 0.2),
                ),
              )),
              SizedBox(height: mq.size.height * 0.14),
              Expanded(
                  child: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    color: Colors.transparent,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(40))),
                child: Flexible(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(mq.size.width * 0.04, 0, mq.size.width * 0.04, 0),
                        child: Text(data[controller.playindex.value].displayNameWOExt,
                            style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: white,
                                fontFamily: 'no',
                                fontSize: 30)),
                      ),
                      SizedBox(
                        height: mq.size.height * 0.008,
                      ),
                      Text(data[controller.playindex.value].artist.toString(),
                          style: const TextStyle(
                              color: Colors.white54,
                              overflow: TextOverflow.ellipsis,
                              fontSize: 15)),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            mq.size.width * 0.04,
                            mq.size.width * 0.05,
                            mq.size.width * 0.05,
                            mq.size.width * 0.04),
                        child: Obx(()=>Row(
                            children: [
                              Text(
                                controller.position.value,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: mq.size.width * 0.05,
                                     // fontFamily: 'no'
                                ),
                              ),
                              Expanded(
                                  child: Slider(
                                    min: const Duration(seconds: 0).inSeconds.toDouble(),
                                max: controller.max.value,
                                value: controller.value.value,
                                onChanged: (newValue) {
                                  controller.updateSlider(newValue.toInt());
                                  newValue = newValue;
                                },
                                activeColor: Colors.white,
                                inactiveColor: Colors.white30,
                              )),
                              Text(
                                controller.duration.value,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: mq.size.width * 0.05,
                                    // fontFamily: 'no'
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: mq.size.height * 0.002,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              onPressed: () {
                                controller.playAudio(data[controller.playindex.value - 1].uri, controller.playindex.value - 1);
                              },
                              icon: Icon(Icons.skip_previous,
                                  color: Colors.white,
                                  size: mq.size.width * 0.1)),
                          Obx(()=> CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: Transform.scale(
                                scale: mq.size.width * 0.007,
                                child: IconButton(
                                  onPressed: () {},
                                  icon: InkWell(
                                    child: Icon(
                                      controller.isplaying.value
                                          ? Icons.pause
                                          : Icons.play_arrow_rounded,
                                      color: white,
                                    ),
                                    onTap: () {
                                      if(controller.isplaying.value){
                                        controller.audioplayer.pause();
                                        controller.isplaying(false);
                                      }else{
                                        controller.audioplayer.play();
                                        controller.isplaying(true);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                controller.playAudio(data[controller.playindex.value + 1].uri, controller.playindex.value + 1);
                              },
                              icon: Icon(Icons.skip_next,
                                  color: Colors.white, size: mq.size.width * 0.1))
                        ],
                      )
                    ],
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
