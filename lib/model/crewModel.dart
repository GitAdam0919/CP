class Crew {
  String? name;
  String? profileURL;
  String? job;

  Crew({
    this.name,
    this.profileURL,
    this.job,
  });

  toJson() {
    return {
      "name": name,
      "profileURL": profileURL,
      "job": job,
    };
  }

  Crew.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    profileURL = map['profile_path'];
    job = map['job'];
  }
}
