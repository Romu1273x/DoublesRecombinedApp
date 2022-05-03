import 'package:flutter/material.dart';
import 'package:doubles_recombined_app/model/user_model.dart';
import 'package:provider/provider.dart';
import 'package:doubles_recombined_app/provider/user_provider.dart';
import 'package:doubles_recombined_app/view_model/user_view_model.dart';

class UserListView extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // デバイスの画面サイズを取得
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('メンバー'),
        actions: [
          IconButton(
            onPressed: (){
              // ユーザー追加ダイアログを表示
              InputUserDialog(context, null);
            }, 
            icon: Icon(Icons.person_add),
          )
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 2.6,
        children: List.generate(userProvider.userList.length, (index) {
          // 性別によってアイコンを変更
          Icon personIcon = Icon(Icons.person, color: Colors.blue, size: size.width/12);
          if (userProvider.userList[index].gender == 2) {
            personIcon = Icon(Icons.person, color: Colors.pink, size: size.width/12);
          }
          return Card(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(5.0),
                  child: personIcon,
                ),
                Container(
                  width: (size.width / 4.2),
                  padding: const EdgeInsets.all(5.0),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(userProvider.userList[index].name_kana!, style: TextStyle(fontSize: size.height/85)),
                      ),
                      Container(
                        child: Text(userProvider.userList[index].name!, style: TextStyle(fontSize: size.height/45)),
                      ),                   
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {
                      // ユーザー編集ダイアログを表示
                      InputUserDialog(context, userProvider.userList[index]);
                    }, 
                    icon: Icon(Icons.more_vert),
                  ),
                ),
              ],
            ),
          );
        })
      ),
    );
  }

  // ユーザー情報入力ダイアログ（ユーザー追加、ユーザー編集）
  Future<void> InputUserDialog(BuildContext context, User? user) async {
    final size = MediaQuery.of(context).size; // デバイスの画面サイズを取得
    final UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    final UserViewModel userModel = Provider.of<UserViewModel>(context, listen: false);
    
    // ユーザー追加の場合の初期値を設定
    String _inputStatus = 'ADD'; // 入力フォームの設定
    String _title = '新規メンバー登録'; // タイトル
    userModel.user = User(status: 0);

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
            return Stack(
              children: <Widget>[
                AlertDialog(
                  title: Text(_title),
                  // 入力フォーム
                  content: Container(
                    height: size.height * 0.45,
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
                                      userModel.user.gender = 1;
                                    },
                                  ),
                                  Text('男性'),
                                  Radio(
                                    activeColor: Colors.blueAccent,
                                    value: '女性',
                                    groupValue: userModel.sexValue,
                                    onChanged: (value){
                                      userModel.sexValue = '女性';
                                      userModel.user.gender = 2;
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
                              userModel.user.status = 1; 
                            } else {
                              userModel.participantFlag = false;
                              userModel.user.status = 0; 
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text('キャンセル'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
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
                ),
                Align(
                  alignment: Alignment(0.53, -0.615),
                  child: GestureDetector(
                    child: Icon(Icons.delete),
                    onTap:() {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text('ユーザーを削除しますか？'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('キャンセル'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  // ユーザーをリストを削除
                                  userProvider.deleteUser(userModel.user.id!);
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

}
