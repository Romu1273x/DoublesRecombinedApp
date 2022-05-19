import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doubles_recombined_app/utility/validator.dart';
import 'package:doubles_recombined_app/model/user_model.dart';
import 'package:doubles_recombined_app/provider/user_provider.dart';
import 'package:doubles_recombined_app/view_model/user_view_model.dart';
import 'package:doubles_recombined_app/widgets/gender_person_icon.dart';

// ユーザーリストとして表示するWidget
class UserListWidget extends StatelessWidget {
  UserListWidget({
    Key? key,
    required this.user, 
    required this.size,
    required this.screen,
  }) : super(key: key);
  final User? user;
  final Size size;
  final String screen;
  static const String USER_LIST_VIEW = 'UserListView';
  static const String PARTICIPANT_LIST_VIEW = 'ParticipantListView';

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2.0),
            child: GenderPersonIcon(gender: user!.gender!, size: size.width/12),
          ),
          Container(
            width: (size.width / 3.9),
            padding: const EdgeInsets.all(1.0),
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [                
                Container(
                  child: Text(user!.name_kana!, style: TextStyle(fontSize: size.width/50)),
                  margin: EdgeInsets.only(left: size.height * 0.003),
                ),
                Container(
                  child: Text(user!.name!, style: TextStyle(fontSize: size.width/25)),
                  margin: EdgeInsets.only(bottom: size.height * 0.005),
                )                 
              ],
            ),
          ),
          IconButton(
            alignment: Alignment.centerRight,
              onPressed: () {
                switch (screen) {
                  case USER_LIST_VIEW: // ユーザーリストの場合
                    InputUserDialog(context, user);
                    break;
                  case PARTICIPANT_LIST_VIEW: // 参加者リストの場合
                    DeleteParticipantListDialog(context, user!);
                    break;
                  default:
                }
              }, 
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
    );
  }

  // ユーザー情報入力ダイアログ（ユーザー追加、ユーザー編集）
  static Future<void> InputUserDialog(BuildContext context, User? user) async {
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
                          UserVariationErrorDialog(context, userModel.user);
                        }
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
  static Future<void> DeleteUserDialog(BuildContext context, int userId) async {
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

  // 参加者リストから削除する
  static Future<void> DeleteParticipantListDialog(BuildContext context, User participantUserList) async {
    final UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text('参加者リストから削除しますか？'),
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
                // 参加状態から不参加にする
                participantUserList.status = 0;
                userProvider.updateUser(participantUserList);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // ユーザーのバリデーショエラー
  static Future<void> UserVariationErrorDialog(BuildContext context, User user) async {
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

