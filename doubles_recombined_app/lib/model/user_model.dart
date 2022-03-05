import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class User {
  final int? id;
  final String? name;
  final String? name_kana;
  final int? sex;
  final int? participant;

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

  // データベースの作成
  static Future<Database> get database async {
    // openDatabase(): データベースに接続
    final Future<Database> _database = openDatabase(
      // getDatabasesPath(): データベースファイルを保存するパス取得
      join(await getDatabasesPath(), 'recombined_app_database.db'),
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE user (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            name_kana TEXT NOT NULL,
            sex INTEGER NOT NULL,
            participant INTEGER
          )
        ''');
      },
      version: 1,
    );
    return _database;
  }

  // データの作成
  static Future<void> insertUser(User user) async {
    final Database db = await database;
    await db.insert(
      'user',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // データの確認
  static Future<List<User>> getUsers() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('user');
    return List.generate(maps.length, (i) {
      return User(
        id: maps[i]['id'],
        name: maps[i]['name'],
        name_kana: maps[i]['name_kana'],
        sex: maps[i]['sex'],
        participant: maps[i]['participant'],
      );
    });
  }

  // データの更新
  static Future<void> updateUser(User user) async {
    final db = await database;
    await db.update(
      'user',
      user.toMap(),
      where: "id = ?",
      whereArgs: [user.id],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  // データの削除
  static Future<void> deleteUser(int id) async {
    final db = await database;
    await db.delete(
      'user',
      where: "id = ?",
      whereArgs: [id],
    );
  }

}
