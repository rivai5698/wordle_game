import 'package:wordle/service/generate_word_api_service.dart';

extension GenWordService on GenerateService{
  Future<String> genWord(
  {required int length}
      )async{
    final result = await request(path: '/word?length=$length',method: Method.get,);
    final word = result.toString();
    return word;

  }
}