import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/colors.dart';
import 'package:music_player/player.dart';
import 'package:music_player/text_style.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../controller/play_controller.dart';
import 'home.dart';

class HomeScreeen extends StatelessWidget {
  const HomeScreeen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context);
    var controller = Get.put(PlayerController());
    return Flexible(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.2],
            colors: [green, Colors.black],
          ),
        ),
        child: Scaffold(
          // backgroundColor: Colors.transparent,
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
          body: FutureBuilder<List<SongModel>>(
            future: controller.audioQuery.querySongs(
                orderType: OrderType.ASC_OR_SMALLER,
                ignoreCase: true,
                sortType: null,
                uriType: UriType.EXTERNAL),
            builder: (BuildContext context, snapshot) {
              if (snapshot.data == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.data!.isEmpty) {
                return Center(child: Text("no song found", style: OurStyle()));
              } else {
                // print(snapshot.data);
                return Container(
                  decoration: const BoxDecoration(color: Colors.transparent),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Obx(
                              () => Flexible(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: controller.playindex.value ==
                                                  index &&
                                              controller.isplaying.value == true
                                          ? green
                                          : Colors.transparent
                                      // gradient: const LinearGradient(
                                      //   begin: Alignment.centerLeft,
                                      //   end: Alignment.centerRight,
                                      //   colors: [
                                      //     g3,g5
                                      //   ]
                                      // ),
                                      ),
                                  child: ListTile(
                                    title: Text(
                                      snapshot.data![index].displayNameWOExt,
                                      style: TextStyle(
                                          color: controller.playindex.value ==
                                                      index &&
                                                  controller.isplaying.value ==
                                                      true
                                              ? Colors.black
                                              : Colors.white,
                                          overflow: TextOverflow.ellipsis,
                                          fontFamily: "body",
                                          fontSize: 18),
                                    ),
                                    subtitle: Text(
                                      "${snapshot.data![index].artist}",
                                      style: TextStyle(
                                          color: controller.playindex.value ==
                                                      index &&
                                                  controller.isplaying.value ==
                                                      true
                                              ? Colors.black54
                                              : Colors.white54,
                                          overflow: TextOverflow.ellipsis,
                                          fontFamily: "title",
                                          fontSize: 18),
                                    ),
                                    leading: QueryArtworkWidget(
                                      id: snapshot.data![index].id,
                                      type: ArtworkType.AUDIO,
                                      nullArtworkWidget: Icon(
                                        Icons.music_note,
                                        color: controller.playindex.value ==
                                                    index &&
                                                controller.isplaying.value ==
                                                    true
                                            ? Colors.black
                                            : Colors.white,
                                        size: 32,
                                      ),
                                    ),
                                    trailing: controller.playindex.value ==
                                                index &&
                                            controller.isplaying.value == true
                                        ? const Icon(
                                            Icons.play_arrow,
                                            color: Colors.black,
                                            size: 26,
                                          )
                                        : null,
                                    onTap: () {
                                      controller.playAudio(
                                          snapshot.data![index].uri, index);
                                      Get.to(
                                          () => player(data: snapshot.data!));
                                    },
                                  ),
                                ),
                              ),
                            ));
                      },
                    ),
                  ),
                );
              }
            },
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
                    color: green,
                    spreadRadius: 1,
                    blurRadius: 15,
                    offset: Offset(5, 5),
                  ),
                  BoxShadow(
                      color: green,
                      offset: Offset(-5, -5),
                      blurRadius: 15,
                      spreadRadius: 1),
                ],
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    green.shade200,
                    green.shade300,
                    green.shade400,
                    green.shade500,
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
                    child: InkWell(
                      child: Icon(
                        Icons.home_outlined,
                        color: white,
                        size: 30,
                      ),
                      onTap: () {
                        controller.audioplayer.pause();
                        controller.isplaying(false);
                        // Navigator.pop(context);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home(),
                        ));
                      },
                    ),
                  ),
                  Container(
                    // margin: EdgeInsets.only(bottom: mq.size.height * 0.001),
                    // padding: EdgeInsets.only(bottom: mq.size.height * 0.05),
                    child: Icon(
                      Icons.audiotrack,
                      color: white,
                      size: 30,
                    ),
                  ),
                  Container(
                    // margin: EdgeInsets.only(bottom: mq.size.height * 0.001),
                    // padding: EdgeInsets.only(bottom: mq.size.height * 0.05),
                    child: Icon(
                      Icons.video_camera_back_outlined,
                      color: white,
                      size: 30,
                    ),
                  ),
                  Container(
                    // margin: EdgeInsets.only(bottom: mq.size.height * 0.001),
                    // padding: EdgeInsets.only(bottom: mq.size.height * 0.05),
                    child: Icon(
                      Icons.image_outlined,
                      color: white,
                      size: 30,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
