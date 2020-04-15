class ColorCode {
  final int id;
  final String title;
  final String color_code;

  ColorCode({this.id, this.title, this.color_code});

  factory ColorCode.fromJson(Map<String, dynamic> parsedJson) {
    return ColorCode(
      id: parsedJson['id'],
      title: parsedJson['title'],
      color_code: parsedJson['color_code'],
    );
  }
}
