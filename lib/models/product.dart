import 'package:flutter/foundation.dart';
import '../models/brand.dart';
import '../models/color_code.dart';
import '../models/gallery.dart';
import '../models/main_features.dart';
import '../models/meta_data.dart';

class Product with ChangeNotifier {
  final int id;
  final String title;
  final String price;
  final String price_low;
  final MainFeatures main_features;
  final String content;

  final List<Gallery> gallery;
  final List<MetaData> tags;
  final List<Brand> brand;
  final List<MetaData> productcat;
  final List<MetaData> sellcase;
  final List<ColorCode> color;
  final List<MetaData> status;



  Product({
    this.id,
    this.title,
    this.price,
    this.price_low,
    this.main_features,
    this.content,
    this.gallery,
    this.tags,
    this.brand,
    this.productcat,
    this.sellcase,
    this.color,
    this.status,
  });


  factory Product.fromJson(Map<String, dynamic> parsedJson) {
    var galleryList = parsedJson['gallery'] as List;
    List<Gallery> galleryRaw = new List<Gallery>();

    galleryRaw = galleryList.map((i) => Gallery.fromJson(i)).toList();

    var tagsList = parsedJson['tags'] as List;
    List<MetaData> tagsRaw = new List<MetaData>();
    tagsRaw = tagsList.map((i) => MetaData.fromJson(i)).toList();

    var brandList = parsedJson['brand'] as List;
    List<Brand> brandRaw = brandList.map((i) => Brand.fromJson(i)).toList();

    var productcatList = parsedJson['productcat'] as List;
    List<MetaData> productcatRaw =
        productcatList.map((i) => MetaData.fromJson(i)).toList();
    var sellcaseList = parsedJson['sellcase'] as List;
    List<MetaData> sellcaseRaw =
        sellcaseList.map((i) => MetaData.fromJson(i)).toList();

    var colorList = parsedJson['color'] as List;
    List<ColorCode> colorRaw =
        colorList.map((i) => ColorCode.fromJson(i)).toList();

    var statusList = parsedJson['status'] as List;
    List<MetaData> statusRaw =
        statusList.map((i) => MetaData.fromJson(i)).toList();

    return Product(
      id: parsedJson['id'],
      title: parsedJson['title'],
      price: parsedJson['price'],
      price_low: parsedJson['price_low'],
      main_features: MainFeatures.fromJson(parsedJson['main_features']),
      content: parsedJson['content'],
      gallery: galleryRaw,
      tags: tagsRaw,
      brand: brandRaw,
      productcat: productcatRaw,
      sellcase: sellcaseRaw,
      color: colorRaw,
      status: statusRaw,
    );
  }
}
