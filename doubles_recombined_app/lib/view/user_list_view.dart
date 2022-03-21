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
                userModel.delete(userModel.users[index].id!);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // ユーザー追加ダイアログを表示
          InputDialog(context);
        }
      ),
    );
  }

  Future<void> InputDialog(BuildContext context) async { // 非同期処理
    UserViewModel userModel = Provider.of<UserViewModel>(context, listen: false);
    String _gValue = '未選択';
    bool _participantFlg = false;

    return showDialog(
      context: context,
      builder: (context) {
        return Consumer<UserViewModel>(
          builder: (context, userModel, _) {
            return AlertDialog(
              title: Text('新規登録'),
              content: Container(
                height: 300,
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText: '名前',
                        hintText: '(例)山田太郎',
                      ),
                      onChanged: (value){
                        userModel.onNameChange(value);
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'なまえ',
                        hintText: '(例)やまだたろう',
                      ),
                      onChanged: (value){
                        userModel.onNameKanaChange(value);
                      },
                    ),
                    // 性別はラジオボタン
                    Container(
                      padding: EdgeInsets.only(top: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('性別'),
                          Row(
                            children: <Widget>[
                              Radio(
                                activeColor: Colors.blueAccent,
                                value: '男性',
                                groupValue: _gValue,
                                onChanged: (value){
                                  _gValue = '男性';
                                  userModel.onSexChange(1);
                                },
                              ),
                              Text('男性'),
                              Radio(
                                activeColor: Colors.blueAccent,
                                value: '女性',
                                groupValue: _gValue,
                                onChanged: (value){
                                  _gValue = '女性';
                                  userModel.onSexChange(2);
                                },
                              ),
                              Text('女性'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // 参加はトグル
                    SwitchListTile(
                      title: Text('参加'),
                      value: _participantFlg,
                      onChanged: (value){
                        if (value) {
                          _participantFlg = true;
                          userModel.onParticipantChange(1);  
                        } else {
                          _participantFlg = false;
                          userModel.onParticipantChange(2);
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  color: Colors.white,
                  textColor: Colors.blue,
                  child: Text('キャンセル'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  color: Colors.white,
                  textColor: Colors.blue,
                  child: Text('OK'),
                  onPressed: () {
                    // ユーザーをリストに追加
                    userModel.addUserList();
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          }
        );
      }
    );
  }
}
