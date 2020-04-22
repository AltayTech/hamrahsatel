import 'package:flutter/foundation.dart';

import '../models/brand.dart';
import '../models/color_code.dart';
import '../models/meta_data.dart';
import 'price.dart';

class Product with ChangeNotifier {
  final int id;
  final String date;
  final bool show;
  final String title;
  final Price price;
  final String featured_image;
  final List<String> gallery;
  final String product_spec;
  final String investigate;
  final String note_product;
  final String description;
  final List<Brand> brand;
  final List<MetaData> productcat;
  final List<MetaData> sellcase;
  final List<ColorCode> color;
  final List<MetaData> status;

  Product({
    this.id,
    this.date,
    this.show,
    this.title,
    this.price,
    this.featured_image,
    this.gallery,
    this.product_spec,
    this.investigate,
    this.note_product,
    this.description,
    this.brand,
    this.productcat,
    this.sellcase,
    this.color,
    this.status,
  });

  factory Product.fromJson(Map<String, dynamic> parsedJson) {
    var galleryList = parsedJson['gallery'] as List;
    List<String> galleryRaw = galleryList.map((i) => i.toString()).toList();

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
      date: parsedJson['date'],
      show: parsedJson['show'],
      title: parsedJson['title'],
      price: Price.fromJson(parsedJson['price']),
      featured_image: parsedJson['featured_image'],
      gallery: galleryRaw,
      product_spec: parsedJson['product_spec'],
      investigate: parsedJson['investigate'],
      note_product: parsedJson['note_product'],
      description: parsedJson['description'],
      brand: brandRaw,
      productcat: productcatRaw,
      sellcase: sellcaseRaw,
      color: colorRaw,
      status: statusRaw,
    );
  }
}
