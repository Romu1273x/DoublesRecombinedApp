import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doubles_recombined_app/provider/user_provider.dart';
import 'package:doubles_recombined_app/widgets/user_list_widget.dart';
import 'package:doubles_recombined_app/view/user_view.dart';

class UserListView extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // デバイスの画面サイズを取得
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('メンバー'),
        actions: [
          IconButton(
            onPressed: (){
              // ユーザー追加画面を表示
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserView(newUser: null)));
            }, 
            icon: const Icon(Icons.person_add),
          )
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 2.6,
        children: List.generate(userProvider.userList.length, (index) {
          return UserListWidget(user: userProvider.userList[index], size: size, screen: UserListWidget.USER_LIST_VIEW);
        })
      ),
    );
  }
}
