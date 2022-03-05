import 'package:flutter/material.dart';
import 'package:doubles_recombined_app/model/user_model.dart';
import 'package:provider/provider.dart';
import 'package:doubles_recombined_app/view_model/user_view_model.dart';

class UserListView extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final UserViewModel userModel = Provider.of<UserViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('メンバー')
      ),
      body: ListView.builder(
        itemCount: userModel.users.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: Colors.cyan[50],
            child: ListTile(
              title: Text(userModel.users[index].name!),
              subtitle: Text(userModel.users[index].name_kana!),
              trailing: Icon(Icons.more_vert),
              leading: Icon(Icons.person, size:40, color: Colors.pink),
              onTap: () {
                // クリック時の動作を記述する
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // TODO:削除。テストデータ
          final User user = User(name: '山田太郎', name_kana: 'やまだたろう', sex: 2, participant: 0);
          // ユーザを追加する処理
          userModel.add(user);
        }
      ),
    );
  }
}
