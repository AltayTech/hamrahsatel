import 'package:flutter/foundation.dart';
import '../models/color_code.dart';

class ProductFavorite with ChangeNotifier {
  final int id;
  final String title;

  final String img_url;
  final String price;
  final String price_low;
  final List<ColorCode> colors;

  ProductFavorite(
      {this.id,
      this.title,
      this.img_url,
      this.price,
      this.price_low,
      this.colors});

  factory ProductFavorite.fromJson(Map<String, dynamic> parsedJson) {
    var colorsFromJson = parsedJson['colors'] as List;
    List<ColorCode> colorRaw =
        colorsFromJson.map((i) => ColorCode.fromJson(i)).toList();

    return ProductFavorite(
      id: parsedJson['id'],
      title: parsedJson['title'],
      img_url: parsedJson['img_url'],
      price: parsedJson['price'],
      price_low: parsedJson['price_low'],
      colors: colorRaw,
    );
  }
}
