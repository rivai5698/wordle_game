class Definitions {
  Definitions({
      this.definition, 
      this.synonyms, 
      this.antonyms,});

  Definitions.fromJson(dynamic json) {
    definition = json['definition'];
    if (json['synonyms'] != null) {
      synonyms = [];
      json['synonyms'].forEach((v) {
        synonyms!.add(v);
      });
    }
    if (json['antonyms'] != null) {
      antonyms = [];
      json['antonyms'].forEach((v) {
        antonyms!.add(v);
      });
    }
  }
  String? definition;
  List<dynamic>? synonyms;
  List<dynamic>? antonyms;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['definition'] = definition;
    if (synonyms != null) {
      map['synonyms'] = synonyms!.map((v) => v.toJson()).toList();
    }
    if (antonyms != null) {
      map['antonyms'] = antonyms!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}