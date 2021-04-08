import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

// You can also test with your own ad unit IDs by registering your device as a
// test device. Check the logs for your device's ID value.
const String testDevice = 'YOUR_DEVICE_ID';

//Admob App id's with '~' sign
//String androidAdAppId = MobileAds.testAppId;
//String iosAdAppId = MobileAds.testAppId;
//Banner unit id's with '/' sign
String androidBannerAdUnitId = BannerAd.testAdUnitId;
String iosBannerAdUnitId = BannerAd.testAdUnitId;
//Interstitial unit id's with '/' sign
String androidInterstitialAdUnitId = InterstitialAd.testAdUnitId;
String iosInterstitialAdUnitId = InterstitialAd.testAdUnitId;

class Ads {
  static final AdRequest request = AdRequest(
    contentUrl: 'https://flutter.io',
    nonPersonalizedAds: true,
    testDevices: testDevice != null
        ? <String>[testDevice]
        : null, // Android emulators are considered test devices
  );

  BannerAd myBanner() => BannerAd(
        adUnitId: Platform.isIOS ? iosBannerAdUnitId : androidBannerAdUnitId,
        request: request,
        size: AdSize.smartBanner,

        //targetingInfo: targetingInfo(),
        listener: AdListener(
          onAdLoaded: (Ad ad) => print("BannerAd event is loaded"),
          onAdOpened: (Ad ad) => print("BannerAd event is opened"),
          onAdClosed: (Ad ad) => print("BannerAd event is closed"),
        ),
      );
  InterstitialAd myInterstitial() => InterstitialAd(
      adUnitId: Platform.isAndroid
          ? androidInterstitialAdUnitId
          : iosInterstitialAdUnitId,
      request: request,
      //targetingInfo: targetingInfo(),
      listener: AdListener(
        onAdLoaded: (Ad ad) => print(
            "------------------------------InterstitialAd event is loaded"),
        onAdOpened: (Ad ad) => print(
            "------------------------------InterstitialAd event is loaded"),
        onAdClosed: (Ad ad) => print(
            "------------------------------InterstitialAd event is loaded"),
      ));

  void disable(ad) {
    try {
      ad?.dispose();
    } catch (e) {
      print("no ad found");
    }
  }
}
