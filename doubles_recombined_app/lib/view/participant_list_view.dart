import 'package:flutter/material.dart';
import 'package:doubles_recombined_app/model/user_model.dart';
import 'package:provider/provider.dart';
import 'package:doubles_recombined_app/view_model/user_view_model.dart';

class ParticipantListView extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // デバイスの画面サイズを取得
    final UserViewModel userModel = Provider.of<UserViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('参加者')
      ),
      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 2.6,
        children: List.generate(userModel.users.length, (index) {
          return Card(
            color: Colors.cyan[50],
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(5.0),
                  child: Icon(Icons.person, color: Colors.pink, size: size.width/12),
                ),
                Container(
                  width: (size.width / 3.3),
                  padding: const EdgeInsets.all(5.0),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(userModel.users[index].name_kana!, style: TextStyle(fontSize: size.height/85)),
                      ),
                      Container(
                        child: Text(userModel.users[index].name!, style: TextStyle(fontSize: size.height/45)),
                      ),                   
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Icon(Icons.more_vert),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}