class Cast {
  String? name;
  String? profileURL;
  String? character;

  Cast({
    this.name,
    this.profileURL,
    this.character,
  });

  toJson() {
    return {
      "name": name,
      "profileURL": profileURL,
      "character": character,
    };
  }

  Cast.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    profileURL = map['profile_path'];
    character = map['character'];
  }
}
