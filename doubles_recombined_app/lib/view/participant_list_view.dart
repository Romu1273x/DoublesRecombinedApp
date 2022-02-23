import 'package:flutter/material.dart';
import 'package:doubles_recombined_app/model/user_model.dart';

class ParticipantListView extends StatelessWidget {
  // TODO:削除。テストデータ
  final userlist = Users().testUsers();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('参加者')
      ),
      body: ListView.builder(
        itemCount: userlist.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: Colors.cyan[50],
            child: ListTile(
              title: Text(userlist[index].name),
              subtitle: Text(userlist[index].name_kana),
              trailing: Icon(Icons.more_vert),
              leading: Icon(Icons.person, size:40, color: Colors.pink),
              onTap: () {
                // クリック時の動作を記述する
              },
            ),
          );
        },
      ),
    );
  }
}