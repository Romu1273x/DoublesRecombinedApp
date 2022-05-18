import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doubles_recombined_app/model/user_model.dart';
import 'package:doubles_recombined_app/provider/user_provider.dart';
import 'package:doubles_recombined_app/provider/setting_provider.dart';
import 'package:doubles_recombined_app/widgets/gender_person_icon.dart';

class GameView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final SettingProvider settingProvider = Provider.of<SettingProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('試合'),
        actions: [
          IconButton(
            onPressed: (){
              // 設定されたコート数から使用するコート数と試合・休憩するユーザーを作成
              settingProvider.getUseCourt(userProvider.participantUserList.length);
              userProvider.getGameUserList(settingProvider.useCourt!);
            }, 
            icon: const Icon(Icons.play_circle),
          )
        ],
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: settingProvider.useCourt,
        itemBuilder: (BuildContext context, int index) {
          // リストの最後は試合中と休憩中のWidgetを表示する
          if (index + 1 == settingProvider.useCourt) {
            return Column(
              children: [
                CourtListWidget(index + 1, userProvider.gamePlayUserList), // コート毎の試合中のユーザー
                WaitingPlayers(userProvider.gameStandUserList), // 休憩中のユーザー
              ]
            );
          }
          // コート毎の試合中のユーザー
          return CourtListWidget(index + 1, userProvider.gamePlayUserList);
        }
      ),
    );
  }
}

// コート毎の試合中のユーザー
class CourtListWidget extends StatelessWidget {
  CourtListWidget(this.index, this.gamePlayUserList);
  int index;
  List<User> gamePlayUserList;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // デバイスの画面サイズを取得

    if (gamePlayUserList.isNotEmpty) {
      return Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: size.height * 0.02, left: size.width * 0.06),
            child: Text("コート$index", style: TextStyle(fontSize: size.width * 0.048, fontWeight: FontWeight.bold)),
          ),
          Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.all(5.0),
            child:  CourtWidget(index),
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}

class CourtWidget extends StatelessWidget {
  CourtWidget(this.courtNumber);
  int courtNumber;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // デバイスの画面サイズを取得
    final courtWidth = size.width * 0.9;
    final courtHeigth = size.height * 0.2;
    
    return Container( // コート全体
      width: courtWidth,
      height: courtHeigth,
      decoration: BoxDecoration(
        color: Colors.green[300],
        border: Border.all(width: 1.5),
      ),
      child: Row( // コートの中身
        children: [
          Container( // ユーザー2人
            width: courtWidth * 0.465,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(left: 5, top: 5),
                  child: Text("サーブ", style: TextStyle(fontSize: size.width * 0.044, fontWeight: FontWeight.bold)),
                ),
                Expanded(child: Container()),
                PlayerWidget(0 + (courtNumber - 1) * 4, courtWidth, courtHeigth),
                PlayerWidget(1 + (courtNumber - 1) * 4, courtWidth, courtHeigth),
                Expanded(child: Container()),
              ],
            ),
          ),
          const VerticalDivider( // 中間線
            thickness: 1,
            color: Colors.black,
          ),
          Container( // ユーザー2人
            width: courtWidth * 0.465,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(left: 5, top: 5),
                  child: Text("レシーブ", style: TextStyle(fontSize: size.width * 0.044, fontWeight: FontWeight.bold)),
                ),
                Expanded(child: Container()),
                PlayerWidget(2 + (courtNumber - 1) * 4, courtWidth, courtHeigth),
                PlayerWidget(3 + (courtNumber - 1) * 4, courtWidth, courtHeigth),
                Expanded(child: Container()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PlayerWidget extends StatelessWidget {
  PlayerWidget(this.index, this.courtWidth, this.courtHeigth);
  int index;
  double courtWidth;
  double courtHeigth;

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    
    return Card(    
      margin: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 5.0),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.only(top: courtHeigth / 25, bottom: courtHeigth / 25),
            child: GenderPersonIcon(gender: userProvider.gamePlayUserList[index].gender!, size: courtHeigth / 5.5),
          ),
          Text(userProvider.gamePlayUserList[index].name!, style: TextStyle(fontSize: courtHeigth / 10))
        ],
      )
    );
  }
}

// 休憩中のユーザー
class WaitingPlayers extends StatelessWidget {
  WaitingPlayers(this.gameStandUserList);
  List<User> gameStandUserList;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // デバイスの画面サイズを取得

    if (gameStandUserList.isNotEmpty) {
      return Container(
        margin: EdgeInsets.only(top:size.height * 0.05, left: size.width * 0.05, right: size.width * 0.05),
        padding: const EdgeInsets.only(top: 2,  bottom: 5),
        decoration: BoxDecoration(
          color: Colors.lime[200],
          border: Border.all(width: 1.5),
        ),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(left: size.width * 0.01),
              child: Text("おやすみ：${gameStandUserList.length}名", style: TextStyle(fontSize: size.width * 0.048, fontWeight: FontWeight.bold)),
            ),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              childAspectRatio: 3,
              children: List.generate(gameStandUserList.length, (index) {
                return Card(
                  margin: const EdgeInsets.all(0.5),
                  child: Row(
                    children: [
                      GenderPersonIcon(gender: gameStandUserList[index].gender!, size: size.width/14),
                      Text(gameStandUserList[index].name!,  style: TextStyle(fontSize: size.height * 0.015)),
                    ]
                  )
                );
              })
            ),         
          ]
        )
      );
    } else {
      return Container();
    }
  }
}
