import 'package:flutter/material.dart';
import 'package:doubles_recombined_app/view/common_view.dart';

class GameView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('試合')
      ),
      body: Center(
        child: Text('試合'),
      ),
      bottomNavigationBar: BottomNavigationView(),
    );
  }
}