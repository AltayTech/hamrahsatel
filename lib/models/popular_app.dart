class PopularApp {
  final int id;
  final String title;
  final String bazar;
  final String appstore;
  final String img_url;

  PopularApp({
    this.id,
    this.title,
    this.bazar,
    this.appstore,
    this.img_url,
  });

  factory PopularApp.fromJson(Map<String, dynamic> parsedJson) {
    return PopularApp(
      id: parsedJson['id'],
      title: parsedJson['title'],
      bazar: parsedJson['bazar'],
      appstore: parsedJson['appstore'],
      img_url: parsedJson['img_url'],
    );
  }
}
