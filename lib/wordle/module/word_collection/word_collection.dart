import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nice_buttons/nice_buttons.dart';
import 'package:provider/provider.dart';
import 'package:wordle/common/dialog/suggestion_dialog.dart';
import 'package:wordle/const/assets_const.dart';
import 'package:wordle/service/app_state.dart';
import 'package:wordle/service/shared_preferences_manager.dart';
import 'package:wordle/wordle/module/login/login_page.dart';
import 'package:wordle/wordle/module/word_collection/word_collection_bloc.dart';
import '../../../common/toast/toast_loading.dart';
import '../../../generated/l10n.dart';
import '../game/wordle_service.dart';
import '../game/wordle_page.dart';

class WordCollectionPage extends StatefulWidget {
  final String player;
  final bool isPlaying;
  const WordCollectionPage(
      {Key? key, required this.player, required this.isPlaying})
      : super(key: key);

  @override
  State<WordCollectionPage> createState() => _WordCollectionPageState();
}

class _WordCollectionPageState extends State<WordCollectionPage> {
  WordleService? wordleBloc;
  List<String> collection = [];
  @override
  void initState() {
    wordleBloc = WordleService();
    collectionService.init();
    collection.addAll(collectionService.collection);
    super.initState();
  }

  myInit() async {
    //await sharedPrefs.init();
    //List<String>? a = await sharedPrefs.getStringList('collections');
  }

  // @override
  // void setState(VoidCallback fn) {
  //   myInit();
  //   // TODO: implement setState
  //   super.setState(fn);
  // }

  @override
  Widget build(BuildContext context) {
    double heightDevice = MediaQuery.of(context).size.height;
    double widthDevice = MediaQuery.of(context).size.width;
    // print('_WordCollectionPageState.build $collection');
    return Stack(
      children: [
        Consumer<AppState>(
          builder: (_, state, __) {
            return Container(
              color: state.isDarkMode ? Colors.black : Colors.white,
              child: LottieBuilder.asset(
                background,
                height: heightDevice,
              ),
            );
          },
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: IconButton(
              icon: Consumer<AppState>(
                builder: (_, state, __) {
                  return Icon(
                    Icons.arrow_back_ios,
                    color: state.isDarkMode ? Colors.white : Colors.black,
                  );
                },
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => LoginPage(
                      player: widget.player,
                      isPlaying: widget.isPlaying,
                    ),
                    transitionDuration: const Duration(seconds: 1),
                    transitionsBuilder: (_, a, __, c) =>
                        FadeTransition(opacity: a, child: c),
                  ),
                  (route) => false,
                );
              },
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              S.of(context).collection,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  color: Colors.green),
            ),
          ),
          body: Column(
            children: [
              StreamBuilder<List<String>>(
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      '${S.of(context).col_word} ${collectionService.collection.length} ${S.of(context).word}',
                      style: const TextStyle(fontSize: 24, color: Colors.green),
                    );
                  }
                  return Text(
                    '${S.of(context).col_word} ${collectionService.collection.length} ${S.of(context).word}',
                    style: const TextStyle(fontSize: 24, color: Colors.green),
                  );
                },
                stream: collectionService.collectionStream,
              ),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                child: Consumer<AppState>(
                  builder: (_, state, __) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      width: widthDevice,
                      margin: const EdgeInsets.only(left: 16, right: 16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color:
                                state.isDarkMode ? Colors.white : Colors.black,
                          )),
                      child: StreamBuilder<List<String>>(
                        stream: collectionService.collectionStream,
                        builder: (_, snapshot) {
                          // print(
                          //     '_WordCollectionPageState.build snap ${snapshot.data}');
                          if (snapshot.hasData) {
                            return GridView.builder(
                              itemCount: collectionService.collection.length,
                              itemBuilder: (_, index) {
                                return _word(
                                    collectionService.collection[index]);
                              },
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisSpacing: 30,
                                      mainAxisSpacing: 30,
                                      mainAxisExtent: 30,
                                      crossAxisCount: 3),
                            );
                          }
                          return Center(
                              child: CircularProgressIndicator(
                            color: Colors.green.shade300,
                          ));
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              SafeArea(
                  child: Container(
                      height: 160,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      margin: const EdgeInsets.only(left: 16, right: 16),
                      decoration: BoxDecoration(
                        color: Colors.brown.shade300,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8)),
                      ),
                      child: Column(
                        children: [
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                S.of(context).sel,
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              )),
                          const SizedBox(
                            height: 50,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              NiceButtons(
                                width: 50,
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
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              NiceButtons(
                                width: 50,
                                height: 50,
                                stretch: false,
                                borderRadius: 50,
                                startColor: Colors.blue.shade300,
                                endColor: Colors.blue,
                                borderColor: Colors.blue,
                                gradientOrientation:
                                    GradientOrientation.Horizontal,
                                onTap: (finish) {
                                  //audioStream.pauseAudio();
                                  selectLevel(5);
                                },
                                child: Text(
                                  S.of(context).casual,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              NiceButtons(
                                borderRadius: 50,
                                width: 50,
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
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )))
            ],
          ),
        ),
      ],
    );
  }

  Widget _word(String word) {
    return GestureDetector(
      onTap: () async {
        String? def = await sharedPrefs.getString(word);
        Future.delayed(Duration.zero, () {
          SuggestionDialog(context, def!, word).showDialog();
        });
      },
      child: Container(
        width: 100,
        height: 30,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: word.length == 3
              ? Colors.green.shade400
              : word.length == 5
                  ? Colors.blue.shade400
                  : Colors.red.shade400,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Container(
          width: 100,
          height: 30,
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: word.length == 3
                ? Colors.green
                : word.length == 5
                    ? Colors.blue
                    : Colors.red,
          ),
          child: Center(child: Text(word)),
        ),
      ),
    );
  }

  Future selectLevel(int level) async {
    var toastLoadingOverlay = ToastLoadingOverlay(context);
    toastLoadingOverlay.show();
    await wordleBloc?.genWord(level);
    var sol = wordleBloc?.solution;
    var def = wordleBloc?.definitions;
    //print('solution: ${sol!.wordStr}');
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
}
