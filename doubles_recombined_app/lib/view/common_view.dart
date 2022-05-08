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
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.groups), // pepole
            activeIcon: const Icon(Icons.groups_outlined),
            label: 'メンバー',
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.emoji_emotions), // view
            activeIcon: const Icon(Icons.emoji_emotions_outlined),
            label: '参加者',
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.flag), // sports_tennis, reduce_capacity, repeat, sports
            activeIcon: const Icon(Icons.flag_outlined),
            label: '試合',
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            activeIcon: const Icon(Icons.settings_outlined),
            label: '設定',
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ],
        // ボトムナビゲーションでページ遷移
        onTap: (index) {
          model.index = index; // ここでcurrentIndexを更新
        }
      )
    );
  }
}
