import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doubles_recombined_app/provider/user_provider.dart';

class ParticipantListView extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // デバイスの画面サイズを取得
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('参加者')
      ),
      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 2.6,
        children: List.generate(userProvider.participantUserList.length, (index) {
          return Card(
            color: Colors.cyan[50],
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(5.0),
                  child: Icon(Icons.person, color: Colors.pink, size: size.width/12),
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
                      showDialog(
                        context: context,
                        builder: (context) {
                          return SimpleDialog(
                            children: <Widget>[
                              SimpleDialogOption(
                                onPressed: () {
                                  // 参加状態から不参加にする
                                  userProvider.participantUserList[index].participant = 1;
                                  userProvider.updateUser(userProvider.participantUserList[index]);
                                  Navigator.of(context).pop();
                                },
                                child: const Center(
                                  child: Text('参加者リストから削除しますか？'),
                                ),
                              ),
                            ],
                          );
                        },
                      );
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
}