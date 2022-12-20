import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:provider/provider.dart';
import 'package:wordle/common/board/board.dart';
import 'package:wordle/common/dialog/coin_dialog.dart';
import 'package:wordle/common/dialog/setting_dialog.dart';
import 'package:wordle/common/dialog/suggestion_dialog.dart';
import 'package:wordle/common/keyboard/my_keyboard.dart';
import 'package:wordle/common/toast/toast_loading.dart';
import 'package:wordle/common/toast/toast_overlay.dart';
import 'package:wordle/const/assets_const.dart';
import 'package:wordle/service/app_state.dart';
import 'package:wordle/service/audio_service.dart';
import 'package:wordle/service/check_grammar_api_service.dart';
import 'package:wordle/service/check_grammar_service.dart';
import 'package:wordle/wordle/module/game/coin_bloc.dart';
import 'package:wordle/wordle/module/game/wordle_service.dart';
import 'package:wordle/wordle/module/login/login_page.dart';
import 'package:wordle/wordle/module/word_collection/word_collection_bloc.dart';
import '../../../generated/l10n.dart';
import '../../../service/shared_preferences_manager.dart';
import '../../model/letter_model.dart';
import '../../model/word_model.dart';

class WordlePage extends StatefulWidget {
  final Word solution;
  final String definition;
  final String player;
  final bool isPlaying;
  final int level;

  const WordlePage(
      {super.key,
      required this.solution,
      required this.player,
      required this.level,
      required this.definition,
      required this.isPlaying});

  @override
  State<WordlePage> createState() => _WordlePageState();
}

class _WordlePageState extends State<WordlePage> {
  WordleService? wordleBloc;
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
  String hintWord = 'Updating';

  @override
  void initState() {
    isPlaying = audioStreamService.isPlaying;
    audioCheck = audioStreamService.audioCheck!;
    wordleBloc = WordleService();
    board = genBoard(widget.level);
    _flipCardKeys = genFlipCard(widget.level);
    coinStream.initCoin();
    solution = widget.solution;
    answer = 'WORDLE';
    flutterTts.setStartHandler(() {});
    flutterTts.setCompletionHandler(() {});
    hintWord = widget.definition;
    super.initState();
    print('_WordlePageState.initState ${solution!.wordStr} $hintWord');
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
        Consumer<AppState>(
          builder: (_,state,__){
            return Container(
              color: state.isDarkMode ?Colors.black : Colors.white,

            );
          },
        ),
        Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            actions: [
              GestureDetector(
                onTap: () {
                  if (coinStream.coin! > 0) {
                    if (pos < _currentWord!.letters.length) {
                      coinStream.removeCoin();
                      _onKeyTap(solution!.letters[pos].val);
                      keyBoardLetter.add(_currentWord!.letters[pos-1].copyWith(status: LetterStatus.correct));
                    }
                  } else {
                    ToastOverlay(context).show(
                        type: ToastType.warning,
                        msg: S.of(context).runOutCoins);
                  }
                },
                child: Consumer<AppState>(
                  builder: (_,state,__){
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      width: 42,
                      height: 42,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                          border: Border.all(color: state.isDarkMode ? Colors.white : Colors.black, width: 2)),
                      child: LottieBuilder.asset(
                        state.isDarkMode ? lightSuggestButton : darkSuggestButton,
                      ),
                    );
                  },
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
                },
                child: Consumer<AppState>(
                  builder: (_,state,__){
                    return Container(
                      margin: const EdgeInsets.all(8),
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                          border: Border.all(color: state.isDarkMode ? Colors.white : Colors.black, width: 2)),
                      child: LottieBuilder.asset(
                        state.isDarkMode ? lightSettingButton : darkSettingButton,
                      ),
                    );
                  },
                ),
              ),
            ],
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    backToLoginPage();

                  },
                  child: Consumer<AppState>(
                    builder: (_,state,__){
                      return Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            //borderRadius: BorderRadius.circular(50),
                            color: Colors.transparent,
                            border: Border.all(color: state.isDarkMode ? Colors.white : Colors.black, width: 2)),
                        child: LottieBuilder.asset(
                          state.isDarkMode ? lightBackButton : darkBackButton,
                          width: 32,
                        ),
                      );
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    CoinDialog(context, coinStream.coin ?? 0).showDialog();
                  },
                  child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                      ),
                      child: _coinWidget()),
                ),
                Expanded(
                  child: Center(
                    child: Consumer<AppState>(
                      builder: (_,state,__){
                        return Text(
                          answer!,
                          style: TextStyle(
                              color: state.isDarkMode ? Colors.white : Colors.black,
                              fontSize: widget.level == 6 ? 28 : 32,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.005),
                        );
                      },
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
                    ? heightDevice / 15
                    : heightDevice / 12,
                margin: const EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Consumer<AppState>(
                      builder: (_,state,__){
                        return Icon(
                          Icons.info_outline,
                          color: state.isDarkMode ? Colors.white :Colors.black,
                        );
                      },
                    ),
                    onPressed: () {
                      SuggestionDialog(context, hintWord, S.of(context).hint).showDialog();
                    },
                  ),
                ),
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
    if(audioStreamService.audioCheck!){
      playAudio();
    }
    if (status == GameStatus.playing) {
      setState(() {
        pos = pos + 1;
        _currentWord?.addLetter(val);
      });
    }
  }

  void _onDelTap() {
    if(audioStreamService.audioCheck!){
      playAudio();
    }
    if (status == GameStatus.playing) {
      setState(() {
        if (pos > 0) {
          pos = pos - 1;
        }
        _currentWord?.removeLetter();
      });
    }
  }

  Future<void> _onEnterTap() async {
    if(audioStreamService.audioCheck!){
      playAudio();
    }
    if (status == GameStatus.playing &&
        _currentWord != null &&
        !_currentWord!.letters.contains(Letter.empty())) {
      if (_currentWord!.wordStr == solution!.wordStr) {
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
            () =>
                _flipCardKeys![_currentWordIndex][i].currentState!.toggleCard(),
          );
        }
        checkWin();
      } else {
        var check = await checkGrammar(_currentWord!.wordStr);
        if (check) {
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
                .show(type: ToastType.warning, msg: S.of(context).wordInvalid);
          });
        }
      }
    }
  }

  Widget _coinWidget() {
    return Consumer<AppState>(
      builder: (_,state,__){
        return Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              //borderRadius: BorderRadius.circular(50),
              color: Colors.transparent,
              border: Border.all(color: state.isDarkMode ? Colors.white : Colors.black, width: 2)),
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
                        coin = snapshot.data
                            .toString()
                            .replaceRange(coin.length - 3, coin.length, 'K');
                      }
                      return Text(
                        coin,
                        style: TextStyle(fontSize: 12, color: state.isDarkMode ? Colors.white : Colors.black),
                      );
                    }
                    return  Text(
                      '0',
                      style: TextStyle(fontSize: 12,color: state.isDarkMode ? Colors.white : Colors.black),
                    );
                  },
                ),
              ),
               Icon(
                Icons.currency_bitcoin,
                size: 12,
                  color: state.isDarkMode ? Colors.white : Colors.black
              ),
            ],
          ),
        );
      },
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
      coinStream.addCoin(widget.level - 2);
      status = GameStatus.won;
      setState(() {
        collection.add(solution!.wordStr);
        collectionService.addString(collection);
      });
      _speak(
          'Congratulation! the answer is ${solution!.wordStr.toLowerCase()}');
      Future.delayed(const Duration(milliseconds: 500), () {
        sharedPrefs.setStringList('collections', collection);
        sharedPrefs.setString(solution!.wordStr, hintWord);
        final appState = context.read<AppState>();
        Dialogs.materialDialog(
            color: appState.isDarkMode ? Colors.black: Colors.white,
            barrierColor: appState.isDarkMode ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.2),
            barrierDismissible: false,
            msgStyle: TextStyle(color: appState.isDarkMode ? Colors.white : Colors.black),
            titleStyle: TextStyle(color: appState.isDarkMode ? Colors.white : Colors.black),
            msg: '${S.of(context).congratulations} ${widget.level-2} coins',
            title: S.of(context).win,
            lottieBuilder: LottieBuilder.asset(congrats),
            context: context,
            actions: [
              IconsButton(
                onPressed: () {
                  backToLoginPage();
                },
                text: S.of(context).back,
                iconData: Icons.arrow_back,
                color: Colors.blue,
                textStyle: const TextStyle(color: Colors.white),
                iconColor: Colors.white,
              ),
              IconsButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _restart();
                },
                text: S.of(context).newGame,
                iconData: Icons.done,
                color: Colors.blue,
                textStyle: const TextStyle(color: Colors.white),
                iconColor: Colors.white,
              ),
            ]);
      });
    } else if (_currentWordIndex + 1 >= board!.length) {
      status = GameStatus.lost;
      setState(() {
        answer = '${solution?.wordStr}';
      });
      _speak('The answer is ${answer!.toLowerCase()}, good luck for next time');
      Future.delayed(const Duration(milliseconds: 500), () {
        final appState = context.read<AppState>();
        Dialogs.materialDialog(
            color: appState.isDarkMode ? Colors.black: Colors.white,
            barrierColor: appState.isDarkMode ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.2),
            barrierDismissible: false,
            msgStyle: TextStyle(color: appState.isDarkMode ? Colors.white : Colors.black),
            titleStyle: TextStyle(color: appState.isDarkMode ? Colors.white : Colors.black),
            msg: '${S.of(context).theAnswer} ${answer!.toLowerCase()}, ${S.of(context).betterNextTime}',
            title: S.of(context).failed,
            lottieBuilder: LottieBuilder.asset(failed),
            context: context,
            actions: [
              IconsButton(
                onPressed: () {
                  backToLoginPage();
                },
                text: S.of(context).back,
                iconData: Icons.arrow_back,
                color: Colors.blue,
                textStyle: const TextStyle(color: Colors.white),
                iconColor: Colors.white,
              ),
              IconsButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _restart();
                },
                text: S.of(context).newGame,
                iconData: Icons.done,
                color: Colors.blue,
                textStyle: const TextStyle(color: Colors.white),
                iconColor: Colors.white,
              ),
            ]);
      });
    } else {
      status = GameStatus.playing;
    }
    _currentWordIndex += 1;
  }

  Future<bool> checkGrammar(String word) async {
    dynamic str;
    await checkService.checkWord(word: word).then((value) {
      str = value;
      return true;
    }).catchError((e) {
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
      pos = 0;
      answer = 'WORDLE';
      status = GameStatus.playing;
      _currentWordIndex = 0;
      board = genBoard(widget.level);
      _flipCardKeys = genFlipCard(widget.level);
      solution = wordleBloc!.solution;
      hintWord = wordleBloc!.definitions!;
      print('_WordlePageState.restart ${solution!.wordStr} $hintWord');
    });
    keyBoardLetter.clear();
  }

   List<Word>genBoard(int level) {
    if (level == 3) {
      return List.generate(level + 3,
          (_) => Word(letters: List.generate(level, (_) => Letter.empty())));
    } else {
      return List.generate(level + 1,
          (_) => Word(letters: List.generate(level, (_) => Letter.empty())));
    }
  }

  List<List<GlobalKey<FlipCardState>>> genFlipCard(int level) {
    if (level == 3) {
      return List.generate(level + 3,
          (_) => List.generate(level, (_) => GlobalKey<FlipCardState>()));
    } else {
      return List.generate(level + 1,
          (_) => List.generate(level, (_) => GlobalKey<FlipCardState>()));
    }
  }

  Future<String> saveDefinition(String word) async {
    String definition = 'The word\'s not defined';
    await checkService.checkWord(word: word).then((value) {
      definition = ' ';
      if (value.meanings!.isNotEmpty) {
        for (int i = 0; i < value.meanings!.length; i++) {
          for (int i = 0; i < value.meanings![i].definitions!.length; i++) {
            definition =
                '$definition ${value.meanings![i].definitions![i].definition!}\n';
          }
        }
      }
      //return definition;
    }).catchError((e) {
      //print(e);
    });
    return definition;
  }

  Future<void> onTap() async {
    bool? audioCheck = await sharedPrefs.getBool('audio');
    if (audioCheck!) {
      audioStreamService.setTts(false);
    } else {
      audioStreamService.setTts(true);
    }
  }
  void backToLoginPage(){
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (_) => LoginPage(
              player: widget.player,
              isPlaying: isPlaying,
            )),
            (route) => false);
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

  playAudio() {
    AssetsAudioPlayer aaP = AssetsAudioPlayer();
    aaP.open(
      Audio(audioTapAsset),
      autoStart: true,
      showNotification: true,
      loopMode: LoopMode.single,
    );
    Future.delayed(const Duration(milliseconds: 500),(){
      aaP.stop();
    });
  }
}
