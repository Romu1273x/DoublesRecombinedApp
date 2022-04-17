import 'package:flutter/material.dart';
import 'package:doubles_recombined_app/model/user_model.dart';
import 'package:provider/provider.dart';
import 'package:doubles_recombined_app/provider/user_provider.dart';
import 'package:doubles_recombined_app/view_model/user_view_model.dart';

class UserListView extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('メンバー')
      ),
      body: ListView.builder(
        itemCount: userProvider.userList.length,
        itemBuilder: (BuildContext context, int index) {
          // 性別によってアイコンを変更
          Icon personIcon = Icon(Icons.person, size:40, color: Colors.blue);
          if (userProvider.userList[index].sex == 2) {
            personIcon = Icon(Icons.person, size:40, color: Colors.pink);
          }
          return Card(
            color: Colors.cyan[50],
            child: ListTile(
              title: Text(userProvider.userList[index].name!),
              subtitle: Text(userProvider.userList[index].name_kana!),
              trailing: IconButton(
                onPressed: () {
                  // ユーザー削除ダイアログを表示
                  showDialog(
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        children: <Widget>[
                          SimpleDialogOption(
                            onPressed: () {
                              // ユーザーをリストから削除
                              userProvider.deleteUser(userProvider.userList[index].id!);
                              Navigator.of(context).pop();
                            },
                            child: const Center(
                              child: Text('削除'),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: Icon(Icons.more_vert),
              ),
              leading: personIcon,
              onTap: () {
                // ユーザー編集ダイアログを表示
                InputUserDialog(context, userProvider.userList[index]);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // ユーザー追加ダイアログを表示
          InputUserDialog(context, null);
        }
      ),
    );
  }

  // ユーザー情報入力ダイアログ（ユーザー追加、ユーザー編集）
  Future<void> InputUserDialog(BuildContext context, User? user) async {
    final UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    final UserViewModel userModel = Provider.of<UserViewModel>(context, listen: false);
    
    // ユーザー追加の場合の初期値を設定
    String _inputStatus = 'ADD'; // 入力フォームの設定
    String _title = '新規メンバー登録'; // タイトル
    userModel.user = User();

    // ユーザー編集の場合の初期値を設定
    if (user != null) {
      _inputStatus = 'EDT';
      _title = 'メンバー情報変更';
      userModel.user = user;
    }
    userModel.initUser(); // ラジオボタンとトグルの設定

    // ダイアログの表示
    return showDialog(
      context: context, 
      builder: (context) {
        return Consumer<UserViewModel>(
          builder: (context, userModel, _) {
            return AlertDialog(
              title: Text(_title),
              // 入力フォーム
              content: Container(
                height: 300,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: userModel.user.name,
                      decoration: InputDecoration(
                        labelText: '名前',
                        hintText: '(例)山田太郎',
                      ),
                      onChanged: (value){
                        userModel.user.name = value;
                      },
                    ),
                    TextFormField(
                      initialValue: userModel.user.name_kana,
                      decoration: InputDecoration(
                        labelText: 'なまえ',
                        hintText: '(例)やまだたろう',
                      ),
                      onChanged: (value){
                        userModel.user.name_kana = value;
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
                                groupValue: userModel.sexValue,
                                onChanged: (value){
                                  userModel.sexValue = '男性';
                                  userModel.user.sex = 1;
                                },
                              ),
                              Text('男性'),
                              Radio(
                                activeColor: Colors.blueAccent,
                                value: '女性',
                                groupValue: userModel.sexValue,
                                onChanged: (value){
                                  userModel.sexValue = '女性';
                                  userModel.user.sex = 2;
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
                      value: userModel.participantFlag,
                      onChanged: (value){
                        if (value) {
                          userModel.participantFlag = true;
                          userModel.user.participant = 0; 
                        } else {
                          userModel.participantFlag = false;
                          userModel.user.participant = 1; 
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
                    if (_inputStatus == 'ADD') {
                      // ユーザーをリストを追加
                      userProvider.addUser(userModel.user);
                    } else {
                      // ユーザーをリストを編集
                      userProvider.updateUser(userModel.user);
                    }
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

}
