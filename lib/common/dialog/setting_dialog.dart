import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nice_buttons/nice_buttons.dart';
import 'package:wordle/service/audio_service.dart';

import '../../service/shared_preferences_manager.dart';

class SettingDialog {
  final BuildContext context;
  final bool isPlaying;
  final bool audioCheck;
  SettingDialog(this.context, this.isPlaying, this.onTap, this.audioCheck);
  final VoidCallback onTap;
  Future<void> showDialog() async {
    await sharedPrefs.init();
    print('SettingDialog.showDialog $isPlaying and $audioCheck');
    // sharedPrefs.setBool('isPlaying', isPlaying);
    // audioCheck = await sharedPrefs.getBool('audio');
    // if(audioCheck==null){
    //   await sharedPrefs.setBool('audio', true);
    // }
    //audioCheck = audio;
    Future.delayed(Duration.zero, () {
      showGeneralDialog(
          barrierDismissible: false,
          barrierColor: Colors.grey.withOpacity(0.2),
          barrierLabel:
              MaterialLocalizations.of(context).modalBarrierDismissLabel,
          context: context,
          pageBuilder: (_, __, ___) {
            return Container(
              alignment: Alignment.center,
              child: Material(
                color: Colors.transparent,
                child: Center(
                  child: _myDialog(isPlaying, audioCheck),
                ),
              ),
            );
          });
    });
  }

  Widget _myDialog(bool isPlaying, bool audioCheck) {
    //var stream = AudioService();
    return Container(
      width: double.infinity,
      height: 300,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.brown.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Positioned(
            child: SizedBox(
              height: 300,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'SETTINGS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(color: Colors.yellow.shade200),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Icon(
                                Icons.circle,
                                color: Colors.brown,
                                size: 16,
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Icon(
                                Icons.circle,
                                color: Colors.brown,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.brown.shade200, width: 2),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          height: 180,
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 7),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              StreamBuilder<bool>(
                                stream: audioStreamService.ttsStream,
                                  builder: (_,snapshot){
                                  if(snapshot.hasData){
                                    return NiceButtons(
                                      stretch: false,
                                      startColor: Colors.green.shade300,
                                      endColor: Colors.green,
                                      borderColor: Colors.green,
                                      width: 100,
                                      height: 60,
                                      gradientOrientation:
                                      GradientOrientation.Horizontal,
                                      onTap: (finish) async {
                                        bool? audioCheck = await sharedPrefs.getBool('audio');
                                        if(audioCheck!){
                                          //sharedPrefs.setBool('audio', false);
                                          audioStreamService.setTts(false);
                                        }else{
                                          //sharedPrefs.setBool('audio', true);
                                          audioStreamService.setTts(true);
                                        }
                                      },
                                      child: snapshot.data! ? const Icon(Icons.volume_up) : const Icon(Icons.volume_off),
                                    );
                                  }
                                return NiceButtons(
                                  stretch: false,
                                  startColor: Colors.green.shade300,
                                  endColor: Colors.green,
                                  borderColor: Colors.green,
                                  width: 100,
                                  height: 60,
                                  gradientOrientation:
                                  GradientOrientation.Horizontal,
                                  onTap: (finish) => onTap(),
                                  child: audioCheck ? const Icon(Icons.volume_up) : const Icon(Icons.volume_off),
                                );
                              },),

                              StreamBuilder<bool>(
                                stream: audioStreamService.audioStream,
                                builder: (_, snapshot) {
                                  if (snapshot.hasData) {
                                    var check = snapshot.data;
                                    print('a: $check');
                                    return NiceButtons(
                                      stretch: false,
                                      startColor: Colors.green.shade300,
                                      endColor: Colors.green,
                                      borderColor: Colors.green,
                                      width: 100,
                                      height: 60,
                                      gradientOrientation:
                                          GradientOrientation.Horizontal,
                                      onTap: (finish) {
                                        print('SettingDialog._myDialog ${audioStreamService.assetsAudioPlayer.isPlaying.value}');
                                        if (audioStreamService.assetsAudioPlayer
                                            .isPlaying.value) {
                                          audioStreamService.pauseAudio();
                                          sharedPrefs.setBool('isPlayed', false);
                                        } else {
                                          audioStreamService.init();
                                          sharedPrefs.setBool('isPlayed', true);
                                        }
                                      },
                                      child: snapshot.data!
                                          ? const Icon(Icons.music_note)
                                          : const Icon(Icons.music_off),
                                    );
                                  }
                                  //return CircularProgressIndicator();
                                  return NiceButtons(
                                    stretch: false,
                                    startColor: Colors.green.shade300,
                                    endColor: Colors.green,
                                    borderColor: Colors.green,
                                    width: 100,
                                    height: 60,
                                    gradientOrientation:
                                        GradientOrientation.Horizontal,
                                    onTap: (finish) {
                                      print('SettingDialog._myDialog ${audioStreamService.assetsAudioPlayer.isPlaying.value}');
                                      if (audioStreamService
                                          .assetsAudioPlayer.isPlaying.value) {
                                        audioStreamService.pauseAudio();
                                        sharedPrefs.setBool('isPlayed', false);
                                      } else {
                                        audioStreamService.init();
                                        sharedPrefs.setBool('isPlayed', true);

                                      }
                                    },
                                    child: isPlaying
                                        ? const Icon(Icons.music_note)
                                        : const Icon(Icons.music_off),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Icon(
                                Icons.circle,
                                color: Colors.brown,
                                size: 16,
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Icon(
                                Icons.circle,
                                color: Colors.brown,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.yellow.shade300,
                    border: Border.all(color: Colors.brown, width: 2)),
                child:
                  LottieBuilder.asset('assets/closebutton.json')
                // const Icon(
                //   Icons.close,
                //   size: 24,
                //   color: Colors.brown,
                // ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
