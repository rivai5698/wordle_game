import 'meanings.dart';

class WordInfo {
  WordInfo({
    this.word,
    //this.phonetic,
    // this.phonetics,
    this.meanings,
    // this.license,
    // this.sourceUrls,
  });

  WordInfo.fromJson(dynamic json) {
    word = json[0]['word'];
    //phonetic = json[0]['phonetic'];
    // if (json['phonetics'] != null) {
    //   phonetics = [];
    //   json['phonetics'].forEach((v) {
    //     phonetics!.add(Phonetics.fromJson(v));
    //   });
    // }
    if (json[0]['meanings'] != null) {
      meanings = [];
      json[0]['meanings'].forEach((v) {
        //print(v);
        meanings!.add(Meanings.fromJson(json[0]['meanings']));
      });
    }
    // license = json['license'] != null ? License.fromJson(json['license']) : null;
    // sourceUrls = json['sourceUrls'] != null ? json['sourceUrls'].cast<String>() : [];
  }
  String? word;
  //String? phonetic;
  // List<Phonetics>? phonetics;
  List<Meanings>? meanings;
  // License? license;
  // List<String>? sourceUrls;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['word'] = word;
    //map['phonetic'] = phonetic;
    // if (phonetics != null) {
    //   map['phonetics'] = phonetics!.map((v) => v.toJson()).toList();
    // }
    if (meanings != null) {
      map['meanings'] = meanings!.map((v) => v.toJson()).toList();
    }
    // if (license != null) {
    //   map['license'] = license!.toJson();
    // }
    // map['sourceUrls'] = sourceUrls;
    return map;
  }
}
