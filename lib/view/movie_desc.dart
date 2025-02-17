import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../constants.dart';
import '../controller/admob_ad_manager_controller.dart';
import '../controller/movieController.dart';

class MovieDescription extends StatefulWidget {
  const MovieDescription({super.key});

  @override
  State<MovieDescription> createState() => _MovieDescriptionState();
}

class _MovieDescriptionState extends State<MovieDescription>
    implements BannerAdListener {
  final MovieController movieController = Get.put(MovieController());
  late BannerAd _bannerAd;
  bool _isBannerAdLoaded = false;
  late bool _wantToShowAdmob;
  bool wantToShowAdmobInitialized = false;

  getTheStatus() async {
    _wantToShowAdmob = await AdManager.getAdmobStatus();
    setState(() {
      wantToShowAdmobInitialized = true;
    });
  }

  @override
  void initState() {
    getTheStatus();
    super.initState();
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
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Obx(
        () {
          return movieController.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.red,
                  ),
                )
              : SingleChildScrollView(
                  child: SizedBox(
                    width: size.width,
                    child: Column(
                      children: [
                        Container(
                          height: size.height * 0.35,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            image: DecorationImage(
                              image: NetworkImage(
                                  '$bgURL${movieController.movie.value.bgURL}'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          width: size.width,
                          padding: const EdgeInsets.all(25),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                contentPadding: const EdgeInsets.all(0),
                                title: Text(
                                    "${movieController.movie.value.title}"),
                                subtitle: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      '${movieController.movie.value.releaseYear}',
                                      // '15+',
                                      '${movieController.movie.value.runtime}'
                                    ]
                                        .map((e) => Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 10, 0),
                                              child: Text(e),
                                            ))
                                        .toList()),
                              ),
                              Wrap(
                                children: movieController.movie.value.category!
                                    .map((e) => Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 10, 0),
                                          child: Chip(
                                            label: Text(e),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),
                              const SizedBox(height: 18),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Overview',
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                      '${movieController.movie.value.overview}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                ],
                              ),
                              const SizedBox(height: 18),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Cast & Crew',
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: 10),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: movieController
                                          .movie.value.cast!
                                          .map((e) => Container(
                                                width: size.width / 4,
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundImage: e
                                                                  .profileURL ==
                                                              null
                                                          ? const NetworkImage(
                                                              'https://randomuser.me/api/portraits/lego/1.jpg')
                                                          : NetworkImage(
                                                              '$posterURL${e.profileURL}'),
                                                      radius: 40,
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                      '${e.name}',
                                                      maxLines: 2,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.clip,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium,
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      '${e.character}',
                                                      maxLines: 2,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.clip,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall,
                                                    ),
                                                  ],
                                                ),
                                              ))
                                          .toList(),
                                    ),
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
                                          : const Center(
                                              child: CircularProgressIndicator(
                                                color: Colors.red,
                                              ),
                                            )
                                      : Container(),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: movieController
                                          .movie.value.crew!
                                          .map((e) => Container(
                                                width: size.width / 4,
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundImage: e
                                                                  .profileURL ==
                                                              null
                                                          ? const NetworkImage(
                                                              'https://randomuser.me/api/portraits/lego/1.jpg')
                                                          : NetworkImage(
                                                              '$posterURL${e.profileURL}'),
                                                      radius: 40,
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                      '${e.name}',
                                                      maxLines: 2,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.clip,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium,
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      '${e.job}',
                                                      maxLines: 2,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.clip,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall,
                                                    ),
                                                  ],
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
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
  // TODO: implement onAdFailedToLoad
  AdLoadErrorCallback? get onAdFailedToLoad => throw UnimplementedError();

  @override
  // TODO: implement onAdImpression
  AdEventCallback? get onAdImpression => throw UnimplementedError();

  @override
  // TODO: implement onAdLoaded
  AdEventCallback? get onAdLoaded => throw UnimplementedError();

  @override
  // TODO: implement onAdOpened
  AdEventCallback? get onAdOpened => throw UnimplementedError();

  @override
  // TODO: implement onAdWillDismissScreen
  AdEventCallback? get onAdWillDismissScreen => throw UnimplementedError();

  @override
  // TODO: implement onPaidEvent
  OnPaidEventCallback? get onPaidEvent => throw UnimplementedError();
}
