import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doubles_recombined_app/model/user_model.dart';
import 'package:doubles_recombined_app/provider/user_provider.dart';
import 'package:doubles_recombined_app/widgets/gender_person_icon.dart';
import 'package:doubles_recombined_app/view/user_view.dart';

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
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserView(newUser: user)));
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
}
