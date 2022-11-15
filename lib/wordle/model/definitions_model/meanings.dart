import 'definitions.dart';

class Meanings {
  Meanings({
    //this.partOfSpeech,
    this.definitions,
    //this.synonyms,
    //this.antonyms,
  });

  Meanings.fromJson(dynamic json) {
    //partOfSpeech = json[0]['partOfSpeech'];
    if (json[0]['definitions'] != null) {
      definitions = [];
      json[0]['definitions'].forEach((v) {
        definitions!.add(Definitions.fromJson(v));
      });
    }
    // synonyms = json['synonyms'] != null ? json['synonyms'].cast<String>() : [];
    // if (json['antonyms'] != null) {
    //   antonyms = [];
    //   json['antonyms'].forEach((v) {
    //     antonyms!.add(v);
    //   });
    //}
  }
  //String? partOfSpeech;
  List<Definitions>? definitions;
  //List<String>? synonyms;
  //List<dynamic>? antonyms;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    // map['partOfSpeech'] = partOfSpeech;
    if (definitions != null) {
      map['definitions'] = definitions!.map((v) => v.toJson()).toList();
    }
    // map['synonyms'] = synonyms;
    // if (antonyms != null) {
    //   map['antonyms'] = antonyms!.map((v) => v.toJson()).toList();
    // }
    return map;
  }
}
