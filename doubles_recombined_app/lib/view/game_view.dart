import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doubles_recombined_app/model/user_model.dart';
import 'package:doubles_recombined_app/provider/user_provider.dart';

class GameView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    const int useCourts = 2; // TODO:仮。コート数

    return Scaffold(
      appBar: AppBar(
        title: Text('試合'),
        actions: [
          IconButton(
            onPressed: (){
              userProvider.getGameUserList(useCourts);
            }, 
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: useCourts,
            itemBuilder: (BuildContext context, int index) {
              // コート毎の試合中のユーザー
              return CourtListWidget(index + 1, userProvider.gamePlayUserList); 
            }
          ),
          WaitingPlayers(userProvider.gameStandUserList), // 休憩中のユーザー
        ],
      )
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

    if (gamePlayUserList.length != 0) {
      return Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(top: size.height * 0.02, left: size.width * 0.06),
            child: Text("No$index"),
          ),
          Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.all(5.0),
            child:  CourtWidget(index),
          ),
        ],
      );
    } else {
      return Container(child: Text('試合を開始する'));
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
        border: Border.all(width: 1),
      ),
      child: Row( // コートの中身
        children: [
          Container( // ユーザー2人
            width: courtWidth * 0.465,
            child: Column(
              children: [
                PlayerWidget(0 + (courtNumber - 1) * 4, courtWidth, courtHeigth),
                PlayerWidget(1 + (courtNumber - 1) * 4, courtWidth, courtHeigth),
              ],
            ),
          ),
          VerticalDivider(color: Colors.black,), // 中間線
          Container( // ユーザー2人
            width: courtWidth * 0.465,
            child: Column(
              children: [
                PlayerWidget(2 + (courtNumber - 1) * 4, courtWidth, courtHeigth),
                PlayerWidget(3 + (courtNumber - 1) * 4, courtWidth, courtHeigth),
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
  var courtWidth;
  var courtHeigth;

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Card(
      margin: EdgeInsets.only(top: courtHeigth * 0.08, bottom: courtHeigth * 0.03, left: courtWidth * 0.02),
      color: Colors.cyan[50],
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(top:10, bottom: 10),
            child: Icon(Icons.person, size: courtHeigth / 5),
          ),
          Text(userProvider.gamePlayUserList[index].name!, style: TextStyle(fontSize: courtHeigth / 9))
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

    if (gameStandUserList.length != 0) {
      return Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(top: size.height * 0.02, left: size.width * 0.06),
            child: Text('休憩中'),
          ),
          Container(
            margin: EdgeInsets.only(left: size.width * 0.05, right: size.width * 0.05),
            decoration: BoxDecoration(
              border: Border.all(width: 1),
            ),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              childAspectRatio: 3,
              children: List.generate(gameStandUserList.length, (index) {
                return Card(
                  color: Colors.cyan[50],
                  child: Row(
                    children: [
                      Container(
                        child: Icon(Icons.person),
                      ),
                      Text(gameStandUserList[index].name!),
                    ]
                  )
                );
              })
            ),
          ),
        ]
      );
    } else {
      return Container();
    }
  }
}
