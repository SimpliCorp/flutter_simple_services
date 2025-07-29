import 'dart:io';
import 'package:flutter/foundation.dart';

//Test id
const adsInterstitialIdAndroidDebug = "ca-app-pub-3940256099942544/4411468910";
const adsInterstitialIdIOSDebug = "ca-app-pub-3940256099942544/4411468910";

const adsOpenAppIOSDebug = "ca-app-pub-3940256099942544/5575463023";
const adsOpenAppAndroidDebug = "ca-app-pub-3940256099942544/9257395921";

const adsRewardIOSDebug = "ca-app-pub-3940256099942544/1712485313";
const adsRewardAndroidDebug = "ca-app-pub-3940256099942544/5224354917";

//iOS
const adsBannerIdIOS = "";
const adsInterstitialIdIOS = "ca-app-pub-4191574836195894/4847630472";
const adsOpenAppIOS = "ca-app-pub-4191574836195894/9908385462";

const adsBannerIdAndroid = "";
const adsInterstitialIdAndroid = "ca-app-pub-4191574836195894/6715245915";
const adsOpenAppAndroid = "ca-app-pub-4191574836195894/3318926383";

const adsRewardIOS = "ca-app-pub-3940256099942544/1712485313";
const adsRewardAndroid = "ca-app-pub-3940256099942544/5224354917";

class AdmobConfig {
  String bannerId() {
    return Platform.isIOS ? adsBannerIdIOS : adsBannerIdAndroid;
  }

  String interstitialId() {
    if (kDebugMode) {
      return Platform.isIOS
          ? adsInterstitialIdIOSDebug
          : adsInterstitialIdAndroidDebug;
    }
    return Platform.isIOS ? adsInterstitialIdIOS : adsInterstitialIdAndroid;
  }

  String rewardId() {
    if (kDebugMode) {
      return Platform.isIOS ? adsRewardIOSDebug : adsRewardAndroidDebug;
    }
    return Platform.isIOS ? adsRewardIOS : adsRewardAndroid;
  }

  String openAppId() {
    if (kDebugMode) {
      return Platform.isIOS ? adsOpenAppIOSDebug : adsOpenAppAndroidDebug;
    }
    return Platform.isIOS ? adsOpenAppIOS : adsOpenAppAndroid;
  }
}
