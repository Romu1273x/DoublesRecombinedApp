import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:doubles_recombined_app/utility/initialize_database.dart';
import 'package:doubles_recombined_app/provider/user_provider.dart';
import 'package:doubles_recombined_app/provider/setting_provider.dart';
import 'package:doubles_recombined_app/view_model/common_view_model.dart';
import 'package:doubles_recombined_app/view_model/user_view_model.dart';
import 'package:doubles_recombined_app/view_model/participant_view_model.dart';
import 'package:doubles_recombined_app/view/common_view.dart';

void main() async {
  // runApp()を呼び出す前にFlutter Engineの機能を利用したい場合に必要
  WidgetsFlutterBinding.ensureInitialized();
  final database = await initializeDatabase(); // DBの準備
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  debugPaintSizeEnabled = false; // レイアウトデバック機能
  runApp(
		MultiProvider( // providerの定義
      providers: [
        ChangeNotifierProvider<CommonViewModel>(create: (context) => CommonViewModel()),
        ChangeNotifierProvider<UserProvider>(create: (context) => UserProvider(database: database)),
        ChangeNotifierProvider<SettingProvider>(create: (context) => SettingProvider(prefs: prefs)),
        ChangeNotifierProvider<UserViewModel>(create: (context) => UserViewModel()),
        ChangeNotifierProvider<ParticipantViewModel>(create: (context) => ParticipantViewModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowMaterialGrid: false, // レイアウトデバック機能
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // ルーティングの設定
      initialRoute: '/home',
      routes: {
        '/home': (context) => CommonView(), 
      },
    );
  }
}