import 'package:flutter/material.dart';
import 'package:doubles_recombined_app/view/user_list_view.dart';
import 'package:doubles_recombined_app/view/participant_list_view.dart';
import 'package:doubles_recombined_app/view/game_view.dart';
import 'package:doubles_recombined_app/view/configuration_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // ルーティングの設定
      initialRoute: '/users', // 最初はユーザー一覧画面に遷移
      routes: {
        '/users': (context) => UserListView(), // ユーザー一覧
        '/participants': (context) => ParticipantListView(), // 参加者一覧
        '/games': (context) => GameView(), // 試合
        '/configuration': (context) => ConfigurationView(), // 設定
      },
    );
  }
}
