import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';

class AdBanner extends StatelessWidget {
  AdBanner(
    this.size, // サイズは利用時に指定
  );

  final AdSize size;

  Widget build(BuildContext context) {
    final banner = BannerAd(
        // サイズ
        size: size,
        // 広告ID
        adUnitId: BannerAd.testAdUnitId, 
        // イベントのコールバック
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) => print('Ad loaded.'),
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            print('Ad failed to load: $error');
          },
          onAdOpened: (Ad ad) => print('Ad opened.'),
          onAdClosed: (Ad ad) => print('Ad closed.'),
          //onApplicationExit: (Ad ad) => print('Left application.'),
        ),
        // リクエストはデフォルトを使う
        request: AdRequest()
      )
      // 表示を行うloadをつける
      ..load();

    // 戻り値はContainerで包んで返す
    return Container(
        width: banner.size.width.toDouble(),
        height: banner.size.height.toDouble(),
        child: AdWidget(ad: banner));
  }
  
  // 広告IDをプラットフォームに合わせて取得
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "XXX";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/2934735716";
    } else {
      //どちらでもない場合は、テスト用を返す
      return BannerAd.testAdUnitId;
    }
  }
}

// class AdState {
//   Future<InitializationStatus> initialization;

//   AdState(this.initialization);

//   String get bannerAdUnitId =>
//       Platform.isAndroid ? "ca-app-pub-3940256099942544/6300978111" : "ca-app-pub-3940256099942544/2934735716";

//   AdListener get adListener => _adListener;
//   AdListener _adListener = AdListener(
//     onAdLoaded: (ad) => print('Ad loaded: ${ad.adUnitId}.'),
//     onAdClosed: (ad) => print('Ad closed: ${ad.adUnitId}.'),
//     onAdFailedToLoad: (ad, error) => print('Ad failed to load: ${ad.adUnitId}, $error.'),
//     onAdOpened: (ad) => print('Ad opened: ${ad.adUnitId}.'),
//     onAppEvent: (ad, name, data) => print('App event: ${ad.adUnitId}, $name, $data'),
//     onApplicationExit: (ad) => print('App Exit: ${ad.adUnitId}.'),
//     onNativeAdClicked: (nativeAd) => print('Native ad clicked: ${nativeAd.adUnitId}'),
//     onNativeAdImpression: (nativeAd) => print('Native ad impression: ${nativeAd.adUnitId}'),
//     onRewardedAdUserEarnedReward: (ad, reward) =>
//         print('User rewarded: ${ad.adUnitId}, ${reward.amount} ${reward.type}.'),
//   );
// }