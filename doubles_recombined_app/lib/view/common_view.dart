import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doubles_recombined_app/view_model/common_view_model.dart';
import 'package:doubles_recombined_app/view/user_list_view.dart';
import 'package:doubles_recombined_app/view/participant_list_view.dart';
import 'package:doubles_recombined_app/view/game_view.dart';
import 'package:doubles_recombined_app/view/configuration_view.dart';

class CommonView extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final CommonViewModel model = Provider.of<CommonViewModel>(context);
    var _pages = <Widget>[
      UserListView(), // ユーザ一覧
      ParticipantListView(), // 参加者一覧
      GameView(), // 試合
      ConfigurationView(), // 設定
    ];

    return Scaffold(
      body: _pages[model.index], // ページ移動
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: model.index,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.group), // pepole
            activeIcon: Icon(Icons.groups),
            label: 'メンバー',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_agenda), // emoji_emotions, view
            activeIcon: Icon(Icons.emoji_emotions_outlined),
            label: '参加者',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_tennis), // flag, reduce_capacity, repeat, sports
            activeIcon: Icon(Icons.sports_tennis_outlined),
            label: '試合',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            activeIcon: Icon(Icons.settings_accessibility),
            label: '設定',
            backgroundColor: Colors.blue,
          ),
        ],
        // ボトムナビゲーションでページ遷移
        onTap: (index) {
          print(index); // TODO:消す。デバック用
          model.setCurrentIndex(index); // ここでcurrentIndexを更新
        }
      )
    );
  }
}
