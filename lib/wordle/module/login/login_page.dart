import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nice_buttons/nice_buttons.dart';
import 'package:wordle/common/dialog/help_dialog.dart';
import 'package:wordle/common/dialog/setting_dialog.dart';
import 'package:wordle/common/toast/toast_loading.dart';
import 'package:wordle/service/audio_service.dart';
import 'package:wordle/service/shared_preferences_manager.dart';
import 'package:wordle/wordle/module/word_collection/word_collection.dart';
import '../game/wordle_bloc.dart';
import '../game/wordle_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage(
      {Key? key,
      required this.player,
      required this.isPlaying,
      required this.audioCheck})
      : super(key: key);
  final String player;
  final bool isPlaying;
  final bool audioCheck;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //AudioService? _audioService;
  WordleBloc? wordleBloc;
  bool? isPlaying;
  bool? audioCheck;
  double turns = 0.0;
  bool isOk = true;
  @override
  void initState() {
    // TODO: implement initState
    isPlaying = audioStreamService.getPlay();
    audioCheck = audioStreamService.audioCheck;
    wordleBloc = WordleBloc();
    isPlaying = widget.isPlaying;
    audioCheck = widget.audioCheck;
    //_audioService = AudioService();
    Future.delayed(const Duration(seconds: 0), () {
      setState(() {
        turns += 0.5;
      });
      initTurn();
    });
    // setState(() { });
    super.initState();
  }

  initTurn() {
    if (isOk) {
      setState(() {
        Future.delayed(const Duration(seconds: 10), () {
          turns += 0.5;
        });
      });
    }
    //print(turns);
  }

  initTurn2() {
    setState(() {
      if (isOk) {
        turns = 0;
        Future.delayed(const Duration(seconds: 10), () {
          initTurn();
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    Future.delayed(const Duration(seconds: 10), () {
      initTurn();
    });
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    double widthDevice = MediaQuery.of(context).size.width;
    double heightDevice = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Container(
          color: Colors.black,
          child: LottieBuilder.asset(
            'assets/background.json',
            height: heightDevice,
            fit: BoxFit.fill,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              const SizedBox(
                height: 80,
              ),
              AnimatedRotation(
                turns: turns,
                duration: const Duration(seconds: 10),
                child: Image.asset(
                  'assets/logo.png',
                  width: widthDevice / 2,
                ),
              ),
              Expanded(
                child: Center(
                    child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      NiceButtons(
                        width: 100,
                        height: 100,
                        stretch: false,
                        borderRadius: 50,
                        startColor: Colors.green.shade300,
                        endColor: Colors.green,
                        borderColor: Colors.green,
                        gradientOrientation: GradientOrientation.Horizontal,
                        onTap: (finish) {
                          //audioStream.pauseAudio();
                          choseLevel(3);
                        },
                        child: const Text(
                          'EASY',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      NiceButtons(
                        width: 100,
                        height: 100,
                        stretch: false,
                        borderRadius: 50,
                        startColor: Colors.blue.shade300,
                        endColor: Colors.blue,
                        borderColor: Colors.blue,
                        gradientOrientation: GradientOrientation.Horizontal,
                        onTap: (finish) {
                          //audioStream.pauseAudio();
                          choseLevel(5);
                        },
                        child: const Text(
                          'CASUAL',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      NiceButtons(
                        borderRadius: 50,
                        width: 100,
                        height: 100,
                        stretch: false,
                        startColor: Colors.red.shade300,
                        endColor: Colors.redAccent,
                        borderColor: Colors.redAccent,
                        gradientOrientation: GradientOrientation.Horizontal,
                        onTap: (finish) {
                          //audioStream.pauseAudio();
                          choseLevel(6);
                        },
                        child: const Text(
                          'HARD',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                )),
              ),
              SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    NiceButtons(
                      stretch: false,
                      width: 64,
                      height: 64,
                      borderRadius: 16,
                      startColor: Colors.green.shade300,
                      endColor: Colors.green,
                      borderColor: Colors.green,
                      gradientOrientation: GradientOrientation.Horizontal,
                      onTap: (finish) {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) => WordCollectionPage(
                              player: widget.player,
                              isPlaying: widget.isPlaying,
                            ),
                            transitionDuration: const Duration(seconds: 1),
                            transitionsBuilder: (_, a, __, c) =>
                                FadeTransition(opacity: a, child: c),
                          ),
                        );
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: LottieBuilder.asset('assets/collection.json')),
                      // const Icon(
                      //   Icons.book,
                      //   color: Colors.white,
                      // ),
                    ),
                    NiceButtons(
                      stretch: false,
                      width: 64,
                      height: 64,
                      borderRadius: 16,
                      startColor: Colors.green.shade300,
                      endColor: Colors.green,
                      borderColor: Colors.green,
                      gradientOrientation: GradientOrientation.Horizontal,
                      onTap: (finish) {
                        HelpDialog(context).showDialog();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: LottieBuilder.asset(
                          'assets/questionbutton.json',
                        ),
                      ),
                      // const Icon(
                      //   Icons.question_mark_sharp,
                      //   color: Colors.white,
                      // ),
                    ),
                    NiceButtons(
                      stretch: false,
                      width: 64,
                      height: 64,
                      borderRadius: 16,
                      startColor: Colors.green.shade300,
                      endColor: Colors.green,
                      borderColor: Colors.green,
                      gradientOrientation: GradientOrientation.Horizontal,
                      onTap: (finish) async {
                        setState(() {
                          isPlaying = audioStreamService.isPlaying;
                          audioCheck = audioStreamService.audioCheck;
                        });
                        Future.delayed(Duration.zero, () {
                          SettingDialog(context, isPlaying!, onTap, audioCheck!)
                              .showDialog();
                        });
                      },
                      child: LottieBuilder.asset(
                        'assets/settingbutton.json',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future choseLevel(int level) async {
    setState(() {
      isOk = false;
    });
    var toastLoadingOverlay = ToastLoadingOverlay(context);
    toastLoadingOverlay.show();
    await wordleBloc?.genWord(level);
    var sol = wordleBloc?.solution;

    toastLoadingOverlay.hide();
    Future.delayed(Duration.zero, () {
      Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => WordlePage(
            isPlaying: widget.isPlaying,
            solution: sol!,
            player: widget.player,
            level: level,
          ),
          transitionDuration: const Duration(seconds: 1),
          transitionsBuilder: (_, a, __, c) =>
              FadeTransition(opacity: a, child: c),
        ),
        (route) => false,
      );

      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(
      //         builder: (_) => WordlePage(
      //               solution: sol,
      //               player: widget.player,
      //               level: level,
      //             ),
      //
      //     ),
      //     (route) => false);
    });
  }

  Future<void> onTap() async {
    bool? audioCheck = await sharedPrefs.getBool('audio');
    //print('_LoginPageState.onTap $audioCheck');
    if (audioCheck!) {
      //sharedPrefs.setBool('audio', false);
      audioStreamService.setTts(false);
    } else {
      //sharedPrefs.setBool('audio', true);
      audioStreamService.setTts(true);
    }
  }
}
