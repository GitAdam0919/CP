import 'package:get/state_manager.dart';
import 'package:play_cine_films/constants.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/detailedMovieModel.dart';
import '../model/trendingMovieModel.dart';
import '../services/apiService.dart';

class MovieController extends GetxController {
  var isLoading = true.obs;
  List<TrendingMovie> trendingMovies = <TrendingMovie>[].obs;
  // ignore: deprecated_member_use
  List<TrendingMovie> searchedMovies = <TrendingMovie>[].obs;
  var movie = DetailedMovie(
    bgURL: null,
    category: null,
    id: null,
    overview: null,
    posterURL: null,
    rating: null,
    releaseYear: null,
    title: null,
    budget: null,
    cast: null,
    crew: null,
    revenue: null,
    runtime: null,
  ).obs;
  var selectedMovie = TrendingMovie(
          bgURL: null,
          category: null,
          id: null,
          overview: null,
          posterURL: null,
          rating: null,
          releaseYear: null,
          title: null)
      .obs;

  @override
  void onInit() {
    getTrendingMovies();
    super.onInit();
  }

  void selectedMovies(int index) {
    selectedMovie(trendingMovies[index]);
  }

  void getSearchedMovie(String movieName) async {
    isLoading(true);
    var movies = await APIService.getSearchedMovie(movieName);
    if (movies != null) {
      searchedMovies = movies;
    }
    isLoading(false);
  }

  void getTrendingMovies() async {
    isLoading(true);
    var movies = await APIService.getTrendingMovie();
    if (movies != null) {
      trendingMovies = movies;
      selectedMovies(0);
    }
    isLoading(false);
  }

  void getMovieDetail(String? id) async {
    isLoading(true);
    var movie = await APIService.getMovieDetail(id!);
    if (movie != null) {
      movie(movie);
    }
    isLoading(false);
  }

  Future<void> launchInBrowser(String filmTitle) async {
    Uri url = Uri.parse(youtubeSearch + filmTitle);
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }
}
