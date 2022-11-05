import 'package:wordle/service/check_grammar_api_service.dart';
import 'generate_word_api_service.dart';

extension CheckWordService on CheckGrammarService {
  Future<String> checkWord({required String word}) async {
    final result = await request(
      path: '/api/v2/entries/en/$word',
      method: Method.get,
    );
    final str = result.toString();
    return str;
  }
}
