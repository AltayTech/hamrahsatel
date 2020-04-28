import 'package:flutter/foundation.dart';

import '../models/color_code.dart';
import 'brandc.dart';

class ProductCart with ChangeNotifier {
  final int id;
  final String title;
  final String price;
  final String featured_media_url;
  final Brandc brand;
  final List<ColorCode> colors;

   int productCount;
  final ColorCode color_selected;

  ProductCart(
      {this.id,
      this.title,
      this.price,
      this.featured_media_url,
      this.brand,
      this.colors,
      this.productCount,
      this.color_selected});

  factory ProductCart.fromJson(Map<String, dynamic> parsedJson) {
    var colorList = parsedJson['colors'] as List;
    List<ColorCode> colorRaw =
        colorList.map((i) => ColorCode.fromJson(i)).toList();

    return ProductCart(
      id: parsedJson['id'],
      title: parsedJson['title'],
      price: parsedJson['price'],
      featured_media_url: parsedJson['featured_media_url'],
      brand: Brandc.fromJson(parsedJson['brand']),
      colors: colorRaw,
      productCount: parsedJson['how_many'],
      color_selected: ColorCode.fromJson(parsedJson['color_selected']),
    );
  }
}
