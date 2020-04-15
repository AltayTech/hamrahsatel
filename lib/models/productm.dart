import 'package:flutter/foundation.dart';
import '../models/brand.dart';
import '../models/color_code.dart';
import '../models/gallery.dart';
import '../models/meta_data.dart';

class Productm with ChangeNotifier {
  final int id;
  final String title;
  final String price;
  final String price_low;

  final List<Gallery> gallery;
  final Brand brand;
  final List<ColorCode> colors;
  final MetaData status;

  Productm({
    this.id,
    this.title,
    this.price,
    this.price_low,
    this.gallery,
    this.brand,
    this.colors,
    this.status,
  });

  factory Productm.fromJson(Map<String, dynamic> parsedJson) {
    var galleryFromJson = parsedJson['gallery'] as List;
    List<Gallery> galleryRaw =
        galleryFromJson.map((i) => Gallery.fromJson(i)).toList();

    var brandFromJson = parsedJson['brand'];
    Brand brandRaw = Brand.fromJson(brandFromJson);

    var colorsFromJson = parsedJson['colors'] as List;
    List<ColorCode> colorRaw =
        colorsFromJson.map((i) => ColorCode.fromJson(i)).toList();

    var statusList = parsedJson['status'];
    MetaData statusRaw = MetaData.fromJson(statusList);

    return Productm(
      id: parsedJson['id'],
      title: parsedJson['title'],
      price: parsedJson['price'],
      price_low: parsedJson['price_low'],
      gallery: galleryRaw,
      brand: brandRaw,
      colors: colorRaw,
      status: statusRaw,
    );
  }
}
