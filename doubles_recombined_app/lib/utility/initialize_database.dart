import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// // DBの初期化
// Future<Database> get database async {
//   final Future<Database> _database = openDatabase(
//     join(await getDatabasesPath(), 'recombined_app_database.db'), // DBのパス
//       onCreate: _onCreate,
//       onUpgrade: _onUpgrade,
//       version: 1,
//     );
//   return _database;
// }

// DBの初期化
Future<Database> initializeDatabase() async {
  final database = openDatabase(
    join(await getDatabasesPath(), 'test03.db'), // DBのパス TODO:仮
    onCreate: _onCreate,
    onUpgrade: _onUpgrade,
    version: 1,
  );
  return database;
}

// DBが存在しない場合に呼び出す
void _onCreate(
  Database database,
  int version,
) async {
  await _migrate(database, 0, version);
}

// DBが既に存在し、versionが前回より高いに呼び出す
void _onUpgrade(
  Database database,
  int oldVersion,
  int newVersion,
) async {
  await _migrate(database, oldVersion, newVersion);
}

// versionに更新があった際にmigrationを実行する
Future<void> _migrate(Database database, int oldVersion, int newVersion) async {
  for (var i = oldVersion + 1; i <= newVersion; i++) {
    final queries = migrationScripts[i.toString()]!;
    for (final query in queries) {
      await database.execute(query);
    }
  }
}

const migrationScripts = {
  '1': ['''
    CREATE TABLE user (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      name_kana TEXT NOT NULL,
      gender INTEGER NOT NULL,
      status INTEGER NOT NULL DEFAULT 0
      )
  '''],
  // アップデートする際のメモ
  //'2': ['ALTER TABLE todo ADD COLUMN videoPath TEXT;'],
};
