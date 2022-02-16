import 'package:flutter/material.dart';
import 'package:doubles_recombined_app/view/common_view.dart';

class ConfigurationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('設定')
      ),
      body: Center(
        child: Text('設定'),
      ),
      bottomNavigationBar: BottomNavigationView(),
    );
  }
}