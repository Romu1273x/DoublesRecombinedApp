import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:doubles_recombined_app/utility/admob_banner.dart';
import 'package:doubles_recombined_app/provider/setting_provider.dart';
import 'package:doubles_recombined_app/provider/theme_provider.dart';

class ConfigurationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // デバイスの画面サイズを取得
    final SettingProvider settingProvider = Provider.of<SettingProvider>(context);
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('設定')
      ),
      body: Column(
        children: [
          // コート設定
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(top: size.height * 0.02, left: size.width * 0.065),
            child: Text('コート設定', style: TextStyle(fontSize: size.width * 0.048, fontWeight: FontWeight.bold))
          ),
          Container(
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.only(top: 2.0),
            padding: EdgeInsets.all(size.width * 0.01),
            width: size.width * 0.87,
            decoration: BoxDecoration(
              border: Border.all(width: 1),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: size.width * 0.01, right: size.width * 0.05),
                  child: const Text('コート数：', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                DropdownButton(
                  value: settingProvider.countCourt,
                  icon: const Icon(Icons.arrow_drop_down),
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
          // 画面設定
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(top: size.height * 0.02, left: size.width * 0.065),
            child: Text('画面設定', style: TextStyle(fontSize: size.width * 0.048, fontWeight: FontWeight.bold))
          ),
          Container(
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.only(top: 2.0),
            padding: EdgeInsets.all(size.width * 0.01),
            width: size.width * 0.87,
            decoration: BoxDecoration(
              border: Border.all(width: 1),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: size.width * 0.01, right: size.width * 0.05),
                  child: const Text('表示モード：', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                DropdownButton(
                  value: themeProvider.themModeToString(themeProvider.themeMode),
                  icon: const Icon(Icons.arrow_drop_down),
                  items: <String>['システムモード', 'ライトモード', 'ダークモード']
                    .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    themeProvider.themeMode = themeProvider.stringToThemMode(value.toString());
                  },
                ),
              ],
            )
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: AdBanner(AdSize.leaderboard),
            ),
          ),
        ],
      )
    );
  }
}