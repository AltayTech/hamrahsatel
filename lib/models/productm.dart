import 'package:flutter/foundation.dart';

import '../models/brand.dart';
import '../models/color_code.dart';
import '../models/meta_data.dart';
import 'price.dart';

class Productm with ChangeNotifier {
  final int id;
  final String title;
  final Price price;
  final String featured_image;
  final Brand brand;

  final List<ColorCode> colors;
  final MetaData status;

  Productm({
    this.id,
    this.title,
    this.price,
    this.featured_image,
    this.brand,
    this.colors,
    this.status,
  });

  factory Productm.fromJson(Map<String, dynamic> parsedJson) {
    var colorList = parsedJson['colors'] as List;
    List<ColorCode> colorRaw =
        colorList.map((i) => ColorCode.fromJson(i)).toList();

    return Productm(
      id: parsedJson['id'],
      title: parsedJson['title'],
      price: Price.fromJson(parsedJson['price']),
      featured_image: parsedJson['featured_image'],
      brand: Brand.fromJson(parsedJson['brand']),
      colors: colorRaw,
      status: MetaData.fromJson(parsedJson['status']),
    );
  }
}
