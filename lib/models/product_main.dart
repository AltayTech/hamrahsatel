import 'package:flutter/foundation.dart';

import '../models/product.dart';
import '../models/products_detail.dart';

class ProductMain with ChangeNotifier {
  final ProductsDetail productsDetail;

  final List<Product> products;

  ProductMain({this.productsDetail, this.products});

  factory ProductMain.fromJson(Map<String, dynamic> parsedJson) {
    var productsList = parsedJson['products'] as List;
    List<Product> productsRaw = new List<Product>();

    productsRaw = productsList.map((i) => Product.fromJson(i)).toList();

    return ProductMain(
      productsDetail: ProductsDetail.fromJson(parsedJson['details']),
      products: productsRaw,
    );
  }
}
