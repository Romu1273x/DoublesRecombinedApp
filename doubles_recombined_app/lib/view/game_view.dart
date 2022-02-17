import 'package:flutter/material.dart';

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
    );
  }
}