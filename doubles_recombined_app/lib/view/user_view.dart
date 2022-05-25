import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doubles_recombined_app/utility/validator.dart';
import 'package:doubles_recombined_app/model/user_model.dart';
import 'package:doubles_recombined_app/provider/user_provider.dart';
import 'package:doubles_recombined_app/view_model/user_view_model.dart';

class UserView extends StatelessWidget {
  UserView({this.newUser});
  final User? newUser;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserViewModel>(create: (context) => UserViewModel()),
      ],
      child: UserViewBuild(newUser: newUser),
    );
  }
}

class UserViewBuild extends StatelessWidget {
  UserViewBuild({this.newUser});
  final User? newUser;

  @override
  Widget build(BuildContext context) {
    final UserViewModel userModel = Provider.of<UserViewModel>(context);
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    userModel.init(newUser); // ラジオボタンとトグルの設定
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(userModel.title),
        actions: [
          DeleteIcon(), // ユーザー編集の場合のみ表示
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.all(10.0),
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
                  // バリデーション
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    return Validator.NameValidation(value);
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
                  // バリデーション
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    return Validator.NameKanaValidation(value);
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Spacer(flex: 8),
                    ElevatedButton(
                      child: const Text('キャンセル'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Spacer(flex: 1),
                    ElevatedButton(
                      child: const Text('OK'),
                      onPressed: () {
                        // バリデーション
                        if (userModel.validationUser(userModel.user).isEmpty) {
                          if (userModel.inputStatus == 'ADD') {
                            // ユーザーをリストを追加
                            userProvider.addUser(userModel.user);
                          } else {
                            // ユーザーをリストを編集
                            userProvider.updateUser(userModel.user);
                          }
                          Navigator.pop(context);
                        } else {
                          // バリデーションエラー
                          userVariationErrorDialog(context, userModel.user);
                        }
                      },
                    ),
                  ]
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> userVariationErrorDialog(BuildContext context, User user) async {
    final UserViewModel userModel = Provider.of<UserViewModel>(context, listen: false);

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(userModel.validationUser(user)),
          actions: <Widget>[
            Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                child: const Text('閉じる'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
          ],
        );
      },
    );
  }
}

class DeleteIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserViewModel userModel = Provider.of<UserViewModel>(context, listen: false);
    
    if (userModel.inputStatus == 'EDT') {
      return IconButton(
        onPressed: (){
          // ユーザーをリストを削除
          deleteUserDialog(context, userModel.user.id!);
        }, 
        icon: const Icon(Icons.delete)
      );
    } else {
      return Container();
    }
  }

  Future<void> deleteUserDialog(BuildContext context, int userId) async {
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