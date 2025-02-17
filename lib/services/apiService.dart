import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants.dart';
import '../model/detailedMovieModel.dart';
import '../model/trendingMovieModel.dart';

class APIService {
  static var client = http.Client();
  static Future<List<TrendingMovie>?> getTrendingMovie() async {
    http.Response response = await client.get(trendingEndPoint);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['results'];
      List<TrendingMovie> movies = <TrendingMovie>[];
      for (var movie in data) {
        movies.add(TrendingMovie.fromMap(movie));
      }
      return movies;
    } else {
      return null;
    }
  }

  static Future<DetailedMovie?> getMovieDetail(String id) async {
    http.Response response =
        await client.get("$movieEndPoint$id$apiKey$crewEndPoint");

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      DetailedMovie detailedMovie = DetailedMovie.fromMap(data);
      return detailedMovie;
    } else {
      return null;
    }
  }

  static Future<List<TrendingMovie>?> getSearchedMovie(String movieName) async {
    http.Response response = await client.get("$searchMovie$movieName");
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['results'];
      List<TrendingMovie> movies = <TrendingMovie>[];
      for (var movie in data) {
        movies.add(TrendingMovie.fromMap(movie));
      }
      return movies;
    }
    return null;
  }
}
