import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:wordle/service/shared_preferences_manager.dart';

class AudioService {
  static final AudioService _audioService = AudioService._internal();
  factory AudioService() => _audioService;
  AudioService._internal();

  final assetsAudioPlayer = AssetsAudioPlayer();

  final _audioStreamController = StreamController<bool>.broadcast();
  final _ttsStreamController = StreamController<bool>.broadcast();
  Stream<bool> get audioStream => _audioStreamController.stream;
  Stream<bool> get ttsStream => _ttsStreamController.stream;

  bool isPlaying = true;
  bool? audioCheck;

  Future init() async {
    //sharedPrefs.init();
    await getTts();
    await playAudio();
  }

  Future<bool> getTts() async {
    audioCheck = (await sharedPrefs.getBool('audio'))!;
    _ttsStreamController.add(audioCheck!);
    return audioCheck!;
  }
  setTts(bool isPlay){
    audioCheck = isPlay;
    _ttsStreamController.add(audioCheck!);
    sharedPrefs.setBool('audio', audioCheck!);
  }

  bool getPlay(){
    _audioStreamController.add(isPlaying);
    getTts();
    return isPlaying;
  }

  disposeAudio(){
    assetsAudioPlayer.dispose();
  }

  playAudio() {
     assetsAudioPlayer.open(
      Audio("assets/audiobackground.mp3"),
      autoStart: true,
      showNotification: true,
      loopMode: LoopMode.single,
    );
    isPlaying = true;
    _audioStreamController.add(isPlaying);
  }

  pauseAudio() {
    assetsAudioPlayer.pause();
    isPlaying = false;
    _audioStreamController.add(isPlaying);
  }

  resumeAudio(){
    if(!assetsAudioPlayer.isPlaying.value){
      assetsAudioPlayer.play();
      isPlaying = true;
      _audioStreamController.add(isPlaying);
    }else{
      isPlaying = false;
      _audioStreamController.add(isPlaying);
    }
  }
}

var audioStreamService = AudioService();
