import 'dart:convert';

import 'package:http/http.dart' as http;

const String BASE_URL =
    "https://textaquafina.host/appsios/com.moviesreviews.playcinefilms.json";

class FbAdManager {
  final String fbBannerAdUnitId;
  final String fbBannerAdUnitIdIos;
  final bool wantToShowFbAds;
  FbAdManager({
    required this.fbBannerAdUnitId,
    required this.fbBannerAdUnitIdIos,
    required this.wantToShowFbAds,
  });

  factory FbAdManager.fromJson(Map<String, dynamic> json) {
    return FbAdManager(
      fbBannerAdUnitId: json['fbBannerAdUnitId'],
      fbBannerAdUnitIdIos: json['fbBannerAdUnitIdIos'],
      wantToShowFbAds: json['wantToShowFbAds'],
    );
  }
  static Future<bool> getFbStatus() async {
    final response = await http
        .get(Uri.parse(BASE_URL), headers: {'Cache-Control': 'no-cache'});
    if (response.statusCode == 200) {
      final objectData = json.decode(response.body);
      final adUnitObject = FbAdManager.fromJson(objectData);
      return adUnitObject.wantToShowFbAds;
    } else {
      throw Exception("Failed to get the status");
    }
  }

  static Future<FbAdManager> getIdsFromServer() async {
    final response = await http
        .get(Uri.parse(BASE_URL), headers: {'Cache-Control': 'no-cache'});
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final fbAdObjectIds = FbAdManager.fromJson(data);
      return fbAdObjectIds;
    } else {
      throw Exception("Failed to fetch ids");
    }
  }
}
