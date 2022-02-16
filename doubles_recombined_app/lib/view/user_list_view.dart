import 'package:flutter/material.dart';
import 'package:doubles_recombined_app/view/common_view.dart';

class UserListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('メンバー')
      ),
      body: Center(
        child: Text('メンバー'),
      ),
      bottomNavigationBar: BottomNavigationView(),
    );
  }
}