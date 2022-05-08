import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doubles_recombined_app/model/user_model.dart';
import 'package:doubles_recombined_app/provider/user_provider.dart';
import 'package:doubles_recombined_app/widgets/gender_person_icon.dart';
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
          return Card(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(5.0),
                  child: GenderPersonIcon(gender: userProvider.userList[index].gender!, size: size.width/12),
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
    
    userModel.init(user); // ラジオボタンとトグルの設定

    // ダイアログの表示
    return showDialog(
      context: context, 
      builder: (context) {
        return Consumer<UserViewModel>(
          builder: (context, userModel, _) {
            return Stack(
              children: <Widget>[
                AlertDialog(
                  title: Text(userModel.title),
                  // 入力フォーム
                  content: Container(
                    height: size.height * 0.45,
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: userModel.user.name,
                          decoration: const InputDecoration(
                            labelText: '名前',
                            hintText: '(例)山田太郎',
                          ),
                          onChanged: (value){
                            userModel.user.name = value;
                          },
                        ),
                        TextFormField(
                          initialValue: userModel.user.name_kana,
                          decoration: const InputDecoration(
                            labelText: 'なまえ',
                            hintText: '(例)やまだたろう',
                          ),
                          onChanged: (value){
                            userModel.user.name_kana = value;
                          },
                        ),
                        // 性別はラジオボタン
                        Container(
                          padding: const EdgeInsets.only(top: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('性別'),
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
                                  const Text('男性'),
                                  Radio(
                                    activeColor: Colors.blueAccent,
                                    value: '女性',
                                    groupValue: userModel.sexValue,
                                    onChanged: (value){
                                      userModel.sexValue = '女性';
                                      userModel.user.gender = 2;
                                    },
                                  ),
                                  const Text('女性'),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // 参加はトグル
                        SwitchListTile(
                          title: const Text('参加'),
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
                      child: const Text('キャンセル'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        if (userModel.inputStatus == 'ADD') {
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
                  alignment: const Alignment(0.53, -0.615),
                  child: GestureDetector(
                    child: const Icon(Icons.delete),
                    onTap:() {
                      if (userModel.inputStatus == 'EDT') {
                        // ユーザーをリストを削除
                        DeleteUserDialog(context, userModel.user.id!);
                      }
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

  // ユーザーを削除
  Future<void> DeleteUserDialog(BuildContext context, int userId) async {
    final UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text('ユーザーを削除しますか？'),
          actions: <Widget>[
            TextButton(
              child: const Text('キャンセル'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                // ユーザーをリストを削除
                userProvider.deleteUser(userId);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
