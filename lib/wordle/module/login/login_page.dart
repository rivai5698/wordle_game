import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:nice_buttons/nice_buttons.dart';
import 'package:provider/provider.dart';
import 'package:wordle/common/dialog/help_dialog.dart';
import 'package:wordle/common/dialog/setting_dialog.dart';
import 'package:wordle/common/toast/toast_loading.dart';
import 'package:wordle/const/assets_const.dart';
import 'package:wordle/service/app_state.dart';
import 'package:wordle/service/audio_service.dart';
import 'package:wordle/service/shared_preferences_manager.dart';
import 'package:wordle/wordle/module/word_collection/word_collection.dart';
import '../../../generated/l10n.dart';
import '../game/wordle_service.dart';
import '../game/wordle_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key? key,
    required this.player,
    required this.isPlaying,
  }) : super(key: key);
  final String player;
  final bool isPlaying;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  WordleService? wordleBloc;
  bool? isPlaying;
  bool? audioCheck;
  double turns = 0.0;
  double position = 0.0;
  bool isRun = true;
  bool isVisible = true;
  bool isOk = true;
  @override
  void initState() {
    isPlaying = audioStreamService.getPlay();
    audioCheck = audioStreamService.audioCheck;
    wordleBloc = WordleService();
    isPlaying = widget.isPlaying;
    AppState().initAppState();
    //audioCheck = widget.audioCheck;
    //_audioService = AudioService();
    // if (isRun) {
    //   Future.delayed(const Duration(seconds: 0), () {
    //     setState(() {
    //       turns += 0.5;
    //       position += 50;
    //     });
    //     initTurn();
    //   });
    // }

    // setState(() { });
    super.initState();
  }

  initTurn() {
    if (isOk) {
      setState(() {
        Future.delayed(const Duration(seconds: 4), () {
          turns += 0.5;
          position += 50;
          // if(position>MediaQuery.of(context).size.width+120){
          //   isVisible = false;
          //   position = -120;
          // }
          if (position > MediaQuery.of(context).size.width + 120) {
            isVisible = false;
            position = -120;
          }
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
    // if (position > MediaQuery.of(context).size.width + 120) {
    //   isVisible = false;
    //   position = -120;
    // } else {
    //   Future.delayed(const Duration(seconds: 1), () {
    //     isVisible = true;
    //   });
    //   Future.delayed(const Duration(seconds: 4), () {
    //     initTurn();
    //   });
    // }

    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    double widthDevice = MediaQuery.of(context).size.width;
    double heightDevice = MediaQuery.of(context).size.height;
    if (widthDevice > heightDevice) {
      var temp = widthDevice;
      widthDevice = heightDevice;
      heightDevice = temp;
    }
    return Stack(
      children: [
        Consumer<AppState>(
          builder: (_, state, __) {
            return Container(
              color: state.isDarkMode ? Colors.black : Colors.white,
              height: heightDevice,
              width: widthDevice,
              child: LottieBuilder.asset(
                background,
                height: heightDevice,
              ),
            );
          },
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              SizedBox(
                height: heightDevice / (2),
              ),
              Expanded(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: NiceButtons(
                              width: widthDevice / 4,
                              height: 50,
                              stretch: false,
                              borderRadius: 50,
                              startColor: Colors.green.shade300,
                              endColor: Colors.green,
                              borderColor: Colors.green,
                              gradientOrientation:
                                  GradientOrientation.Horizontal,
                              onTap: (finish) {
                                //audioStream.pauseAudio();
                                selectLevel(3);
                              },
                              child: Text(
                                S.of(context).easy,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Flexible(
                            child: NiceButtons(
                              width: widthDevice / 4,
                              height: 50,
                              stretch: false,
                              borderRadius: 50,
                              startColor: Colors.blue.shade300,
                              endColor: Colors.blue,
                              borderColor: Colors.blue,
                              gradientOrientation:
                                  GradientOrientation.Horizontal,
                              onTap: (finish) {
                                selectLevel(5);
                              },
                              child: Text(
                                S.of(context).casual,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Flexible(
                            child: NiceButtons(
                              borderRadius: 50,
                              width: widthDevice / 4,
                              height: 50,
                              stretch: false,
                              startColor: Colors.red.shade300,
                              endColor: Colors.redAccent,
                              borderColor: Colors.redAccent,
                              gradientOrientation:
                                  GradientOrientation.Horizontal,
                              onTap: (finish) {
                                //audioStream.pauseAudio();
                                selectLevel(6);
                              },
                              child: Text(
                                S.of(context).hard,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
              SafeArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
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
                          setState(() {
                            isRun = false;
                            isOk = false;
                          });
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
                            child: LottieBuilder.asset(collection)),
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
                          final appState = context.read<AppState>();
                          var langCheck = appState.languageCode;
                          if (langCheck.contains('vi')) {
                            HelpDialog(context, htpImgVi).showDialog();
                          } else {
                            HelpDialog(context, htpImgEn).showDialog();
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: LottieBuilder.asset(
                            questionButton,
                          ),
                        ),
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
                            SettingDialog(
                                    context, isPlaying!, onTap, audioCheck!)
                                .showDialog();
                          });
                        },
                        child: LottieBuilder.asset(
                          lightSettingButton,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
            right: 8,
            top: 0,
            child: SafeArea(
              child: SizedBox(
                width: 80,
                height: 36,
                child: Consumer<AppState>(
                  builder: (_, state, __) {
                    return AnimatedToggleSwitch<bool>.dual(
                      current: (state.languageCode.contains('en')),
                      first: false,
                      second: true,
                      innerColor: Colors.blueAccent,
                      dif: 10.0,
                      borderColor: Colors.transparent,
                      borderWidth: 5.0,
                      height: 36,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 1.5),
                        ),
                      ],
                      onChanged: (b) {
                        final appState = context.read<AppState>();
                        //print('lang Code${appState.languageCode}');
                        if (appState.languageCode == 'vi') {
                          appState.changeLanguage('en');
                        } else {
                          appState.changeLanguage('vi');
                        }
                      },
                      colorBuilder: (b) => state.languageCode == 'vi'
                          ? Colors.white
                          : Colors.white,
                      iconBuilder: (value) => value
                          ? Center(
                              child: Material(
                                  color: Colors.blueAccent,
                                  child: Container(
                                      color: Colors.white,
                                      child: const Text(
                                        'EN',
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold),
                                      ))))
                          : Center(
                              child: Material(
                                  child: Container(
                              color: Colors.white,
                              child: const Text(
                                'VI',
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ))),
                      textBuilder: (value) => value
                          ? const Material(
                              color: Colors.blueAccent,
                              child: Center(
                                  child: Text(
                                'VI',
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.bold),
                              )),
                            )
                          : const Material(
                              color: Colors.blueAccent,
                              child: Center(
                                  child: Text(
                                'EN',
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.bold),
                              )),
                            ),
                    );
                  },
                ),
              ),
            )),
        Positioned(
            left: 8,
            top: 0,
            child: SafeArea(
              child: SizedBox(
                width: 80,
                height: 36,
                child: Consumer<AppState>(
                  builder: (_, state, __) {
                    return AnimatedToggleSwitch<bool>.dual(
                      innerColor: Colors.green,
                      current: state.isDarkMode,
                      first: false,
                      second: true,
                      dif: 10.0,
                      borderColor: Colors.transparent,
                      borderWidth: 5.0,
                      height: 36,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 1.5),
                        ),
                      ],
                      onChanged: (b) {
                        final appState = context.read<AppState>();
                        appState.changeTheme(!appState.isDarkMode);
                        // setState(() {
                        //   positive = b;
                        // });
                      },
                      colorBuilder: (b) =>
                          state.isDarkMode ? Colors.white : Colors.white,
                      iconBuilder: (value) => value
                          ? const Icon(
                              Icons.dark_mode,
                              color: Colors.black45,
                            )
                          : const Icon(
                              Icons.light_mode,
                              color: Colors.black45,
                            ),
                      textBuilder: (value) => value
                          ? Material(
                              child: Container(
                                color: Colors.green,
                                child: const Icon(
                                  Icons.light_mode,
                                  color: Colors.black45,
                                ),
                              ),
                            )
                          : Material(
                              child: Container(
                                color: Colors.green,
                                child: const Icon(
                                  Icons.dark_mode,
                                  color: Colors.black45,
                                ),
                              ),
                            ),
                    );
                  },
                ),
              ),
            )),
      ],
    );
  }

  Future<void> selectLevel(int level) async {
    setState(() {
      isOk = false;
    });
    var toastLoadingOverlay = ToastLoadingOverlay(context);
    toastLoadingOverlay.show();
    await wordleBloc?.genWord(level);
    //await wordleBloc?.genDefinition();
    var sol = wordleBloc?.solution;
    var def = wordleBloc?.definitions;
    toastLoadingOverlay.hide();
    Future.delayed(Duration.zero, () {
      Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => WordlePage(
            definition: def!,
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
    });
  }

  Future<void> onTap() async {
    bool? audioCheck = await sharedPrefs.getBool('audio');
    if (audioCheck!) {
      audioStreamService.setTts(false);
    } else {
      audioStreamService.setTts(true);
    }
  }
}
