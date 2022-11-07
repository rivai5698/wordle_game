import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:lottie/lottie.dart';
import 'package:wordle/common/board/board.dart';
import 'package:wordle/common/dialog/coin_dialog.dart';
import 'package:wordle/common/dialog/setting_dialog.dart';
import 'package:wordle/common/keyboard/my_keyboard.dart';
import 'package:wordle/common/toast/toast_loading.dart';
import 'package:wordle/common/toast/toast_overlay.dart';
import 'package:wordle/const/const_color.dart';
import 'package:wordle/service/audio_service.dart';
import 'package:wordle/service/check_grammar_api_service.dart';
import 'package:wordle/service/check_grammar_service.dart';
import 'package:wordle/wordle/module/game/coin_bloc.dart';
import 'package:wordle/wordle/module/game/wordle_bloc.dart';
import 'package:wordle/wordle/module/login/login_page.dart';
import 'package:wordle/wordle/module/word_collection/word_collection_bloc.dart';
import '../../../service/shared_preferences_manager.dart';
import '../../model/letter_model.dart';
import '../../model/word_model.dart';

class WordlePage extends StatefulWidget {
  final Word solution;
  final String player;
  final bool isPlaying;
  final int level;

  const WordlePage(
      {super.key,
      required this.solution,
      required this.player,
      required this.level,
      required this.isPlaying});

  @override
  State<WordlePage> createState() => _WordlePageState();
}

class _WordlePageState extends State<WordlePage> {
  WordleBloc? wordleBloc;
  FlutterTts flutterTts = FlutterTts();
  List<Word>? board;
  GameStatus status = GameStatus.playing;
  bool isPlaying = true;
  bool audioCheck = true;
  int _currentWordIndex = 0;
  String? answer;
  Word? get _currentWord =>
      _currentWordIndex < board!.length ? board![_currentWordIndex] : null;
  List<List<GlobalKey<FlipCardState>>>? _flipCardKeys;
  Word? solution;
  List<String> collection = [];
  Set<Letter> keyBoardLetter = {};
  int? coins;
  int pos = 0;

  @override
  void initState() {
    // TODO: implement initState
    isPlaying = audioStreamService.isPlaying;
    audioCheck = audioStreamService.audioCheck!;
    wordleBloc = WordleBloc();
    board = genBoard(widget.level);
    _flipCardKeys = genFlipCard(widget.level);
    coinStream.initCoin();
    solution = widget.solution;
    answer = 'WORDLE';
    flutterTts.setStartHandler(() {});
    flutterTts.setCompletionHandler(() {});
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
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
        Container(
          color: Colors.black,
          child: LottieBuilder.asset(
            'assets/background.json',
            height: heightDevice,
            fit: BoxFit.fill,
          ),
        ),
        Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            // leading: GestureDetector(
            //   onTap: () async {
            //     await hideSM();
            //     Future.delayed(Duration.zero, () {
            //       Navigator.pushAndRemoveUntil(
            //           context,
            //           MaterialPageRoute(
            //               builder: (_) => LoginPage(
            //                     player: widget.player,
            //                     isPlaying: isPlaying,
            //                     audioCheck: audioCheck,
            //                   )),
            //           (route) => false);
            //     });
            //     //stream.closeStream();
            //   },
            //   child: Container(
            //     margin: const EdgeInsets.symmetric(horizontal: 8),
            //     decoration: BoxDecoration(
            //         shape: BoxShape.circle,
            //         //borderRadius: BorderRadius.circular(50),
            //         color: Colors.transparent,
            //         border: Border.all(color: Colors.white, width: 2)),
            //     child: LottieBuilder.asset(
            //       'assets/backbutton.json',
            //     ),
            //     // const Icon(
            //     //   Icons.settings,
            //     //   size: 16,
            //     //   color: Colors.white,
            //     // ),
            //   ),
            // ),
            actions: [
              GestureDetector(
                onTap: () {
                  if(coinStream.coin!>0){
                    if(pos<_currentWord!.letters.length){
                      coinStream.removeCoin();
                      // setState(() {
                      //  // for (var i = 0; i < _currentWord!.letters.length; i++) {
                      //   // _currentWord!.letters[pos] =
                      //    //    solution!.letters[pos].copyWith(status: LetterStatus.correct);
                      //   //_currentWord!.addLetter(solution!.letters[pos].copyWith(status: LetterStatus.correct).val);
                      //   //}
                      // });
                      _onKeyTap(solution!.letters[pos].val);
                      keyBoardLetter.add(_currentWord!.letters[pos]);
                      //_flipCardKeys![_currentWordIndex][pos].currentState!.toggleCard();
                      // setState(() {
                      //   pos = pos+1;
                      // });

                    }
                  }else{
                    ToastOverlay(context).show(type: ToastType.warning,msg: 'You\'re run out of coins');
                  }

                  },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 42,
                  height: 42,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      //borderRadius: BorderRadius.circular(50),
                      color: Colors.transparent,
                      border: Border.all(color: Colors.white, width: 2)),
                  child: LottieBuilder.asset(
                    'assets/light.json',
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isPlaying = audioStreamService.isPlaying;
                    audioCheck = audioStreamService.audioCheck!;
                  });
                  SettingDialog(context, isPlaying, onTap, audioCheck)
                      .showDialog();
                  //stream.closeStream();
                },
                child: Container(
                  margin:  const EdgeInsets.all(8),
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      //borderRadius: BorderRadius.circular(50),
                      color: Colors.transparent,
                      border: Border.all(color: Colors.white, width: 2)),
                  child: LottieBuilder.asset(
                    'assets/settingbutton.json',
                  ),
                  // const Icon(
                  //   Icons.settings,
                  //   size: 16,
                  //   color: Colors.white,
                  // ),
                ),
              ),
            ],
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    await hideSM();
                    Future.delayed(Duration.zero, () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (_) => LoginPage(
                                    player: widget.player,
                                    isPlaying: isPlaying,
                                    audioCheck: audioCheck,
                                  )),
                          (route) => false);
                    });
                    //stream.closeStream();
                  },
                  child: Container(
                    //margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        //borderRadius: BorderRadius.circular(50),
                        color: Colors.transparent,
                        border: Border.all(color: Colors.white, width: 2)),
                    child: LottieBuilder.asset(
                      'assets/backbutton.json',
                      width: 32,
                    ),
                    // const Icon(
                    //   Icons.settings,
                    //   size: 16,
                    //   color: Colors.white,
                    // ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    CoinDialog(context,coinStream.coin ?? 0).showDialog();
                  },
                  child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8,),
                      child: _coinWidget()),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      answer!,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: widget.level == 6 ? 28 : 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.005),
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // MyBoard(
              //   board: board,
              //   height: widthDevice / 7,
              //   width: widthDevice / 7,
              //   flipCardKey: _flipCardKeys,
              // ),
              Container(
                color: Colors.transparent,
                height: heightDevice < 680 && widget.level == 6
                    ? 0
                    : heightDevice / 12,
              ),
              Expanded(
                child: Center(
                  child: MyBoard(
                    board: board!,
                    height: widthDevice < 600 && widthDevice > 280
                        ? widthDevice / 7
                        : widthDevice <= 280
                            ? widthDevice / 10
                            : widthDevice / 9,
                    width: widthDevice < 600 && widthDevice > 280
                        ? widthDevice / 7
                        : widthDevice <= 280
                            ? widthDevice / 10
                            : widthDevice / 9,
                    flipCardKey: _flipCardKeys!,
                  ),
                  // child: StreamBuilder<Word>(
                  //   stream: wordleBloc!.streamWord,
                  //   builder: (_, snapshot) {
                  //     //ToastLoadingOverlay toast = ToastLoadingOverlay(context);
                  //     // toast.show();
                  //     if (snapshot.hasError) {
                  //       return const Center(
                  //         child: Text('Error'),
                  //       );
                  //     }
                  //     if (snapshot.hasData) {
                  //       solution = snapshot.data;
                  //       if (heightDevice < 680) {
                  //         return MyBoard(
                  //           board: board,
                  //           height: widthDevice / 7,
                  //           width: widthDevice / 7,
                  //           flipCardKey: _flipCardKeys,
                  //         );
                  //       } else {
                  //         return MyBoard(
                  //           board: board,
                  //           height: widthDevice / 7,
                  //           width: widthDevice / 7,
                  //           flipCardKey: _flipCardKeys,
                  //         );
                  //       }
                  //     }
                  //     return Center(
                  //       child: AnimatedTextKit(
                  //         repeatForever: true,
                  //         animatedTexts: [
                  //           FadeAnimatedText(
                  //             'Loading',
                  //             textStyle: const TextStyle(
                  //                 fontSize: 32.0, fontWeight: FontWeight.bold),
                  //           ),
                  //           ScaleAnimatedText(
                  //             'Loading',
                  //             textStyle: const TextStyle(
                  //                 fontSize: 70.0, fontFamily: 'Canterbury'),
                  //           ),
                  //         ],
                  //       ),
                  //     );
                  //   },
                  // ),
                ),
              ),
              Container(),
              SafeArea(
                child: heightDevice < 680
                    ? MyKeyBoard(
                        height: 40,
                        width: widthDevice <= 280
                            ? widthDevice / 15
                            : widthDevice / 12,
                        onKeyTap: _onKeyTap,
                        onDelTap: _onDelTap,
                        onEnterTap: _onEnterTap,
                        letters: keyBoardLetter,
                      )
                    : MyKeyBoard(
                        height: 48,
                        width: widthDevice / 12,
                        onKeyTap: _onKeyTap,
                        onDelTap: _onDelTap,
                        onEnterTap: _onEnterTap,
                        letters: keyBoardLetter,
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _onKeyTap(String val) {
    if (status == GameStatus.playing) {
      setState(() {
        pos = pos + 1;
        _currentWord?.addLetter(val);
      });
    }
  }

  void _onDelTap() {
    if (status == GameStatus.playing) {
      setState(() {
        if(pos>0){
          pos = pos -1;
        }
        _currentWord?.removeLetter();
      });
    }
  }

  Future<void> _onEnterTap() async {
    if (status == GameStatus.playing &&
        _currentWord != null &&
        !_currentWord!.letters.contains(Letter.empty())) {
      if (_currentWord!.wordStr == solution!.wordStr) {
        for (var i = 0; i < _currentWord!.letters.length; i++) {
          status = GameStatus.submitting;
          final currentWordLetter = _currentWord!.letters[i];
          print('currentWordLetter $currentWordLetter');
          final currentSolutionLetter = solution!.letters[i];
          setState(() {
            if (currentWordLetter == currentSolutionLetter) {
              _currentWord!.letters[i] =
                  currentWordLetter.copyWith(status: LetterStatus.correct);
            } else if (solution!.letters.contains(currentWordLetter)) {
              _currentWord!.letters[i] =
                  currentWordLetter.copyWith(status: LetterStatus.inWord);
            } else {
              _currentWord!.letters[i] =
                  currentWordLetter.copyWith(status: LetterStatus.notInWord);
            }
          });
          final letter = keyBoardLetter.firstWhere(
            (e) => e.val == currentWordLetter.val,
            orElse: () => Letter.empty(),
          );
          if (letter.status != LetterStatus.correct) {
            keyBoardLetter.removeWhere((e) => e.val == currentWordLetter.val);
            keyBoardLetter.add(_currentWord!.letters[i]);
          }
          await Future.delayed(
            const Duration(microseconds: 150),
            () =>
                _flipCardKeys![_currentWordIndex][i].currentState!.toggleCard(),
          );
        }
        checkWin();
      } else {
        var check = await checkGrammar(_currentWord!.wordStr);
        if (check) {
          //print('check: $check');
          for (var i = 0; i < _currentWord!.letters.length; i++) {
            status = GameStatus.submitting;
            final currentWordLetter = _currentWord!.letters[i];
            final currentSolutionLetter = solution!.letters[i];
            setState(() {
              if (currentWordLetter == currentSolutionLetter) {
                _currentWord!.letters[i] =
                    currentWordLetter.copyWith(status: LetterStatus.correct);
              } else if (solution!.letters.contains(currentWordLetter)) {
                _currentWord!.letters[i] =
                    currentWordLetter.copyWith(status: LetterStatus.inWord);
              } else {
                _currentWord!.letters[i] =
                    currentWordLetter.copyWith(status: LetterStatus.notInWord);
              }
            });
            final letter = keyBoardLetter.firstWhere(
              (e) => e.val == currentWordLetter.val,
              orElse: () => Letter.empty(),
            );
            if (letter.status != LetterStatus.correct) {
              keyBoardLetter.removeWhere((e) => e.val == currentWordLetter.val);
              keyBoardLetter.add(_currentWord!.letters[i]);
            }
            await Future.delayed(
              const Duration(microseconds: 150),
              () => _flipCardKeys![_currentWordIndex][i]
                  .currentState!
                  .toggleCard(),
            );
          }
          checkWin();
        } else {
          Future.delayed(Duration.zero, () {
            ToastOverlay(context)
                .show(type: ToastType.warning, msg: 'Not in word list');
          });
        }
      }
    }
  }

  Widget _coinWidget() {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          //borderRadius: BorderRadius.circular(50),
          color: Colors.transparent,
          border: Border.all(color: Colors.white, width: 2)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: StreamBuilder<int>(
              stream: coinStream.coinStream,
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  String coin = snapshot.data.toString();
                  if (snapshot.data! >= 1000) {
                    coin = snapshot.data.toString().replaceRange(coin.length - 3, coin.length, 'K');
                  }
                  return Text(
                    coin,
                    style: const TextStyle(fontSize: 12),
                  );
                }
                return const Text(
                  '0',
                  style: TextStyle(fontSize: 12),
                );
              },
            ),
          ),
          const Icon(
            Icons.currency_bitcoin,
            size: 12,
          ),
        ],
      ),
    );
  }

  Future<void> checkWin() async {
    await sharedPrefs.init();
    var a = await sharedPrefs.getStringList('collections');
    if (a == null) {
      collection.addAll([]);
    } else {
      collection.clear();
      collection.addAll(a);
    }
    if (_currentWord!.wordStr == solution?.wordStr) {
      coinStream.addCoin(widget.level-2);
      status = GameStatus.won;
      setState(() {
        collection.add(solution!.wordStr);
        collectionService.addString(collection);
      });
      _speak(
          'Congratulation! the answer is ${solution!.wordStr.toLowerCase()}');
      Future.delayed(Duration.zero, () {
        sharedPrefs.setStringList('collections', collection);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            dismissDirection: DismissDirection.none,
            duration: const Duration(days: 1),
            backgroundColor: correctColor,
            content: const Text(
              'You won',
              style: TextStyle(color: Colors.white),
            ),
            action: SnackBarAction(
              onPressed: _restart,
              label: 'New Game',
              textColor: Colors.white,
            ),
          ),
        );
      });
    } else if (_currentWordIndex + 1 >= board!.length) {
      status = GameStatus.lost;
      setState(() {
        answer = '${solution?.wordStr}';
      });
      _speak('The answer is ${answer!.toLowerCase()}, good luck for next time');
      Future.delayed(Duration.zero, () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            dismissDirection: DismissDirection.none,
            duration: const Duration(days: 1),
            backgroundColor: Colors.red,
            content: const Text(
              'You lost',
              style: TextStyle(color: Colors.white),
            ),
            action: SnackBarAction(
              onPressed: _restart,
              label: 'New Game',
              textColor: Colors.white,
            ),
          ),
        );
      });
    } else {
      status = GameStatus.playing;
    }
    _currentWordIndex += 1;
  }

  Future<bool> checkGrammar(String word) async {
    dynamic str;
    await checkService.checkWord(word: word).then((value) {
      //print(value.toString());
      str = value.toString();
      return true;
    }).catchError((e) {
      //print(e);
      return false;
    });
    if (str == null) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> _restart() async {
    ToastLoadingOverlay toastLoadingOverlay = ToastLoadingOverlay(context);
    toastLoadingOverlay.show();
    await wordleBloc!.genWord(widget.level);
    toastLoadingOverlay.hide();
    setState(() {
      pos=0;
      answer = 'WORDLE';
      status = GameStatus.playing;
      _currentWordIndex = 0;
      board = genBoard(widget.level);
      _flipCardKeys = genFlipCard(widget.level);
      // board!
      //   ..clear()
      //   ..addAll(List.generate(
      //       widget.level + 1,
      //       (_) => Word(
      //           letters: List.generate(widget.level, (_) => Letter.empty()))));
      // _flipCardKeys!
      //   ..clear()
      //   ..addAll(List.generate(
      //       widget.level + 1,
      //       (_) => List.generate(
      //           widget.level, (_) => GlobalKey<FlipCardState>())));
      solution = wordleBloc!.solution;
    });
    keyBoardLetter.clear();
  }

  genBoard(int level) {
    if (level == 3) {
      return List.generate(level + 3,
          (_) => Word(letters: List.generate(level, (_) => Letter.empty())));
    } else {
      return List.generate(level + 1,
          (_) => Word(letters: List.generate(level, (_) => Letter.empty())));
    }
  }

  genFlipCard(int level) {
    if (level == 3) {
      return List.generate(level + 3,
          (_) => List.generate(level, (_) => GlobalKey<FlipCardState>()));
    } else {
      return List.generate(level + 1,
          (_) => List.generate(level, (_) => GlobalKey<FlipCardState>()));
    }
  }

  Future<void> onTap() async {
    bool? audioCheck = await sharedPrefs.getBool('audio');
    if (audioCheck!) {
      //sharedPrefs.setBool('audio', false);
      audioStreamService.setTts(false);
    } else {
      //sharedPrefs.setBool('audio', true);
      audioStreamService.setTts(true);
    }
    //print('audio: $audioCheck');
  }

  //Future<void> onTap() async {
  // await hideSM();
  // Future.delayed(Duration.zero, () {
  //   Navigator.pushAndRemoveUntil(
  //       context,
  //       MaterialPageRoute(
  //           builder: (_) => LoginPage(
  //                 player: widget.player,
  //                 isPlaying: widget.isPlaying,
  //               )),
  //       (route) => false);
  // });
  // }

  Future<void> hideSM() async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  Future _speak(String text) async {
    bool audioCheck = audioStreamService.audioCheck!;
    if (audioCheck) {
      await flutterTts.setVoice({"name": "Karen", "locale": "en-AU"});
      await flutterTts.setLanguage("en-US");
      await flutterTts.setPitch(1);
      await flutterTts.speak(text);
    }
  }
}
