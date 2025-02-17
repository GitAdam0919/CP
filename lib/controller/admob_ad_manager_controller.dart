import 'dart:convert';
import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;

const String BASE_URL =
    "https://textaquafina.host/appsios/com.moviesreviews.playcinefilms.json";

class AdManager {
  final String bannerAdUnitId;
  final String bannerAdUnitIos;
  final String interstitialAdUnitId;
  final String interstitialAdUnitIdIos;

  final bool wantToShowAdmob;

  AdManager({
    required this.bannerAdUnitId,
    required this.bannerAdUnitIos,
    required this.interstitialAdUnitId,
    required this.interstitialAdUnitIdIos,
    required this.wantToShowAdmob,
  });
  factory AdManager.fromJson(Map<String, dynamic> json) {
    return AdManager(
      bannerAdUnitId: json['bannerAdUnitId'],
      bannerAdUnitIos: json['bannerAdUnitIos'],
      interstitialAdUnitId: json['interstitialAdUnitId'],
      interstitialAdUnitIdIos: json['interstitialAdUnitIdIos'],
      wantToShowAdmob: json['wantToShowAdmob'],
    );
  }
  static Future<AdManager> getAdUnitIds() async {
    final response = await http.get(Uri.parse(BASE_URL));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final adUnitsObject = AdManager.fromJson(data);

      return adUnitsObject;
    } else {
      throw Exception("Failed to load admob id from the server");
    }
  }

  static Future<bool> getAdmobStatus() async {
    final response = await http
        .get(Uri.parse(BASE_URL), headers: {'Cache-Control': 'no-cache'});
    if (response.statusCode == 200) {
      final objectData = json.decode(response.body);
      final adUnitObject = AdManager.fromJson(objectData);
      return adUnitObject.wantToShowAdmob;
    } else {
      throw Exception("Failed to get the status");
    }
  }

  static Future<BannerAd> loadBannerAd(BannerAdListener listener) async {
    final adManager = await getAdUnitIds();
    final bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: Platform.isAndroid
            ? adManager.bannerAdUnitId
            : adManager.bannerAdUnitIos,
        listener: listener,
        request: const AdRequest());
    bannerAd.load();

    return bannerAd;
  }

  static void loadInterstitialAd(Function() onAdClosed) async {
    final adManager = await getAdUnitIds();

    InterstitialAd.load(
      adUnitId: Platform.isAndroid
          ? adManager.interstitialAdUnitId
          : adManager.interstitialAdUnitIdIos,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              ad.dispose();
              onAdClosed();
            },
          );
          ad.show();
        },
        onAdFailedToLoad: (LoadAdError error) {},
      ),
    );
  }
}
