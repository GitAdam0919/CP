import '../model/castModel.dart';
import '../model/crewModel.dart';

class DetailedMovie {
  String? id;
  String? rating;
  String? overview;
  String? releaseYear;
  String? bgURL;
  String? posterURL;
  String? title;
  List<String>? category;
  int? budget;
  int? revenue;
  int? runtime;
  List<Crew>? crew;
  List<Cast>? cast;

  DetailedMovie({
    this.id,
    this.rating,
    this.overview,
    this.releaseYear,
    this.bgURL,
    this.posterURL,
    this.title,
    this.category,
    this.budget,
    this.revenue,
    this.runtime,
    this.crew,
    this.cast,
  });

  DetailedMovie.fromMap(Map<String, dynamic> map) {
    id = map["id"].toString();
    rating = map['vote_average'].toString();
    overview = map['overview'];
    releaseYear = map['release_date'].toString().substring(0, 4);
    bgURL = map['backdrop_path'];
    posterURL = map['poster_path'];
    title = map['title'];
    category = <String>[];
    for (var id in map['genres']) {
      category?.add(id['name']);
    }
    budget = map['budget'];
    revenue = map['revenue'];
    runtime = map['runtime'];
    cast = <Cast>[];
    for (var cast in map['credits']['cast']) {
      this.cast?.add(Cast.fromMap(cast));
    }
    crew = <Crew>[];
    for (var crew in map['credits']['crew']) {
      this.crew?.add(Crew.fromMap(crew));
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
      "budget": budget,
      "revenue": revenue,
      "runtime": runtime,
      "crew": crew,
      "cast": cast,
    };
  }
}
