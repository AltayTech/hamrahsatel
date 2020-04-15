class Gallerym {
  final int id;
  final String url;

  Gallerym({this.id, this.url});

  factory Gallerym.fromJson(Map<String, dynamic> parsedJson) {
    return Gallerym(
      id: parsedJson['id'],
      url: parsedJson['url'],
    );
  }
}
