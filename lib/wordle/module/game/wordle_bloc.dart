import 'dart:async';

import 'package:wordle/service/gen_word_service.dart';
import 'package:wordle/service/generate_word_api_service.dart';
import 'package:wordle/wordle/model/letter_model.dart';
import 'package:wordle/wordle/model/word_model.dart';

class WordleBloc {
  final _wordleStreamController = StreamController<List<Word>>();
  final _wordStreamController = StreamController<Word>();
  Stream<List<Word>> get streamWordle => _wordleStreamController.stream;
  Stream<Word> get streamWord => _wordStreamController.stream;
  List<Word> board = [];
  Word? solution;
  GameStatus gameStatus = GameStatus.playing;
  final int _currentWordIndex= 0;
  //int?level;
  WordleBloc(){
    //genWord(level!);
  }

  Future genWord(int level) async {
    await genService.genWord(length: level).then((value){
       solution = Word.fromString(value.replaceAll('[','').replaceAll(']', '').trim().toUpperCase());
      _wordStreamController.add(Word.fromString(value.replaceAll('[','').replaceAll(']', '').trim().toUpperCase()));
       print('sol: ${solution!.wordStr}');
    }).catchError((e){
      print(e);
    });
  }

  void genBoard(){
     gameStatus = GameStatus.playing;
     board = List.generate(6, (index) => Word(letters: List.generate(5, (index) => Letter.empty())));
     _wordleStreamController.add(board);
  }

  Word? get currentWord{
      var val = _currentWordIndex < board.length ? board[_currentWordIndex] : null;

      return val;
  }

}

enum GameStatus {
  playing,
  submitting,
  lost,
  won,
}
