import 'package:flutter/material.dart';
import '../models/home_slider.dart';

import '../models/category.dart' as category;
import 'brand.dart';
import 'color_code.dart';
import 'productm.dart';

class HomePage with ChangeNotifier {
  final List<HomeSlider> sliders;

  final List<category.Category> categories;
  final List<Brand> brands;
  final List<ColorCode> colors;
  final List<Productm> new_products;
  final List<Productm> ads_products;
  final List<Productm> discount_products;

  HomePage({
    this.sliders,
    this.categories,
    this.brands,
    this.colors,
    this.new_products,
    this.ads_products,
    this.discount_products,
  });

  factory HomePage.fromJson(Map<String, dynamic> parsedJson) {
    var slidersList = parsedJson['sliders'] as List;
    List<HomeSlider> slidersRaw = new List<HomeSlider>();

    slidersRaw = slidersList.map((i) => HomeSlider.fromJson(i)).toList();

    var categoriesList = parsedJson['categories'] as List;
    List<category.Category> categoriesRaw = new List<category.Category>();

    categoriesRaw =
        categoriesList.map((i) => category.Category.fromJson(i)).toList();

    var brandList = parsedJson['brands'] as List;
    List<Brand> brandRaw = new List<Brand>();

    brandRaw = brandList.map((i) => Brand.fromJson(i)).toList();

    var colorList = parsedJson['color'] as List;
    List<ColorCode> colorRaw = new List<ColorCode>();

    colorRaw = colorList.map((i) => ColorCode.fromJson(i)).toList();

    var new_productsList = parsedJson['new_products'] as List;
    List<Productm> new_productsRaw =
        new_productsList.map((i) => Productm.fromJson(i)).toList();

    var ads_productsList = parsedJson['ads_products'] as List;
    List<Productm> ads_productsRaw =
        ads_productsList.map((i) => Productm.fromJson(i)).toList();

    var discount_productsList = parsedJson['discount_products'] as List;
    List<Productm> discount_productsRaw =
        discount_productsList.map((i) => Productm.fromJson(i)).toList();

    return HomePage(
      sliders: slidersRaw,
      categories: categoriesRaw,
      brands: brandRaw,
      colors: colorRaw,
      new_products: new_productsRaw,
      ads_products: ads_productsRaw,
      discount_products: discount_productsRaw,
    );
  }
}
