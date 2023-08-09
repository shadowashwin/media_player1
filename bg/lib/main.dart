import 'package:bg/color.dart';
import 'package:bg/player.dart';
import 'package:bg/player_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:glassmorphism/glassmorphism.dart';
// import 'package:rive/rive.dart';
import 'custom_clippath.dart';
import 'package:alan_voice/alan_voice.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(bg()));
  runApp(bg());
}

class bg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'bgtest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var l;
  final scroll_controller = ScrollController();
  var controller = Get.put(PlayerController());
  var i;

  _HomeScreenState() {
    /// Init Alan Button with project key from Alan AI Studio
    AlanVoice.addButton(
        "fabafe1910e673bcfefb077ed6c09c542e956eca572e1d8b807a3e2338fdd0dc/stage",
        buttonAlign: AlanVoice.BUTTON_ALIGN_LEFT);

    /// Handle commands from Alan AI Studio
    AlanVoice.onCommand.add((command) => _handleCommand(command.data));
  }

  void _handleCommand(Map<String, dynamic> command) {
    // if(command["command"]=="increment"){
    //   _incrementCounter();
    // }
    switch (command["command"]) {
      case "play from begining":
        controller.playAudio(l.data![0].uri, 0);
        i = 0;
        break;
      case "playing previous":
        controller.playAudio(l.data![i - 1].uri, i - 1);
        i = i - 1;
        break;

      case "playing next":
        controller.playAudio(l.data![i + 1].uri, i + 1);
        i = i + 1;
        break;

      case "pause":
        controller.audioplayer.pause();
        controller.isplaying(false);
        break;

      case "play":
        controller.audioplayer.play();
        controller.isplaying(true);
        break;
      default:
        debugPrint("unknown command");
    }
  }

  void onListenerControler() {
    setState(() {});
  }

  @override
  void initState() {
    scroll_controller.addListener(onListenerControler);
    super.initState();
  }

  @override
  void dispose() {
    scroll_controller.removeListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context);
    var x = 0;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.7],
              colors: [dblue, lblue],
            )),
          ),
          ClipPath(
            clipper: clippath2(),
            child: Container(
              decoration: BoxDecoration(color: Colors.white10),
              height: mq.size.height * 0.11,
            ),
          ),
          ClipPath(
            clipper: clippath1(),
            child: Container(
              decoration: BoxDecoration(color: Colors.white24),
              height: mq.size.height * 0.11,
            ),
          ),
          Container(
            decoration: const BoxDecoration(color: Colors.white12),
          ),
          Container(
            height: mq.size.height * 0.1,
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            alignment: Alignment.bottomLeft,
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  child: const Icon(
                    Icons.sort_rounded,
                    color: Colors.white,
                  ),
                  onTap: () {},
                ),
                const Text("Shadow Beats",
                    style: TextStyle(
                        color: Colors.white, fontFamily: "logo", fontSize: 20)),
                InkWell(
                  child: const Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(1, mq.size.height * 0.13, 1, 5),
            child: FutureBuilder<List<SongModel>>(
              future: controller.audioQuery.querySongs(
                  orderType: OrderType.values.first,
                  ignoreCase: true,
                  sortType: null,
                  uriType: UriType.EXTERNAL),
              builder: (BuildContext context, snapshot) {
                if (snapshot.data == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.data!.isEmpty) {
                  return Center(child: Text("no song found"));
                } else {
                  l = snapshot;
                  // print(snapshot.data);
                  return Container(
                    decoration: const BoxDecoration(color: Colors.transparent),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ListView.builder(
                        controller: scroll_controller,
                        physics: const BouncingScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          i = controller.playindex.value;
                          final itemoffset =
                              index * controller.playindex.value == index &&
                                      controller.isplaying.value == true
                                  ? mq.size.height * 0.17
                                  : mq.size.height * 0.08;
                          final difference =
                              scroll_controller.offset - itemoffset;
                          final percent = 1 -
                              (difference /
                                  (controller.playindex.value == index &&
                                          controller.isplaying.value == true
                                      ? (mq.size.height * 0.17) / 2
                                      : (mq.size.height * 0.08) / 2));
                          double opacity = percent;
                          double scale = percent;
                          if (opacity > 1.0) opacity = 1.0;
                          if (opacity < 0.0) opacity = 0.0;
                          if (scale > 1.0) scale = 1.0;
                          return Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Obx(
                              () => Stack(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 4.25),
                                    height: controller.playindex.value ==
                                                index &&
                                            controller.isplaying.value == true
                                        ? mq.size.height * 0.17
                                        : mq.size.height * 0.08,
                                    decoration: controller.playindex.value ==
                                                index &&
                                            controller.isplaying.value == true
                                        ? const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            image: DecorationImage(
                                                opacity: 0.7,
                                                image: AssetImage(
                                                    'assets/card1.png')))
                                        : null,
                                  ),
                                  GlassmorphicContainer(
                                      margin: EdgeInsets.only(top: 3.5),
                                      height: controller.playindex.value ==
                                                  index &&
                                              controller.isplaying.value == true
                                          ? mq.size.height * 0.17
                                          : mq.size.height * 0.08,
                                      width: controller.playindex.value ==
                                                  index &&
                                              controller.isplaying.value == true
                                          ? mq.size.width * 1
                                          : 0,
                                      borderRadius: 5,
                                      blur: 0.1,
                                      alignment: Alignment.center,
                                      border: 5,
                                      linearGradient: LinearGradient(
                                          colors: [
                                            lblue.withOpacity(0.02),
                                            dblue.withOpacity(0.01)
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight),
                                      borderGradient: const LinearGradient(
                                          colors: [dblue, lblue])),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        0,
                                        mq.size.height * 0.005,
                                        0,
                                        mq.size.height * 0.005),
                                    height: controller.playindex.value ==
                                                index &&
                                            controller.isplaying.value == true
                                        // && controller.i.value == 1
                                        ? mq.size.height * 0.17
                                        : mq.size.height * 0.08,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: controller.playindex.value ==
                                                  index &&
                                              controller.isplaying.value == true
                                          ? Colors.transparent
                                          : Colors.white12,
                                    ),
                                    child: ListTile(
                                      title: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 5, 0, 0),
                                        child: Text(
                                          snapshot
                                              .data![index].displayNameWOExt,
                                          style: TextStyle(
                                              color: Colors.white,
                                              overflow: TextOverflow.ellipsis,
                                              fontFamily: "body",
                                              fontSize:
                                                  controller.playindex.value ==
                                                              index &&
                                                          controller.isplaying
                                                                  .value ==
                                                              true
                                                      ? 20
                                                      : 18),
                                        ),
                                      ),
                                      subtitle: controller.playindex.value ==
                                                  index &&
                                              controller.isplaying.value == true
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${snapshot.data![index].artist}",
                                                  style: TextStyle(
                                                      color: controller
                                                                      .playindex
                                                                      .value ==
                                                                  index &&
                                                              controller
                                                                      .isplaying
                                                                      .value ==
                                                                  true
                                                          ? Colors.white
                                                          : Colors.white,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontSize: 11),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 5, 0, 0),
                                                  child: Container(
                                                    height: 20,
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          0, 15, 0, 0),
                                                      child: Slider(
                                                        min: const Duration(
                                                                seconds: 0)
                                                            .inSeconds
                                                            .toDouble(),
                                                        max: controller
                                                            .max.value,
                                                        value: controller
                                                            .value.value,
                                                        onChanged: (newValue) {
                                                          controller
                                                              .updateSlider(
                                                                  newValue
                                                                      .toInt());
                                                          newValue = newValue;
                                                          if (newValue
                                                                  .toInt() ==
                                                              controller
                                                                  .max.value) {
                                                            controller
                                                                .audioplayer
                                                                .pause();
                                                            controller
                                                                .isplaying(
                                                                    false);
                                                          }
                                                        },
                                                        activeColor:
                                                            Colors.white,
                                                        inactiveColor:
                                                            Colors.white30,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    IconButton(
                                                        onPressed: () {
                                                          controller.playAudio(
                                                              snapshot
                                                                  .data![controller
                                                                          .playindex
                                                                          .value -
                                                                      1]
                                                                  .uri,
                                                              controller
                                                                      .playindex
                                                                      .value -
                                                                  1);
                                                        },
                                                        icon: Icon(
                                                            Icons.skip_previous,
                                                            color: Colors.white,
                                                            size:
                                                                mq.size.width *
                                                                    0.07)),
                                                    Obx(
                                                      () => CircleAvatar(
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        child: Transform.scale(
                                                          scale: mq.size.width *
                                                              0.003,
                                                          child: IconButton(
                                                            onPressed: () {},
                                                            icon: InkWell(
                                                              child: Icon(
                                                                controller
                                                                        .isplaying
                                                                        .value
                                                                    ? Icons
                                                                        .pause
                                                                    : Icons
                                                                        .play_arrow_rounded,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              onTap: () {
                                                                if (controller
                                                                    .isplaying
                                                                    .value) {
                                                                  controller
                                                                      .audioplayer
                                                                      .pause();
                                                                  controller
                                                                      .isplaying(
                                                                          false);
                                                                  controller
                                                                      .i(1);
                                                                } else {
                                                                  controller
                                                                      .audioplayer
                                                                      .play();
                                                                  controller
                                                                      .isplaying(
                                                                          true);
                                                                  controller
                                                                      .i(1);
                                                                }
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    IconButton(
                                                        onPressed: () {
                                                          controller.playAudio(
                                                              snapshot
                                                                  .data![controller
                                                                          .playindex
                                                                          .value +
                                                                      1]
                                                                  .uri,
                                                              controller
                                                                      .playindex
                                                                      .value +
                                                                  1);
                                                        },
                                                        icon: Icon(
                                                            Icons.skip_next,
                                                            color: Colors.white,
                                                            size:
                                                                mq.size.width *
                                                                    0.07))
                                                  ],
                                                ),
                                              ],
                                            )
                                          : Text(
                                              "${snapshot.data![index].artist}",
                                              style: TextStyle(
                                                  color: controller.playindex
                                                                  .value ==
                                                              index &&
                                                          controller.isplaying
                                                                  .value ==
                                                              true
                                                      ? Colors.white
                                                      : Colors.white,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontSize: 11),
                                            ),
                                      leading: const Icon(
                                        Icons.music_note,
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                      // Stack(children: [
                                      //   // const RiveAnimation.asset('assets/rive/simple_radial_visualizer.riv'),
                                      //   QueryArtworkWidget(
                                      //     id: snapshot.data![index].id,
                                      //     type: ArtworkType.AUDIO,
                                      //     nullArtworkWidget: Icon(
                                      //       Icons.music_note,
                                      //       color: controller.playindex.value ==
                                      //                   index &&
                                      //               controller
                                      //                       .isplaying.value ==
                                      //                   true
                                      //           ? Colors.white
                                      //           : Colors.white,
                                      //       size: 32,
                                      //     ),
                                      //   ),
                                      // ]),
                                      trailing: controller.playindex.value ==
                                                  index &&
                                              controller.isplaying.value == true
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: const [
                                                InkWell(
                                                  child: Icon(
                                                    Icons.favorite_border,
                                                    color: Colors.white,
                                                    size: 26,
                                                  ),
                                                ),
                                                InkWell(
                                                  child: Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                    size: 26,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : null,
                                      onTap: () {
                                        x = x + 1;
                                        controller.playAudio(
                                            snapshot.data![index].uri, index);
                                        Get.to(
                                            () => player(data: snapshot.data!));
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(
                top: mq.size.height * 0.12,
                left: mq.size.width * 0.05,
                right: mq.size.width * 0.05),
            height: mq.size.height * 0.05,
            width: mq.size.width * 0.9,
            decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [b1, b2, b3]),
                boxShadow: [
                  const BoxShadow(
                    color: b1,
                    spreadRadius: 0.2,
                    blurRadius: 5,
                    offset: Offset(0, 1),
                  ).scale(3)
                ],
                borderRadius: BorderRadius.circular(8)),
            child: Row(children: [
              Padding(
                padding: EdgeInsets.only(left: 5, bottom: 2),
                child: Container(
                  height: mq.size.height * 0.05,
                  width: mq.size.width * 0.75,
                  child: TextFormField(
                    style: const TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    cursorHeight: mq.size.height * 0.03,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      hintText: 'Search the music',
                      hintStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.search_rounded,
                    color: Colors.white,
                    size: mq.size.width * 0.08,
                  ))
            ]),
          ),
          Center(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                  top: mq.size.height * 0.91,
                  left: mq.size.width * 0.05,
                  right: mq.size.width * 0.05),
              height: mq.size.height * 0.06,
              width: mq.size.width * 0.6,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [b1, b2, b3]),
                  boxShadow: [
                    const BoxShadow(
                      color: b1,
                      spreadRadius: 0.2,
                      blurRadius: 5,
                      offset: Offset(0, 1),
                    ).scale(3)
                  ],
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.home,
                        color: Colors.white,
                        size: mq.size.width * 0.08,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.list_outlined,
                        color: Colors.white,
                        size: mq.size.width * 0.08,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                        size: mq.size.width * 0.08,
                      ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class visualcomponent extends StatefulWidget {
  const visualcomponent({Key? key, required this.duration, required this.color})
      : super(key: key);

  final int duration;
  final Color color;

  @override
  State<visualcomponent> createState() => _visualcomponentState();
}

class _visualcomponentState extends State<visualcomponent>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(
        duration: Duration(milliseconds: widget.duration), vsync: this);
    final curvedanimation = CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn);

    animation = Tween<double>(begin: 0, end: 100).animate(curvedanimation)
      ..addListener(() {
        setState(() {});
      });

    animationController.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context);
    return Container(
      width: 10,
      decoration: BoxDecoration(
          color: widget.color, borderRadius: BorderRadius.circular(1)),
      height: animation.value,
    );
  }
}

class MusicVisualizer extends StatelessWidget {
  List<Color> colors = [
    Colors.yellowAccent,
    Colors.redAccent,
    Colors.lightBlue,
    Colors.lightGreenAccent
  ];
  List<int> duration = [900, 700, 600, 800, 500];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: new List<Widget>.generate(
          10,
          (index) => visualcomponent(
              duration: duration[index % 5], color: colors[index % 4])),
    );
  }
}
