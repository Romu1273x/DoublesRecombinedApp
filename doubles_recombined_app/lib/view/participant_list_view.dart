import 'package:flutter/material.dart';
import 'package:doubles_recombined_app/view/common_view.dart';

class ParticipantListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('参加者')
      ),
      body: Center(
        child: Text('参加者'),
      ),
      bottomNavigationBar: BottomNavigationView(),
    );
  }
}