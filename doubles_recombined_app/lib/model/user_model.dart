class User {
  int? id;
  String? name;
  String? name_kana;
  int? gender; // 1:男, 2:女
  int? status; // 0:不参加, 1:参加, 2:試合中

  User({
    this.id,
    this.name,
    this.name_kana,
    this.gender,
    this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'name_kana': name_kana,
      'gender': gender,
      'status': status,
    };
  }
}
