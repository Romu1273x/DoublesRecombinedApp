import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doubles_recombined_app/model/user_model.dart';
import 'package:doubles_recombined_app/provider/user_provider.dart';

class GameView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    const int useCourts = 1; // TODO:仮。コート数

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
              return CourtListWidget(index + 1, userProvider.gamePlayUserList);
            }
          ),
          Container(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: userProvider.gameStandUserList.length,
              itemBuilder: (BuildContext context, int index) {
                return Text(userProvider.gameStandUserList[index].name!);
              }
            )
          ),
        ],
      )
    );
  }
}

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
            child:  CourtWidget(size),
          ),
        ],
      );
    } else {
      return Container(child: Text('試合を開始する'));
    }
  }
}

class CourtWidget extends StatelessWidget {
  CourtWidget(this.size);
  var size;

  @override
  Widget build(BuildContext context) {
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
                PlayerWidget(0, size, courtWidth, courtHeigth),
                PlayerWidget(1, size, courtWidth, courtHeigth),
              ],
            ),
          ),
          VerticalDivider(color: Colors.black,), // 中間線
          Container( // ユーザー2人
            width: courtWidth * 0.465,
            child: Column(
              children: [
                PlayerWidget(2, size, courtWidth, courtHeigth),
                PlayerWidget(3, size, courtWidth, courtHeigth),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PlayerWidget extends StatelessWidget {
  PlayerWidget(this.index, this.size, this.courtWidth, this.courtHeigth);
  int index;
  var size;
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
            child: Icon(Icons.person, size: size.height/25),
          ),
          Text(userProvider.gamePlayUserList[index].name!, style: TextStyle(fontSize: size.height/45))
        ],
      )
    );
  }
}
