import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doubles_recombined_app/provider/user_provider.dart';
import 'package:doubles_recombined_app/widgets/user_list_widget.dart';

class ParticipantListView extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // デバイスの画面サイズを取得
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('参加者')
      ),
      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 2.6,
        children: List.generate(userProvider.participantUserList.length, (index) {
          return UserListWidget(user: userProvider.participantUserList[index], size: size, screen: UserListWidget.PARTICIPANT_LIST_VIEW);
        }),
      ),
    );
  }
}
