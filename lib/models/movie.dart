class Movie {
  int id;
  String imageURL, name, director;

  Movie(this.imageURL, this.name,this.director,);

  Movie.map(dynamic obj) {
    this.id = obj["id"];
    this.imageURL = obj["imageURL"];
    this.name = obj["name"];
    this.director = obj["director"];
  }

  int get getId => id;

  String get getImageURL => imageURL;

  String get getName => name;

  String get getDirector => director;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["imageURL"] = imageURL;
    map["name"] = name;
    map["director"] = director;
    return map;
  }
}
