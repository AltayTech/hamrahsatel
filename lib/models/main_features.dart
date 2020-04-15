class MainFeatures {
  final String screen_inch;
  final String camera;
  final String memory;
  final String ram;

  MainFeatures({
    this.screen_inch,
    this.camera,
    this.memory,
    this.ram,
  });

  factory MainFeatures.fromJson(Map<String, dynamic> parsedJson) {
    return MainFeatures(
      screen_inch: parsedJson['screen-inch'],
      camera: parsedJson['camera'],
      memory: parsedJson['memory'],
      ram: parsedJson['os'],
    );
  }
}
