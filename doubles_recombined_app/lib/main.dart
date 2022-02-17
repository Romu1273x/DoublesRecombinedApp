import 'package:flutter/material.dart';
import 'package:doubles_recombined_app/view/common_view.dart';
import 'package:provider/provider.dart';
import 'package:doubles_recombined_app/view_model/common_view_model.dart';

// TODO:消す。レイアウトデバック機能
import 'package:flutter/rendering.dart';

void main() {
  // TODO:消す。レイアウトデバック機能
  //debugPaintSizeEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 状態管理をするモデルの設定
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CommonViewModel>(create: (context) => CommonViewModel()),
      ],
      child: MaterialApp(
        // TODO:消す。レイアウトデバック機能
        //debugShowMaterialGrid: true,
        // テーマ（仮）
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // ルーティングの設定
        initialRoute: '/home',
        routes: {
          '/home': (context) => CommonView(), 
        },
      ),
    );
  }
}
