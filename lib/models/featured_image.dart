class FeaturedImage {
  final int id;
  final String url;

  FeaturedImage({this.id, this.url});

  factory FeaturedImage.fromJson(Map<String, dynamic> parsedJson) {
    return FeaturedImage(
      id: parsedJson['id'],
      url: parsedJson['url'],
    );
  }
}
