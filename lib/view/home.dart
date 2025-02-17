import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:play_cine_films/controller/fb_ad_manager_controller.dart';

import '../constants.dart';
import '../controller/admob_ad_manager_controller.dart';
import '../controller/movieController.dart';
import '../view/movie_search.dart';
import 'movie_desc.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> implements BannerAdListener {
  final MovieController movieController = Get.put(MovieController());
  late BannerAd _bannerAd;
  bool _isBannerAdLoaded = false;
  late bool _wantToShowAdmob;
  late bool _wantToShowFbAds;
  static bool wantToShowAdmobInitialized = false;
  static bool wantToShowFbAdsInitialized = false;
  Widget _currentAd = const SizedBox(
    width: 0.0,
    height: 0.0,
  );
  _showBannerAd() async {
    final ids = await FbAdManager.getIdsFromServer();
    setState(() {
      _currentAd = FacebookBannerAd(
        placementId:
            Platform.isAndroid ? ids.fbBannerAdUnitId : ids.fbBannerAdUnitIdIos,
        bannerSize: BannerSize.STANDARD,
      );
    });
  }

  //
  getAdmobStatus() async {
    _wantToShowAdmob = await AdManager.getAdmobStatus();
    setState(() {
      wantToShowAdmobInitialized = true;
    });
  }

  getFbStatus() async {
    _wantToShowFbAds = await FbAdManager.getFbStatus();
    setState(() {
      wantToShowFbAdsInitialized = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getAdmobStatus();
    getFbStatus();
    _showBannerAd();

    AdManager.loadBannerAd(this).then((ad) => setState(() {
          _bannerAd = ad;
          _isBannerAdLoaded = true;
        }));
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Center(child: Icon(Icons.search_outlined)),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const MovieSearch()));
            },
          )
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      extendBodyBehindAppBar: true,
      body: Obx(
        () {
          return movieController.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                  children: [
                    Container(
                      height: size.height,
                      width: size.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              "$bgURL${movieController.selectedMovie.value.bgURL}"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      height: size.height,
                      width: size.width,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: FractionalOffset.bottomCenter,
                            end: FractionalOffset.topCenter,
                            colors: [
                              Colors.black87,
                              Colors.black26,
                            ],
                            stops: [
                              0.4,
                              1.0
                            ]),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding:
                                  const EdgeInsets.fromLTRB(30, 20, 30, 20),
                              width: size.width,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.grey,
                                        ),
                                        child: const Text(
                                          "TRENDING",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.grey,
                                        ),
                                        child: Text(
                                          "${movieController.selectedMovie.value.releaseYear}",
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.amber,
                                        ),
                                        child: Text(
                                          "${movieController.selectedMovie.value.rating}",
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: movieController
                                        .selectedMovie.value.category!
                                        .map((e) => Expanded(
                                              child: Chip(
                                                backgroundColor: Colors.grey,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4)),
                                                label: FittedBox(
                                                  child: Text(
                                                    e.category!,
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              width: size.width,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Align(
                                    alignment: const Alignment(0, 1.0),
                                    child: _currentAd,
                                  ),
                                  (wantToShowAdmobInitialized &&
                                          _wantToShowAdmob)
                                      ? _isBannerAdLoaded
                                          ? SizedBox(
                                              height: _bannerAd.size.height
                                                  .toDouble(),
                                              width: _bannerAd.size.width
                                                  .toDouble(),
                                              child: AdWidget(ad: _bannerAd),
                                            )
                                          : const CircularProgressIndicator(
                                              color: Colors.red,
                                            )
                                      : Container(),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: GFButton(
                                      padding: const EdgeInsets.all(10),
                                      textStyle: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                      shape: GFButtonShape.standard,
                                      onPressed: () {
                                        movieController.launchInBrowser(
                                          movieController
                                              .selectedMovie.value.title!,
                                        );
                                      },
                                      text: "Watch Trailer",
                                      color: Colors.red,
                                    ),
                                  ),
                                  Expanded(
                                    child: CarouselSlider.builder(
                                      options: CarouselOptions(
                                        autoPlay: false,
                                        viewportFraction: 0.5,
                                        height: size.height,
                                        enlargeCenterPage: true,
                                        onPageChanged: (i, _) {
                                          movieController.selectedMovies(i);
                                        },
                                      ),
                                      itemCount:
                                          movieController.trendingMovies.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return InkWell(
                                          onTap: () {
                                            if (wantToShowAdmobInitialized &&
                                                _wantToShowAdmob) {
                                              AdManager.loadInterstitialAd(() {
                                                movieController.getMovieDetail(
                                                    movieController
                                                        .selectedMovie
                                                        .value
                                                        .id);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            const MovieDescription()));
                                              });
                                            } else {
                                              movieController.getMovieDetail(
                                                  movieController
                                                      .selectedMovie.value.id);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          const MovieDescription()));
                                            }
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Colors.grey,
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    "$posterURL${movieController.trendingMovies[index].posterURL}"),
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    (wantToShowFbAdsInitialized && _wantToShowFbAds)
                        ? Align(
                            alignment: const Alignment(0, 1.0),
                            child: _currentAd,
                          )
                        : Container(),
                  ],
                );
        },
      ),
    );
  }

  @override
  // TODO: implement onAdClicked
  AdEventCallback? get onAdClicked => throw UnimplementedError();

  @override
  // TODO: implement onAdClosed
  AdEventCallback? get onAdClosed => throw UnimplementedError();

  @override
  // TODO: implement onAdImpression
  AdEventCallback? get onAdImpression => throw UnimplementedError();

  @override
  // TODO: implement onAdOpened
  AdEventCallback? get onAdOpened => throw UnimplementedError();

  @override
  // TODO: implement onAdWillDismissScreen
  AdEventCallback? get onAdWillDismissScreen => throw UnimplementedError();

  @override
  // TODO: implement onPaidEvent
  OnPaidEventCallback? get onPaidEvent => throw UnimplementedError();

  @override
  // TODO: implement onAdFailedToLoad
  AdLoadErrorCallback? get onAdFailedToLoad => throw UnimplementedError();

  @override
  // TODO: implement onAdLoaded
  AdEventCallback? get onAdLoaded => throw UnimplementedError();
}
