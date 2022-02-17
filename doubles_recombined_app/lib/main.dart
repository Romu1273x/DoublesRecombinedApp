import 'package:flutter/material.dart';
import 'package:doubles_recombined_app/view/user_list_view.dart';
import 'package:doubles_recombined_app/view/participant_list_view.dart';
import 'package:doubles_recombined_app/view/game_view.dart';
import 'package:doubles_recombined_app/view/configuration_view.dart';
import 'package:provider/provider.dart';
import 'package:doubles_recombined_app/view_model/common_view_model.dart';

// TODO:消す。レイアウトデバック機能
import 'package:flutter/rendering.dart';

void main() {
  // TODO:消す。レイアウトデバック機能
  //debugPaintSizeEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 状態管理をするモデルの設定
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CommonViewModel>(create: (context) => CommonViewModel()),
      ],
      child: MaterialApp(
        // TODO:消す。レイアウトデバック機能
        //debugShowMaterialGrid: true,
        // テーマ（仮）
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // ルーティングの設定
        initialRoute: '/users', // 最初はユーザー一覧画面に遷移
        routes: {
          '/users': (context) => UserListView(), // ユーザー一覧
          '/participants': (context) => ParticipantListView(), // 参加者一覧
          '/games': (context) => GameView(), // 試合
          '/configuration': (context) => ConfigurationView(), // 設定
        },
      ),
    );
  }
}
