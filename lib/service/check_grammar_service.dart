import 'package:wordle/service/check_grammar_api_service.dart';
import '../wordle/model/definitions_model/wordInfo.dart';
import 'generate_word_api_service.dart';

extension CheckWordService on CheckGrammarService {
  Future<WordInfo> checkWord({required String word}) async {
    final result = await request(
      path: '/api/v2/entries/en/$word',
      method: Method.get,
    );
    //print(str);
    final wordInfo = WordInfo.fromJson(result);
    //print(wordInfo.toString());
    //print(wordInfo.word);
    return wordInfo;
  }
}
