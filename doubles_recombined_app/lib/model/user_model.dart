class User {
  int? id;
  String? name;
  String? name_kana;
  int? sex;
  int? participant;

  User({
    this.id,
    this.name,
    this.name_kana,
    this.sex,
    this.participant,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'name_kana': name_kana,
      'sex': sex,
      'participant': participant,
    };
  }
}
