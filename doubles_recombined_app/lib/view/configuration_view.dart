import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doubles_recombined_app/provider/setting_provider.dart';

class ConfigurationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // デバイスの画面サイズを取得
    final SettingProvider settingProvider = Provider.of<SettingProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('設定')
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(top: size.height * 0.02, left: size.width * 0.06),
            child: Text('コート設定', style: TextStyle(fontWeight: FontWeight.bold))
          ),
          Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.only(top: size.height * 0.01),
            padding: EdgeInsets.all(size.width * 0.01),
            width: size.width * 0.87,
            decoration: BoxDecoration(
              border: Border.all(width: 1),
            ),
            child: Row(
              children: [
                Text('コート数 ', style: TextStyle(fontWeight: FontWeight.bold)),
                DropdownButton(
                  value: settingProvider.countCourt,
                  icon: Icon(Icons.arrow_drop_down),
                  items: <int>[1,2,3,4,5,6,7,8,9]
                    .map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    settingProvider.countCourt = value;
                  },
                ),
              ],
            )
          ),
        ],
      )
    );
  }
}