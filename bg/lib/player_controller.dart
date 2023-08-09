import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class PlayerController extends GetxController{

  final audioQuery = OnAudioQuery();
  final audioplayer = AudioPlayer();
  var playindex = 0.obs;
  var isplaying = false.obs;
  var duration = ''.obs;
  var position = ''.obs;
  var max = 0.0.obs;
  var value = 0.0.obs;
  var i = 0.obs;

  @override
  void onInit() {
    super.onInit();
    checkPermission();
  }

  updatePosition(){
    audioplayer.durationStream.listen((d) {
      duration.value = d.toString().split('.')[0];
      max.value = d!.inSeconds.toDouble();
    });
    audioplayer.positionStream.listen((p) {
      position.value = p.toString().split('.')[0];
      value.value = p!.inSeconds.toDouble();
    });
  }

  updateSlider(sec){
    var duration = Duration(seconds : sec);
    audioplayer.seek(duration);
  }

  playAudio(String? uri, int index){
    playindex.value = index;
    try{
      audioplayer.setAudioSource(
          AudioSource.uri(Uri.parse(uri!))
      );
      audioplayer.play();
      isplaying(true);
      updatePosition();
    }
    on Exception catch(e){
      print(e.toString());
    }
  }


  pauseAudio(String? uri, int index){
    playindex.value = index;
    try{
      audioplayer.setAudioSource(
          AudioSource.uri(Uri.parse(uri!))
      );
      audioplayer.pause();
      isplaying(false);
    }
    on Exception catch(e){
      print(e.toString());
    }
  }


  checkPermission() async {
    var perm = await Permission.storage.request();
    if(perm.isGranted)
    {
    }
    else {
      checkPermission();
    }
  }


}