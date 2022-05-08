import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doubles_recombined_app/model/user_model.dart';
import 'package:doubles_recombined_app/provider/user_provider.dart';
import 'package:doubles_recombined_app/widgets/gender_person_icon.dart';

class ParticipantListView extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // デバイスの画面サイズを取得
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('参加者')
      ),
      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 2.6,
        children: List.generate(userProvider.participantUserList.length, (index) {
          return Card(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(5.0),
                  child: GenderPersonIcon(gender: userProvider.participantUserList[index].gender!, size: size.width/12),
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
                        child: Text(userProvider.participantUserList[index].name_kana!, style: TextStyle(fontSize: size.height/85)),
                      ),
                      Container(
                        child: Text(userProvider.participantUserList[index].name!, style: TextStyle(fontSize: size.height/45)),
                      ),                   
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {
                      DeleteParticipantListDialog(context, userProvider.participantUserList[index]);
                    }, 
                    icon: Icon(Icons.more_vert),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Future<void> DeleteParticipantListDialog(BuildContext context, User participantUserList) async {
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