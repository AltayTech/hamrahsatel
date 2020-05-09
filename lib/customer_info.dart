import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'models/color_code.dart';
import 'models/price.dart';
import 'models/shop.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/customer.dart';
import 'models/order.dart';
import 'models/orderItem.dart';
import 'models/order_details.dart';
import 'models/order_details_aghsat.dart';
import 'models/personal_data.dart';
import 'models/productFavorite.dart';
import 'provider/urls.dart';

class CustomerInfo with ChangeNotifier {
  String _payUrl = '';

  int _currentOrderId;

  Shop _shop;

  String get payUrl => _payUrl;
  List<File> chequeImageList = [];

  static Customer _customer_zero = Customer(
    personal_data: PersonalData(
      id: 0,
      first_name: '',
      last_name: '',
      email: '',
      ostan: '',
      city: '',
      address: '',
      postcode: '',
      phone: '',
      personal_data_complete: false,
    ),
    orders: [Order()],
//      favorites: [ProductFavorite()],
  );
  Customer _customer = _customer_zero;
  String _token;

  Customer get customer => _customer;

  List<Order> _orders = [
    Order(
        id: 0,
        shenaseh: '',
        total_cost: '',
        order_register_date: '',
        pay_type: '',
        order_status: '',
        pish: '',
        total_num: 1,
        pay_status: ''),
  ];
  List<ProductFavorite> _favoriteProducts = [
    ProductFavorite(
      id: 0,
      title: '',
      price: Price(price: '', price_without_discount: ''),
      colors: [ColorCode(title: '', price: '', color_code: '', id: 0)],
      featured_image: '',
    ),
  ];
  OrderDetails _order = OrderDetails(
    id: 0,
    total_cost: '0',
    order_register_date: '0',
    pay_type: '0',
    order_status: '0',
    pish: '0',
    number_of_products: 1,
    pay_status: '0',
    products: [OrderItem(id: 0, title: '0', price_low: '0')],
    orderDetailsAghsat: OrderDetailsAghsat(
      shenaseh: '0',
      cheque_images: [],
      owner: '0',
      bank: '0',
      number_pay: '0',
      pay: '0',
    ),
    pay_status_slug: '0',
    order_status_slug: '0',
    pay_type_slug: '0',
  );

  int _id;
  String _first_name;
  String _last_name;
  String _email;
  String _ostan;
  String _city;
  String _address;
  String _postcode;

  set id(int value) {
    _id = value;
  }

  List<Order> get orders => _orders;

  Future<void> getCustomer() async {
    print('getCustomer');

    final url = Urls.rootUrl + Urls.customerEndPoint;
    print(url);

    final prefs = await SharedPreferences.getInstance();

    _token = prefs.getString('token');

    print(_token);

    Customer customers;
    try {
      final response = await get(url, headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      });

      final extractedData = json.decode(response.body);
      print(extractedData);

      customers = Customer.fromJson(extractedData);

      _customer = customers;

      _orders = customers.orders;

      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> sendCustomer() async {
    print('sendCustomer');

    final url = Urls.rootUrl + Urls.customerEndPoint;

    final prefs = await SharedPreferences.getInstance();

    _token = prefs.getString('token');

    try {
      final response = await post(url,
          headers: {
            'Authorization': 'Bearer $_token',
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          },
          body: jsonEncode({
            "personal_data": {
              "id": _customer.personal_data.id,
              "phone": _customer.personal_data.phone,
              "first_name": _first_name,
              "last_name": _last_name,
              "credit": _email,
              "ostan": _ostan,
              "city": _city,
              "address": _address,
              "postcode": _postcode
            },
            "orders": [],
            "favorites": []
          }));

      final extractedData = json.decode(response.body);
      print(extractedData);
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Order findById(int id) {
    return _orders.firstWhere((prod) => prod.id == id);
  }

  OrderDetails getOrder() {
    return _order;
  }

  Future<void> getOrderDetails(int orderId) async {
    print('getOrderDetails');
    print(orderId.toString());

    _currentOrderId = orderId;

    final url = Urls.rootUrl + Urls.orderInfoEndPoint + '?order_id=$orderId';

    final prefs = await SharedPreferences.getInstance();

    _token = prefs.getString('token');

    OrderDetails orderDetails;
    try {
      final response = await get(url, headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      });

      final extractedData = json.decode(response.body);

      orderDetails = OrderDetails.fromJson(extractedData);

      _order = orderDetails;
      print(extractedData.toString());

      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> payCashOrder(int orderId) async {
    print('payCashOrder');

    final url = Urls.rootUrl + Urls.payEndPoint + '?order_id=$orderId';

    final prefs = await SharedPreferences.getInstance();

    _token = prefs.getString('token');

    try {
      final response = await get(url, headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      });

      final extractedData = json.decode(response.body);
      print(extractedData.toString());

      _payUrl = extractedData;
      print(extractedData.toString());

      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> addFavorite(int productId, String action) async {
    print('addFavorite');

    final url = Urls.rootUrl +
        Urls.favoriteEndPoint +
        '?product_id=$productId&action=$action';

    final prefs = await SharedPreferences.getInstance();

    _token = prefs.getString('token');

    try {
      final response = await post(url, headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      });

      final extractedData = json.decode(response.body);
      print(extractedData);
      if (action == 'remove') {
        _favoriteProducts.remove(
            _favoriteProducts.firstWhere((prod) => prod.id == productId));
      }
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> getFavorite() async {
    print('getFavorite');

    final url = Urls.rootUrl + Urls.favoriteEndPoint;
    print(url);

    final prefs = await SharedPreferences.getInstance();

    _token = prefs.getString('token');

    try {
      final response = await get(url, headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      });

      final extractedData = json.decode(response.body) as List;
      print(extractedData);

      List<ProductFavorite> productFavorite = new List<ProductFavorite>();

      productFavorite =
          extractedData.map((i) => ProductFavorite.fromJson(i)).toList();

      _favoriteProducts = productFavorite;

      print(extractedData);

      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> sendNaghdOrder() async {
    print('sendNaghdOrder');

    final url = Urls.rootUrl + Urls.orderInfoEndPoint + '?paytype=naghd';

    final prefs = await SharedPreferences.getInstance();

    _token = prefs.getString('token');

    try {
      final response = await post(url, headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      });

      final extractedData = json.decode(response.body);
      print(extractedData);

      int orderId = extractedData['order_id'];
      _currentOrderId = orderId;

      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> sendAqsatOrder({
    String number_pay,
    String month_per_ghest,
    String deposit,
    String bank,
    String branch,
    String owner,
    String shenaseh,
  }) async {
    print('sendAqsatOrder');
    print(number_pay);
    print(month_per_ghest);
    print(deposit);
    print(bank);
    print(branch);
    print(owner);
    print(shenaseh);

    final url = Urls.rootUrl +
        Urls.orderInfoEndPoint +
        '?paytype=aghsat&number_pay=$number_pay&month_per_ghest=$month_per_ghest'
            '&deposite=$deposit&bank=$bank&branch=$branch&owner=$owner&shenaseh=$shenaseh';
    print(url);

    final prefs = await SharedPreferences.getInstance();

    _token = prefs.getString('token');

    try {
      final response = await post(url, headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      });

      final extractedData = json.decode(response.body);
      print(extractedData);

      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> addPicture(int order_id) async {
    print('addPicture');

    File _image;

    _image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (_image != null) {
      chequeImageList.add(_image);
      Upload(_image, order_id);
    }
  }

  Future<void> Upload(File imageFile, int order_id) async {
    print('Upload');

    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    final url = Uri.parse(
        Urls.rootUrl + Urls.imageUploadEndPoint + '?order_id=$order_id');

    var request = new http.MultipartRequest(
      "POST",
      url,
    );
    final prefs = await SharedPreferences.getInstance();

    _token = prefs.getString('token');
    print(order_id.toString());

    Map<String, String> header1 = {
      'Authorization': 'Bearer $_token',
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
    request.headers.addAll(header1);

    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));

    request.files.add(multipartFile);
    var response = await request.send();
    print(response.toString());
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

  Future<void> fetchShopData() async {
    print('fetchShopData');

    final url = Urls.rootUrl + Urls.shopEndPoint;
    print(url);

    try {
      final response = await get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      });

      final extractedData = json.decode(response.body) as dynamic;
      print(extractedData);

      Shop shopData = Shop.fromJson(extractedData);
      print(shopData.about_shop);

      _shop = shopData;
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  set first_name(String value) {
    _first_name = value;
  }

  set last_name(String value) {
    _last_name = value;
  }

  set email(String value) {
    _email = value;
  }

  set ostan(String value) {
    _ostan = value;
  }

  set city(String value) {
    _city = value;
  }

  set address(String value) {
    _address = value;
  }

  set postcode(String value) {
    _postcode = value;
  }

  List<ProductFavorite> get favoriteProducts => _favoriteProducts;

  int get currentOrderId => _currentOrderId;

  set customer(Customer value) {
    _customer = value;
  }

  set order(OrderDetails value) {
    _order = value;
  }

  set favoriteProducts(List<ProductFavorite> value) {
    _favoriteProducts = value;
  }

  Customer get customer_zero => _customer_zero;

  Shop get shop => _shop;

  set shop(Shop value) {
    _shop = value;
  }
}
