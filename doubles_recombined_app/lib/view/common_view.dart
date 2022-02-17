import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doubles_recombined_app/view_model/common_view_model.dart';
import 'package:doubles_recombined_app/view/user_list_view.dart';
import 'package:doubles_recombined_app/view/participant_list_view.dart';
import 'package:doubles_recombined_app/view/game_view.dart';
import 'package:doubles_recombined_app/view/configuration_view.dart';

class BottomNavigationView extends StatelessWidget {
  
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


// TODO:消す。参考プログラム
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BottomNavigationBar Sample'),
      ),
      body: Center(
        child: Text(
          "indexNum: $_selectedIndex",
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            activeIcon: Icon(Icons.book_online),
            label: 'Book',
            tooltip: "This is a Book Page",
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            activeIcon: Icon(Icons.business_center),
            label: 'Business',
            tooltip: "This is a Business Page",
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            activeIcon: Icon(Icons.school_outlined),
            label: 'School',
            tooltip: "This is a School Page",
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            activeIcon: Icon(Icons.settings_accessibility),
            label: 'Settings',
            tooltip: "This is a Settings Page",
            backgroundColor: Colors.pink,
          ),
        ],

        type: BottomNavigationBarType.shifting,
        // ここで色を設定していても、shiftingにしているので
        // Itemの方のbackgroundColorが勝ちます。
        backgroundColor: Colors.red,
        enableFeedback: true,
        // IconTheme系統の値が優先されます。
        iconSize: 18,
        // 横向きレイアウトは省略します。
        // landscapeLayout: 省略
        selectedFontSize: 20,
        selectedIconTheme: const IconThemeData(size: 30, color: Colors.green),
        selectedLabelStyle: const TextStyle(color: Colors.red),
        // ちなみに、LabelStyleとItemColorの両方を選択した場合、ItemColorが勝ちます。
        selectedItemColor: Colors.black,
        unselectedFontSize: 15,
        unselectedIconTheme: const IconThemeData(size: 25, color: Colors.white),
        unselectedLabelStyle: const TextStyle(color: Colors.purple),
        // IconTheme系統の値が優先されるのでこの値は適応されません。
        unselectedItemColor: Colors.red,
      ),
    );
  }
}
