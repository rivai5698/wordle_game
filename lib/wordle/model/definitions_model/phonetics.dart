class Phonetics {
  Phonetics({
      this.text, 
      this.audio,});

  Phonetics.fromJson(dynamic json) {
    text = json['text'];
    audio = json['audio'];
  }
  String? text;
  String? audio;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['text'] = text;
    map['audio'] = audio;
    return map;
  }

}