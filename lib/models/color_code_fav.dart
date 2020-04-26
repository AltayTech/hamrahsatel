class ColorCodeFav {
  final int id;
  final String title;
  final String color_code;

  ColorCodeFav({
    this.id,
    this.title,
    this.color_code,
  });

  factory ColorCodeFav.fromJson(Map<String, dynamic> parsedJson) {
    return ColorCodeFav(
      id: parsedJson['id'],
      title: parsedJson['title'],
      color_code: parsedJson['color_code'],
    );
  }
}
