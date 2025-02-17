import '../model/generesModel.dart';

class TrendingMovie {
  String? rating;
  String? overview;
  String? releaseYear;
  String? bgURL;
  String? posterURL;
  String? title;
  String? id;
  List<Genre>? category;

  TrendingMovie({
    this.id,
    this.rating,
    this.overview,
    this.releaseYear,
    this.bgURL,
    this.posterURL,
    this.title,
    this.category,
  });

  TrendingMovie.fromMap(Map<String, dynamic> map) {
    id = map["id"].toString();
    rating = map['vote_average'].toString();
    overview = map['overview'];
    releaseYear = map['release_date'].toString().substring(0, 4);
    bgURL = map['backdrop_path'];
    posterURL = map['poster_path'];
    title = map['title'];
    category = <Genre>[];
    for (var id in map['genre_ids']) {
      for (var cat in genre) {
        if (cat.id == id) {
          category?.add(cat);
        }
      }
    }
  }

  toJson() {
    return {
      "id": id,
      "rating": rating,
      "overview": overview,
      "releaseDate": releaseYear,
      "bgURL": bgURL,
      "posterURL": posterURL,
      "title": title,
      "category": category,
    };
  }
}
