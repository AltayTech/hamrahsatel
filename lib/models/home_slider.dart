import 'package:flutter/material.dart';

class HomeSlider with ChangeNotifier {
  final String title;
  final String featured_image;

  HomeSlider({
    this.title,
    this.featured_image,
  });

  factory HomeSlider.fromJson(Map<String, dynamic> parsedJson) {
    return HomeSlider(
      title: parsedJson['title'],
      featured_image: parsedJson['featured_image'],
    );
  }
}
