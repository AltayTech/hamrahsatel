import 'package:flutter/foundation.dart';
import '../models/personal_data.dart';
import 'order.dart';
import 'productFavorite.dart';

class Customer with ChangeNotifier {
  final PersonalData personal_data;
  final List<Order> orders;
//  final List<ProductFavorite> favorites;

  Customer({
    this.personal_data,
    this.orders,
//    this.favorites,
  });

  factory Customer.fromJson(Map<String, dynamic> parsedJson) {
    var orderList = parsedJson['orders'] as List;
    List<Order> orderRaw = new List<Order>();

    orderRaw = orderList.map((i) => Order.fromJson(i)).toList();

//    var favoritesList = parsedJson['favorites'] as List;
//    List<ProductFavorite> favoritesRaw = new List<ProductFavorite>();
//
//    favoritesRaw =
//        favoritesList.map((i) => ProductFavorite.fromJson(i)).toList();
    return Customer(
      personal_data: PersonalData.fromJson(parsedJson['personal_data']),
      orders: orderRaw,
//      favorites: favoritesRaw,
    );
  }
}
