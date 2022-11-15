import 'dart:async';

import 'package:wordle/service/check_grammar_api_service.dart';
import 'package:wordle/service/check_grammar_service.dart';
import 'package:wordle/service/gen_word_service.dart';
import 'package:wordle/service/generate_word_api_service.dart';
import 'package:wordle/wordle/model/word_model.dart';

class WordleService {
  List<Word> board = [];
  Word? solution;
  String? definitions;
  // GameStatus gameStatus = GameStatus.playing;
  // //int?level;
  // WordleService(){
  //   //genWord(level!);
  // }

  Future genWord(int level) async {
    await genService.genWord(length: level).then((value)  async {
       solution = Word.fromString(value.replaceAll('[','').replaceAll(']', '').trim().toUpperCase());
       //_definitionsStreamController.add(definitions!);
       //_wordStreamController.add(Word.fromString(value.replaceAll('[','').replaceAll(']', '').trim().toUpperCase()));
       await genDefinition();
       //print('solution: ${solution!.wordStr}');
    }).catchError((e){
      //print(e);
    });
  }

  Future genDefinition() async {
    //String definitions = 'The word\'s not defined';
    await checkService.checkWord(word: solution!.wordStr).then((value) {
      definitions = '';
      if (value.meanings!.isNotEmpty) {
       // for (int i = 0; i < value.meanings!.length; i++) {
          for (int i = 0; i < value.meanings![0].definitions!.length; i++) {
            //if(value.meanings![0].definitions![i].definition.toString() != 'null'){
              definitions =
              '$definitions ${value.meanings![0].definitions![i].definition!}\n';
            //}
            }
      //  }
      }
      //return definition;
    }).catchError((e) {
      definitions = 'The word\'s not defined';
      print(e);
    });
  }

}

enum GameStatus {
  playing,
  submitting,
  lost,
  won,
}
