import 'package:doubles_recombined_app/view/participant_list_view.dart';

class User {
  final int id;
  final String name;
  final String name_kana;
  final int sex;
  final bool participant;

  User(
    this.id,
    this.name,
    this.name_kana,
    this.sex,
    this.participant,
  );

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

class Users {
  List<User> _users = [];

  // TODO：削除。テストデータ
  List<User> testUsers (){
    final data1 = User(1, '山田太郎', 'やまだたろう', 2, true);
    final data2 = User(2, '野田洋次郎', 'のだようじろう', 1, false);
    final data3 = User(3, '山中拓也', 'やまなかたくや', 1, true);

    _users.add(data1);
    _users.add(data2);
    _users.add(data3);

    return _users;
  }

}